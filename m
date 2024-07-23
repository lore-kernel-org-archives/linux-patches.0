Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209F713D600;
	Tue, 23 Jul 2024 18:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759683; cv=none; b=gcf4qgO9mue0dCBXs5AhpKj2wKkvPJpZb0wAhCrcm25FPYNorduu6eUwxljSBL3/And7ha6SOvlrKDB9AXLIN+7CYpEApcj1bzDDwKBiVJaSWP/7MulBz2dwBQ611S2YxnVWHvnxtxhCL2yhblShdz6O/wRtVmyEcOIPZer1OHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759683; c=relaxed/simple;
	bh=Rv7/juAlJIYw4mI5DRMLd+HYAu/sUXln4lIRQSC8PZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NDVghpOhafcYv7PFwhZBH+ygdEitbX7bN4pvw4AY0/ohtUer0nP+BhENm7GboSiTspJcSnDQq/CcV22RbgUUmY1O6/VYToSiV/iWZ4LtXEXk0DzM7izZ520IlIBO6hi7M+sBVUm/zYuGmLKRMqgQOHYLIOBcwuTk4ZxIndWeD0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sRZZLr4q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sRZZLr4q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C6AC4AF09;
	Tue, 23 Jul 2024 18:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759683;
	bh=Rv7/juAlJIYw4mI5DRMLd+HYAu/sUXln4lIRQSC8PZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sRZZLr4qNU2H9lpwOlpALERv4ZIXQ8fl7A7m6QeBGA62ybqtDuJjGvrM7fNQTgDfg
	 FuHmkVw4PfB5GFocPx36DEj3crPDzTg3RfDWPG/L92ZA0NcqGzL+t2oMGAumzM+0So
	 xF2z/s2fjZLbwqUoMH+EbSAPTfJ/eoNkl5GZpCNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 062/129] mips: fix compat_sys_lseek syscall
Date: Tue, 23 Jul 2024 20:23:30 +0200
Message-ID: <20240723180407.182513569@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 37bbc8d9a94cc..1ee62a861380a 100644
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



