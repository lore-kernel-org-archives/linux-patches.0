Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F9E4409;
	Mon, 23 Jun 2025 21:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714451; cv=none; b=pl98NPWAnPzoOCromtzHP9o4yJd7imOiSwVAToMFVAONnkrE/1jxnj//87ROLFGFcza54jdOmAPCVeczWA5iL1lxTYTH3Aht5ty0gNcaNZwLbrAtaRw3ZbbLe70uhlZwgwibFq0IyUvHoRo8ehn7efRsVDVBmC2N4ukXQ4G6ElI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714451; c=relaxed/simple;
	bh=73lSYHMtVOEjL71WwX7OIoF36eHWO9I1CHARztwESdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i21D/+XGhZFcRgDgQkvKuv5gXU7BfSxW9BDbbwzXJBIDqU3mgusy7k5zDXSgu6ntm81aYS/RMVdbRBMfpNQNaLRUGdsJ9lBegypNETuFhYL8cxDav6gmhilZ31nkYvlKXkAsGvnIaCvVmUyY2FEN4r3M2efhFN4T9Phb7syQsIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FEWFi170; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FEWFi170"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CF53C4CEEA;
	Mon, 23 Jun 2025 21:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714450;
	bh=73lSYHMtVOEjL71WwX7OIoF36eHWO9I1CHARztwESdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FEWFi170/8aZkwH2Mjtq1ihHyMbbwLUxVgJsr0Dd+hzUGAsklgZDuApAdBPDFNfPV
	 o4c76OPEnuR6Yp69Gk1vPyRTfTIYLAL36D1wWo05FszroN7nmTTF7IKPAcvca7mTBd
	 lSGfdjn4mGBiUWxE3HUFFCrXx+UyzYkn3iDajbWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5.15 209/411] media: ccs-pll: Check for too high VT PLL multiplier in dual PLL case
Date: Mon, 23 Jun 2025 15:05:53 +0200
Message-ID: <20250623130638.931705998@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


