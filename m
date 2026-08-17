Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D920843231F;
	Mon, 17 Aug 2026 14:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977504; cv=none; b=uLmGX0OPTDyrg+fAAN+5xc7a3CDW2npExDAIUcvQlNfR1ntnH5cPPACUjciZQ7JvRGbF8x5WH5OVYWvAY9noS1lgDEyfE2AgmSyIpR1yCk01oHC6MFF/HXnFGO3ZX/M0OluMJfWlB1Fw+S2kj0etMQG93mmDpQchFkjrHpeBc6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977504; c=relaxed/simple;
	bh=NYudEAevIF7EJ5TradsxekhqFAdHDvTs9+oQY8Ykp0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C/I2ZNtHSGeKOegaAOSqmzVdA02rwaNMhIED1MAB7c8nI0EuQZu9aRExub30E1nd4CsESFbPpmswoR2b15TdpL6chLWgL6dQZzWo6UkRUSoHPftJRxn1lYkDLKqyIotuYKJsq0aI2YaR4MnmIIwcapgFGW8krbw5zWYYcy0gWCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nipPrOfR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nipPrOfR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0812D1F000E9;
	Mon, 17 Aug 2026 14:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977503;
	bh=pqJ+6lHGKwmDILdVKcv6doJxtgBwxKiz5tjYzAetlyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nipPrOfRm+fOWJHo8X1BEs0jO7sCUqBMEW+cqPXewoBwx9GMEEZ/r6VbSoZ9Jbdbk
	 k5MKByzPgjdKCFpCxq3DmE9cYsqa44GwRMojWL58OLIC2tje53CgNw4UGcTTn6UqYM
	 6bhAtGQPCAY4MEUfUrhnXMSLixmsW0wURWjts7Uc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.15 350/456] can: kvaser_usb: kvaser_usb_hydra_get_busparams(): fix memory leak in kvaser_usb_hydra_get_busparams()
Date: Mon, 17 Aug 2026 15:32:20 +0200
Message-ID: <20260817132553.240712243@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1601,6 +1601,7 @@ static int kvaser_usb_hydra_get_busparam
 	reinit_completion(&priv->get_busparams_comp);
 
 	err = kvaser_usb_send_cmd(dev, cmd, cmd_len);
+	kfree(cmd);
 	if (err)
 		return err;
 


