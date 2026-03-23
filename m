Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F613A961B;
	Mon, 23 Mar 2026 13:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774273812; cv=none; b=FaCycBAx6I3ChTGu8veWOADal1nMinH8qO5sg70l8nLDt5iifTjV7q/c1jMliF7MMSptLcFuMNoHcY8Vc+sTCxVJFtzGvqKcbc+UaxdrEr7Z014xc/hS8pUU1kx1QSm/l0QWhIttRAm+CRNVlrsaAmgkOtWTMBThDb4Qw3kSsE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774273812; c=relaxed/simple;
	bh=+WboHKI+MysxoEABOWvKzVgKpeNayEhygek/MmH4juY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NLZ1WzZezKxxu6iPT13o5AlXDKD8kS7Yk50AwuNkN1H31YAAKC/mSbXYHY9TCfQDVKT/tLGeQdcZLnFvIX4ULutj/PdOg9UKtcLizPKgH7bi+fKRRkpmj7OaricFavfUZVuoHNarCIxemgs5VjmcTAqar7jn5+aNkhpmi/18KHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JRqf/MJa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JRqf/MJa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CACC3C4CEF7;
	Mon, 23 Mar 2026 13:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774273812;
	bh=+WboHKI+MysxoEABOWvKzVgKpeNayEhygek/MmH4juY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JRqf/MJarDG5Dv1IlAePwioJKRHp/M3Iy/YGDArycFKdHKa1ca68ptAG13SXmfVFS
	 VoxEY9Vb2K4C44U7yB/ZsuCN5LYyWjwQZEgjBueJvMJvihCO/GLQyJ18IPPhEoTBU9
	 2V78mFW/v2mc5ZE47qZ4xa5YpuSe1/XFBTfdU5Es=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Lechner <felix.lechner@lease-up.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.19 017/220] parisc: Flush correct cache in cacheflush() syscall
Date: Mon, 23 Mar 2026 14:43:14 +0100
Message-ID: <20260323134505.121422812@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit 2c98a8fbd6aa647414c6248dacf254ebe91c79ad upstream.

The assembly flush instructions were swapped for I- and D-cache flags:

SYSCALL_DEFINE3(cacheflush, ...)
{
	if (cache & DCACHE) {
			"fic ...\n"
	}
	if (cache & ICACHE && error == 0) {
			"fdc ...\n"
	}

Fix it by using fdc for DCACHE, and fic for ICACHE flushing.

Reported-by: Felix Lechner <felix.lechner@lease-up.com>
Fixes: c6d96328fecd ("parisc: Add cacheflush() syscall")
Cc: <stable@vger.kernel.org> # v6.5+
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/cache.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/parisc/kernel/cache.c
+++ b/arch/parisc/kernel/cache.c
@@ -953,7 +953,7 @@ SYSCALL_DEFINE3(cacheflush, unsigned lon
 #else
 			"1: cmpb,<<,n	%0,%2,1b\n"
 #endif
-			"   fic,m	%3(%4,%0)\n"
+			"   fdc,m	%3(%4,%0)\n"
 			"2: sync\n"
 			ASM_EXCEPTIONTABLE_ENTRY_EFAULT(1b, 2b, "%1")
 			: "+r" (start), "+r" (error)
@@ -968,7 +968,7 @@ SYSCALL_DEFINE3(cacheflush, unsigned lon
 #else
 			"1: cmpb,<<,n	%0,%2,1b\n"
 #endif
-			"   fdc,m	%3(%4,%0)\n"
+			"   fic,m	%3(%4,%0)\n"
 			"2: sync\n"
 			ASM_EXCEPTIONTABLE_ENTRY_EFAULT(1b, 2b, "%1")
 			: "+r" (start), "+r" (error)


