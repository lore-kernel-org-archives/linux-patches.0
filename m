Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039516;
	b=E07vhBwh8RPIe5IEtGo4MedLod/net94sULHwZsMSEj/k2887m5QK8A3lDoJj/M10vZK
	 YuEjbjgAKenV25/Y073Oo39T62A110HnnI3yaM9SGd52PIoeoVIEbrQwB3LiOckajl5vd
	 VBak0j3dRd4pQu49y36C9KhkChVHzjNeaj5jWB9iHypqgTtpe4y5DQyJsv8saV/fh+vbj
	 XEchPL9yLqk27s3/5Ppff5FAsqRa6faGUTub6w5H7P91QPnt7j6Vb2B2qtUqDZY2E04V7
	 d3H2WkcTZLr3j66vWk55gGlEdWsK3MRoRcBlnhDQGiFCuedPyOLQYGDZiXoRclEt8QA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039516;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XsPlX7K9i+3imOmaE1zLXk3zd1na1SE/wc21tAkSw5M=;
	b=Bu0QFxFxGUemGRk+pA20/GbggULqG//DALu6dZnlqWNocrScwVOygAAQgOkRtkiRyYnS
	 B1+JICO2c4+kYXtLTyOWKO8Yq7ntEt+pk/PHWfBJHtQXreIv6PsfI6sPESN5d+QA65kzk
	 6pt835XdrFQ67NQej3E2OGRqZQHR9ouXV3yX6Wkfh/SS7nmthFZ+BLrKBJ3K/hUOnjppt
	 yiZEW+ZhhUQ5GM0D1mJFbVkm7ES5DYbmGSei1YFEbmmhlpjKUQWfy8BYBfOjHFZu+EBq7
	 /48+5CpulpJ5u/FWviFdybwMkZmbWQNKgBxej8FtQZrqrZ3rJe7JYIgRubayRkTlZbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XJ0gCrEQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742D0606A32A;
	Wed, 18 Nov 2026 22:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XJ0gCrEQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 838B51F000C5;
	Wed, 18 Nov 2026 22:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039516;
	bh=XsPlX7K9i+3imOmaE1zLXk3zd1na1SE/wc21tAkSw5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XJ0gCrEQYUPYWFBckVU/bw/WFgb149/r7/wtOczchPrWl8c65JYGJcaLdlrlG6BVZ
	 bkfZOk85IsgsF3EB2Ro4QZYsg9itoAItXUoZi1GZxHPz8VPMzNmpveGZbPsicmw7jB
	 gKx6fOqYYF7teHhsLsg7SO5EmU94C1+0KRjymX78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2127/3318] scsi: mpi3mr: Fix out-of-bounds read in SAS topology change events
Date: Wed, 18 Nov 2026 15:45:49 +0100
Message-ID: <20261118150425.870400622@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 19b6fb752c236..2c6efc9f26746 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2600,12 +2600,28 @@ static void mpi3mr_sastopochg_evt_th(struct mpi3mr_ioc *mrioc,
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



