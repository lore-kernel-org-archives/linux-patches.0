Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E111E493;
	Tue,  8 Oct 2024 12:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390753; cv=none; b=nvuvsWX7tsFXBJU7muHcRvimqZMD4ojHVTToJ83inbHXlBBpr4BSUEErKpnVUlhhEuUyIbhv5UVnFc45OvPIyYvRERdsaFXAlouqjTszgvALLSmuoO9wXc6Cq0aQzvUpwWvfRPn8cOytgMiWBGuYLPzjXT6FyT2Kyah24Vs91s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390753; c=relaxed/simple;
	bh=RdrBGepv/0v3RVZKnVDVgYRVy5tIwWzw9/hEgnQFsE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WHNWndhzFxpPuZnhzBytt9a4y3Jom++WID4fT+hem+BXQGx2lwRCG232pTbMddBKbYXMMFKoYVxyM0lZWOoa1DF+pz8u8lypo2i6NwjptvX/MZfVR2CWO+hC3IUJZ/dDNDhE44+fvZPqWMEz+6TdudswPC8A/VGdvD3gzLOhCJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xvC9mxWP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xvC9mxWP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C79C4CEC7;
	Tue,  8 Oct 2024 12:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390753;
	bh=RdrBGepv/0v3RVZKnVDVgYRVy5tIwWzw9/hEgnQFsE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xvC9mxWPQls75ZWgEUY77vp8pewxJ2y1VmaGghALgwUjmpYo2L++NGt7+AC5NlxaZ
	 evkuxLbCOtASCTxTuBmNWinQpaePzguu0XptNgbe08imGc8JADr+EYcY6Fl0lEqrJm
	 sjEOAG/zPSjGbGYCPrwhcfnMCX72DW+8J619KSmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.10 382/482] clk: rockchip: fix error for unknown clocks
Date: Tue,  8 Oct 2024 14:07:25 +0200
Message-ID: <20241008115703.450306997@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -450,12 +450,13 @@ void rockchip_clk_register_branches(stru
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


