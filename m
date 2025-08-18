Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4D830DD05;
	Mon, 18 Aug 2025 12:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521441; cv=none; b=B68BSCNVUZS27sDsOGJ7Zf0ChlPkZpdSV1AX2keMntNw87XC4Ep704AiKmOqJYiTO2OCM3j3uEcDXJmXt/V2+Be+KU1wbG7GBRW93h83jml3JX3tx6YMBeCCbqZ9ioI1LLZw5emso/0uu1bbHQA9eq/4/cT37QkrfxfM2M4Vlpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521441; c=relaxed/simple;
	bh=wufA9uz7TLKib4IJQZ9am0pEjsvdkV9Rwc6UA6QWDr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o4bKV7Pm3BBC6ZlI8vOiDcGMX2uvOxLXlTRpn0s29Is8FnSzfbvrn/J0wrC5BBBlmxoDnGeiz0iZfELw0MP8GIHVgPaUUM+eUAgGWrr4ZqbMy5t0zaV29HZLse+JfcmxV69wMRQQc3t+8lApsgkWODRcPIhmdzfQm6woi1BBbzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F7NLZNy8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F7NLZNy8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3119C4CEEB;
	Mon, 18 Aug 2025 12:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521440;
	bh=wufA9uz7TLKib4IJQZ9am0pEjsvdkV9Rwc6UA6QWDr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F7NLZNy8siqqeIY1AImNCCNJD492AzPzeFtF2eic6OuW/iNTNm0x5YLK9NLP1xU4H
	 hEKuh9k45Ni+DwgS0oiS3wTvm6llkiwALjBRqaNmmb6yAxOfCGK360SVBwP2o/xXEo
	 n5vcr0Hgi5yu0IZi40IRpkNzJtUWKmauS/5rvjGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangbo Lu <yangbo.lu@nxp.com>,
	Johan Hovold <johan@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 021/444] net: dpaa: fix device leak when querying time stamp info
Date: Mon, 18 Aug 2025 14:40:47 +0200
Message-ID: <20250818124449.711212081@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 3fa840230f534385b34a4f39c8dd313fbe723f05 upstream.

Make sure to drop the reference to the ptp device taken by
of_find_device_by_node() when querying the time stamping capabilities.

Note that holding a reference to the ptp device does not prevent its
driver data from going away.

Fixes: 17ae0b0ee9db ("dpaa_eth: add the get_ts_info interface for ethtool")
Cc: stable@vger.kernel.org	# 4.19
Cc: Yangbo Lu <yangbo.lu@nxp.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250725171213.880-2-johan@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
@@ -415,8 +415,10 @@ static int dpaa_get_ts_info(struct net_d
 		of_node_put(ptp_node);
 	}
 
-	if (ptp_dev)
+	if (ptp_dev) {
 		ptp = platform_get_drvdata(ptp_dev);
+		put_device(&ptp_dev->dev);
+	}
 
 	if (ptp)
 		info->phc_index = ptp->phc_index;


