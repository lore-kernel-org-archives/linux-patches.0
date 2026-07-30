Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD563E0091;
	Thu, 30 Jul 2026 15:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426256; cv=none; b=Ne837e6baAgBMng6ChJyi+RNCtk0TzuoFrMqYAC4bCrvvlmbq3EO/8Cc0dYSy7i74KlGgZeXCwBesVXQjQ2Vbwtmo6AFp9Ncf9gIshat3Uhq4ZqHiaxKVTp0lyul9khkZbf8McwJPdN2BjQdBP1zTb3p7qKqUF3CeZFTp6nAQCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426256; c=relaxed/simple;
	bh=4T299tVyutkLHzGURpCxPP4RMX7FNbkPVytI9nenA0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J2zBeiPCKfp7LJALG16BDxQpkENd6YDgN64eUoEgp9/DsVIxd780BsWEs8Dy76Onva17xlT6d8o0E274T8BKXorXMLAhTy3sqoqVMiKZ+FemJlPynjNKZZ1x/AnyD6mJMgpVSXLQgPYdjB7xLzvOE36eQ7e6LldSr28uvZWrK9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wq+8iHGm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wq+8iHGm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF9461F00A3A;
	Thu, 30 Jul 2026 15:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426255;
	bh=g01ctxu8Q0ysEwIuIZWSvKC1vWrc9TWF+eV9JakJYW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wq+8iHGm7N725+SOfz42hjTPQI1gI+m+vz4PfXzmPC4BlKUvBHewufUsvNStNcYTt
	 AM9jCmIDRNVeK8QqCSgKpTSEbJbtS+qMiI2fA636RT8HCD1NmHsvbP8JDVOZj/lIH4
	 tZ75ZX8eq/Y9UrP9/J2hJ+W9xjxQL4vx7rJhw87g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 328/602] media: stm32: dcmi: unregister notifier on probe failure
Date: Thu, 30 Jul 2026 16:12:00 +0200
Message-ID: <20260730141442.856424301@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

commit 084973ebd67b28f0945c5d45408f86c58b540110 upstream.

dcmi_graph_init() registers the async notifier before dcmi_probe() toggles
the reset line. If reset_control_assert() or reset_control_deassert()
fails afterwards, probe returns through err_cleanup and the driver core
will not call dcmi_remove().

Unregister the notifier before cleaning it up on that error path,
matching the successful remove path and the V4L2 async notifier lifetime
rules.

Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Fixes: d079f94c9046 ("media: platform: Switch to v4l2_async_notifier_add_subdev")
Cc: stable@vger.kernel.org
[hverkuil: added Fixes tag]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/st/stm32/stm32-dcmi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/platform/st/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/st/stm32/stm32-dcmi.c
@@ -2069,6 +2069,7 @@ static int dcmi_probe(struct platform_de
 	return 0;
 
 err_cleanup:
+	v4l2_async_nf_unregister(&dcmi->notifier);
 	v4l2_async_nf_cleanup(&dcmi->notifier);
 err_media_entity_cleanup:
 	media_entity_cleanup(&dcmi->vdev->entity);


