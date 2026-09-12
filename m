Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E323B299920;
	Sat, 12 Sep 2026 09:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206659; cv=none; b=IDJEIhn5p1sZQaBGgEtbdcuySoHPvFHhPQd3s8WXnW7qfOLiAK0/1mIyr6/5JrQnzeIt8bGr/ef+PM0aFjsPWivWp0w9THpWbUMDS0G9IHK3pHCwudS58bTUeH6v3y+Hl9nUF5RMQgRpeyKVvHYhmALlVKE/2718xoy4FhtpAew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206659; c=relaxed/simple;
	bh=RGGRaAdRtwdvHTJeK5qzp2AHt7ia0h0Jlq9ILpnRXrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fyc0Up04MWnboRRQ27xlVvAJi/y8QFCqvPkNhgsBCEjulWReZnl2vZLKfv1/7hnRxaB4vqJKNFkzyk0hGN5f1Q6Pjz0Zjrs3hAOkugYHGX31dbhqhnzjbQE6/V8we8yI4cDNdmyOhd+/D8xNFoYyqZnmd8J8EV/TvZIc1aJgf40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nBJyj8DI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nBJyj8DI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7A41F000FF;
	Sat, 12 Sep 2026 09:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206657;
	bh=NcjWQ5gKZpDCu2mdwneoejr98unB7QIVOUZvpBTY+Hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nBJyj8DIc72fAMjozMz6fWbF7FdznHr2F/2KY7+sqxdIm0xdDEzz2enSmCYQ321qk
	 p5JVhbQrPYdzc4gGEeyXSV+JNniaknxhtCtv2hLhYjTNZhNiPJBLfkW68RpPd1gJkm
	 FhbacSXvqXlFauFRY7TgtQTnW7waHI5zDiwWRmEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0252/1518] y2038: uapi: Use 64-bit __kernel_old_timespec::tv_nsec on x32
Date: Sat, 12 Sep 2026 08:40:21 +0200
Message-ID: <20260912065629.183317888@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit 79ced850e549e8c86b772a79ea417a1425b5c04b ]

'struct __kernel_old_timespec' represents the 'native' time ABI of the
kernel. On 32-bit systems it uses 32-bit fields and on 64-bit systems
it uses 64-bit fields.

However the x86 x32 ABI uses the 64-bit time ABI natively.  This is
correctly handled for the 'tv_sec' fields, through the typedefs of
'__kernel_old_time_t' -> '__kernel_long_t' -> 'long long'. The same
treatment was missed for 'tv_nsec'.

In practice this might not make much of a difference as the value of
'tv_nsec' will always fit into 32 bits and the missing bits fall
into the padding of the structure.

When introspecting the structure however, a difference can be observed.

Switch to 64-bit tv_nsec on x32.  No other architectures or ABIs are
affected.

While this could be interpreted as violating the POSIX requirement of
'timespec::tv_nsec' being 'long':

  * __kernel_old_timespec is not actually the POSIX timespec type

  * the requirement is gone in newer versions of POSIX

  * this matches glibc

Fixes: 94c467ddb273 ("y2038: add __kernel_old_timespec and __kernel_old_time_t")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260504-timespec-x32-v2-1-0739c9047fc4@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/time_types.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/time_types.h b/include/uapi/linux/time_types.h
index bcc0002115d39..03a0d8aaadca5 100644
--- a/include/uapi/linux/time_types.h
+++ b/include/uapi/linux/time_types.h
@@ -30,7 +30,7 @@ struct __kernel_old_timeval {
 
 struct __kernel_old_timespec {
 	__kernel_old_time_t	tv_sec;		/* seconds */
-	long			tv_nsec;	/* nanoseconds */
+	__kernel_long_t		tv_nsec;	/* nanoseconds */
 };
 
 struct __kernel_old_itimerval {
-- 
2.53.0



