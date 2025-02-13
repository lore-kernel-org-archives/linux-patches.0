Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54CDF26B087;
	Thu, 13 Feb 2025 15:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460501; cv=none; b=rZXYxaO0Dck4aOca87AYXBCfhEKOAMCpU4xT33VBHehPKBZfmGranTc4JTTDLDiEvEy9v5PS4OefhJKMd5AftkInTEB13BeUTphi2tz4pe79LHNxIbF4IGGWe8tOqu8HKisqH8bbc3/U58ZPwFTZM7RPx7sjBPpWgylxExUXvrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460501; c=relaxed/simple;
	bh=NOBKCLRc0GKR2qhHP3rb36Zja+G2YMX0DSYf5PCxfl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pf3XdUbp781/3tSm6Xw6Uqx2U9blpA0IFcDFBxipMa1OhDYRFleK0YeY6YK5PJUwjNyR9IeXYDhbBiLiia2FscSmFyxbOrSfXcmNSUzPm6022My3j+oKoot7Xy2880VvpzPgYWGMbsFSuxZlBEdnfqR8xQ+AOpigWyCNUmvwB4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jbmqFMch; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jbmqFMch"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E90C4CEE5;
	Thu, 13 Feb 2025 15:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460501;
	bh=NOBKCLRc0GKR2qhHP3rb36Zja+G2YMX0DSYf5PCxfl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jbmqFMchlIxr8kFNvFOf1yWwpOv4SyhxAJiDnzCIxDymgf2OCz4GcmOvLPYsD6bZz
	 dFP7ZGa4xEn3goN45oWZB0ntGPrypeoYGjStnlIrLyvcKt92anQ8fY6SrqFf93nNkM
	 BjOVResQG4MU3OpaiEF0U4Kdg8pKlOTB0r1SOb0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcel Hamer <marcel.hamer@windriver.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.6 128/273] wifi: brcmfmac: fix NULL pointer dereference in brcmf_txfinalize()
Date: Thu, 13 Feb 2025 15:28:20 +0100
Message-ID: <20250213142412.398060822@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcel Hamer <marcel.hamer@windriver.com>

commit 68abd0c4ebf24cd499841a488b97a6873d5efabb upstream.

On removal of the device or unloading of the kernel module a potential NULL
pointer dereference occurs.

The following sequence deletes the interface:

  brcmf_detach()
    brcmf_remove_interface()
      brcmf_del_if()

Inside the brcmf_del_if() function the drvr->if2bss[ifidx] is updated to
BRCMF_BSSIDX_INVALID (-1) if the bsscfgidx matches.

After brcmf_remove_interface() call the brcmf_proto_detach() function is
called providing the following sequence:

  brcmf_detach()
    brcmf_proto_detach()
      brcmf_proto_msgbuf_detach()
        brcmf_flowring_detach()
          brcmf_msgbuf_delete_flowring()
            brcmf_msgbuf_remove_flowring()
              brcmf_flowring_delete()
                brcmf_get_ifp()
                brcmf_txfinalize()

Since brcmf_get_ip() can and actually will return NULL in this case the
call to brcmf_txfinalize() will result in a NULL pointer dereference inside
brcmf_txfinalize() when trying to update ifp->ndev->stats.tx_errors.

This will only happen if a flowring still has an skb.

Although the NULL pointer dereference has only been seen when trying to
update the tx statistic, all other uses of the ifp pointer have been
guarded as well with an early return if ifp is NULL.

Cc: stable@vger.kernel.org
Signed-off-by: Marcel Hamer <marcel.hamer@windriver.com>
Link: https://lore.kernel.org/all/b519e746-ddfd-421f-d897-7620d229e4b2@gmail.com/
Acked-by: Arend van Spriel  <arend.vanspriel@broadcom.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://patch.msgid.link/20250116132240.731039-1-marcel.hamer@windriver.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -540,6 +540,11 @@ void brcmf_txfinalize(struct brcmf_if *i
 	struct ethhdr *eh;
 	u16 type;
 
+	if (!ifp) {
+		brcmu_pkt_buf_free_skb(txp);
+		return;
+	}
+
 	eh = (struct ethhdr *)(txp->data);
 	type = ntohs(eh->h_proto);
 


