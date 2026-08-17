Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DADE3E025C;
	Mon, 17 Aug 2026 14:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976200; cv=none; b=H3ZrZmMzgV+tDVEMWYl3rVZFexjJ673xRU6H418b6hzvc5Q2c1K9N/gthEioSaxL9gyzFdIvsc0tpqP6lD8OQHefNL8merwdidHV0AsVYa+mGP9XLEztUrF8EB4FYCi2qrdqyulZkswYDvS/JvIYzilJACxVXKk8b4OopoQv8Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976200; c=relaxed/simple;
	bh=Vqs/iaRk/l8okTsD9Cx0CHmAi4ekteoG877uROH5QLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZznjOS6po0ni8jq0mfEPPPvaZWxgNhCvSMoGjBEW0Q4RjiRodlPCIBKk8NouITcfF27v/LGwvKVdrxFBkDWKnvBZKEEjccQG7kkGIj1mOwoXxd7DoVrPNG5q8HndyKFtIoNMSQWVHYIwTnfo4A482Z7OI7bz2lKbuNBF0X5obvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rSgrJmTx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rSgrJmTx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E6A11F000E9;
	Mon, 17 Aug 2026 14:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976198;
	bh=4Z2Jh8cKwxz3IO904KfIe+3lQk99ElDH09S2BqIDZJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rSgrJmTxw7Gbh/nc748Kmmd2wKP/mT1AVpwvoOZ9rTxKUuA0QkK1+5QzR3iZODyxo
	 2ZmBXbdPGGc32/wyms+bIQm7Ny35ogXtT6XzzQ26o/LM15ZseZojKnNepOiKy5ksbd
	 t7EKUFddMLUk1KrBBO6pbCG1x+BsLNsrPTqzNUEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.10 292/389] can: kvaser_usb: kvaser_usb_hydra_get_busparams(): fix memory leak in kvaser_usb_hydra_get_busparams()
Date: Mon, 17 Aug 2026 15:32:11 +0200
Message-ID: <20260817132550.472160375@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit 941eaf9a6d3b33dea49f2c0a1da7546a03b6ff71 upstream.

The memory allocated for cmd is not freed after the call to
kvaser_usb_send_cmd() in both the normal and error paths.
Fix that by adding a kfree() immediately after the call.

Fixes: 39d3df6b0ea8 ("can: kvaser_usb: Compare requested bittiming parameters with actual parameters in do_set_{,data}_bittiming")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Link: https://patch.msgid.link/20260722103906.108571-1-nihaal@cse.iitm.ac.in
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -1582,6 +1582,7 @@ static int kvaser_usb_hydra_get_busparam
 	reinit_completion(&priv->get_busparams_comp);
 
 	err = kvaser_usb_send_cmd(dev, cmd, cmd_len);
+	kfree(cmd);
 	if (err)
 		return err;
 


