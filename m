Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BABD3330317;
	Fri, 17 Oct 2025 15:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713661; cv=none; b=JI7XqxvRHY1Z1b1yPDCRommQXPe9dewvgEfj7BvNEcUWSjDLKxA1+yLYB2iY6hwaOSceR/9xafO131Sl6EgWy5bCZDPtLBf8sD2fHhuJw6hHGtQnWfWcWzIRg2nLsS3TKT8g2jBDMwmOXkbdjQyDdDEChFS2CiCwVBegAq7qZOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713661; c=relaxed/simple;
	bh=2kSCpRgnPd1Q1DAdVOTEuLnriZYmpNBhlsBibo3Wrkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M16Hoq40DDG5h6rxG7EomWGZls/u1MHzejs7T8kv5r8x/gwATIlAQMWne6lNYDvemYVUDDIK3t4R6/+6I0tGfxleOAEK2inOb9Dhg29wwOgl3hDj9zdTwOOWk9d6Pb8IC2g0zMZC7bSdjPrqExdxbdabKOwv7omhkffN57G4pLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c9f8nYj6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c9f8nYj6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48425C4CEE7;
	Fri, 17 Oct 2025 15:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713661;
	bh=2kSCpRgnPd1Q1DAdVOTEuLnriZYmpNBhlsBibo3Wrkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c9f8nYj6lLlcwCv+p6GEWmXTVe9QFWjAuEozY1gGzGGGnrjSm1IKtA0BZ9wymetdK
	 glYcsyiIoeB5UFhkH5Oaa+LZ+kvBmRbpWHkn3B9RERUbGtsfJs4rHC/wXmYvwYFzct
	 u6+bM10DZz1hSTYSxO526TzyOFgyExw5N5vwKz7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Martin=20Kepplinger-Novakovi=C4=87?= <martink@posteo.de>,
	Maud Spierings <maudspierings@gocontroll.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 074/201] media: mc: Fix MUST_CONNECT handling for pads with no links
Date: Fri, 17 Oct 2025 16:52:15 +0200
Message-ID: <20251017145137.474819582@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

commit eec81250219a209b863f11d02128ec1dd8e20877 upstream.

Commit b3decc5ce7d7 ("media: mc: Expand MUST_CONNECT flag to always
require an enabled link") expanded the meaning of the MUST_CONNECT flag
to require an enabled link in all cases. To do so, the link exploration
code was expanded to cover unconnected pads, in order to reject those
that have the MUST_CONNECT flag set. The implementation was however
incorrect, ignoring unconnected pads instead of ignoring connected pads.
Fix it.

Reported-by: Martin Kepplinger-Novaković <martink@posteo.de>
Closes: https://lore.kernel.org/linux-media/20250205172957.182362-1-martink@posteo.de
Reported-by: Maud Spierings <maudspierings@gocontroll.com>
Closes: https://lore.kernel.org/linux-media/20250818-imx8_isi-v1-1-e9cfe994c435@gocontroll.com
Fixes: b3decc5ce7d7 ("media: mc: Expand MUST_CONNECT flag to always require an enabled link")
Cc: stable@vger.kernel.org # 6.1
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Tested-by: Maud Spierings <maudspierings@gocontroll.com>
Tested-by: Martin Kepplinger-Novaković <martink@posteo.de>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/mc/mc-entity.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/mc/mc-entity.c
+++ b/drivers/media/mc/mc-entity.c
@@ -678,7 +678,7 @@ done:
 		 * (already discovered through iterating over links) and pads
 		 * not internally connected.
 		 */
-		if (origin == local || !local->num_links ||
+		if (origin == local || local->num_links ||
 		    !media_entity_has_pad_interdep(origin->entity, origin->index,
 						   local->index))
 			continue;


