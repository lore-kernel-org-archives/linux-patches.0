Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4CB4E56CB;
	Fri,  9 Oct 2026 14:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555678; cv=none; b=m82o7Zlq3oHBuXGaWk2P/WfepCz44tSVZSAZiK1NDOjG88KJbRFgqEdXPKM/2P0hqpScZwFN8ry7vDCjB0m4g+7BU2a/CmbEiLvbj9Zf+CsrPfARanPW83xvwzzOcyi2D7dzocnrulWRGTyfpXRfxSmOBzogzc4PNUVW3oQmLU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555678; c=relaxed/simple;
	bh=liK5HUlnLbVwWRqL6CnhvPb6+Z1lI85ILPt13KqglAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H1lwR1qknfzonF1HXLYxdjBDun78tyuzPQbV3+G8G/LtyFKX7KGK3GQQGN0Njo0Y45nr7u1Ti5GK61Xh3kkhsls8c4DZDKX4JKgk/QgMU0F0/hDFlIPRSUbimfFziQKuv/TEjsyBCR6Yoc0NZQpENEERaDUtiLNB+uxhaqZvvfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r+1fp9ck; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r+1fp9ck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6D21F000FF;
	Fri,  9 Oct 2026 14:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555677;
	bh=yRUXP0ImvjOTEZhk4pFomTB3M88pydKKxnjyJBULQ00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r+1fp9ckOiIbcbpFwONtig61bUcvSCQExUmizIOgipLGq7FSQXfzt9XQGWQ1P/a7+
	 qDf9KC0F4ybveATwniL8xrDY8GCsPvOtNi93JyiXR9ZtpHbQdS23KVnJg7XmPXQ8vp
	 u21T2lduZ9kuLoT4qPO2cDu1b1M8cyXlx3abOYVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Joel Granados <joel.granados@kernel.org>
Subject: [PATCH 7.2 047/428] time/jiffies: Saturate in mult_hz() instead of wrapping
Date: Fri,  9 Oct 2026 16:06:24 +0200
Message-ID: <20261009140947.143787778@linuxfoundation.org>
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

commit fdd6553e1e53b0421d89c7469c8a36d2eadb1115 upstream.

Return ULONG_MAX for values that don't fit an unsigned long.
proc_int_u2k_conv_uop() now correctly rejects a result above INT_MAX.

This is the erroneous behaviour that is being fixed. The input has to
exceed ULONG_MAX / HZ for the product to wrap, so the value below is
specific to CONFIG_HZ=1000:

  # echo 18446744073709552 > /proc/sys/net/ipv4/tcp_keepalive_time
  # cat /proc/sys/net/ipv4/tcp_keepalive_time
  0

That value is now rejected with an error.

The original bound ("*u_ptr > INT_MAX / HZ") was removed in commit
2dc164a48e6f ("sysctl: Create converter functions with two new macros").

Fixes: 2dc164a48e6f ("sysctl: Create converter functions with two new macros")
Cc: stable@vger.kernel.org
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Signed-off-by: Joel Granados <joel.granados@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/jiffies.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/time/jiffies.c
+++ b/kernel/time/jiffies.c
@@ -101,6 +101,8 @@ void __init register_refined_jiffies(lon
 #ifdef CONFIG_PROC_SYSCTL
 static ulong mult_hz(const ulong val)
 {
+	if (val >= ULONG_MAX / HZ)
+		return ULONG_MAX;
 	return val * HZ;
 }
 


