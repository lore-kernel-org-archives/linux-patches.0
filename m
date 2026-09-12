Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB42732FA30;
	Sat, 12 Sep 2026 16:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229252; cv=none; b=EQZe3oPIdkjOZKK1xCLCUmkf8eJDM63tgJ5aCOo+uHB1jyE0OSMnpQM8dj/b9zwicWhxIMPsAah3jEAAh28HjwpFN8IZJbEBcyQsoy247R4QelWIk7whCwh4aCinzvRB9usinCxsrCQaxKw36lEb+fCLopmg+C5sIFJ+wqyOWF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229252; c=relaxed/simple;
	bh=+PS5O1TNeqO7ZXB+QbU+V9j9pwoiHcHoVOPwHO+CJHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eNpCTDBoPNxSlYi1VKu9KqF96BdISf5aWpGRzhljbysqELYCBcmNk+oo0lyPxZIiWI/hAEALnUZfjrZhs3/kV35xpv46zzQftOUty7qHf5r/DLC5bLvp6WPpdfrtingfS/RVq6EwZjrY94PQbrUqeixWp71ljhse73bH99FyOvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XElBNw+n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XElBNw+n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB191F00893;
	Sat, 12 Sep 2026 16:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229250;
	bh=Rm0p2WyI6kUyjXJJH94jWdxv3XOxlVImC8Jo7hjKldo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XElBNw+nSJ0d2TwWfVWbxa8s8FOGgdmYkD8LJasSFHtK4AVRYVuUUoODJ5BAM2Jsk
	 7Vq93zsALhjh4MqpZKH/LIsBYS7+BbBU3rwatFqJPxCsTMEBQXJsewhmnmMDD8fCPx
	 E1dJaJXBQ7CWhN5g+LvFHdtq0WqpgCA8Lrgkt5SI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0550/1191] y2038: uapi: Use 64-bit __kernel_old_timespec::tv_nsec on x32
Date: Sat, 12 Sep 2026 08:54:38 +0200
Message-ID: <20260912065600.595893853@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



