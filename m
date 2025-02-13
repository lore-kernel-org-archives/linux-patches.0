Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFDD4F218;
	Thu, 13 Feb 2025 14:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457749; cv=none; b=gW6NlNLt/3xKuH2fj//ssjRxGZDHAs6KGQoEyc9Gd/rzjl7BQfVsWIEDzREyXYDYHgIop5nZ2o7fz2Yf+E040gctrSfpNoVvKlkN7yytrl+SVlIkS6p/ETUKHsw3E3Og0fSIz6zDVGnZc1MUULL5FJmBA48YeYcQLqZWBKWQIAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457749; c=relaxed/simple;
	bh=xAzAj8qGZwkX83t2LFZRwC24tbKKg+5akQrUdsJk3/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U9Gh0gdgqjdqdfK78T8QOik9Sc+Hp5zFPcH2wASmMLLb8bkJOFBkecrdmmSg8cYd1xs7tB9Xt7VCnSZX2n40hpt2gJ8aaGEc9InfZPHig/kZus8gCyczRJ4YzK+stmzJjIT1Yo0tqXSeqrP0rvzC0JVQtn/oK+4b4Fu73qVurzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JJOJuRoU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JJOJuRoU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F9AC4CED1;
	Thu, 13 Feb 2025 14:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457748;
	bh=xAzAj8qGZwkX83t2LFZRwC24tbKKg+5akQrUdsJk3/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JJOJuRoU1vtziQmF/uC6YCRxoJd8H0YHBbNNjnLEAfc5xPzhwNzVPB0qReCdVdPGw
	 g6tfgUlNeho52Ue+y1xgID4sfhYbIAgWRZj4sSwM688c+OiT8W9YYySWS8EGXbvi8H
	 kbbvVLnORQMYrmsz1zBv8N5w5htRelpHzYb7WYs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcel Hamer <marcel.hamer@windriver.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.12 203/422] wifi: brcmfmac: fix NULL pointer dereference in brcmf_txfinalize()
Date: Thu, 13 Feb 2025 15:25:52 +0100
Message-ID: <20250213142444.376830612@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


