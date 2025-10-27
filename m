Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884813074AC;
	Mon, 27 Oct 2025 19:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592226; cv=none; b=j7FleoleoCoNiPW116Hkvg8ytLujv5L9/2fTemhtTlUGyX/6HuSJht80SYw6LIqKR6SOASMQv6fLkvFf+9f/35eoLvhsh0p2sGkC2J+M3QaN2wVvt9oy0cOQxbitGxn6Pq+T9TFcYKWrfexCTs6+tvaZBsUp5wVh1w8Eb9tiKJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592226; c=relaxed/simple;
	bh=GqPCnFGgkoJmtLshweIO1jDqKjYeglw0stjQYbzbmLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F3RPFKtdHwLtuEVRnUQ3uCjqzvRi0jhui7Ux1cGrM+iAz1s/4X29Wa/ilF1MaBx95nCHG7wrls9NtsYPsVCMxhHnDPetOCWzrsAdhfGlGy6nieJ4IoxzTR7sk674uKjZD0sj3rOFNIqfLrPwdUl1qwpiK0V65ZYP5xa0OkB0ig0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TixgTo8N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TixgTo8N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C0A7C4CEF1;
	Mon, 27 Oct 2025 19:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592226;
	bh=GqPCnFGgkoJmtLshweIO1jDqKjYeglw0stjQYbzbmLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TixgTo8NU0IH916KCdjEih5HSjHW3GReuicEOEsH6F2VxLtVIKd4eciZhOhRiSTeJ
	 pugd90NqKWXRKIDu9fZj2IdaZFtaZ3dkWmXLeN29UfIXvt6dC5Rvfyp1n5Y8a9RwMP
	 IZJ5nWIJDs/sj6mZYPWG/qGcj6s7TM3ck0natkBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 040/157] r8169: fix packet truncation after S4 resume on RTL8168H/RTL8111H
Date: Mon, 27 Oct 2025 19:35:01 +0100
Message-ID: <20251027183502.371869287@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linmao Li <lilinmao@kylinos.cn>

[ Upstream commit 70f92ab97042f243e1c8da1c457ff56b9b3e49f1 ]

After resume from S4 (hibernate), RTL8168H/RTL8111H truncates incoming
packets. Packet captures show messages like "IP truncated-ip - 146 bytes
missing!".

The issue is caused by RxConfig not being properly re-initialized after
resume. Re-initializing the RxConfig register before the chip
re-initialization sequence avoids the truncation and restores correct
packet reception.

This follows the same pattern as commit ef9da46ddef0 ("r8169: fix data
corruption issue on RTL8402").

Fixes: 6e1d0b898818 ("r8169:add support for RTL8168H and RTL8107E")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://patch.msgid.link/20251009122549.3955845-1-lilinmao@kylinos.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 6346821d480bd..6879660e44fad 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4950,8 +4950,9 @@ static int rtl8169_resume(struct device *device)
 	if (!device_may_wakeup(tp_to_dev(tp)))
 		clk_prepare_enable(tp->clk);
 
-	/* Reportedly at least Asus X453MA truncates packets otherwise */
-	if (tp->mac_version == RTL_GIGA_MAC_VER_37)
+	/* Some chip versions may truncate packets without this initialization */
+	if (tp->mac_version == RTL_GIGA_MAC_VER_37 ||
+	    tp->mac_version == RTL_GIGA_MAC_VER_46)
 		rtl_init_rxcfg(tp);
 
 	return rtl8169_runtime_resume(device);
-- 
2.51.0



