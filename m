Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119151F543C;
	Tue, 17 Dec 2024 17:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455498; cv=none; b=MAgShcOcfgb+53jzW65sq6PTtRoqzCAaxOF8mFgoTSxQPOdnweZIWk51g61hAc1KeiJe4YmhVNVP8ZW0077GvEukg95m1r6oLfZ1ar++sB+8rqritFGG0K1cqrAiJUgiakoYuRPoGXqr5kalVDqVgKXwu3gcFkAtptSkRf++6UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455498; c=relaxed/simple;
	bh=9qLIxceUbjKEh2wu3+JGNBPFramnnrEpGJl4SAPnod4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bm+MrHTwI8hLes/HyDhCjYdzRGBHZjrXDNZK2Nyz+20ZWTbyGLsN0Dzc2N9+RiAflEoMtkuNrfaezFBb8Z/BUY2PxTVYbhHgvVpW07arsef9T55WcNC77wYqfwgWlKd2YrP048CdDDyIUKMFcKPInqcQnSrBEoug24pADQxD674=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eVQS1fNj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eVQS1fNj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E691C4CED3;
	Tue, 17 Dec 2024 17:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455497;
	bh=9qLIxceUbjKEh2wu3+JGNBPFramnnrEpGJl4SAPnod4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eVQS1fNjAC80fBlfjLYb/r+110yibTzJKLr2vsb+a55A4l5QRT63LCxq8IxtphDTr
	 htpzTwyNa+SL2H8GAJiJEhOQeFqhCW8v+pXJ3iiDsSaHMKn/tH9JUuzyMdP7dJNm+G
	 PyjJOI4qAQstOZHBrLnt86ANLqff41ptN6eOmLKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 5.10 03/43] ata: sata_highbank: fix OF node reference leak in highbank_initialize_phys()
Date: Tue, 17 Dec 2024 18:06:54 +0100
Message-ID: <20241217170520.601838473@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170520.459491270@linuxfoundation.org>
References: <20241217170520.459491270@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


