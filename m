Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C99230DD2F;
	Sat, 12 Sep 2026 19:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240335; cv=none; b=QPltQEP4R6ikBSscZ0SlqtAhQMZ0WauJ2YHYoFOgraW44nzCdh0sFZ0wQ8CbYizY2fiRr97nZTa52Q7UyBsJNfqDG1E2FcbQav7RsYKuWx5SFVkPTzqjtExbqbhGplDESiGk/TS1y7KiJ5VtTRQKTAfpIK+lHyhcCDcDzuiPhTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240335; c=relaxed/simple;
	bh=GtuHy4RLBjnpEtp49R7UupNqqnFD+LasIob+S23Fkug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FpaZq0uxgta05bppFjLoACKoXj/ayvAYwNQn4E38A1nJ6n7nyZgBsRlJi6E2kL8oPPc3AWpE9gvHcDZ+lhign5JezXMxj34MLc9bLn6GBBv9w3TWPTrTniZp8A2IHaeBHvtg0VtGv9uOKudYVBQVcbwdDwWG6ls3LZLSn4Hk1+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cS3l5rNv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cS3l5rNv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E02741F000FF;
	Sat, 12 Sep 2026 19:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240334;
	bh=o8PscAEMNffBsItmuiwYmT5h42WGMkghgLSlzr8StDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cS3l5rNvEOD+SwPQDT4x7NXequPdX/b4lNaZsvIRYpuUBQwh/+/tDHNHUED41TzLm
	 JNNpUUJop6PEAl5RqVo/qgn81t1AcHm2miONopZzECn/AKA+CqaYV6rEmiF0CmT6GE
	 xONQbz+eoZcwGMAu26p6xjlG667V6j2yikNqq3Rk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 846/935] net: bridge: vlan: fix inverted default vlan notification
Date: Sat, 12 Sep 2026 09:04:36 +0200
Message-ID: <20260912065546.232579584@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Aleksandrov <razor@blackwall.org>

[ Upstream commit 21040c7f931502070dcc66bb0f1aeed07dec032b ]

A notification should be emitted only when the vlan delete was successful
and not otherwise. The proper check is if br/nbp_vlan_delete returned 0.

Fixes: f545923b4a6b ("net: bridge: vlan: notify on vlan add/delete/change flags")
Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260814141640.64958-1-razor@blackwall.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_vlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 5c41c6d00942d..eb3b7d23fbd0c 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1072,7 +1072,7 @@ int __br_vlan_set_default_pvid(struct net_bridge *br, u16 pvid,
 		if (err)
 			goto out;
 
-		if (br_vlan_delete(br, old_pvid))
+		if (!br_vlan_delete(br, old_pvid))
 			br_vlan_notify(br, NULL, old_pvid, 0, RTM_DELVLAN);
 		br_vlan_notify(br, NULL, pvid, 0, RTM_NEWVLAN);
 		set_bit(0, changed);
@@ -1094,7 +1094,7 @@ int __br_vlan_set_default_pvid(struct net_bridge *br, u16 pvid,
 				   &vlchange, extack);
 		if (err)
 			goto err_port;
-		if (nbp_vlan_delete(p, old_pvid))
+		if (!nbp_vlan_delete(p, old_pvid))
 			br_vlan_notify(br, p, old_pvid, 0, RTM_DELVLAN);
 		br_vlan_notify(p->br, p, pvid, 0, RTM_NEWVLAN);
 		set_bit(p->port_no, changed);
-- 
2.53.0



