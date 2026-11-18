Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048180;
	b=30ZtXdJq/XhmLrIcUfyOan/ept2xNd2ER5RdEOFbBoWPLJokVFEOcGol9YEVCj/AFv1S
	 EMikCj6Hwr1Nap0ppdh7dT+h6cDQZdZjmyAX3qBo3cguV3kCyg/SEB4JWjGN1XuP4HVhH
	 lMdEn9z5bvDa2Y1jaUyYJ++OhUgF4IPmFTwlmE2VeAY+6d4OqUmkWwyqmR6heGrpLr/ib
	 GNv4r28bBEU8ohLMdyAcgBQLM736zpuYk2iPmI5UBW7MS9TNwySD+BOc4ggNLIgmUyz4b
	 lOu9BH3X6MC6GLnPP7cYbGr9ikRWk+dYdk5uApF36YOfSIDyg4ZyyKibdazcVBYYOqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048180;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gjyIVtIikotmqMrrl5u/EffBwGizr73i5yE6FmKTI9Y=;
	b=5WzR9ytR/7uzo324JOiHdap+hdZ0IgYVxHYfWfMuPEwWIhq5/Vq4cqIBCr+1JV6IsvNk
	 SC4UdvJLA23LETttsAdSNgy/YjCQirJrykRw2nDwwu6dV6Xuo8rqsSt1HmXSSPLH0TOGV
	 D6TOpWcb8fk5KEahImB+syKNfyUrBPl9A9MuQ8SlV9BHecXz4pCkGmDlVkKWCJdt50aM4
	 D9/h2hTC8JGmffsu3g7kQ3F1AqvNKUFvhzumIQO/8Vwvp9vXeZOVBnn1B04T/ZeR18Xo2
	 MroxUIgukCzMCQu2ETb2vy+s/+b872GoOO6smddzcVoP6te5VTOFrYfblO8lVjBafjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wSkws+SV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15CD7606A31C;
	Thu, 19 Nov 2026 00:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wSkws+SV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 208931F000C4;
	Thu, 19 Nov 2026 00:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048179;
	bh=gjyIVtIikotmqMrrl5u/EffBwGizr73i5yE6FmKTI9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wSkws+SVmrGXmY++jVfFsNqP03941zlmlmzhiD+wf4hOEXRAI3BfMOwHTXro4Es9q
	 6RLijRoFY8v9VmmqrkldDek9RpM91T2hs7obuQXhovTFKKKhDXnVg1qUWRXJO89uYI
	 OHhluqr4GRybE4OMnd/bexCrOwOiouSXyLzcKwNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1863/2857] scsi: mpi3mr: Fix out-of-bounds read in PCIe topology change events
Date: Wed, 18 Nov 2026 15:48:17 +0100
Message-ID: <20261118150308.314292149@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b1173c63993e5..a5360e29e106c 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2515,12 +2515,28 @@ static void mpi3mr_pcietopochg_evt_th(struct mpi3mr_ioc *mrioc,
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



