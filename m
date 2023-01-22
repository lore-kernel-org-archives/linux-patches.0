Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B472590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:20:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD67C433EF;
	Sun, 22 Jan 2023 15:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400844;
	bh=PgIHuTYor0qdqilMWA4mt/hYSEJrpxTfS2+yy3S8CU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iUt1O/ncwgOD5pqFPMwMn8/Y8QdS1tpNUe46IOHs4INNzWnAt/kVA3wO/VJf03HvM
	 1zzPEpVC4lGYBTxixsLj5+WPP1kX7ohf5mQuAJKr3X9yaT40uSp+J1WXpdxWrNoSO4
	 4JKNfxP51aKPhXX3W89XocrnKQXCYYDvI/sEvgZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cindy Lu <lulu@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 013/193] vdpa_sim_net: should not drop the multicast/broadcast packet
Date: Sun, 22 Jan 2023 16:02:22 +0100
Message-Id: <20230122150246.979549435@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Cindy Lu <lulu@redhat.com>

[ Upstream commit 72455a1142527e607e1d69439f3ffa2ef6d09e26 ]

In the receive_filter(), should not drop the packet with the
broadcast/multicast address. Add the check for this

Signed-off-by: Cindy Lu <lulu@redhat.com>
Message-Id: <20221214054306.24145-1-lulu@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
index 11f5a121df24..584b975a98a7 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
@@ -62,6 +62,9 @@ static bool receive_filter(struct vdpasim *vdpasim, size_t len)
 	if (len < ETH_ALEN + hdr_len)
 		return false;
 
+	if (is_broadcast_ether_addr(vdpasim->buffer + hdr_len) ||
+	    is_multicast_ether_addr(vdpasim->buffer + hdr_len))
+		return true;
 	if (!strncmp(vdpasim->buffer + hdr_len, vio_config->mac, ETH_ALEN))
 		return true;
 
-- 
2.35.1



