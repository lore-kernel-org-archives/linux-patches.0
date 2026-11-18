Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039538;
	b=25JbA2klt6/70q/hMbQshjeeapqBKEo711QTYFO8qFxLG59QGR97kweoJDTRE8OVas/j
	 Bdn0LQxF9dFW9Sf+DN6Y2Lt+V0l+xJ0Afpt/0qjOqUXzNnYyT0fcMFik1a3Qp9rcuokJC
	 rceIHZ0ePxrzWZCh7nEvxmGDTFyuyxPksXUNLKNydmClINgFKCBmG5U+xNERmtrw5VRSJ
	 IJXoIwtGKmHul28zBjDUlomCLGCqm7dTbzL7XsGB4mBZM0DnkFgYmOxO2iyGwFvbRRx7V
	 3b90t0t2W6scUZPkBvgcF5IvK3bunxbvO3uMOUjByRjA+zYbZIdD0+p5zVuMYm4UpwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039538;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OL+jY+eoqH7RsGmcNatZy+Tn2P8mHbecZBqvl/A/FrA=;
	b=5GK0JBotIed/Yw0/Tkn1FO7+5tYy4rnVqp8XLaGnDojrp5a6apsXoIS6JFYwAkpoKUUH
	 EKPua/2xWHjfEcQmm1yQXcCjeToit6ZaPuaO5Cn+dViG4Knqb0YFwrCtQ8Ml5BLFn1+iX
	 XWNX1Qw1157vhrxmP8EAR5QwzrF6KkOegEZgPwzKUaDRBMDZ/D/mrAMq50VkGAtBfZxTs
	 vWP3ywyeGxn4kISfEq9pOC1Co1HbQin06/77HcvKLf3N0+riKuTaZBGjGLvlBgKV4OkUO
	 YK9jX6d/HF777EBbPULubU5faP/lq7QdmFMt/v29IgDVGid8x5pAI7r7ZRdn8ywfvnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fhZmzzWx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C99C606A320;
	Wed, 18 Nov 2026 22:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fhZmzzWx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEE3A1F000C6;
	Wed, 18 Nov 2026 22:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039538;
	bh=OL+jY+eoqH7RsGmcNatZy+Tn2P8mHbecZBqvl/A/FrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fhZmzzWxPQIsOOpn2yHKqojkEBpV+AFmgrG/9a6lOcBmNwog1BljYzkNQtGn+45Dk
	 aUkeNqlBFM7Sj4EvZaoxx03CZ+bcpq3TAH8WBe9CuDN6uvlF8aojTCBqfP2riodbl/
	 ctBfoHjEqG9EcE/ja/D+rSTofrEz35Cd+WzLJhig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2134/3318] scsi: mpi3mr: Fix out-of-bounds read in PCIe topology change events
Date: Wed, 18 Nov 2026 15:45:56 +0100
Message-ID: <20261118150426.083813995@linuxfoundation.org>
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
index 74bfddfd42c09..48dd77a91aa1d 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2554,12 +2554,28 @@ static void mpi3mr_pcietopochg_evt_th(struct mpi3mr_ioc *mrioc,
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



