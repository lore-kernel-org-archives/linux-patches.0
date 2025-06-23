Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2476F2628C;
	Mon, 23 Jun 2025 21:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713558; cv=none; b=Z54mNE1gawMYCyNpAxHTK8m1w+Kdw81J0OKt87mt2Dt6lGMq46sOn8YMFT4JU88vuj4KbNQd0RB1uXDAkWwt2HJpAY9x1vr539g7vKNlF8CYuom1kWOdiZgvi7FsIMkIGlIOdF5I+K/gdS95NpHNyUPavtERWn5ID4zG67ekhk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713558; c=relaxed/simple;
	bh=wGdHUHH6X8ZgFPC79hBNMVGArCmK5I0/iNzldFYdMKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U1bljR9tl+EyYvXFgO6JK8Gqd1uZPiuTU+gi3V08P2p9bSHiJEVuZUHvjGh4EdXkDTDgZUym84RxN31ID1Dqx29XunscvZBVFPebfJKdSCFL5cRlv1o59S9JaY99lS9rqquJZ6ypCidwFEnkdIvPwt0SfMwk6PBTFhPuYBeAmmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wmVomPDR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wmVomPDR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1EE2C4CEEA;
	Mon, 23 Jun 2025 21:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713558;
	bh=wGdHUHH6X8ZgFPC79hBNMVGArCmK5I0/iNzldFYdMKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wmVomPDRXHLINLtrUcI0YzLNPSCBeg+qZH5K2wfOAbIWMKFWh72vwpMN5cm6NaIn5
	 QIf9X/jYBYtfoe7R5NfdKm9/91iPz26pN9fT4G7RuHCUA2rTS/tujth+diwavYorH0
	 aarso3XavngPiSqM0GJ6qneWP7a1BDCvD5H7lrfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 050/414] media: ccs-pll: Check for too high VT PLL multiplier in dual PLL case
Date: Mon, 23 Jun 2025 15:03:07 +0200
Message-ID: <20250623130643.296730560@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit 6868b955acd6e5d7405a2b730c2ffb692ad50d2c upstream.

The check for VT PLL upper limit in dual PLL case was missing. Add it now.

Fixes: 6c7469e46b60 ("media: ccs-pll: Add trivial dual PLL support")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ccs-pll.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/media/i2c/ccs-pll.c
+++ b/drivers/media/i2c/ccs-pll.c
@@ -312,6 +312,11 @@ __ccs_pll_calculate_vt_tree(struct devic
 	dev_dbg(dev, "more_mul2: %u\n", more_mul);
 
 	pll_fr->pll_multiplier = mul * more_mul;
+	if (pll_fr->pll_multiplier > lim_fr->max_pll_multiplier) {
+		dev_dbg(dev, "pll multiplier %u too high\n",
+			pll_fr->pll_multiplier);
+		return -EINVAL;
+	}
 
 	if (pll_fr->pll_multiplier * pll_fr->pll_ip_clk_freq_hz >
 	    lim_fr->max_pll_op_clk_freq_hz)


