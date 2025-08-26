Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C7F393DC0;
	Tue, 26 Aug 2025 13:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216119; cv=none; b=YdqdomlY0U1PZ2A7fCva1TFrZP+PDBIIkLxE+F3hPRyi+4Wkc7wGykpsRqkYxZ7uRO+FSqx1cYmFHbaY3MtxnrBGOP3RDdwQJnEMf7dXPSVzq/dr9ct/mCj8RJOB1F0GM6SMHVV6jcj9MIf/fBTds8AXQ1G8ZQfO0pCiur+aOOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216119; c=relaxed/simple;
	bh=zf8GMJKU2K3etJCcTbBRYRPd3PQW6P8mzG161Lvn+DE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d26LdSsq5mh+flrWOlZ24F164kr0WpziSqWFry816fYutmxiFLlmUmyOYdAwY4flzf/xCnaMms6GXSrCGaJk0O9x1/B7tZyJ3j7WF8CwIqyQx/KV8NomoNDpzEj5A9sGRwGFClSGDcoxuRWvn/fVXKavU87IeO3qx04Hi4TKJ1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jN+r4JVx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jN+r4JVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D01BC4CEF1;
	Tue, 26 Aug 2025 13:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216118;
	bh=zf8GMJKU2K3etJCcTbBRYRPd3PQW6P8mzG161Lvn+DE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jN+r4JVx51y+dpJ2MqGJpD2yYDMvM72OkYtzz09YpujA5qKem9qCxLKag3KgTuabp
	 XG/qp8wYhBhHVoXfiL3RoKWQFDMwql7k7U1LIxyg3+CBlbxfZbjuIP+8cL8vHoP8E5
	 rEOCzMb627iDxL3XjnNHEsip1if8V2TPUwVt483U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangbo Lu <yangbo.lu@nxp.com>,
	Johan Hovold <johan@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 264/644] net: dpaa: fix device leak when querying time stamp info
Date: Tue, 26 Aug 2025 13:05:55 +0200
Message-ID: <20250826110952.916771372@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


