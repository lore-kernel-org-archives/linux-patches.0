Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7BC883CBE;
	Mon, 15 Apr 2024 14:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191634; cv=none; b=KKqOtN49RI9M8+3N2ZAn6BKUg8nTKUR6/aTXIe6FVgj2sO/GnVRKdgKT7FOuIQtba3glPzeJF6ranCjGuYTJHp9yApL/vz/JX1bognPVME03ORSZw4BtzvcIqDoC4GblBxGVz+VJ5PrWawzbC7BGIc9OT7z6TAU3Fce1c+cSrbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191634; c=relaxed/simple;
	bh=2MvIhG0WJyCk3oobbK4xxYI6Hc3BSwn5+exV8G8dV3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OSrqdm1b79FXYJ7zc2ksmK5n/UvIqgRa8CNDOrUwl1ICJkaLodyx/3gonafuU9Rolf5j98j5wZITHjqrfoWCS7Kphh/5ftUvRScO/qLRr5Z9kiu0qHQ3oJFCyusrAOEZ65651dZbKA/PQBjjSBK5i8Y1OdJjHsn3h/YB6sNd7Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LVHeUY2l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LVHeUY2l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BDD4C2BD10;
	Mon, 15 Apr 2024 14:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191634;
	bh=2MvIhG0WJyCk3oobbK4xxYI6Hc3BSwn5+exV8G8dV3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LVHeUY2lmAxBY9li7CbjknR6sTaOF0AkcRLkLxRTIbbO0V9EMD44dwpYRdiNk9B86
	 ybBqL2Jb5dluRccAxI4J/c8su42QtnDVcyI5IA8S3yazPg1Qc1BQ4YGGgKbZ2meqF+
	 s3MAUMrfIvIkpyiDmzFVWbIhTu5Q567/TXe0lOow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 034/122] octeontx2-pf: Fix transmit scheduler resource leak
Date: Mon, 15 Apr 2024 16:19:59 +0200
Message-ID: <20240415141954.394560340@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit bccb798e07f8bb8b91212fe8ed1e421685449076 ]

Inorder to support shaping and scheduling, Upon class creation
Netdev driver allocates trasmit schedulers.

The previous patch which added support for Round robin scheduling has
a bug due to which driver is not freeing transmit schedulers post
class deletion.

This patch fixes the same.

Fixes: 47a9656f168a ("octeontx2-pf: htb offload support for Round Robin scheduling")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/qos.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/qos.c b/drivers/net/ethernet/marvell/octeontx2/nic/qos.c
index 1e77bbf5d22a1..1723e9912ae07 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/qos.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/qos.c
@@ -382,6 +382,7 @@ static void otx2_qos_read_txschq_cfg_tl(struct otx2_qos_node *parent,
 		otx2_qos_read_txschq_cfg_tl(node, cfg);
 		cnt = cfg->static_node_pos[node->level];
 		cfg->schq_contig_list[node->level][cnt] = node->schq;
+		cfg->schq_index_used[node->level][cnt] = true;
 		cfg->schq_contig[node->level]++;
 		cfg->static_node_pos[node->level]++;
 		otx2_qos_read_txschq_cfg_schq(node, cfg);
-- 
2.43.0



