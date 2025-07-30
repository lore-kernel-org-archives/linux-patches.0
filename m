Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542B9635;
	Wed, 30 Jul 2025 09:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869202; cv=none; b=T4s0be0RF5/3vIN23w8+vIOm5j2HExSJw/B7r+RmmkOb8CWFKCwcveZ+BFPfkMZysBdWFqa+dqMQLNe4LhOjx/P8stMF6NhS4dnM8Uary5uWvoQ755Zj56byViGjgTB43On+pbRXeTAEfF9enQ1bsOHeACgUOKOvT9BqOePIeuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869202; c=relaxed/simple;
	bh=OiVWgjyO4kSXUOZmcc8dvKtbp9fdQYp8gwFzuY+CIsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CtRpBxgClFMuX0Xsu/XAQFigqo161kjef4sYBUd0L2Qfm0QsOOzn2AhSh/ss+iYDZg4inE0L8JtJqtPK6lqqT3spDR7wRjoGEmcF8T3x/lnK9Yh3YY5xw4rYhCwriI+qBHgPsRGbvw8pQu+9yMVjEoO3QLXSHMPzfGRQW6gfjYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sn/8+kWw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sn/8+kWw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C22BC4CEF8;
	Wed, 30 Jul 2025 09:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869202;
	bh=OiVWgjyO4kSXUOZmcc8dvKtbp9fdQYp8gwFzuY+CIsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sn/8+kWwjoHKcaUsSwPA23DxBazqmYmHDyuQ1IZh6R96fkDpXpQu+1bf+YIkY7tz2
	 EfgSXXYI+D7zsloiyTqS/GNOzB6gUyaZQgLJS4V2iwx+XxSOY1dHAS+ecAJ8tnzbqZ
	 9/MlTePsNInXTw42vE03Ko+rx54brqeHzXXsYSD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.15 59/92] bus: fsl-mc: Fix potential double device reference in fsl_mc_get_endpoint()
Date: Wed, 30 Jul 2025 11:36:07 +0200
Message-ID: <20250730093233.040831501@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit bddbe13d36a02d5097b99cf02354d5752ad1ac60 upstream.

The fsl_mc_get_endpoint() function may call fsl_mc_device_lookup()
twice, which would increment the device's reference count twice if
both lookups find a device. This could lead to a reference count leak.

Found by code review.

Cc: stable@vger.kernel.org
Fixes: 1ac210d128ef ("bus: fsl-mc: add the fsl_mc_get_endpoint function")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Tested-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Fixes: 8567494cebe5 ("bus: fsl-mc: rescan devices if endpoint not found")
Link: https://patch.msgid.link/20250717022309.3339976-1-make24@iscas.ac.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/fsl-mc/fsl-mc-bus.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/drivers/bus/fsl-mc/fsl-mc-bus.c
+++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
@@ -943,6 +943,7 @@ struct fsl_mc_device *fsl_mc_get_endpoin
 	struct fsl_mc_obj_desc endpoint_desc = {{ 0 }};
 	struct dprc_endpoint endpoint1 = {{ 0 }};
 	struct dprc_endpoint endpoint2 = {{ 0 }};
+	struct fsl_mc_bus *mc_bus;
 	int state, err;
 
 	mc_bus_dev = to_fsl_mc_device(mc_dev->dev.parent);
@@ -966,6 +967,8 @@ struct fsl_mc_device *fsl_mc_get_endpoin
 	strcpy(endpoint_desc.type, endpoint2.type);
 	endpoint_desc.id = endpoint2.id;
 	endpoint = fsl_mc_device_lookup(&endpoint_desc, mc_bus_dev);
+	if (endpoint)
+		return endpoint;
 
 	/*
 	 * We know that the device has an endpoint because we verified by
@@ -973,17 +976,13 @@ struct fsl_mc_device *fsl_mc_get_endpoin
 	 * yet discovered by the fsl-mc bus, thus the lookup returned NULL.
 	 * Force a rescan of the devices in this container and retry the lookup.
 	 */
-	if (!endpoint) {
-		struct fsl_mc_bus *mc_bus = to_fsl_mc_bus(mc_bus_dev);
-
-		if (mutex_trylock(&mc_bus->scan_mutex)) {
-			err = dprc_scan_objects(mc_bus_dev, true);
-			mutex_unlock(&mc_bus->scan_mutex);
-		}
-
-		if (err < 0)
-			return ERR_PTR(err);
+	mc_bus = to_fsl_mc_bus(mc_bus_dev);
+	if (mutex_trylock(&mc_bus->scan_mutex)) {
+		err = dprc_scan_objects(mc_bus_dev, true);
+		mutex_unlock(&mc_bus->scan_mutex);
 	}
+	if (err < 0)
+		return ERR_PTR(err);
 
 	endpoint = fsl_mc_device_lookup(&endpoint_desc, mc_bus_dev);
 	/*


