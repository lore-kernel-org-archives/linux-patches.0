Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669314749C1;
	Tue, 25 Aug 2026 13:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666096; cv=none; b=SSUeqA33FsjDw0U+y7bKXwXixt9Y+UUfSpHkwX1KKJL1yVqjtWKovtU9uO4E2PGPDu9UuJye0gz1reI33jxF5Z8PQOz73U9JpQhB3kZdppTUOdEAx2x42bmYpzzeK2BnKiJGcUmxnle8ZWPaMGIBLmO0w2demdpttuQMfxW4A8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666096; c=relaxed/simple;
	bh=GYicHrP5AHJlf1TbSio5zt0o72Kpv0U3yLoJRZUiIEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jRy3TXjCUFKJKSeDH04COFvJ8vg5XK/d2jJWDsTh7U+s+ZxQrMhbDCugSowvsXtii6doBRRUTWqFUJukEArr6m0wJC+P07QpfuF3YZDobQMhF44ttWnICWAyzDxeRkAmg4Zx5q/8Mnqs54JqNIrDmqDyACh6YWfB9t80OeKXBR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fqTSYPlw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fqTSYPlw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A9F51F00A3A;
	Tue, 25 Aug 2026 13:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666095;
	bh=qS3LOV4KxBLTfMCn94jWUAkxoHINi4uuu/oyBc1ZTmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fqTSYPlwWlKl/V/o26GlB1phrPwZA69egNtZqbCS5ed9h8j2O0ZvXEyXJsjJCjuDZ
	 t0aD7vRThllSyWe8o/GaifGI8bYgE+7pRJ/NfDNBNAI59bYtDBx2NmARsHFq1uFpHG
	 iyQ5cCMRvvmmWkDXNRZEhhP8xEEX57dONd2cNmYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Page <sam@bynar.io>,
	David Heidelberg <david@ixit.cz>
Subject: [PATCH 6.1 51/79] nfc: nci: fix uninit-value in the RF discover/activated NTF handlers
Date: Tue, 25 Aug 2026 15:26:31 +0200
Message-ID: <20260825132543.704370519@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.677185791@linuxfoundation.org>
References: <20260825132541.677185791@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 
@@ -672,7 +672,7 @@ static int nci_rf_intf_activated_ntf_pac
 					    const struct sk_buff *skb)
 {
 	struct nci_conn_info *conn_info;
-	struct nci_rf_intf_activated_ntf ntf;
+	struct nci_rf_intf_activated_ntf ntf = {};
 	const __u8 *data;
 	int err = NCI_STATUS_OK;
 


