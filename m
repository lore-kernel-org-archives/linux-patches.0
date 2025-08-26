Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4920450FE;
	Tue, 26 Aug 2025 12:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212557; cv=none; b=ddWdVdahJzkQfAdKvy+DDMbKGm8zXU6VR96bCv7mAWtE1x8oLJe8Cm1GS1bqjpJD2kwFuD+4P93s52geWlNEaTEoUE1P6qp4t5Aogska0odh+iuhxNGDxZ6uGVWS1IiB68MN3gKFIsn056dhcvQVcLuyq990Kb/54Hnjwlu4/Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212557; c=relaxed/simple;
	bh=66vVV6fsN3WzX4B23ScKCvEFSwSnorFjvwkWyJ7tm9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jQ4b/ejh9OkPKpEHfQIzAx1au5KdWvlZJnSVy5FTcqt/B9lI1r2e3Qew7dg64pMNGuJ3QCwrK3uZqDJkOMZh3mhqtp4W2KWybvnt7gUFUW6w0IeOy+HvxsJcw5rRaDrShJqVu4cO6OaO78vEVtEYPViK5x/8j4c9nwJXGSs1XDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=edSXWJna; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="edSXWJna"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2067C4CEF1;
	Tue, 26 Aug 2025 12:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212556;
	bh=66vVV6fsN3WzX4B23ScKCvEFSwSnorFjvwkWyJ7tm9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=edSXWJnaoAvIT3J+qm+9Bmw3h6Kh/fYKjpECyMsT6iUg+X1uwZQ9OnGGD+n6A4hYe
	 IdSbGnXNhM6I1yqDJKzM0lTt7g4E1Onl09t14xxgQe7zFOXg1mk2WzMMlQ+AALrdrg
	 G4NQo/vgzprSK8AxPgzsOgdnChiWqzFOMeaQcka8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangbo Lu <yangbo.lu@nxp.com>,
	Johan Hovold <johan@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 015/587] net: gianfar: fix device leak when querying time stamp info
Date: Tue, 26 Aug 2025 13:02:44 +0200
Message-ID: <20250826110953.338734235@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit da717540acd34e5056e3fa35791d50f6b3303f55 upstream.

Make sure to drop the reference to the ptp device taken by
of_find_device_by_node() when querying the time stamping capabilities.

Note that holding a reference to the ptp device does not prevent its
driver data from going away.

Fixes: 7349a74ea75c ("net: ethernet: gianfar_ethtool: get phc index through drvdata")
Cc: stable@vger.kernel.org	# 4.18
Cc: Yangbo Lu <yangbo.lu@nxp.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250725171213.880-4-johan@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/gianfar_ethtool.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/freescale/gianfar_ethtool.c
+++ b/drivers/net/ethernet/freescale/gianfar_ethtool.c
@@ -1468,8 +1468,10 @@ static int gfar_get_ts_info(struct net_d
 	if (ptp_node) {
 		ptp_dev = of_find_device_by_node(ptp_node);
 		of_node_put(ptp_node);
-		if (ptp_dev)
+		if (ptp_dev) {
 			ptp = platform_get_drvdata(ptp_dev);
+			put_device(&ptp_dev->dev);
+		}
 	}
 
 	if (ptp)


