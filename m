Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5F0757EA;
	Mon, 15 Apr 2024 14:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191145; cv=none; b=klfOSbco07l8F1b9MEFU5QkVJVEU2MtgRSLlfXrLF78p1aWRrfE4mp55IK1aa8q9TOZlSwiuht+FSNFm/KJLKijD5MfXBLbZjvQ3z2d3Djr3UqhTYu7hisn7JKXrHByoI2Zbi6/sldpXD6+ySH2YvYMdk0UyhZTi6deai9R+qwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191145; c=relaxed/simple;
	bh=FXtC2sfKog7X/71oDZ+RZltqpoZdhZc5feRE1vl0lT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GrT2Z1deZunMfiNTjUE2QFwEpXGpiFE74yiCe+pdX3q2qgCRubaPgstGRcpytyfZ6rCP4sxxlRgs3MtazmA921rX/J54/CnmFavhd4pHSCcQZ1PfHpuoJw6fEWZItnuxWzOPikJMJ6JBZfoN9daPy975XotUaFkahO2ArGs3WyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mXp8F/+V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mXp8F/+V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B80C3277B;
	Mon, 15 Apr 2024 14:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191145;
	bh=FXtC2sfKog7X/71oDZ+RZltqpoZdhZc5feRE1vl0lT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mXp8F/+VX2OOQYHV6Og5EXyRecKVnlPcIDwdirOJKvekAhQ91M/QziDoUW860pPxm
	 90t+37oB5HzSCJ8dIILqoVRhl+HHQR+Z6fRqqkfpQIiIVY/N3H8hEQpND6HonTvK4A
	 lKfsF1GT4m40wDLMNCwVEovtI5NLKs65gvwYHQdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 046/172] octeontx2-pf: Fix transmit scheduler resource leak
Date: Mon, 15 Apr 2024 16:19:05 +0200
Message-ID: <20240415142001.818414126@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



