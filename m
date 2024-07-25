Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85321E895;
	Thu, 25 Jul 2024 14:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919032; cv=none; b=ILWrhwqM9l/UCM0ZXQNeGd3/wxaAkjK5G2/rBjkx0Wzfdc5FWKXqNESrVYBAnMed5yEgvyf/V6FVvE8oDYiGGonAhZ+2qBzlxKk44C3R00qAbIsv6PZO6vvkcBkflg00uknJ7e1oUjSS4WLfFZO3xlNa+qpPeIKja8jDPHtNJh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919032; c=relaxed/simple;
	bh=WOZz3erTPIGz+sOzsE0DF/o/r2/g7JICK1DR1fjGYIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BPhZyAsRKYRvFEVp0e8G8NY3bLp/usYQgV+rfUGckOxFLPnX7zDriFVIVIpkIK52DAb6lkCPAKt3TNsyn3szDsECbl1apvkIB3Nkb2L9TBuHtEv0vv6Lqi+nbok5RBFCU7WTgbziQ1rHIXbGF9lEZBaXdreJMWIie+CM8BVKfrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RSS6nxj8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RSS6nxj8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2756FC116B1;
	Thu, 25 Jul 2024 14:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919032;
	bh=WOZz3erTPIGz+sOzsE0DF/o/r2/g7JICK1DR1fjGYIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RSS6nxj8ocbcJ8WX1heQ0ImvonvK9twnz7UiUNB810NiJwxCYkApfaGEPIzmZvVpY
	 2bYkSPinQTjHXkNnJRMawlZExpMH+H79P7+JT29FNqsMZuizeOfGbVnFoWmeU91FwT
	 3W/2FqmYXvsIId+yKr+J1CXSEcBBxpMMVgzORAPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 21/59] mips: fix compat_sys_lseek syscall
Date: Thu, 25 Jul 2024 16:37:11 +0200
Message-ID: <20240725142734.063122837@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142733.262322603@linuxfoundation.org>
References: <20240725142733.262322603@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 0d5679a0aae2d8cda72169452c32e5cb88a7ab33 ]

This is almost compatible, but passing a negative offset should result
in a EINVAL error, but on mips o32 compat mode would seek to a large
32-bit byte offset.

Use compat_sys_lseek() to correctly sign-extend the argument.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/syscalls/syscall_o32.tbl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/kernel/syscalls/syscall_o32.tbl b/arch/mips/kernel/syscalls/syscall_o32.tbl
index 6036af4f30e2d..c262975484fa4 100644
--- a/arch/mips/kernel/syscalls/syscall_o32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_o32.tbl
@@ -27,7 +27,7 @@
 17	o32	break				sys_ni_syscall
 # 18 was sys_stat
 18	o32	unused18			sys_ni_syscall
-19	o32	lseek				sys_lseek
+19	o32	lseek				sys_lseek			compat_sys_lseek
 20	o32	getpid				sys_getpid
 21	o32	mount				sys_mount
 22	o32	umount				sys_oldumount
-- 
2.43.0



