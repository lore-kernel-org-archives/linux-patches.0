Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216FD345757;
	Tue, 11 Nov 2025 01:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823627; cv=none; b=EkN2wW9SzRRTUTQBQ31mq9cLQh/fMLB6jdmkgRFmWbgtfXIwq9hNdAtYFGg7+uu/EzIJN0TqJ4bX+WQ1AMR4DWEZkAdS0B9ZZhf5s9Re9fA86pYTSMSBR7VGMrSdu/8rEfYBtp+B07i/0t+CNVhay2VGFoJm8JhJvHziHVG3Waw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823627; c=relaxed/simple;
	bh=th6wBPZnubua1wWNJ2Y8cr7Goj4qXZH/PYujpc6MhYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MriGXrZOzHdiltdHsJQApBtYUFe1qSMq6xCOIvAdtIGP5Bj6cI/i6MXdwulRTHRVqyrKbiJoaEgCgRi7Rp2S4MJtGpShbu/rD7QHufZlaUgJq3JUCeny9yLHIt5eB7usY8/qCnb/rD7s2zUcylP17RmohUR7xUgDYE5D2w6Bfws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rEao0hWm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rEao0hWm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6CFEC16AAE;
	Tue, 11 Nov 2025 01:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823627;
	bh=th6wBPZnubua1wWNJ2Y8cr7Goj4qXZH/PYujpc6MhYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rEao0hWmUNhXkA4AxvVYFBZt4jSiOvEWBl1VIQVkTBKW//dy3PBiSblGSRweMsdU2
	 VKWydoFrFWJ0gMUSkzpZ0CkxQqJ1g1oVamumZj6O81SxKmrJDk6skzeAMFxsBAMYTf
	 L4Kj1cghLqESxx8wCoIGkBv1FIE19UMO/At+PNi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Haibing <yuehaibing@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 289/565] ipv6: Add sanity checks on ipv6_devconf.rpl_seg_enabled
Date: Tue, 11 Nov 2025 09:42:25 +0900
Message-ID: <20251111004533.377371973@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yue Haibing <yuehaibing@huawei.com>

[ Upstream commit 3d95261eeb74958cd496e1875684827dc5d028cc ]

In ipv6_rpl_srh_rcv() we use min(net->ipv6.devconf_all->rpl_seg_enabled,
idev->cnf.rpl_seg_enabled) is intended to return 0 when either value is
zero, but if one of the values is negative it will in fact return non-zero.

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
Link: https://patch.msgid.link/20250901123726.1972881-3-yuehaibing@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 49ec223f2eda4..228cf72e52503 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -7176,7 +7176,9 @@ static const struct ctl_table addrconf_sysctl[] = {
 		.data		= &ipv6_devconf.rpl_seg_enabled,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler   = proc_dointvec_minmax,
+		.extra1         = SYSCTL_ZERO,
+		.extra2         = SYSCTL_ONE,
 	},
 	{
 		.procname	= "ioam6_enabled",
-- 
2.51.0



