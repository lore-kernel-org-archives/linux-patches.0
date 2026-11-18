Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054899;
	b=QRm4VMXuvanC6Nx7BiWZHZp+B+N3wSbjZDhe1UbiAGnS4dMvS7vd3ataGbQM6+tnXs9i
	 8iwzaza1dnjDy8W89+TDFGx8rR6MOq+0Of1e8lG0SaldPSdEJv1+xVkBzjDGiSi01BEVF
	 sILRHDByl8diuMvPnRQy7bmcmbmtd8wqWp1N+Wd9UV098jJGqXeBeTk9gd5PGE+DhbKN0
	 DDERwWnzS0vTaV9b/oUCPmie3Zxsl6h8G+PiBYUvQwj773zjQ70LMOfJui3c9OMPoV85I
	 IV+knJszf1o+ekFkB5UrffIjyc33num0uKvfCcDl9Wekhi/SjX097xcDp0u2ty1mY8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054899;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/Ooea7xWBu8aDllq5rUi7RewBzDg2LpdEXLxeF7wsiQ=;
	b=Mgafvm3kO5nMt7kGQbhLMeqUyqAIWBxMc1vsK7gLGMogeTD9TL7GenErHT/0C3QOnCEG
	 v+M7AHoLQ45Qe9KDYDpObJ38fuVPJmi5F5MVtTIcOwCUD/OD1UANpSRG1IUQrCtojgtUv
	 2hvUjVXhSUIA8FWTBE9TtOepqCbCEPu5eYZ9rAg8uXCUJNtmGxHF26wI69fW/+OEuf7Gc
	 XUmQIsZ14Q8s/CV+etJKKsNCzsq9kIUz42xPlQQmOdErFDgKPXk5A+nCFlv6gOYE8Y5cB
	 vk7WL5AsmifnvpzETsTI9ZYwT/u4BCbh/WCo7at76luXVtxeGrQGabhKfBPEYyG3ixQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s+SwKM0n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560BC606A325;
	Thu, 19 Nov 2026 02:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s+SwKM0n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3662F1F000C5;
	Thu, 19 Nov 2026 02:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054899;
	bh=/Ooea7xWBu8aDllq5rUi7RewBzDg2LpdEXLxeF7wsiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s+SwKM0nINN2T6jHQSAMVbEGQ5MXSWVPOluyezrzr/CPwz1kJ9Wv3nabnT0ewlBtk
	 /CrQldiK8lXYSNe2u0h94hwXYXuqrlY2uLkEngUCv9oqOHHkB0DoVrif3srC3wM7bz
	 /uREcYJcWWDFA4gYHxsTmwMRwpnrczU4o1hsS/ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1439/2214] scsi: mpi3mr: Fix out-of-bounds read in SAS topology change events
Date: Wed, 18 Nov 2026 15:51:55 +0100
Message-ID: <20261118150108.714893208@linuxfoundation.org>
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

[ Upstream commit 9e220ce4bd0468e47cc9eea07e40799ebae6eda8 ]

The number of entries in a SAS topology change event is used to walk the
entry array without being compared against the amount of event data that
was received, so the walk can run past the end of the buffer.

Work out how many entries the payload can hold and skip the event if it
claims more.

Fixes: 13ef29ea4aa0 ("scsi: mpi3mr: Add support for device add/remove event handling")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://patch.msgid.link/20260825210411.301535-11-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index bba31ef05c7fa..adbcdbccd0e13 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -1700,12 +1700,28 @@ static void mpi3mr_sastopochg_evt_th(struct mpi3mr_ioc *mrioc,
 	struct mpi3_event_data_sas_topology_change_list *topo_evt =
 	    (struct mpi3_event_data_sas_topology_change_list *)event_reply->event_data;
 	int i;
-	u16 handle;
-	u8 reason_code;
+	u16 handle, avail_len;
+	u8 reason_code, max_entries, num_entries;
 	struct mpi3mr_tgt_dev *tgtdev = NULL;
 	struct mpi3mr_stgt_priv_data *scsi_tgt_priv_data = NULL;
 
-	for (i = 0; i < topo_evt->num_entries; i++) {
+	avail_len = event_reply->event_data_length * 4;
+	if (avail_len < offsetof(struct mpi3_event_data_sas_topology_change_list, phy_entry)) {
+		ioc_err(mrioc, "SAS topology event: event data too small (%u bytes)\n",
+			avail_len);
+		return;
+	}
+	max_entries = (avail_len -
+		      offsetof(struct mpi3_event_data_sas_topology_change_list, phy_entry)) /
+		      sizeof(struct mpi3_event_sas_topo_phy_entry);
+	num_entries = topo_evt->num_entries;
+	if (num_entries > max_entries) {
+		ioc_err(mrioc, "SAS topology event: num_entries(%d) exceeds max(%d)\n",
+			num_entries, max_entries);
+		return;
+	}
+
+	for (i = 0; i < num_entries; i++) {
 		handle = le16_to_cpu(topo_evt->phy_entry[i].attached_dev_handle);
 		if (!handle)
 			continue;
-- 
2.53.0



