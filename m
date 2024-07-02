Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0445C15218A;
	Tue,  2 Jul 2024 17:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940201; cv=none; b=h1XwyPHtEmAvFi0rbhlvxvbuwA76aU4iJqMc8JwAsOA7qTSJ6GWrzz5N09o1XTZEbGriEwlmF30ei+U1C5zfgyjYFrqaHqt4aDUHXVGFTR6O8di+BSQcA4ptPMU7ltKEWxY541suj9VC3zQoi51/1EnMxAckk3I5/I/YpWrQoog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940201; c=relaxed/simple;
	bh=hjJUOr1fG7nmm/oZA/r/SoBGup9Cjk+TkGijiqOolP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jR1yX094MD9+yXtKjp8f9k2a/HToFASGFDqASCTrIxzxvTjpB4hbAtVs2dVDC8e14l7X2WzPxc831buz3eqIAc8gXR3TnkKQWKLKiPWEplWsgPo16qgGweez+EC/YKZkbmygX0yb8OoF6quoy4s0s6Lw1JF3sfMjT9iBR7NoLg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uZIQUCUX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uZIQUCUX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E374C116B1;
	Tue,  2 Jul 2024 17:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940200;
	bh=hjJUOr1fG7nmm/oZA/r/SoBGup9Cjk+TkGijiqOolP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uZIQUCUX6Yx1sJ0IeF1Ts6vquQ7nYqkfKCvB5TvHH6BbIFaKqICKoMOMoeeTs4P4t
	 dcubSjdtITVBB5hQI16kL59eZBAmJG9toe2yHJ3OxqscSVn+y3IEsN7UrULUl/sH5y
	 FsqVjcJ4Sm0rWB6TqLtRxOlXHz8GSGkBoD1uxk/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 051/222] sparc: fix old compat_sys_select()
Date: Tue,  2 Jul 2024 19:01:29 +0200
Message-ID: <20240702170245.926897359@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index b23d59313589a..45c01529585c9 100644
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



