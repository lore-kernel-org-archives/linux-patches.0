Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3627614293;
	Tue,  2 Jul 2024 17:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940909; cv=none; b=jOBsZAo8mZEM6gwRQjOg0T3kH+5qgvbm+9NbKM2z3KF5mOPNWKLtNCw4AXjaXiWZar7vvy0ZXPzcFBzLHwdO6hZ/sySGTzvtvG9seu4VfFUBPwzv/Fnt9MpTLkMzlQll6jG+rDHZ3ywXg4giTIZINrA4+578llWGbOq+bax+wRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940909; c=relaxed/simple;
	bh=Np0/aZ9RR/2yryW3xI2qMD739GYMGZVp3d3HOjeNJYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f3yjQ8h2eUqn5bPiN40DhJiwNqmtTCrd4AtkjRR+WQuH5KAq7CDGC4oKQpOzAaVPioYd4pFenUz4PDZoDnUFyh5JkortLZgeUuiy3AuPn8EVmh4MdaAa0qr2rsFW+AHx6XMgqzIV6alLVGPpYosZ0XJJRcAYemEz9Xt8ACbKUKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jZDjBW7X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jZDjBW7X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0870C116B1;
	Tue,  2 Jul 2024 17:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940909;
	bh=Np0/aZ9RR/2yryW3xI2qMD739GYMGZVp3d3HOjeNJYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jZDjBW7X8/T0AEfCYbOdl8l/EN/TpDRf3HrMIIqQu/hN2lOAtPOqBJaGqem27Sq0T
	 gl++LdSTrUnrsgUQEI2e+g5UrUZSviJb03GdFUi3REoEF4xNhLKPM4ew/uFK89v+UX
	 w6SR9B9FijdvtbfWcvDrzF2OchLvs/Er59EUV3+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/163] sparc: fix old compat_sys_select()
Date: Tue,  2 Jul 2024 19:02:36 +0200
Message-ID: <20240702170234.653507241@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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
index 4ed06c71c43fb..6dd1e2df87a03 100644
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



