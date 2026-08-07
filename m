Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CEEE4B0482;
	Fri,  7 Aug 2026 14:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114349; cv=none; b=Yd7e3z+OYuC6u0zklrfMhhXmJhimud3SUxFcMeNNW2j50Nd2fvEwFY9r8JV72fT0d2AOyxopTkDQENpAEvac1vVX3PIxGCEd5D3a7duSESOdzR0kd78ZpLttVzxxK6Dty5YvZbjDb4jNOKSN8qCV2rQZrSfJqoJMQF3HtGMXq3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114349; c=relaxed/simple;
	bh=VeVNkcUYcMcs1B4E9xljLOtXyto3rPb34eIBMJoCSzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=srcYGmpqvN5LsCxfsO0PNXO859GmeJ79klb8DaoKqjZHm8w9JvdEBcyRwFpMUnoNuXhaQX424f3WdVCkP5qMllTecjVQ5soVupnRbj78RYj3P7IFKlV0I4c3mhwo11R8TbZ4fFdHQeVo9KPUf8mV7HPeW6TqUpfLEu5RXV3dszo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SEp+I9SJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SEp+I9SJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA1871F000E9;
	Fri,  7 Aug 2026 14:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114348;
	bh=8/7UuMIrhKU0+gOuzInmQq2D8WZe9X8bNpcSfdoYUYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SEp+I9SJPQwPxibDkIRzmhccXjZJvi2UMG4uHzXPY0GOODUTP2GZJi6jbUUviHLAM
	 D6aWERZfa7TVAij/BpZ282MZLxzeAZERvNJoyIeXzL1XK8nLuzAmfq7z2sVw8HSBHj
	 kJf12xd979weiBYecawCYfU+28vulzJlRbFFDjKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.12 233/337] can: kvaser_usb: kvaser_usb_hydra_get_busparams(): fix memory leak in kvaser_usb_hydra_get_busparams()
Date: Fri,  7 Aug 2026 16:37:16 +0200
Message-ID: <20260807143423.604166665@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1625,6 +1625,7 @@ static int kvaser_usb_hydra_get_busparam
 	reinit_completion(&priv->get_busparams_comp);
 
 	err = kvaser_usb_send_cmd(dev, cmd, cmd_len);
+	kfree(cmd);
 	if (err)
 		return err;
 


