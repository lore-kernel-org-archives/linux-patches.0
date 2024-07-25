Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D96B19AD93;
	Thu, 25 Jul 2024 14:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919240; cv=none; b=ZVNZpCIhbYuZ60m6PVhd5OoKkFGYxJLxiV6aY4Ai6Y598xo8dCGXsgYUSQ7Ab4ytDRTT4SFV6MAbMJKRMBpKOFgHqWiTikfA3/leQMi+NpXY4ze3pUq1fKi/58BYVtJmhELoxrFgRlAov8YTIuD0vXYOxJO/Z1IzABVHvXHxbMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919240; c=relaxed/simple;
	bh=s2PR9rvFiggAXH6L1bQRwlo7+E7mCtqSgc2rJGlIBeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ctpgUZ4vwHSu/35tYKzPHTPcBeeNlB3Mo31hufBTKTsQDAytgCQBkjC7pSoIZ5ZoCo2RdzwQ0dYs6PqSccIpVYMxCqpKO1kZApq5508d0UY6RthPQhLMMw3c20GAbM1OIV0zvaOgp/jMjshhVQXWIuqwm9Q4ZecqBDEueQd1UU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nc2c/ZWs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nc2c/ZWs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA15C116B1;
	Thu, 25 Jul 2024 14:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919240;
	bh=s2PR9rvFiggAXH6L1bQRwlo7+E7mCtqSgc2rJGlIBeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nc2c/ZWsbsD8YwRO80IV4Vbi2mmrTn1tN1XjX0ZO3Qjan1LTM9Cb1YrduRADfWHTX
	 JJISwPS4OBTVVEyX0vORUuMpIObhi+3Af1zlc6EI9FV4Giyhp/QtTZx9NVdgejKVfe
	 763Y+ToH+wFlYcKi3R/IhZ0LH1aYykMBofgYBWyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 35/87] mips: fix compat_sys_lseek syscall
Date: Thu, 25 Jul 2024 16:37:08 +0200
Message-ID: <20240725142739.758737187@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142738.422724252@linuxfoundation.org>
References: <20240725142738.422724252@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ec1119760cd3c..cd107ca10e69a 100644
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



