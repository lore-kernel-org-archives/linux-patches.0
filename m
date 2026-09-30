Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7AA546D092;
	Wed, 30 Sep 2026 19:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797251; cv=none; b=PWboNuvYXMNaxba+WaRCoUbhMN4pOdl5VzHO5C7zV8cGTNswf9JolCHMFgvI/WUT22Gjh2rnzTu0HkBxqfJ00qQJ8EF6aau6zEjZZNI2Ah4oyNVqFt2pRQGV2EUGW8HVviQIkvDwjspesf813zYqE0EDvbCUI0tfCdBgOH3kt/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797251; c=relaxed/simple;
	bh=/cC+MaysGJRIbRgCGlQor74SfJ/G4d93QtBR5C530+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OSuf5QRoZ63mXNfVnyxA6zuevixV9aXbDetHz2+X5V3BE3nAsJBbZNOATotWd0vUs9XC9W4WvTczrXMzY2StpwlMWNXRjMmA4Zy0IoxcmcbZ/Y3zbTjzhfLiRg6Zx7vJjq9UcNbtNabefLJskNZJe5oWw9qW6OK1BCVs7lWPdUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tIiFSZy+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tIiFSZy+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7FEC1F000FF;
	Wed, 30 Sep 2026 19:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797250;
	bh=giDVT+iitzj7fMdqgcuAdsRy4pMjkDCeEHaO4sNEcDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tIiFSZy+y9/C3pLubujAIN4lQ6f55jUnj3b4ISeSlUhSQbkQW3Wt6d+wtMEvr7e8a
	 k5IHcZEYsqPi8GDjpbTVE43RqP0qmRTccwjtf1ZGbACsDvwYKQdbA0PH8ALUBMEwh8
	 XFPpsHjGdVohDZ1B6R5cR6n3+cib0OZf93IKDopI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Breno Leitao <leitao@debian.org>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 1193/1193] net: mediatek: Fix potential NULL pointer dereference in dummy net_device handling
Date: Wed, 30 Sep 2026 17:31:17 +0200
Message-ID: <20260930152500.753391726@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

commit 16f3a28cf5f876a7f3550d8f4c870a7b41bcfaef upstream.

Move the freeing of the dummy net_device from mtk_free_dev() to
mtk_remove().

Previously, if alloc_netdev_dummy() failed in mtk_probe(),
eth->dummy_dev would be NULL. The error path would then call
mtk_free_dev(), which in turn called free_netdev() assuming dummy_dev
was allocated (but it was not), potentially causing a NULL pointer
dereference.

By moving free_netdev() to mtk_remove(), we ensure it's only called when
mtk_probe() has succeeded and dummy_dev is fully allocated. This
addresses a potential NULL pointer dereference detected by Smatch[1].

Fixes: b209bd6d0bff ("net: mediatek: mtk_eth_sock: allocate dummy net_device dynamically")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/4160f4e0-cbef-4a22-8b5d-42c4d399e1f7@stanley.mountain/ [1]
Suggested-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20240724080524.2734499-1-leitao@debian.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -4249,8 +4249,6 @@ static int mtk_free_dev(struct mtk_eth *
 		dst_release(&eth->dsa_meta[i]->dst);
 	}
 
-	free_netdev(eth->dummy_dev);
-
 	return 0;
 }
 
@@ -5103,6 +5101,7 @@ static int mtk_remove(struct platform_de
 	netif_napi_del(&eth->tx_napi);
 	netif_napi_del(&eth->rx_napi);
 	mtk_cleanup(eth);
+	free_netdev(eth->dummy_dev);
 	mtk_mdio_cleanup(eth);
 
 	return 0;


