Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB3C14A4E7;
	Tue, 17 Dec 2024 17:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455952; cv=none; b=KIQJ761OiYwhjXlJB98UbQZMFFVUGG5bCzgcg0XNJErKG3U3Cxfw7xOaamJ+IarNgj4T5gZN7VlP/tzYxihDfOd9KKmjCM9CoCmJPcCSyCqiySbXeWvwG0j2SqUMrwbkRD4QHL3Lg46OD8fz1lShMvVOulkwLSn1ZH50UwwNwx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455952; c=relaxed/simple;
	bh=BV2BEor9/zGHC/zk+XAKOUBajCxN30vfmmqVe/VIcx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sAqAtubhgYg/aTlAesx4yfsl3bpH0qHWlA84QE8te9hPZqZGDbxZ/Z4/I0kyrpN/pYBedfDtjcuxO2zR6+2hZYyZKB62/C1MghSgZzgQe9ISWdUmZfSb4dN59bgd6BxFSTYcXNWNQkpkyC9dmzgEw+0cY+aqir187vJXocyOlZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mZLZlctN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mZLZlctN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34AD2C4CED3;
	Tue, 17 Dec 2024 17:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455952;
	bh=BV2BEor9/zGHC/zk+XAKOUBajCxN30vfmmqVe/VIcx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mZLZlctN/28v5RNuYzPofqHXyCjE7Ed0Bl3VhvISN8RoMYPBmU6svY0DlLqLQGrHR
	 +J35l96wulnKIv0crQ5CgPVfpXsOIM/tJlwef4gSsho1iZGbmJmBPi0fJGVrjofWFe
	 Btl2n4FMgVbgmzuHNhYsuL4QIAfuui/vSTsvrzdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 6.6 011/109] ata: sata_highbank: fix OF node reference leak in highbank_initialize_phys()
Date: Tue, 17 Dec 2024 18:06:55 +0100
Message-ID: <20241217170533.825420889@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

commit 676fe1f6f74db988191dab5df3bf256908177072 upstream.

The OF node reference obtained by of_parse_phandle_with_args() is not
released on early return. Add a of_node_put() call before returning.

Fixes: 8996b89d6bc9 ("ata: add platform driver for Calxeda AHCI controller")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/sata_highbank.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ata/sata_highbank.c
+++ b/drivers/ata/sata_highbank.c
@@ -348,6 +348,7 @@ static int highbank_initialize_phys(stru
 			phy_nodes[phy] = phy_data.np;
 			cphy_base[phy] = of_iomap(phy_nodes[phy], 0);
 			if (cphy_base[phy] == NULL) {
+				of_node_put(phy_data.np);
 				return 0;
 			}
 			phy_count += 1;


