Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8754828980F;
	Wed,  8 Apr 2026 18:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674554; cv=none; b=EzkUe1HEdTIJHx9B6R8g3iaT4WpWSKfCgKTU6GHfr+CiKTIABm+xobM92eICtj+uEmHEm2bvEJUXo0zgrwexXaXexQGWVHzriEQMvQOU3BDhkQKKPRFEtFEij5VSEdoOsQNxVZDY2F0O5WiAQ9umg2TODk2ZVv1ad2X0EyyhmHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674554; c=relaxed/simple;
	bh=0lg/1fuFUmUc/lltlIe7fYOGJsmmroE2hux174yUchI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k8XGcdfC6K6XC0yB3sG3kMUPWAn3CFGKrUX4Hkky4eX/m6DmEmXvKKIKD2kxywJ53H8oKI/+b/GErsahGPn7JTREag8ziuO8ckb/fWT25qds6wthturvqIAeFWa+m8VhTATS9rj27uh41Zu+wyrelBAbMj0U3mmkENHRgF+akZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nfm4lXhW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nfm4lXhW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD0ACC19421;
	Wed,  8 Apr 2026 18:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674554;
	bh=0lg/1fuFUmUc/lltlIe7fYOGJsmmroE2hux174yUchI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nfm4lXhWx41vmN47oYFAOyU+9LtW5Zw19fU0Y2MkaED/uq+RNbmBE0TjAS6ZO3uGm
	 w87xs+NkV3M0u3r4/tZ1tfzvNxuRMzwGHZmLgiC7qRBsMa/71kn6d2f0l0vo4cWQE2
	 b4jttCrdPJ54vH5hA5/BCraI2/olUSvsZ/a2u5T0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 110/311] net: macb: properly unregister fixed rate clocks
Date: Wed,  8 Apr 2026 20:01:50 +0200
Message-ID: <20260408175943.522556777@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit f0f367a4f459cc8118aadc43c6bba53c60d93f8d ]

The additional resources allocated with clk_register_fixed_rate() need
to be released with clk_unregister_fixed_rate(), otherwise they are lost.

Fixes: 83a77e9ec415 ("net: macb: Added PCI wrapper for Platform Driver.")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Link: https://patch.msgid.link/20260330184542.626619-2-pchelkin@ispras.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_pci.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_pci.c b/drivers/net/ethernet/cadence/macb_pci.c
index 0ce5b736ea438..b79dec17e6b09 100644
--- a/drivers/net/ethernet/cadence/macb_pci.c
+++ b/drivers/net/ethernet/cadence/macb_pci.c
@@ -96,10 +96,10 @@ static int macb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return 0;
 
 err_plat_dev_register:
-	clk_unregister(plat_data.hclk);
+	clk_unregister_fixed_rate(plat_data.hclk);
 
 err_hclk_register:
-	clk_unregister(plat_data.pclk);
+	clk_unregister_fixed_rate(plat_data.pclk);
 
 err_pclk_register:
 	return err;
@@ -113,8 +113,8 @@ static void macb_remove(struct pci_dev *pdev)
 	struct clk *hclk = plat_data->hclk;
 
 	platform_device_unregister(plat_dev);
-	clk_unregister(pclk);
-	clk_unregister(hclk);
+	clk_unregister_fixed_rate(pclk);
+	clk_unregister_fixed_rate(hclk);
 }
 
 static const struct pci_device_id dev_id_table[] = {
-- 
2.53.0



