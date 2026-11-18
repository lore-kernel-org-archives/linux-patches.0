Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048188;
	b=Av2Es+rWCYoQLf/QPuYVKF//KQkRRwVkRRL1aInFAwW+UagYojgjMFh9zi3qjvJalWJF
	 WTrrQI1JQIS+5+PlHNLzWH7ajs7DAtvVIhnRkQuVXpt9D4L8k9h4EzMVO+XuU0i841THW
	 ikknUTpPi6JNfNMAUjguhgWUo2r8qp8mG1QgZVwetk80JzE6/tGF2R0Gm45tcGdB+PTd8
	 OeILPP6mOagEyn/4sbf08VKc/L+loWrqLOvARgVR/D+iHl8EiBCEO9JBZcIP5LsohEJ0U
	 Gi2uZcMHf4FALomHLq+65pY0WFR9BCaZfT9SBc7cjVJycGviH19lfxQoJGge0Vsu9pA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048188;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vFXUyjU8th5cLJYSUcHb/HwibP7Tg4xBn0Y8mUtFqDo=;
	b=Ciw71SzuWN9rFvtc7EGDP8rVr/yS1L/uRwmlC8IAg9SYzKOuYKXk83ECe36/zHEUgzPr
	 DdZuJ2Qh5QyLStN4uIDzh9juSI22f1XtG6pR1cFFaHCIHmRa6ekg7X+odeB0PxHqtnBWh
	 ZBShpSzQV9blE0QXOpMm7gjbTErPHRyjKtKU2af1p3liUORa5oJMBDNZ1kfyUa93poB4y
	 mdIUcoF+Mu782gBZyrdEEkPcnlIwifinAgXwAMb3wZKXdJuu1JScI2VjBJ31Wn1btG3g3
	 qDyI5KegXZac4LnCwafFM1aRlUHF5TM68Uc9ZWhbCoYjcpkkyYbG8QZilHu+YxGYJTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X90p2by2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F142606A320;
	Thu, 19 Nov 2026 00:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X90p2by2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 835511F000C4;
	Thu, 19 Nov 2026 00:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048188;
	bh=vFXUyjU8th5cLJYSUcHb/HwibP7Tg4xBn0Y8mUtFqDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X90p2by2NN8zJWi4QCMDy+8PbzK5QdqLZj0PM4VuxONhNnQy026Q5X3Pjv6g0wW+n
	 gTrcyzOMr+rZyl0kzsuc7O2BwKx4BoZFY6tRigEufoN3SWBhTtg8v66JUHVXx3DHQM
	 bimV2l9ElZXpxdvEBoNk23wzTDMOu6O1t1XOtbAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1856/2857] scsi: mpi3mr: Fix out-of-bounds read in SAS topology change events
Date: Wed, 18 Nov 2026 15:48:10 +0100
Message-ID: <20261118150308.070531839@linuxfoundation.org>
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
index 6a19af5e66495..51e390c44784e 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2561,12 +2561,28 @@ static void mpi3mr_sastopochg_evt_th(struct mpi3mr_ioc *mrioc,
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



