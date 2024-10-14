Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219DF1798C;
	Mon, 14 Oct 2024 14:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916282; cv=none; b=omKh1zpJYW8g+A0Zjb1CwDd7p14tYCKKZU5BUu5L3ni8AdVK4X+ILCoed+ZBSbuBP0+G6aiyZ/YZShb7G3aOZ8IzBl8h7eMYaee5hi7AdGI0iB2gRIi7XP5zY+igj9iWf/MAlR3r6FEv5cQPCOoJyKbCiV9SFYW8LS/fytXIHOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916282; c=relaxed/simple;
	bh=2yU8Ub58j14EFyi+qdF27xunJBYnaGRnjdTgn6OOMNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ux5W/VQCimmmeFyag98AxncYy9O+PbHCCXcuv67VMpp+0k1GvRk1poUBThpr7F7wCZn3UorVMqy/S7nDSdK6h0qhweABVQ35ySoa0YjbGwzAg/UAfPjxXpmNQXSOIbJsNVb0KD+dMoca0v8+F1kKfpP2lCHbAafCojYvm0usi8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZVW96j81; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZVW96j81"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B9EC4CEC7;
	Mon, 14 Oct 2024 14:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916282;
	bh=2yU8Ub58j14EFyi+qdF27xunJBYnaGRnjdTgn6OOMNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZVW96j81QlC495HbQ7MHDbxkKolIsNuXEBU3EMBv3hnoEs106gWTmp/IQsTGdJPDZ
	 rZiPZc/RC4oLjdv2sB+cQQHyxgd0FG4F4v8J6zaZOCsxmczgkxKOC1inu9cSzB8PBJ
	 zSNxWGbJ4dYJlkvSx4ek0aHPSOKPDj5A0SYXXF4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 137/214] net: dsa: refuse cross-chip mirroring operations
Date: Mon, 14 Oct 2024 16:20:00 +0200
Message-ID: <20241014141050.337060882@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 8c924369cb56c3054dca504c2c9c3eb208272865 ]

In case of a tc mirred action from one switch to another, the behavior
is not correct. We simply tell the source switch driver to program a
mirroring entry towards mirror->to_local_port = to_dp->index, but it is
not even guaranteed that the to_dp belongs to the same switch as dp.

For proper cross-chip support, we would need to go through the
cross-chip notifier layer in switch.c, program the entry on cascade
ports, and introduce new, explicit API for cross-chip mirroring, given
that intermediary switches should have introspection into the DSA tags
passed through the cascade port (and not just program a port mirror on
the entire cascade port). None of that exists today.

Reject what is not implemented so that user space is not misled into
thinking it works.

Fixes: f50f212749e8 ("net: dsa: Add plumbing for port mirroring")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20241008094320.3340980-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/user.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/dsa/user.c b/net/dsa/user.c
index f5adfa1d978a2..ac34d5d1deb09 100644
--- a/net/dsa/user.c
+++ b/net/dsa/user.c
@@ -1392,6 +1392,14 @@ dsa_user_add_cls_matchall_mirred(struct net_device *dev,
 	if (!dsa_user_dev_check(act->dev))
 		return -EOPNOTSUPP;
 
+	to_dp = dsa_user_to_port(act->dev);
+
+	if (dp->ds != to_dp->ds) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Cross-chip mirroring not implemented");
+		return -EOPNOTSUPP;
+	}
+
 	mall_tc_entry = kzalloc(sizeof(*mall_tc_entry), GFP_KERNEL);
 	if (!mall_tc_entry)
 		return -ENOMEM;
@@ -1399,9 +1407,6 @@ dsa_user_add_cls_matchall_mirred(struct net_device *dev,
 	mall_tc_entry->cookie = cls->cookie;
 	mall_tc_entry->type = DSA_PORT_MALL_MIRROR;
 	mirror = &mall_tc_entry->mirror;
-
-	to_dp = dsa_user_to_port(act->dev);
-
 	mirror->to_local_port = to_dp->index;
 	mirror->ingress = ingress;
 
-- 
2.43.0



