Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686514D1796;
	Thu, 17 Sep 2026 17:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665983; cv=none; b=N+kOk7WdVfXUI25S0lvRWqGJ1uHF4Gt8zOWsLW6FFTfPkQ7klg0naC+0CsoDtRro98ZuV+4h4Xxk/Mo0Tgy5lG5xCTUJHOMEjF13mZ0YXov7zipEfRsf32z9HCMqKlbrZgNURWAI+sXuetd/sIIBZGSuaREK+e/ebxU6QmCvA6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665983; c=relaxed/simple;
	bh=vpgwiVjZmJpQ6gaHih6EFyn8esqCglNpjFdEVSr809Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=URewY1V42tQlYeGp4ZzyGDGLq2KnryOMUV5yIYZASpHCzIy+I1N1yFrHncCvKFcu3ZfkKoS/YHXDpCiixUm2940eocMsGRqbhf8gsGNZZP3HtI2Hb8fG2bG7KqnpBpn49lKA4V9fts2Lpo7gaMmsd/UOwcR54m58Hv70BOdAsZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p90d2cNm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p90d2cNm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9178D1F000FF;
	Thu, 17 Sep 2026 17:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665982;
	bh=eMJh8ZftueZGMYIQ4da8kjZkRxktUqRMfLY7vHZkYgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p90d2cNmBaSFLpzqbQVX09KJtAvXo9xENGKXQNosS04Jk9JMuamVuL8WGlzqBIH8j
	 oYUIM6gItjlmtk7m7gy+DhFiR/VLoIkGq/AgqCNiCVGk/h/XNMer0z5HK2MrhZu1Ue
	 Y9bJrusPyeiefs9kfug6KRLOlz1Q/J6xYJXckI4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0858/1250] vdpa_sim_net: check TX pull result before RX copy
Date: Thu, 17 Sep 2026 16:10:53 +0100
Message-ID: <20260917151615.224764994@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 6caf09a1907b5..b596d4a532d01 100644
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



