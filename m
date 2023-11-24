Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B61663A1;
	Fri, 24 Nov 2023 19:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NH8XVU4r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A23C433C7;
	Fri, 24 Nov 2023 19:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853651;
	bh=hyiRjlM/QfQTfsiX/5HuGnewKZnYMoJM0GfbONutnkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NH8XVU4rS+QJIw2JwoR7kiF4+D+/Fuqsv9nXSsjCSq9+6aVAk/TuF4bEi+ZvOZF2Z
	 yOcKNReFxdvoo1Z79R+GtZXrKIf+b1pXA3AoXMn7dys3XCEc6p6pS/FDXJfvDSDlpI
	 sy66c77EH6r8XHb0gCtssfgUzmyglnqTq5bLi818=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	ChunHao Lin <hau@realtek.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 274/297] r8169: fix network lost after resume on DASH systems
Date: Fri, 24 Nov 2023 17:55:16 +0000
Message-ID: <20231124172009.723817889@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
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

From: ChunHao Lin <hau@realtek.com>

commit 868c3b95afef4883bfb66c9397482da6840b5baf upstream.

Device that support DASH may be reseted or powered off during suspend.
So driver needs to handle DASH during system suspend and resume. Or
DASH firmware will influence device behavior and causes network lost.

Fixes: b646d90053f8 ("r8169: magic.")
Cc: stable@vger.kernel.org
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: ChunHao Lin <hau@realtek.com>
Link: https://lore.kernel.org/r/20231109173400.4573-3-hau@realtek.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169_main.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4714,10 +4714,16 @@ static void rtl8169_down(struct rtl8169_
 	rtl8169_cleanup(tp, true);
 
 	rtl_prepare_power_down(tp);
+
+	if (tp->dash_type != RTL_DASH_NONE)
+		rtl8168_driver_stop(tp);
 }
 
 static void rtl8169_up(struct rtl8169_private *tp)
 {
+	if (tp->dash_type != RTL_DASH_NONE)
+		rtl8168_driver_start(tp);
+
 	pci_set_master(tp->pci_dev);
 	phy_init_hw(tp->phydev);
 	phy_resume(tp->phydev);


