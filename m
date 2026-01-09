Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0EF33D511;
	Fri,  9 Jan 2026 11:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959439; cv=none; b=StEE8xd7/UZys7watm6FBAjsP+MCSbaqbDkl3IoMQ/Nlj9LzBE8tWZs/F1Cf3D8j2E/uYwcZyrUWkEeonKJ09MssOD5Ts/ph04Raz5hJ8//FSj4SXL/pwDlhUY+qmIkik2moiftRtzYjWCP91/Tq+lrt9VBhDsoYOjIR/EPgfrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959439; c=relaxed/simple;
	bh=gnvamdzvBzDtpdqqdqg6F5rzYyGknDJ4Hz/WYoDcL2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R5TjX/FGUFW6cw/PI3pu6rD3IZTuFI/USWTryOfSsFq5ED6gLxEa7VRB31ktfMwSwCsEGRcKkZ5fXk1MZ2CS2IouH5nNO1+guJ/6nWWMHfHsFW9zPLCvhmQwUL9P1vTS9ovSND2xdHeWuda2Y56+9LOwWT4/GzBgsYY+4eAMOUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pWYlhbEC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pWYlhbEC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53CD1C4CEF1;
	Fri,  9 Jan 2026 11:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959439;
	bh=gnvamdzvBzDtpdqqdqg6F5rzYyGknDJ4Hz/WYoDcL2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pWYlhbECQy/3QVp/DvNPw30IO7swf4o7pUfGeYFNhxLc+DqCU2zymyloXMr8h2w/8
	 5+nKPpEfx2Sv2WB5owD9aYXBvxp6kPfOPj4QLQyDYHQi1YAx4cLD4f/ZlFzzrUhudS
	 6lGjkef2XNFarZ0QUdpWa4zwit+6JHH3P/uXDM48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 053/737] clk: renesas: rzg2l: Simplify the logic in rzg2l_mod_clock_endisable()
Date: Fri,  9 Jan 2026 12:33:12 +0100
Message-ID: <20260109112135.988676160@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

[ Upstream commit becf4a771a12b52dc5b3d2b089598d5603f3bbec ]

The bitmask << 16 is anyway set on both branches of if thus move it
before the if and set the lower bits of registers only in case clock is
enabled.

Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20230912045157.177966-12-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Stable-dep-of: b91401af6c00 ("clk: renesas: cpg-mssr: Read back reset registers to assure values latched")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/rzg2l-cpg.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/renesas/rzg2l-cpg.c b/drivers/clk/renesas/rzg2l-cpg.c
index 77eefb6ee4538..0b3b6097b33a0 100644
--- a/drivers/clk/renesas/rzg2l-cpg.c
+++ b/drivers/clk/renesas/rzg2l-cpg.c
@@ -992,10 +992,9 @@ static int rzg2l_mod_clock_endisable(struct clk_hw *hw, bool enable)
 		enable ? "ON" : "OFF");
 	spin_lock_irqsave(&priv->rmw_lock, flags);
 
+	value = bitmask << 16;
 	if (enable)
-		value = (bitmask << 16) | bitmask;
-	else
-		value = bitmask << 16;
+		value |= bitmask;
 	writel(value, priv->base + CLK_ON_R(reg));
 
 	spin_unlock_irqrestore(&priv->rmw_lock, flags);
-- 
2.51.0



