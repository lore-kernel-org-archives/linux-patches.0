Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C694D477E36;
	Tue, 16 Jun 2026 17:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630185; cv=none; b=NDt9bu2oDgcrOAMfjqT+1AlLgxiiXHZF1e8xR2aEU63V0tyJzAoQupOzZmc7rfkPD0S+fqeH3RFXOLG2vWCn/HjZyzceaCkoNUpSyHfNOZwGNcJHk7m1qfsgojU+6OF2Dq0IELYboSOqzeGucpIeomexyP/3kb0oRUrHt6bMu8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630185; c=relaxed/simple;
	bh=7982pmaxv8Z4BnZrUDozyo4hyg3GfgSjxu/c2j9P39c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DSJAphJY+qJU/Mz/kv2WjDz3/Yhhnk61Md/1+BMCWx1+s6AIqDelc6c1CywaiE2+P/UvweRbmfP3Q+T+eBoCSHh9n5+vTZcsfKK1jYZHAuaQT/kE5T4mVusLpVDzoZQz+37HNvhoq+ZzTcLHy39zcHcCQ7cG8X4J5V4FxUszLuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sk0/FWBj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sk0/FWBj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 465381F000E9;
	Tue, 16 Jun 2026 17:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630183;
	bh=X/Ut174tgBwX/MvemaN9PJaa6QfS9rs9BdNyv/vD01E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sk0/FWBjs7MgjsaIsQF9WkPe9hri1W9kmG2QmBuSnjhknG0VM/ZCGxjj5A7tg1Vw2
	 6TyAtEKhbGzOEQD7VhxDCVl688XbSp/JJ6mDbRqametdz4Rc7cZrB4UQ6wVpDw+foe
	 ipWYnHkGT6q8QXi/qXJ2Y5yUsymGakaSseMHHR2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>,
	Sasha Levin <sashal@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 6.6 426/452] usb: typec: ucsi: Dont update power_supply on power role change if not connected
Date: Tue, 16 Jun 2026 20:30:53 +0530
Message-ID: <20260616145139.075808989@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

From: Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>

[ Upstream commit d98d413ca65d0790a8f3695d0a5845538958ab84 ]

We only need to update the power_supply on power role change if the port
is connected, because otherwise the online status should be the same for
both cases.

Cc: stable <stable@kernel.org>
Fixes: 7616f006db07 ("usb: typec: ucsi: Update power_supply on power role change")
Signed-off-by: Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>
Reported-and-tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Link: https://patch.msgid.link/20260519-ucsi-fix-2-v1-2-6f1239535187@qtmlabs.xyz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ changed `UCSI_CONSTAT(con, CONNECTED)` accessor macro to `con->status.flags & UCSI_CONSTAT_CONNECTED` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -912,7 +912,12 @@ static void ucsi_handle_connector_change
 
 	if ((con->status.change & UCSI_CONSTAT_POWER_DIR_CHANGE) && role != prev_role) {
 		typec_set_pwr_role(con->port, role);
-		ucsi_port_psy_changed(con);
+
+		/* Some power_supply properties vary depending on the power direction when
+		 * connected
+		 */
+		if (con->status.flags & UCSI_CONSTAT_CONNECTED)
+			ucsi_port_psy_changed(con);
 
 		/* Complete pending power role swap */
 		if (!completion_done(&con->complete))


