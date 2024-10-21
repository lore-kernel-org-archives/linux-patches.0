Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F4F39FD6;
	Mon, 21 Oct 2024 10:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506531; cv=none; b=aNLMLhSAQ5myvSqajVakU4X5xU1pP94gFVQTo3+AX7vnSAO9E0NV+hzkf8blyTSEd4z5/L79HUpT9w2OjuPshQ35c0Dp4B1YYfqf2EuXouMkH1JNRSu/y1lATiiMr5jOe6ZVpwz09P03McfuK1JPSjndfygDsiU1dEh+oUd2IZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506531; c=relaxed/simple;
	bh=v6d3Wcv2Bs0eD1ck6W39QmV17GvS5aOd4lGeOZgbLKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yfne8m/2g8xgB1Hs1JvCaqulIraIw1KWYCeQ2xki0GMA4r8XD1zwSucda++Pr3FIuEOX13Y44K+pZJNVIqYvI2oD6gvHNOcQ5L3zmHlh+Rl2a2zqo9UWOC5estIgM9DKTEcyYuyPMeqq+Dck96DRo5axSHvUoJT+Nrqgg23HdaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XoFGiGeg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XoFGiGeg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FAB7C4CEC3;
	Mon, 21 Oct 2024 10:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506530;
	bh=v6d3Wcv2Bs0eD1ck6W39QmV17GvS5aOd4lGeOZgbLKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XoFGiGegdqu4EafWEGH/ZLobwpty71tctiLxVdaHoZ14iAfPGpB6mTBsJaaS96CIm
	 +hDefhuT+rx3wt/fkIOMNOR0+UEzA1ZB1EZkybBOAo9TWY/ja/3lcCtuohAlJI3LwG
	 5RBp0GaIyBpL8F5YWdFNOJa4SI/cb7E+6y5cLBzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cs=C3=B3k=C3=A1s,
	=20Bence?= <csokas.bence@prolan.hu>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.11 034/135] net: fec: Remove duplicated code
Date: Mon, 21 Oct 2024 12:23:10 +0200
Message-ID: <20241021102300.669505094@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Csókás, Bence <csokas.bence@prolan.hu>

commit 713ebaed68d88121cbaf5e74104e2290a9ea74bd upstream.

`fec_ptp_pps_perout()` reimplements logic already
in `fec_ptp_read()`. Replace with function call.

Signed-off-by: Csókás, Bence <csokas.bence@prolan.hu>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20240812094713.2883476-2-csokas.bence@prolan.hu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/fec_ptp.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -235,13 +235,7 @@ static int fec_ptp_pps_perout(struct fec
 	timecounter_read(&fep->tc);
 
 	/* Get the current ptp hardware time counter */
-	temp_val = readl(fep->hwp + FEC_ATIME_CTRL);
-	temp_val |= FEC_T_CTRL_CAPTURE;
-	writel(temp_val, fep->hwp + FEC_ATIME_CTRL);
-	if (fep->quirks & FEC_QUIRK_BUG_CAPTURE)
-		udelay(1);
-
-	ptp_hc = readl(fep->hwp + FEC_ATIME);
+	ptp_hc = fec_ptp_read(&fep->cc);
 
 	/* Convert the ptp local counter to 1588 timestamp */
 	curr_time = timecounter_cyc2time(&fep->tc, ptp_hc);


