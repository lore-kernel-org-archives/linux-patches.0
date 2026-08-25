Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD732E06E4;
	Tue, 25 Aug 2026 13:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665210; cv=none; b=VOizRBTN8ppj3pQlTRkkGsg/IW0fnf6ilpZFomxIjsNuEU1d44VZfteTjUuH4ew9KOzjzDaVbW62rmfrXjhRLHofnuYGM5s+Jx/7Xynq7ZkqfVhYie44SjCPicSlJtnjsBtkhLdLsJXsch522Ld7mGmZ0eaSM79jYcTK4T6drdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665210; c=relaxed/simple;
	bh=0XEUPskDcGsejIxArj3WbaQfzX/6M2ZW37v5TRhe9Ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AH/4kgGX6EmaR7flQnpEd9ZNkqLBn78mAcmJ5uyI6C3OBKnavvoi7+nWOp/RPzfzf+zvJJjtmPWg3FsSW2iwMZC+O8gMfgMqQHzAUyJXkCVQh7jhZvkLWFaEKNxhVKudRYwDIcV43Xf/DtkRvBou7FuE8B2V6U/3iE2aRrv2X8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w2M46Pua; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w2M46Pua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD3031F000E9;
	Tue, 25 Aug 2026 13:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665209;
	bh=kwjrTrKY3MNTtQ7zK8tVNivU0HqSbTc3HWMhYMrFv3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w2M46PuaQ51sfBCSrDt9SApo6hoaku4admz79YxaH2HVFwNYpHVaEsgsaWV0mTfMj
	 WnKV9HLIzDQc/jNITggEPP+b+Q/XCPsa6jAHoyqfyVapBTGjTJYBI8ln9yRLC/HFoH
	 2Pzgg0Ps2tgMbN4qUUqKYtZx88oybNOXdOl0UsJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Page <sam@bynar.io>,
	David Heidelberg <david@ixit.cz>
Subject: [PATCH 6.18 44/94] nfc: nci: fix uninit-value in the RF discover/activated NTF handlers
Date: Tue, 25 Aug 2026 15:25:40 +0200
Message-ID: <20260825132543.630629373@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.887883084@linuxfoundation.org>
References: <20260825132541.887883084@linuxfoundation.org>
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

From: Samuel Page <sam@bynar.io>

commit 8cbe06c1e699c0a165dae5093a2550e65f914818 upstream.

nci_rf_discover_ntf_packet() and nci_rf_intf_activated_ntf_packet() each
parse a notification into an on-stack struct (nci_rf_discover_ntf /
nci_rf_intf_activated_ntf) that is not initialised. The RF
technology-specific parameters are only extracted when
rf_tech_specific_params_len is non-zero, so a notification that reports a
zero length leaves the rf_tech_specific_params union uninitialised - and
both handlers then pass it to nci_add_new_protocol(), which reads it:

 - discover:  nci_add_new_target() -> nci_add_new_protocol();
 - activated: nci_target_auto_activated() -> nci_add_new_protocol().

nci_add_new_protocol() uses nfca_poll->nfcid1_len as both a branch
condition and a memcpy() length and copies nfcid1/sens_res/sel_res into
ndev->targets, which is later exposed to user space via NFC_CMD_GET_TARGET.

  BUG: KMSAN: uninit-value in nci_add_new_protocol+0x624/0x6c0
   nci_add_new_protocol+0x624/0x6c0
   nci_ntf_packet+0x25b2/0x3c30
   nci_rx_work+0x318/0x5d0
   process_scheduled_works+0x84b/0x17a0
   worker_thread+0xc10/0x11b0
   kthread+0x376/0x500
  Local variable ntf.i created at:
   nci_ntf_packet+0xbc2/0x3c30

Zero-initialise both on-stack notifications so the union reads back as
zero when no technology-specific parameters are present.

Fixes: 019c4fbaa790 ("NFC: Add NCI multiple targets support")
Fixes: e8c0dacd9836 ("NFC: Update names and structs to NCI spec 1.0 d18")
Link: https://lore.kernel.org/netdev/20260623172109.1105965-2-horms@kernel.org/
Cc: stable@vger.kernel.org
Assisted-by: Bynario AI
Signed-off-by: Samuel Page <sam@bynar.io>
Link: https://patch.msgid.link/20260626090301.2139500-1-sam@bynar.io
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/nci/ntf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/nfc/nci/ntf.c
+++ b/net/nfc/nci/ntf.c
@@ -440,7 +440,7 @@ void nci_clear_target_list(struct nci_de
 static int nci_rf_discover_ntf_packet(struct nci_dev *ndev,
 				      const struct sk_buff *skb)
 {
-	struct nci_rf_discover_ntf ntf;
+	struct nci_rf_discover_ntf ntf = {};
 	const __u8 *data;
 	bool add_target = true;
 
@@ -710,7 +710,7 @@ static int nci_rf_intf_activated_ntf_pac
 					    const struct sk_buff *skb)
 {
 	struct nci_conn_info *conn_info;
-	struct nci_rf_intf_activated_ntf ntf;
+	struct nci_rf_intf_activated_ntf ntf = {};
 	const __u8 *data;
 	int err = NCI_STATUS_OK;
 


