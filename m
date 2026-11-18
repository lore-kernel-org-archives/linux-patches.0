Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054902;
	b=sYqMXAjfX9rNpRUhbhJtcEULkZo7yyyaInBkGYjxZaJOQug+Hl5S9n9CkQkrlfnF67uJ
	 tOU9VH3rR9MX1rRW1mlrH1ScCEfANYoUHTTYdAwZQCP22TlU8ZXKvyRSJJbrZWZAmB7II
	 MDJcF5gH49z+89F1SLtw5anUj8sFe8D8i9ar3qWvmdKbfbfTtvpl7hPyYVb3PvuU8obuz
	 /j0uiNZC0lqw6F8qznd872CH+9GCloGTtZsysqIJ5Dm9+2DVbHoBKbT6nrlf9CwRlktsM
	 K77kz7B4acW9lSa4pjmDDANnRV4JCw0vhA9NNxlpw2SWZCZ1JOBV/s8zbIbnf6eQgZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054902;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UEgN1C9ZE2GJV5MdSZ6Mt8ZQw973sLvUMEfz7Bp7TuE=;
	b=D4BqQZxH3eCuHL7COUTxiBdcBWRINUqHVDwjoMFlBMRjs9uzx4SzbxkHDKyt1CtDkW4B
	 GAErV4z44EkNONtsXHcM7erww45CloGg0R/TMfn9VWx2RbbkKS89XiZMyJE1sKyh1uooW
	 Fv5aqoeZHrWIEvKdDea30QWXFP2SvhXhdcRrZwGTrZTEgpZv8KQzMszY44d3zdB7lKGrc
	 enR32kOeiUBun9XftaAT1hpE1iVbFRV5p0GHFlP2YMGvtAeztDNVORWSla4T4Q7G29Ak8
	 QDis7LfZmDPcyaKNbkVDvnGSnq+TaAep+c52UP346gZDgb06GBhC6vqbtvTl9lSCUtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wIVIHsJQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38FAD606A330;
	Thu, 19 Nov 2026 02:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wIVIHsJQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874141F000C5;
	Thu, 19 Nov 2026 02:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054902;
	bh=UEgN1C9ZE2GJV5MdSZ6Mt8ZQw973sLvUMEfz7Bp7TuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wIVIHsJQeKT8ABk2dMHd+uDakXX6qFoQ/R1eCqRDv46hBYHQIvm01Swf3QTmIGOJI
	 nzf4w2rZTEQYjCeLDgyzelgAYkqMUAYAbAB586Ver7/vIVCKUMMwyQePzdBEabWYYO
	 /qHRTT1gZD36iXxnb+LKrgtRFXN6jBtoOzSJ5x0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1440/2214] scsi: mpi3mr: Fix out-of-bounds read in PCIe topology change events
Date: Wed, 18 Nov 2026 15:51:56 +0100
Message-ID: <20261118150108.748005881@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

[ Upstream commit 7d572b4dc4ed0494e67097d4b7368666655f5c99 ]

The number of entries in a PCIe topology change event is used to walk the
entry array without being compared against the amount of event data that
was received.

Bound the entry count to the received event data before use.

Fixes: 8e653455547a ("scsi: mpi3mr: Add support for PCIe device event handling")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://patch.msgid.link/20260825210411.301535-15-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index adbcdbccd0e13..d5a3ddd3b2b83 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -1634,12 +1634,28 @@ static void mpi3mr_pcietopochg_evt_th(struct mpi3mr_ioc *mrioc,
 	struct mpi3_event_data_pcie_topology_change_list *topo_evt =
 	    (struct mpi3_event_data_pcie_topology_change_list *)event_reply->event_data;
 	int i;
-	u16 handle;
-	u8 reason_code;
+	u16 handle, avail_len;
+	u8 reason_code, max_entries, num_entries;
 	struct mpi3mr_tgt_dev *tgtdev = NULL;
 	struct mpi3mr_stgt_priv_data *scsi_tgt_priv_data = NULL;
 
-	for (i = 0; i < topo_evt->num_entries; i++) {
+	avail_len = event_reply->event_data_length * 4;
+	if (avail_len < offsetof(struct mpi3_event_data_pcie_topology_change_list, port_entry)) {
+		ioc_err(mrioc, "PCIe topology event: event data too small (%u bytes)\n",
+			avail_len);
+		return;
+	}
+	max_entries = (avail_len -
+		      offsetof(struct mpi3_event_data_pcie_topology_change_list, port_entry)) /
+		      sizeof(struct mpi3_event_pcie_topo_port_entry);
+	num_entries = topo_evt->num_entries;
+	if (num_entries > max_entries) {
+		ioc_err(mrioc, "PCIe topology event: num_entries(%d) exceeds max(%d)\n",
+			num_entries, max_entries);
+		return;
+	}
+
+	for (i = 0; i < num_entries; i++) {
 		handle = le16_to_cpu(topo_evt->port_entry[i].attached_dev_handle);
 		if (!handle)
 			continue;
-- 
2.53.0



