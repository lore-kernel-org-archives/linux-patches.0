Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3EEC41D233;
	Fri,  7 Aug 2026 15:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116278; cv=none; b=iJqW/hMUhRZqiB6XgU2O3OKIyWW0iFn/1i/KxkPaGAtOERlov6SMHSY3a53eDp4FbkLwbRw7EFkLBHuRyqBGyvMgVnMhf5WxMybiEMmNb+q130sz/o//Edg+IstYkxdaAibTX+NVpj0CvfWoPtGuS5PHXdOe5jl5aa472/TsAhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116278; c=relaxed/simple;
	bh=AUVnvA10DZMkKp+Z6pFG/PLPXIhmunqw3Xp86+u0uLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VBaN6jLGvResfWdWdqCZ11B4UpcLH4KjisX4geHBQ5C60UqbLCd8TwPmKG+efNUtAKJjxiF6FoZvjGO1vbUUa+/nsJXDL7W1BplX1DRxu/xAj6I7tkb7VbMSDtXeSy7GhBH3vUmKfr1K5ORE4qle71+QjWEWX9Zqw48ZVipCmLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bh+FsCL3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bh+FsCL3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CEA71F000E9;
	Fri,  7 Aug 2026 15:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116277;
	bh=/5/lcggMwUZAlqhtR4GhLdq8pq0ZqX3cpa2GU/dqaEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bh+FsCL3vtzauZOr7QEQ58hvbffSEpyim+Ny5XsNmedVMZ6ey/Tf4aM7tuKyobEAk
	 yLNiS2zLQCj5d+gzpTihOeBjJ7P7obVLcUnsTGJhu7wIU6UZGIqYUoYUkIORuKUE39
	 SU64zJDlH5ptk6ljXgTB1/2HJ1AortTaKLZs8ns4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.6 176/261] can: kvaser_usb: kvaser_usb_hydra_get_busparams(): fix memory leak in kvaser_usb_hydra_get_busparams()
Date: Fri,  7 Aug 2026 16:38:53 +0200
Message-ID: <20260807143419.161834310@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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
@@ -1610,6 +1610,7 @@ static int kvaser_usb_hydra_get_busparam
 	reinit_completion(&priv->get_busparams_comp);
 
 	err = kvaser_usb_send_cmd(dev, cmd, cmd_len);
+	kfree(cmd);
 	if (err)
 		return err;
 


