Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68AAF1F7580;
	Mon, 23 Jun 2025 22:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716527; cv=none; b=PGoN8Ey/8GbfHhpUVWvrFq07KD6dsZNFgjXpy7JImGK66yVFM7wHhlPMe+DyqcrhgBkyiyP445EaVsAo9QaBRvo5aEpuPtVqa8HuG8ll5CA3YmkQGplZ1N5Wa9Zdq2Xk6DyM7IAdEUcxfjucIQxKa9uAMKsPa6VBmjRC74B0RYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716527; c=relaxed/simple;
	bh=pvY6GJnN71gHbPhpNMsdVDlEVpyfWiw8qxBQr3LCdEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hqflscHXRMPRRrq/iLCazV6nFwDbsQg0zneSKLlwIvbAffJV7QldJzb8W8FhguaFZJ9hQSzN1KevyLxrsx0Sl/h0FS8zoV+qzs+37Zru6McK98mc4JpjEl5uBOe3y+EGa3ZOifCf8TqyOiu6IAGvvatNsAef1SvW2OM0SdG/dP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ULXbYU/A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ULXbYU/A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0104CC4CEEA;
	Mon, 23 Jun 2025 22:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716527;
	bh=pvY6GJnN71gHbPhpNMsdVDlEVpyfWiw8qxBQr3LCdEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ULXbYU/Api2ChoNL7q/w+YExBZWmS52VvQfOWHsoSECsbyiRdMu1VwK5yxPvFNybv
	 5zfMwuBg6cMyi03hfqDFo4Bg110KmQ356P2k6iGi+u3CMz/pfUV3O5aqdtnR+nXdAx
	 +SHECR0ewlkRorxLHd73o9A2BF31/wQBf5Y3VUyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH 6.1 332/508] bus: fsl-mc: do not add a device-link for the UAPI used DPMCP device
Date: Mon, 23 Jun 2025 15:06:17 +0200
Message-ID: <20250623130653.497542905@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ioana Ciornei <ioana.ciornei@nxp.com>

commit dd7d8e012b23de158ca0188239c7a1f2a83b4484 upstream.

The fsl-mc bus associated to the root DPRC in a DPAA2 system exports a
device file for userspace access to the MC firmware. In case the DPRC's
local MC portal (DPMCP) is currently in use, a new DPMCP device is
allocated through the fsl_mc_portal_allocate() function.

In this case, the call to fsl_mc_portal_allocate() will fail with -EINVAL
when trying to add a device link between the root DPRC (consumer) and
the newly allocated DPMCP device (supplier). This is because the DPMCP
is a dependent of the DPRC device (the bus).

Fix this by not adding a device link in case the DPMCP is allocated for
the root DPRC's usage.

Fixes: afb77422819f ("bus: fsl-mc: automatically add a device_link on fsl_mc_[portal,object]_allocate")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250408105814.2837951-3-ioana.ciornei@nxp.com
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/fsl-mc/mc-io.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/drivers/bus/fsl-mc/mc-io.c
+++ b/drivers/bus/fsl-mc/mc-io.c
@@ -214,12 +214,19 @@ int __must_check fsl_mc_portal_allocate(
 	if (error < 0)
 		goto error_cleanup_resource;
 
-	dpmcp_dev->consumer_link = device_link_add(&mc_dev->dev,
-						   &dpmcp_dev->dev,
-						   DL_FLAG_AUTOREMOVE_CONSUMER);
-	if (!dpmcp_dev->consumer_link) {
-		error = -EINVAL;
-		goto error_cleanup_mc_io;
+	/* If the DPRC device itself tries to allocate a portal (usually for
+	 * UAPI interaction), don't add a device link between them since the
+	 * DPMCP device is an actual child device of the DPRC and a reverse
+	 * dependency is not allowed.
+	 */
+	if (mc_dev != mc_bus_dev) {
+		dpmcp_dev->consumer_link = device_link_add(&mc_dev->dev,
+							   &dpmcp_dev->dev,
+							   DL_FLAG_AUTOREMOVE_CONSUMER);
+		if (!dpmcp_dev->consumer_link) {
+			error = -EINVAL;
+			goto error_cleanup_mc_io;
+		}
 	}
 
 	*new_mc_io = mc_io;


