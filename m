Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0E9332ECC;
	Mon, 29 Dec 2025 16:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025996; cv=none; b=Hm/dqGYGIZnVXB2D6COKm9KjLWRNxNyRFd+s5DY7+gQdWvt9l08mBuRRNHM7yPKeMzmayNA1Oi4v5CkIO9WHSwGHDyhnGjvLNnB60EPVjKLw5VRnAWEon1dqYfjciA/fQaNjyCG672JU3D2Bi8wA1Lz9hoktOHomrv78fAPQQ+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025996; c=relaxed/simple;
	bh=pRuYu/10S273RGDJdHimQFfh9O3vb8DoLhsy91Wg0G8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t8hdiki8gC1peNqkp9vTReXE//iWRIhwrbfwAWyzsD27GNlvsXNBOLemTYZ6P2hnkv8iLowdqc9zNNBH70GtZVAbsl+YH73xBOUtggSGavF0EZav/ZveLD5IQXfhsiINUPatsZDRHpLqMuD6LKPhqGNmqOw7zmG8bHyyKc5vsis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w7WEwK3D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w7WEwK3D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0240C4CEF7;
	Mon, 29 Dec 2025 16:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025996;
	bh=pRuYu/10S273RGDJdHimQFfh9O3vb8DoLhsy91Wg0G8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w7WEwK3DtQ6231FzdMSxgm2MEv5YNmAlQfk15N2vyQmK9RoDuGr4RYDM8f6/PbEZc
	 Yy/GGBFeDUPRz7D04pZaIXJRdpgvV3TTfTUdhprMjPxBfAEfHc4CSIerP5Bn4jASUj
	 Qo2x51/q476/nd/OKgE6GeF9nqQppOi4cOeRG0BU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Sven Peter <sven@kernel.org>
Subject: [PATCH 6.18 409/430] soc: apple: mailbox: fix device leak on lookup
Date: Mon, 29 Dec 2025 17:13:31 +0100
Message-ID: <20251229160739.364563308@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit f401671e90ccc26b3022f177c4156a429c024f6c upstream.

Make sure to drop the reference taken to the mbox platform device when
looking up its driver data.

Note that holding a reference to a device does not prevent its driver
data from going away so there is no point in keeping the reference.

Fixes: 6e1457fcad3f ("soc: apple: mailbox: Add ASC/M3 mailbox driver")
Cc: stable@vger.kernel.org	# 6.8
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Neal Gompa <neal@gompa.dev>
Signed-off-by: Sven Peter <sven@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/apple/mailbox.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/soc/apple/mailbox.c
+++ b/drivers/soc/apple/mailbox.c
@@ -302,11 +302,18 @@ struct apple_mbox *apple_mbox_get(struct
 		return ERR_PTR(-EPROBE_DEFER);
 
 	mbox = platform_get_drvdata(pdev);
-	if (!mbox)
-		return ERR_PTR(-EPROBE_DEFER);
+	if (!mbox) {
+		mbox = ERR_PTR(-EPROBE_DEFER);
+		goto out_put_pdev;
+	}
+
+	if (!device_link_add(dev, &pdev->dev, DL_FLAG_AUTOREMOVE_CONSUMER)) {
+		mbox = ERR_PTR(-ENODEV);
+		goto out_put_pdev;
+	}
 
-	if (!device_link_add(dev, &pdev->dev, DL_FLAG_AUTOREMOVE_CONSUMER))
-		return ERR_PTR(-ENODEV);
+out_put_pdev:
+	put_device(&pdev->dev);
 
 	return mbox;
 }


