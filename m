Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD43B16DEAC;
	Wed,  3 Jul 2024 11:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005043; cv=none; b=jkfbZnXWHgixjRh6pkzKM8+hSDSod4j3V7DRBURi1QGi8Td9fG8bthEFpCa0XCNrE3F6vxtNinbvAd4uk3bnJDaZ/uGe7rHKdBv96kIB/wFmZnIAc/6zh9BC6pd3yjfwB7M/BeCwKhvCu3Xuf1t6/H6BJzKztax8N7al/JlKzxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005043; c=relaxed/simple;
	bh=Bm4mg30AGVTav0JGa2QGMCMAHDqjfGCP5qDm+8+RpgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GHFqqk3VZ1kjmbfkbZeUP9Oz9D+wtMLtXDLaktdYaheDt+TXK/9IxbyIZn14HWJ7rH+UNHZFHIkGS8kM/t7KUyS4VOCyN6LyMqnToqlN9S2sv5d4/GZt9xFLglhtUhNFeMNigI3551PeItewJWcD9fmvv5BEiyGjw3KCq1Gj0s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RePdMdjG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RePdMdjG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55A34C2BD10;
	Wed,  3 Jul 2024 11:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005042;
	bh=Bm4mg30AGVTav0JGa2QGMCMAHDqjfGCP5qDm+8+RpgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RePdMdjGMqgV1JGAl14jmE6A/+iHZSq1f92qXS5ZpzR6xrut9ODHyLjlpqiVfNq83
	 eumDXD8FKCcyNqpM/y0md7wgw0CgnN75fKZF1O9Qfd81SmKyi4zDT/7YhXfehUujYr
	 Ijjyzwp7EVAyXxHQWp4UrVpHntPr0dJ0Fzz2imVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 224/290] sparc: fix old compat_sys_select()
Date: Wed,  3 Jul 2024 12:40:05 +0200
Message-ID: <20240703102912.617783667@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

[ Upstream commit bae6428a9fffb2023191b0723e276cf1377a7c9f ]

sparc has two identical select syscalls at numbers 93 and 230, respectively.
During the conversion to the modern syscall.tbl format, the older one of the
two broke in compat mode, and now refers to the native 64-bit syscall.

Restore the correct behavior. This has very little effect, as glibc has
been using the newer number anyway.

Fixes: 6ff645dd683a ("sparc: add system call table generation support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/kernel/syscalls/syscall.tbl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/kernel/syscalls/syscall.tbl b/arch/sparc/kernel/syscalls/syscall.tbl
index 78160260991be..6869c7c71ebaf 100644
--- a/arch/sparc/kernel/syscalls/syscall.tbl
+++ b/arch/sparc/kernel/syscalls/syscall.tbl
@@ -117,7 +117,7 @@
 90	common	dup2			sys_dup2
 91	32	setfsuid32		sys_setfsuid
 92	common	fcntl			sys_fcntl			compat_sys_fcntl
-93	common	select			sys_select
+93	common	select			sys_select			compat_sys_select
 94	32	setfsgid32		sys_setfsgid
 95	common	fsync			sys_fsync
 96	common	setpriority		sys_setpriority
-- 
2.43.0



