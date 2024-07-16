Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B094A17A930;
	Tue, 16 Jul 2024 16:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146328; cv=none; b=KKT62W+1OSp0nOjpqL0/ihxrCNT83f76i9PVYfjmT+ewvHUScOcuPYTiegFQH0Bay0fgvOawuLe0ZYm5T4CdlB7MYBQaP+uV13KvcqLicE6t+jM7D+o4Xym2slQoscq3LZUDAICRB1mKNHCQmJMaXGeV6ouFHBO6nfnyKFOhCns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146328; c=relaxed/simple;
	bh=ny0DvqX+hqtPDtdjilnlXUcKubtucFLGiiR5q8Zf0Zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M9BlEtP5AVDjIUAQxqC+dunUUzau7/gpoOXm440n5X4NAMQcSZuDBQoPhIEtXZ5RNu5brva7RSeVUEAzVmlZ2FZBt1hvggnmpu7qbOB8tfJu/DX0w92oNzwL9GO2f1cTo4+UNJPae63BrdAuch7x6dxANFwE2nuC+j2ZAy7wBYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DgQAvYJ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DgQAvYJ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D68C4AF0D;
	Tue, 16 Jul 2024 16:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146328;
	bh=ny0DvqX+hqtPDtdjilnlXUcKubtucFLGiiR5q8Zf0Zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DgQAvYJ74ZzM793zfgn2viKsuVXDL1BjhFpkwvPpjhg9f7+WWFokDd3BUmGaKAv1H
	 epysFkPtM3rypAg+Tn3CBIgPV0cusp8XtJUVx/yIQS9HcqFdgKvZOirF5TjqaDSpSa
	 IZFK6VXcW1Tv8nj3zB7/ykvy+Eyu6vWmmbAyyMWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Mazur <mmazur2@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 100/144] octeontx2-af: fix detection of IP layer
Date: Tue, 16 Jul 2024 17:32:49 +0200
Message-ID: <20240716152756.380032801@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

From: Michal Mazur <mmazur2@marvell.com>

[ Upstream commit 404dc0fd6fb0bb942b18008c6f8c0320b80aca20 ]

Checksum and length checks are not enabled for IPv4 header with
options and IPv6 with extension headers.
To fix this a change in enum npc_kpu_lc_ltype is required which will
allow adjustment of LTYPE_MASK to detect all types of IP headers.

Fixes: 21e6699e5cd6 ("octeontx2-af: Add NPC KPU profile")
Signed-off-by: Michal Mazur <mmazur2@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/npc.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
index 0f88efe39e41a..bac083c5c2785 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -56,8 +56,13 @@ enum npc_kpu_lb_ltype {
 	NPC_LT_LB_CUSTOM1 = 0xF,
 };
 
+/* Don't modify ltypes up to IP6_EXT, otherwise length and checksum of IP
+ * headers may not be checked correctly. IPv4 ltypes and IPv6 ltypes must
+ * differ only at bit 0 so mask 0xE can be used to detect extended headers.
+ */
 enum npc_kpu_lc_ltype {
-	NPC_LT_LC_IP = 1,
+	NPC_LT_LC_PTP = 1,
+	NPC_LT_LC_IP,
 	NPC_LT_LC_IP_OPT,
 	NPC_LT_LC_IP6,
 	NPC_LT_LC_IP6_EXT,
@@ -65,7 +70,6 @@ enum npc_kpu_lc_ltype {
 	NPC_LT_LC_RARP,
 	NPC_LT_LC_MPLS,
 	NPC_LT_LC_NSH,
-	NPC_LT_LC_PTP,
 	NPC_LT_LC_FCOE,
 	NPC_LT_LC_NGIO,
 	NPC_LT_LC_CUSTOM0 = 0xE,
-- 
2.43.0



