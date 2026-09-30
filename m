Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446473EB11D;
	Wed, 30 Sep 2026 19:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795354; cv=none; b=GQmXUMBsu18RyIPEmbXmpyo+Yt6/amJD+UBOVuAYKbAWhUCgs/GgnNMV4mvV9ORV9YXtFO1p/z3gmvhJdYxNWun0SZlYttbyHRcDo33J5y3+rGOJrTto3FQCXA8UU71G5ia2CNVT7OByYtkhn3HyRGzJvJuNs9VyDpRG0UDYrV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795354; c=relaxed/simple;
	bh=f+7jIN1uqqRTsAC5vVG+vuhst6XTE6pPhgWUrb4CrWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BtMGzx7MT5JQLS9ndDPUIs3vDbGXZ62nX89zleMYUqglOMVmQnICmAt+iofE3QcS2ILbnjLTgh4oMhagHJCh1orTZqvLCySvHopaOR2lxwB8ub+PPXkEIWLgZxC1cNnmO69xxtEfAE4Pdx86+SPM8f0/aydxCunCjPZRdB3nEpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WylWKotJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WylWKotJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F1071F000FF;
	Wed, 30 Sep 2026 19:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795353;
	bh=KIJ+2STlLqFLzwXxPMqgvlw1ARQVCc+w5sLdJHJYEIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WylWKotJfpjFTYAv0IK3lz0l0W/0iTxP6zdXHoqqXmZCUKcU28Vl64dKlxgpBufcB
	 77D2T8/qdPiUTAZhLCZe73PvnEIUNvebGELjW95X9LwJ1VWxSP4XQAXq4SnV532ny6
	 1yJk5QMPumB1ejhRUmhG1VyKkgp4E5rNejwVkxdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0533/1193] vdpa_sim_net: check TX pull result before RX copy
Date: Wed, 30 Sep 2026 17:20:17 +0200
Message-ID: <20260930152446.050661468@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linfeng Sun <linfeng.sun.dev@gmail.com>

[ Upstream commit 0d195797a80b77f2ec56718cd26d3ee65d0093e8 ]

vringh_iov_pull_iotlb() returns a signed byte count.  A failed TX pull is
currently added to the unsigned byte counter and then passed as a size_t
length to receive_filter() and vringh_iov_push_iotlb().  A negative error
can therefore become a large length in the RX path.

Handle non-positive pull results before every length use.  Count the TX
error and complete the consumed TX descriptor with zero bytes.

I found this bug myself, though the patch was written with AI assistance.

Fixes: cfe226892913 ("vdpa_sim: filter destination mac address")
Assisted-by: OpenAI-Codex:GPT-5
Signed-off-by: Linfeng Sun <linfeng.sun.dev@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260901094842.25875-1-linfeng.sun.dev@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
index cfe9629118045..2a997b0ae3a84 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
@@ -225,10 +225,15 @@ static void vdpasim_net_work(struct vdpasim *vdpasim)
 			break;
 		}
 
-		++tx_pkts;
 		read = vringh_iov_pull_iotlb(&txq->vring, &txq->out_iov,
 					     net->buffer, PAGE_SIZE);
+		if (read <= 0) {
+			++tx_errors;
+			vdpasim_net_complete(txq, 0);
+			continue;
+		}
 
+		++tx_pkts;
 		tx_bytes += read;
 
 		if (!receive_filter(vdpasim, read)) {
-- 
2.53.0



