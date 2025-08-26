Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4CE28314A;
	Tue, 26 Aug 2025 14:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217585; cv=none; b=hFxYqs+IG/Mk+8jhf4isADRMSPd6SERX0OAFJWOjhEXZM3wYSvDD8Ajp6VVUcmyPM/Yj9NR+lmCloKrxN/uoFX7Df4ZuuQdFTEluPQwRncO+Qwm7sR23W5A23Dy6teXneogBNY8rSj2Wg1M9vAIjyjrPPMAUXTc5hdCGJAU6Rj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217585; c=relaxed/simple;
	bh=V3G/Ute5O6SyM5dYBaPuM48/uAuVcQSzuetXxwr32ps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nI/n1/47iUTkp7Lm+r9HQ8yiDwtfV87tkHMxCqCwD7o+172U7o6lvcHyHebJPDiypJe/vyMfM33CdyFwfRY5oW5sxpWE3rNZDEr3W7QKLkrjZFQpm9d0pEENHVvuNpX97pvm+qDWXB00rHvnEIKWk+3Z26bgQ77nN8VAFHc1HgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PnHEJ1nF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PnHEJ1nF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19C94C116D0;
	Tue, 26 Aug 2025 14:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217585;
	bh=V3G/Ute5O6SyM5dYBaPuM48/uAuVcQSzuetXxwr32ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PnHEJ1nFCVGv00J1pHClmehs+KMIrWlYnikRsRIXdNObgGYQvayxy9jAei8t7Ahbk
	 WM4PwrOY6mHq503Sc6C7U3qG11NpjORKgdu4ArkcRzpSNkzDiRc7cvMY6hxkd5n343
	 Lg+JyJE6E1Omo+uxsDdKzpPWQ4qAwOS7+RhKq4vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangbo Lu <yangbo.lu@nxp.com>,
	Johan Hovold <johan@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 197/523] net: dpaa: fix device leak when querying time stamp info
Date: Tue, 26 Aug 2025 13:06:47 +0200
Message-ID: <20250826110929.306877094@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -499,8 +499,10 @@ static int dpaa_get_ts_info(struct net_d
 		of_node_put(ptp_node);
 	}
 
-	if (ptp_dev)
+	if (ptp_dev) {
 		ptp = platform_get_drvdata(ptp_dev);
+		put_device(&ptp_dev->dev);
+	}
 
 	if (ptp)
 		info->phc_index = ptp->phc_index;


