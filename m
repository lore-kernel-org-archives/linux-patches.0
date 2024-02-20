Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403F62DF9F;
	Tue, 20 Feb 2024 21:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465287; cv=none; b=f83btxRE//vA14pVA1mUkiAL4lAh4DDuZKPfNB5NF6mMICYxbkH+xbea7macHdz1s0Ch5l+nvIopLSBnedFYfVrlVzMBs3upWT+WGpiT4Cp0ds32B9Ju2H9aPyuhFMUFzamxOL0crEz1bpsPYcrkSNQoaS2Acw89mj6eikrYKeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465287; c=relaxed/simple;
	bh=bSX6c4xsQBLnCDY30ScnyqC78DT6rnG62AHcdEYwNLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PQJJ82bwyvuQnAmIF5Py1sEtK78/vngoUQ7VY8PAGiLX/JxNJ8dX54s6C0sqlbcjNIDa7OeAvTLSNoXFkcuraPqtIQb4i71qM53eeLVADcqWG35n9VLfdZYix34rGr0HwhUOY/4aCiFXHz8iCIs2eZRHgBPMKuF/Ma8+iVmQ60s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z8x06RPg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z8x06RPg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0B3AC433F1;
	Tue, 20 Feb 2024 21:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465287;
	bh=bSX6c4xsQBLnCDY30ScnyqC78DT6rnG62AHcdEYwNLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z8x06RPg8SDOetQpf3puz/r9q2xl2o8dbnOWd49wZPQwQwWSJqm+RNhL/XpnnPCaB
	 8sYFPXePcjarbXWeqHxV1USa/7Ev6Px+nvOT6Lg8bp+E+6oZmet3sZ31jaBQR5vwFL
	 2gPLtLpNRQZWX7694GR1lz2xV9x/DQJTxWdpNvaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Jayat <maxime.jayat@mobile-devices.fr>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.7 296/309] can: netlink: Fix TDCO calculation using the old data bittiming
Date: Tue, 20 Feb 2024 21:57:35 +0100
Message-ID: <20240220205642.353225530@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Jayat <maxime.jayat@mobile-devices.fr>

commit 2aa0a5e65eae27dbd96faca92c84ecbf6f492d42 upstream.

The TDCO calculation was done using the currently applied data bittiming,
instead of the newly computed data bittiming, which means that the TDCO
had an invalid value unless setting the same data bittiming twice.

Fixes: d99755f71a80 ("can: netlink: add interface for CAN-FD Transmitter Delay Compensation (TDC)")
Signed-off-by: Maxime Jayat <maxime.jayat@mobile-devices.fr>
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/all/40579c18-63c0-43a4-8d4c-f3a6c1c0b417@munic.io
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/dev/netlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/dev/netlink.c
+++ b/drivers/net/can/dev/netlink.c
@@ -346,7 +346,7 @@ static int can_changelink(struct net_dev
 			/* Neither of TDC parameters nor TDC flags are
 			 * provided: do calculation
 			 */
-			can_calc_tdco(&priv->tdc, priv->tdc_const, &priv->data_bittiming,
+			can_calc_tdco(&priv->tdc, priv->tdc_const, &dbt,
 				      &priv->ctrlmode, priv->ctrlmode_supported);
 		} /* else: both CAN_CTRLMODE_TDC_{AUTO,MANUAL} are explicitly
 		   * turned off. TDC is disabled: do nothing


