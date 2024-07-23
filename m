Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7596158A00;
	Tue, 23 Jul 2024 18:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759252; cv=none; b=S1qI+Qhe+VPuyWC6byoaGUtJhDb3n/MQ42vOa6WfIoNaGgDSwlNWz/i3zN3KHDWFuw6BZZqCTWcI4HnYrqKIgDPWrh0ThvxdTHFsnBG9J1USTIHak7vw7vF+c5AgChW1625u6S5EPHb/TscQm2zxn7J7KxIrpsFZyYT0QhIx/kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759252; c=relaxed/simple;
	bh=qT43gByu8zJY/Sg+i8gRwBjbmMREW0Jgtvv9SK8ybsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iGdSJM/bIK5j7shvmEdghLQ8O49Zm5xr9BqbIXVp8Gupp0FsWR68/c3zqY1loyv/2i9QrpqJ8TViGLIREsSV8rHbSYpCJsHbL3UgCcL6IbdsDsU2KaIMXUiC1pOdlWjs29VX+/nGxGXZzxqUkzPPCuoMygZXGUML2NWjzXA4YZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hsXKz2yG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hsXKz2yG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39EA9C4AF0A;
	Tue, 23 Jul 2024 18:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759252;
	bh=qT43gByu8zJY/Sg+i8gRwBjbmMREW0Jgtvv9SK8ybsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hsXKz2yGyrKVUZh5OyQTWBNsFCshOK/V12lcbD+LXEtxd/DhrmZdd0mNI95N0LHOn
	 17QxQHLiYHwsgtNkCnJZQir1JzLXh2iWtOUdsuoeGRM4tjfvCDhK8HKgHMn1G9L156
	 E3Y8AIuGU2PXPDqonEhNQb/Dsgctu92Y6vQybsxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 053/105] mips: fix compat_sys_lseek syscall
Date: Tue, 23 Jul 2024 20:23:30 +0200
Message-ID: <20240723180405.294790847@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7ab572040f534..20a6434f56361 100644
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



