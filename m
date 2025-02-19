Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB2F1B85EC;
	Wed, 19 Feb 2025 09:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956993; cv=none; b=aKbKi3CJBrpCsIAlKYrthwSnlJfnCZIX077XdLMcKInuDSiUDvkCPhmgtwATJSN19dgoFi9sNooYNxqzxB2eRYQdz+IosDo0kcZV+n4LEYHo6bX1un8MJFmOxDu/ZKohzHLpHRWPt9JtuZ/WpxG8v0vydG2ayMArWAsWQEja47Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956993; c=relaxed/simple;
	bh=CuWIpAnFj5kXj8+ij7pJxmIhRwD8hIEvjIh0JJWwoEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BZhDCf9ooIrhGkGJuurjZD4awLv3mP6Sh2dJulPoGZg75uhywkOWShUyuBP3aovCbgpAe6bPdXtqa9WFLL162GcWX5uq/h/TlkzK/OTfTSsBOF+ONHaMu0WAzEc+g2WK1UcLdn4SC0p7ouOQ5GNYTSc1UoDpsl5Xhfq1vnYL/rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p0J2NixW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p0J2NixW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FAACC4CED1;
	Wed, 19 Feb 2025 09:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956993;
	bh=CuWIpAnFj5kXj8+ij7pJxmIhRwD8hIEvjIh0JJWwoEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p0J2NixWt2/USmCseQr3A913/z9/3Oj/QwZSIiJiLuOwrut71cCQayu7HquFDaZ4d
	 YCKtz4gk9VBmPt4uLuZx8+i7BuDw9zsf0SEWmEwjOED+jQ6CcJOSlt3eqDasIxeRXT
	 qA2RDcPJKMUFgnoHLHxrgnJvJFA60Zxrobijt0zI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcel Hamer <marcel.hamer@windriver.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.1 371/578] wifi: brcmfmac: fix NULL pointer dereference in brcmf_txfinalize()
Date: Wed, 19 Feb 2025 09:26:15 +0100
Message-ID: <20250219082707.613347293@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -539,6 +539,11 @@ void brcmf_txfinalize(struct brcmf_if *i
 	struct ethhdr *eh;
 	u16 type;
 
+	if (!ifp) {
+		brcmu_pkt_buf_free_skb(txp);
+		return;
+	}
+
 	eh = (struct ethhdr *)(txp->data);
 	type = ntohs(eh->h_proto);
 


