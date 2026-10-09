Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DEA1230BDB;
	Fri,  9 Oct 2026 14:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555669; cv=none; b=hHI6TZc/Q6L6BRb9YGJsPrzGFbn6GTiIpTEAgI1oZbZZzKZdZOw4KTyViadD/2qBY7+F1dYW5fZgnUkPTDmDcnJGhi1vkiAWV1QtokGXIsco2gzhEycHGyZtwoJ72KWkl0htUnNrrtNyIgeRkIO5gTK6hYxaz8Vz9XX39ODi2m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555669; c=relaxed/simple;
	bh=JtGxthZwP/N/+wYRf3uMTG2OttR4EUxYwqYGxivsj4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GMgWdIuFX3cC5eJl5YPwMuVUQEs3ep2zgvwK1Y0GC9okA8pvEUi6V7yjLM4RfacJNAvtkrVW1a4IvBqoTcmg8FUVLMxV9JcrHlOr+RiV54T5D36Jj0MNFVYDIJt06Htw6WgQtHTaa/5b/lREeL/JV+e8SNXrndCnA5kROCT7s3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qd5jlo4I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qd5jlo4I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBEAD1F00898;
	Fri,  9 Oct 2026 14:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555668;
	bh=waUb5S2CHVr2BtbeQc+OVcrz/Fd2bOpAT35dfX8p5I4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qd5jlo4I0CICTdbmkv/kWIKVHvr+IlunktEIi/akWBYS33OBaiEoNSmb3PDfM28zJ
	 xxzmiKoyd08/8W6T4EpzhgjEbW1/K+fPZiFoSA4Fa5Ys9RubXBO1ydlpKcpx5fSt6z
	 CX0NGmRjxqOoIk4a/ydGitYMvcx5uem4z36qXEB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bradley Morgan <brads@mainlining.org>,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Joel Granados <joel.granados@kernel.org>
Subject: [PATCH 7.2 046/428] sysctl: Negate before converting in the int read path
Date: Fri,  9 Oct 2026 16:06:23 +0200
Message-ID: <20261009140947.118995510@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhan Xusheng <zhanxusheng1024@gmail.com>

commit e955f14fa8467d70aaeea5830b4d1773d5b25500 upstream.

proc_int_k2u_conv_kop() reports the sign through *negp and the magnitude
through *u_ptr, but for a negative value it hands the sign-extended int to
the converter and negates the result:

	*u_ptr = k_ptr_op ? -k_ptr_op((ulong)val) : -(ulong)val;

With div_hz() and CONFIG_HZ=1000 a stored -1000 becomes
(ulong)-1000 / 1000 == 18446744073709550, and negating that wraps:

	# echo -1 > /proc/sys/net/ipv4/tcp_fin_timeout
	# cat /proc/sys/net/ipv4/tcp_fin_timeout
	-18428297329635842066

The magnitude is HZ dependent but the wrap is not: the negation happens
after the division at every CONFIG_HZ.

Take the magnitude first and convert that, which is what the open-coded
version did before commit 2dc164a48e6f ("sysctl: Create converter
functions with two new macros") folded it into a macro.  The
k_ptr_op == NULL branch was already correct.

All three int converters that pass a k_ptr_op are affected:
proc_dointvec_jiffies(), proc_dointvec_userhz_jiffies() and
proc_dointvec_ms_jiffies().

Fixes: 2dc164a48e6f ("sysctl: Create converter functions with two new macros")
Cc: stable@vger.kernel.org
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Signed-off-by: Joel Granados <joel.granados@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sysctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -478,7 +478,7 @@ int proc_int_k2u_conv_kop(ulong *u_ptr,
 
 	if (val < 0) {
 		*negp = true;
-		*u_ptr = k_ptr_op ? -k_ptr_op((ulong)val) : -(ulong)val;
+		*u_ptr = k_ptr_op ? k_ptr_op(-(ulong)val) : -(ulong)val;
 	} else {
 		*negp = false;
 		*u_ptr = k_ptr_op ? k_ptr_op((ulong)val) : (ulong) val;


