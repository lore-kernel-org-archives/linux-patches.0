Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1A8212F9E;
	Thu, 12 Dec 2024 15:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017458; cv=none; b=RdFXff90Y584h3DC5MNULbg6Ez2UnzUdTGOl7GiodsnJAxnh40tg4TKXkEJxyON7AkI+IFnVdcCYEMMyrzU6LPQ9e168kt7n1BJSTOPHGOnlOsHh+kTO06Cax1KidoWI+iwfNIG9f9XFaTLYChqki6WPgzPfTMj7fZETlECLFeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017458; c=relaxed/simple;
	bh=2sxx28Nmma6KuN/a6rSzQ3sJh3T/n9PO8M7mErNtH+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=muo5zsp7vZXuLZBl8R/cdR9bki4Lf1YaXD0HhBjR6Kwz5jts5wUQCqdTU5i6oznEDwfyc45Sg4nkMRx6u0kM3vkDl48st1LUKuyMSRTsdV6ShTVLQjSwSlS2PIByShXE83U0qitzGRnCxctAMYsIVoCjH6C4nFnIemsTV1X4GHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BG7iVTZv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BG7iVTZv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5AB4C4CECE;
	Thu, 12 Dec 2024 15:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017458;
	bh=2sxx28Nmma6KuN/a6rSzQ3sJh3T/n9PO8M7mErNtH+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BG7iVTZvVs+ShcsdyyU9BlV58skPBJmtCDTKIoLfDdmef0ds84y0hPnvrdVB0M0ie
	 89WBghJyVg19D8Lur4b9c5uxlSHy0FilNSMreDS+NK/c2xJq3Y/E7zzXmsIGpD+lUZ
	 NzqSLSZk0fkOGHPqkk+aGkjM/7DUNLwpelb1wtpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+57bac0866ddd99fe47c0@syzkaller.appspotmail.com,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 019/356] netfilter: nft_socket: remove WARN_ON_ONCE on maximum cgroup level
Date: Thu, 12 Dec 2024 15:55:38 +0100
Message-ID: <20241212144245.379743036@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit b7529880cb961d515642ce63f9d7570869bbbdc3 ]

cgroup maximum depth is INT_MAX by default, there is a cgroup toggle to
restrict this maximum depth to a more reasonable value not to harm
performance. Remove unnecessary WARN_ON_ONCE which is reachable from
userspace.

Fixes: 7f3287db6543 ("netfilter: nft_socket: make cgroupsv2 matching work with namespaces")
Reported-by: syzbot+57bac0866ddd99fe47c0@syzkaller.appspotmail.com
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index 0a8883a93e836..187b667bad6c3 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -68,7 +68,7 @@ static noinline int nft_socket_cgroup_subtree_level(void)
 
 	cgroup_put(cgrp);
 
-	if (WARN_ON_ONCE(level > 255))
+	if (level > 255)
 		return -ERANGE;
 
 	if (WARN_ON_ONCE(level < 0))
-- 
2.43.0



