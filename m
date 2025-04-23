Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D79289364;
	Wed, 23 Apr 2025 15:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421306; cv=none; b=YnIrDRh9Pdsef0phhZ30wXP3VNH0IYWpbw4RAEejgNGAtY3SOIyvEcSCX6/ABpNZyPDFA/7O1FeKOHLfhkJldWnul1yNk/Mk3XtR5H+BbQhGav6FaSynfxzAUaCRm47kvo70LwHQidpM+e74K9StSBRJ6shpIJJ+Jj8q5mN4VjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421306; c=relaxed/simple;
	bh=lvIu5rzYHN1UKF5OvJnvGRoslKvvnzjmy37nt2pJpds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jD5sPKNxnKnUMtt5IvbvSKRq9pWcMnm6EiQM6o8ExmTfUIJLmlpGnFGovDvLGUn6Asen53hv2ZRZ3wjYVbXLQkSbeIsWZmEVncubyP08ul26wediITCW80D+DSt6LW7euvXQWpk+kd0KKS9RtGcVciLro/EG3YPJZIYNHj46TTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xS9zS8cR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xS9zS8cR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 613BFC4CEE2;
	Wed, 23 Apr 2025 15:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421306;
	bh=lvIu5rzYHN1UKF5OvJnvGRoslKvvnzjmy37nt2pJpds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xS9zS8cRnY7S5JF0DLHG18xtlpV2VBE4lUdOkoPzc4BMKMY8XP2TdmHwn7rTgZkF7
	 orDjObiM1V4SkrnK3piDZ8fBh1iZaKJDcqWzku+zie0IX7GSHY239BE3sQMVpn8Xy9
	 GcCL5kxiBi/JaI3MkYUJHOnC3lSCa6unPoxUGu4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Stanley Chu <yschu@nuvoton.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.6 167/393] i3c: master: svc: Use readsb helper for reading MDB
Date: Wed, 23 Apr 2025 16:41:03 +0200
Message-ID: <20250423142650.266599748@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanley Chu <yschu@nuvoton.com>

commit c06acf7143bddaa3c0f7bedd8b99e48f6acb85c3 upstream.

The target can send the MDB byte followed by additional data bytes.
The readl on MRDATAB reads one actual byte, but the readsl advances
the destination pointer by 4 bytes. This causes the subsequent payload
to be copied to wrong position in the destination buffer.

Cc: stable@kernel.org
Fixes: dd3c52846d59 ("i3c: master: svc: Add Silvaco I3C master driver")
Signed-off-by: Stanley Chu <yschu@nuvoton.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20250318053606.3087121-3-yschu@nuvoton.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master/svc-i3c-master.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -376,7 +376,7 @@ static int svc_i3c_master_handle_ibi(str
 	       slot->len < SVC_I3C_FIFO_SIZE) {
 		mdatactrl = readl(master->regs + SVC_I3C_MDATACTRL);
 		count = SVC_I3C_MDATACTRL_RXCOUNT(mdatactrl);
-		readsl(master->regs + SVC_I3C_MRDATAB, buf, count);
+		readsb(master->regs + SVC_I3C_MRDATAB, buf, count);
 		slot->len += count;
 		buf += count;
 	}


