Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B854187FF9;
	Tue, 10 Sep 2024 10:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963635; cv=none; b=K+O7oXC6DsOk5fNRRdPC8LWuu7EfswGuJ1DTeiz0rusXTGRt5BFc4RdhjzFa/rbIgNwt8MyaYm9VI47lG6hW3ftkXTNtok9HE1JJ6O3JqXbgxzbz7rTHwkVbu2WE7X273WZBjfPMuMqZ9fGg4+1eur2hGuTHctAGEvCcLptdxUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963635; c=relaxed/simple;
	bh=H3X6TgTirhMMNDD1jOHaD67R1auujoyDpo52+GPpkdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ICtcfX5+7NsGmXJP9CRV5E6SJI/k21Q3L8SfIxSKruAOPdpuavBTHjOvjdQ6wTmjDGgFq0uSxxpKqA+wlQc1kaBW+s/TUK7/VL36m3709p8lInV7XTLdAtaL/Ji2BYoLHT0DXlQjN0zDuSoQqw5WFYEJ1J6U4NHBmYfo1JnBiiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SgSWfaeE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SgSWfaeE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 855FCC4CEC3;
	Tue, 10 Sep 2024 10:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963634;
	bh=H3X6TgTirhMMNDD1jOHaD67R1auujoyDpo52+GPpkdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SgSWfaeEn7IpaG4XwrCkAcEr/JCCsZ+B89CN5GDce0rF1Jbw5eR/t3sc8m0pmmRda
	 ia5XFJy8MXjKcfrqvC23xCBY31v+VFMBj7yacPOvuSC2Lp8YjabWbZjLe1j1tIyhAo
	 HKJT+B4+LlQR2stUYCFvZ+SkqaR2+Vf7Rmmj+n98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Gerhard Engleder <gerhard@engleder-embedded.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 125/214] igc: Unlock on error in igc_io_resume()
Date: Tue, 10 Sep 2024 11:32:27 +0200
Message-ID: <20240910092603.868356248@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit ef4a99a0164e3972abb421cbb1b09ea6c61414df ]

Call rtnl_unlock() on this error path, before returning.

Fixes: bc23aa949aeb ("igc: Add pcie error handler support")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Gerhard Engleder <gerhard@engleder-embedded.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 7605115e6a1b..27c24bfc2dbe 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -7057,6 +7057,7 @@ static void igc_io_resume(struct pci_dev *pdev)
 	rtnl_lock();
 	if (netif_running(netdev)) {
 		if (igc_open(netdev)) {
+			rtnl_unlock();
 			netdev_err(netdev, "igc_open failed after reset\n");
 			return;
 		}
-- 
2.43.0



