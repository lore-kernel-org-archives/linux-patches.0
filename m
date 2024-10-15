Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96286205E26;
	Tue, 15 Oct 2024 13:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998175; cv=none; b=Ay/0D3ckckzmwmbaSMg8zFkHYJs9d06jexDiYMFR5qAiv3GXw64cPzC4PNWcRMc9SyEbRbqWiesq5E5C8fi7JhsREazOZa+rtwtYTytpWAguqv9k12KAbpm5/TIr/hoWqloCwF+tDWnu0KQGUeGziJrhV6IVKk0YB1JvY1ghI0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998175; c=relaxed/simple;
	bh=RB7PIW0DGo7SC0e2ltwUFvAyjwQQSbhTFDabZhMfxv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mBOpyPEiaiVzNQiLgzekoMTO8vKFYK9NHwahaF9Ogunn/LiSgf70RiYYbXhLMDdS9642ZclYpzjKtENkOosD10vlgALkdRaTBL5R5ghvhM6ZJJDlzOfT6psDqPkPzUYpdp9worOsE1gDi1PcqAPAYEamKko+sfoToSDrdugKcRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u+vjHfvS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u+vjHfvS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B77ABC4CEC6;
	Tue, 15 Oct 2024 13:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998175;
	bh=RB7PIW0DGo7SC0e2ltwUFvAyjwQQSbhTFDabZhMfxv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u+vjHfvSOO29lAkPZ+EbQL56JAOAzEYfouZp5PtMQfXkyzEPxwcDtH1Yt/LcMXP+s
	 Uozjf6IUNIPiDx3rFArinXDuFsIw4bCi1aOy/vulSNnj7QlFgxgx+P1K2V6Mv790DX
	 PdTZzAogJZkXfSi3DhrwCTMSZPNVLxfCIvCH5W7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 5.10 399/518] clk: rockchip: fix error for unknown clocks
Date: Tue, 15 Oct 2024 14:45:03 +0200
Message-ID: <20241015123932.373835434@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

From: Sebastian Reichel <sebastian.reichel@collabora.com>

commit 12fd64babaca4dc09d072f63eda76ba44119816a upstream.

There is a clk == NULL check after the switch to check for
unsupported clk types. Since clk is re-assigned in a loop,
this check is useless right now for anything but the first
round. Let's fix this up by assigning clk = NULL in the
loop before the switch statement.

Fixes: a245fecbb806 ("clk: rockchip: add basic infrastructure for clock branches")
Cc: stable@vger.kernel.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
[added fixes + stable-cc]
Link: https://lore.kernel.org/r/20240325193609.237182-6-sebastian.reichel@collabora.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/rockchip/clk.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/clk/rockchip/clk.c
+++ b/drivers/clk/rockchip/clk.c
@@ -442,12 +442,13 @@ void rockchip_clk_register_branches(stru
 				    struct rockchip_clk_branch *list,
 				    unsigned int nr_clk)
 {
-	struct clk *clk = NULL;
+	struct clk *clk;
 	unsigned int idx;
 	unsigned long flags;
 
 	for (idx = 0; idx < nr_clk; idx++, list++) {
 		flags = list->flags;
+		clk = NULL;
 
 		/* catch simple muxes */
 		switch (list->branch_type) {


