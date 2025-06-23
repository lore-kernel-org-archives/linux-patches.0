Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4943FB1B;
	Mon, 23 Jun 2025 22:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716248; cv=none; b=g/qGEFiPUyv4k0Yv+IPoWrhBSua8OUj02oKpmzD+UdgeQTboxlXiJJ1DtHMHK8LtHidmrIsoqY2D+Fv9xdWDpXASYnwRaca+CX02q5yBrdiLTAz50BaWhz3a7Sm3mtPFAIqTVjoySToohmTExQ13KHJiTvSXBzeyRpZr3vvlzrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716248; c=relaxed/simple;
	bh=faW1s6yOuQBAx7ABNVP9VsS8UJ/WPB+V6VpF5lvsVv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GFhkQAIMf65LQDRXOf76pIoAu4aeqMgV+poFhLHdLlrNkVoTCMhIBH8uBi4tWDH2EMvZiidVWrjzyaA0Zk9nEvdBk7vkZJ4eDSceuVn2w233/qDlZrPMEu2gIorO6dECTjPWr56Hth6Dfi8R0+42Hc5BhFbEekGFHepiZ/GoEGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1G3/6hf8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1G3/6hf8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84655C4CEEA;
	Mon, 23 Jun 2025 22:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716247;
	bh=faW1s6yOuQBAx7ABNVP9VsS8UJ/WPB+V6VpF5lvsVv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1G3/6hf8gDaabV9nfu3uHQvyeYXa6FANwtERQTk324A4CiOcxMwqmUa3DG5MR0vYr
	 RdBCo4ZyNfpEVrF3lkgR46CsMkzC4en/N9JJIUBnPO8J8PX7JnerH8cvbc/vdZ2H8w
	 SEkwOuqQPTbln5jlwa97mSjM4bzBxr9qJA6MMt7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.1 311/508] media: ccs-pll: Check for too high VT PLL multiplier in dual PLL case
Date: Mon, 23 Jun 2025 15:05:56 +0200
Message-ID: <20250623130652.970440333@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


