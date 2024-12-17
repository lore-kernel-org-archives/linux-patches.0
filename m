Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FBDF1F75B5;
	Tue, 17 Dec 2024 17:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455581; cv=none; b=Lp5juOLus3pjm2/meQ6L87gAMyAeeUsyKiEEwcPMQkt04KAdwkW/1ue59kIAbSESnqqOK7fhu7P0ItHclOLAHkWxFZUp6FNJJ0MgkZ2fbAK9QjyBnXNcLjSRYrBdeK9tg95nPZuXx5ersxlcz/Tnih4VKR/Q/nnTHXwc4o9dgXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455581; c=relaxed/simple;
	bh=y45GwhKh4xq8LZipiW3enAqHkACy2rug2UpuqLHyIBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nm31Fvu/D8FbxEI8pEwlxtGdOptqp0JJj0TzEoBSLCAAokTlon/k5cYtEMuxV9bxmJf5P0PeAau76j4uCbMH8qC0wegzBBc1Z5Oa/aGBCLb55DQdaO+EYaTlQyM1mmkXd9J1GmRJF7k8XAwuSzs5/KTeaZuiuT7rekefVbwloIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lzTQE4PS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lzTQE4PS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F5CC4CED3;
	Tue, 17 Dec 2024 17:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455581;
	bh=y45GwhKh4xq8LZipiW3enAqHkACy2rug2UpuqLHyIBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lzTQE4PSpDptrPgltlEqb9Od46kJ+B640gTdCGEwexZbbWnmqrrkZJucQcWyFqedN
	 n9SIGVarh2OTnffHgWBQF7TQxGxwZOpcTjWMBIQCnxJM3NFdsdeKuPEFxnkCMwJ2zL
	 tviQxcQLRoPaosnAQtw7eosS/Q5rdw1OUyysyNQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 5.15 04/51] ata: sata_highbank: fix OF node reference leak in highbank_initialize_phys()
Date: Tue, 17 Dec 2024 18:06:57 +0100
Message-ID: <20241217170520.488992459@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170520.301972474@linuxfoundation.org>
References: <20241217170520.301972474@linuxfoundation.org>
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


