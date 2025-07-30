Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55491270ED4;
	Wed, 30 Jul 2025 09:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868270; cv=none; b=ts1iYT4dYqJT5KCEiMlQGqN+H2Rv+zHjWbyuqEZ4n65Gs0VUn0Y1hQoIzkSxjs22Ba0WKPR6yHFV06r/5VZlqvcqRw79WuSYrfgegKy+51d75T2MZk/r95FGgB9VsN8Pk3QmUIdHRurn9NyMhI7XQ8U0yt3POSDLg2DVLOLRQFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868270; c=relaxed/simple;
	bh=8lXJGS5GWmSRo18oD3KmVA4JrwFOAONqXGQE0U3qXvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pVchb+/gKW+dd4bMLNqsrFMEMtoDcYAnS1ik7SHselPnz4q5lbyJ5C7ySgM6JNnKFwPS/x6msqljEiY6WwRAxu22HTZKcg5CReTN63IK2kKjctUsfIkt7wNPglrc+wuZA5NtW6JL9E3A5Ce7ZqTCv5zQdr5quPRFVqR7bD9kUJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CUQ5SIai; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CUQ5SIai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D96C4CEE7;
	Wed, 30 Jul 2025 09:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868270;
	bh=8lXJGS5GWmSRo18oD3KmVA4JrwFOAONqXGQE0U3qXvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CUQ5SIaigCEawCSB3spIhQMyu2/K+zkq5uZeEfSMecq8sksepI5UsXd/84WG+C2dn
	 SVIe1ilQ2HT/a8/ytuOpBKcfZpkZD31FsIHbTvP54Cel3xuXpE6wG/UoqwmiophAN3
	 FVqVDQSb5gA6W0FclWbbm9H5vuQnvpVL3SQOh+P0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 20/76] can: dev: can_restart(): move debug message and stats after successful restart
Date: Wed, 30 Jul 2025 11:35:13 +0200
Message-ID: <20250730093227.632657131@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
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

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit f0e0c809c0be05fe865b9ac128ef3ee35c276021 ]

Move the debug message "restarted" and the CAN restart stats_after_
the successful restart of the CAN device, because the restart may
fail.

While there update the error message from printing the error number to
printing symbolic error names.

Link: https://lore.kernel.org/all/20231005-can-dev-fix-can-restart-v2-4-91b5c1fd922c@pengutronix.de
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
[mkl: mention stats in subject and description, too]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Stable-dep-of: c1f3f9797c1f ("can: netlink: can_changelink(): fix NULL pointer deref of struct can_priv::do_set_mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/dev/dev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/dev/dev.c b/drivers/net/can/dev/dev.c
index 6c1ceb8ce6c4b..88f345966c991 100644
--- a/drivers/net/can/dev/dev.c
+++ b/drivers/net/can/dev/dev.c
@@ -147,15 +147,15 @@ static void can_restart(struct net_device *dev)
 		netif_rx(skb);
 	}
 
-	netdev_dbg(dev, "restarted\n");
-	priv->can_stats.restarts++;
-
 	/* Now restart the device */
 	netif_carrier_on(dev);
 	err = priv->do_set_mode(dev, CAN_MODE_START);
 	if (err) {
-		netdev_err(dev, "Error %d during restart", err);
+		netdev_err(dev, "Restart failed, error %pe\n", ERR_PTR(err));
 		netif_carrier_off(dev);
+	} else {
+		netdev_dbg(dev, "Restarted\n");
+		priv->can_stats.restarts++;
 	}
 }
 
-- 
2.39.5



