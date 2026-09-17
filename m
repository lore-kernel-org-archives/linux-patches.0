Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F4E3A5E84;
	Thu, 17 Sep 2026 18:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670635; cv=none; b=FwNVRGKMdR2PToTlyDBhzSjhJGFUk9shhur0NVyen+HzzrcAvq/70OG8nT24/s8U3jcz1OTMmF337XxdPJrTGirJyVtS1yfrOV++gnVZIlTOJN6l1AAMiMi8Yu8DJc0TIwQqclwLUfymhRN0aaLws8D/MoOxTLuFedpc5GJOywU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670635; c=relaxed/simple;
	bh=JfG8SZwSCXnhXIz0ZfsuDadlyYsoljl9bEXqkK4HpN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pcEEpgO0UdscAa4AyEINKiCVVS3g54GLnVVgiLlj6k5Cg+j0Wx/qlBjbefK+jrtTww5oUWDT2A/+CWhUZk4vD1StX9AfQIHVJN9h4DdKEn6X2QNXo5n3b0nAf7jHqD3uBjz9elIObyeGtOMRDUOq8DKDkrWGGR9NMut4B7vVJBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ArbGjgvG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ArbGjgvG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6BA51F000FF;
	Thu, 17 Sep 2026 18:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670634;
	bh=iQbd7cxtY/QuzGL76VUlieyuyHAXTcslQ2sWBYeGSI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ArbGjgvGg8U5ClLAG9jovrv5CmLw5xJrT6v6pyF4TvZ08QYI4RwqiHMT8pcCrBZVY
	 cneORO69SpzHhoDirAscA7dk62YX3O2TxtoEwh6SU2u84r+SDwfLEeNH1/RSzo5IZv
	 PDnuB1JQWvpEZqidT1IlaZ7U4u3tlGvMlREo0PkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0717/1102] vdpa_sim_net: check TX pull result before RX copy
Date: Thu, 17 Sep 2026 16:11:00 +0100
Message-ID: <20260917151558.343058929@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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



