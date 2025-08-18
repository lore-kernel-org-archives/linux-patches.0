Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E4131770C;
	Mon, 18 Aug 2025 12:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521425; cv=none; b=TQDGLHbDq0dCcWWEpwqUz47qLXmP+I44Fp7gsB22JAUTWYmCuLgtpT+1/GUGiEJTdV94v8COxEB7OxH3xXEG7kspgwajmhsyjMPA/JYOF7lELt+XYaQO7CkFY8QEWxIyfO0Cz6x1GGGJwgM4r3wZ3eTY1E6vnA0lcobH/jbUZEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521425; c=relaxed/simple;
	bh=qqANDpMXvlhCzgwUpsnJp/+kCP9fHqz+wrBBzcAlUgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qj3h3dZkHi+b0I3I9K8v5qUMeuLyEXXm4Cl9kCLP3GUt/5wxW6Lfg+ayY9lCb/d2VD9fxlJ8k+oodx3y/1H3vx8kgkgoM9LQeHbBnV2qn4A4B00+CkkLl3ixkSIqrTxJWKoCU822LeQnpnNmQyYdQyc/Tg9yygYHWao2YY8zw0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kXVJDZ1g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kXVJDZ1g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA49DC4CEEB;
	Mon, 18 Aug 2025 12:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521425;
	bh=qqANDpMXvlhCzgwUpsnJp/+kCP9fHqz+wrBBzcAlUgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kXVJDZ1g995j1sGWsoFyvS48ITb5fwcsNL8icc9C0bLX2WMLREi2qK++2MMTQ7rIx
	 XevAKC6ujprAh8tLfsxR0TZGK+FRYpWRU8BHiZ92oiCQetwGqGVqZyey5QtLyIizX7
	 5M/bivSqvCqeKpTzhTGnUCXlgYescHjGRBdMi0gY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangbo Lu <yangbo.lu@nxp.com>,
	Johan Hovold <johan@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 017/444] net: gianfar: fix device leak when querying time stamp info
Date: Mon, 18 Aug 2025 14:40:43 +0200
Message-ID: <20250818124449.547061153@linuxfoundation.org>
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
@@ -1464,8 +1464,10 @@ static int gfar_get_ts_info(struct net_d
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


