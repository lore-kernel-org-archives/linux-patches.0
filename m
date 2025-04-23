Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F62280A55;
	Wed, 23 Apr 2025 14:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420282; cv=none; b=GeFRnE4XlLRkTc4RcJTU+n2K4c7IbKAOcbk83zQxxb3Y/mYTtCjGSm0ga5VtFvF3elNqfBGAkMrvXuOdQvmPXuDoNHrI//SOLsOttDVdlBeVmMFy/Sdc0PTreRfkmtQqdpxRu5c9GVwNbWU5uiChuPfcc3UfEdqt0cMo0xCaNTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420282; c=relaxed/simple;
	bh=pluNPGyr1CaWOLT9KeeTl7/+j8mKG2ROsS7T0CQYDBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sgt2usvJ9NFaxv6tf2+Q12Wna0iSjDQcRSW/MdTTu9IV6GxgeIOqmCDwci3giupGw3/Sniy9IMvN3DeS5maZtD+/J/J5Q4lE6VU+BXCT/UTKmH49ZjxfSUh5GkT/w5/EqFPjxLdM3eAncQaF4hfO4REd0BsfJ8iDKegZL26EoE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VMIJ0n39; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VMIJ0n39"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD72C4CEE2;
	Wed, 23 Apr 2025 14:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420281;
	bh=pluNPGyr1CaWOLT9KeeTl7/+j8mKG2ROsS7T0CQYDBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VMIJ0n39K1PSt02EUy71YE0w4/IKqwemIHKNgtINLdSSnArvGxBv/zp4Pq/3Iiw+c
	 pK4U9Znird8e8DW62pLClL8GDqT3YnIRx+SCXt+WndT2LmsfNu9QerLHNlvHlwhXh/
	 KPP5C2xPHdv7sPLGvBpaFAG6+shd4LvLx5fpkAW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 078/241] net: dsa: avoid refcount warnings when ds->ops->tag_8021q_vlan_del() fails
Date: Wed, 23 Apr 2025 16:42:22 +0200
Message-ID: <20250423142623.777083206@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 514eff7b0aa1c5eb645ddbb8676ef3e2d88a8b99 ]

This is very similar to the problem and solution from commit
232deb3f9567 ("net: dsa: avoid refcount warnings when
->port_{fdb,mdb}_del returns error"), except for the
dsa_port_do_tag_8021q_vlan_del() operation.

Fixes: c64b9c05045a ("net: dsa: tag_8021q: add proper cross-chip notifier support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20250414213020.2959021-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/tag_8021q.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 3ee53e28ec2e9..53e03fd8071b4 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -197,7 +197,7 @@ static int dsa_port_do_tag_8021q_vlan_del(struct dsa_port *dp, u16 vid)
 
 	err = ds->ops->tag_8021q_vlan_del(ds, port, vid);
 	if (err) {
-		refcount_inc(&v->refcount);
+		refcount_set(&v->refcount, 1);
 		return err;
 	}
 
-- 
2.39.5



