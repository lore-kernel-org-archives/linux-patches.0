Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873A03914ED;
	Thu, 30 Jul 2026 14:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422666; cv=none; b=D44TXu+RMwU9d9B9qwfpu5EkKfWM9sh3jJ1GIhPqjhNTDuBMZkK8QVe84m9Mf2R8Sv3TVBzmgY9DfKJ/Cefb/F3ByRCYe7TFqHInPsBu9Ok/BeS5n9mkeP2BKI8+xMJfBLe3EN+zHdXUSHkN32FCt7uy053G8kgmu8I7d0xRF9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422666; c=relaxed/simple;
	bh=oNIsU+RnkQ4C7krxbT0n+9fujECRE8QFQ+EJz5R5+UM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mbC1iE9oCpQpDY7AisfdQRi2/W7a9LrsQVlYRtQuR+RpRv37rQZk+un6kdjvs57JpQuMZtT9EOkeWYUXJsPFjwgXthIf+1h3wHUIFMpI7g4F/nQf4KadnUKS5VwsIViXq6nGAURjB0qBUf+zhjFk+MiPOisTNJRh/3h3wDV8/vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ulbRzXmu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ulbRzXmu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D1A1F000E9;
	Thu, 30 Jul 2026 14:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422665;
	bh=GDvZ6AwUv8/nIDrtcLwdpa2nymi91g+EUgXyEJSOk8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ulbRzXmuYs1k1eNfOod0H2p86GGCOvWGkg4NR+BwXsc18wHE1J7N4OalISkPCkQcX
	 GDPV5EtE9TQbh9p80cMv6yNgvC0K4iDRwqUCxE/103baCjZj3kdSnqPeFYR1sLX8tu
	 Z2+xUvk3Mf8cjiD65w2eSBvlpIr9tiHXEdWhC5qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.1 517/744] media: stm32: dcmi: unregister notifier on probe failure
Date: Thu, 30 Jul 2026 16:13:10 +0200
Message-ID: <20260730141455.267385627@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2195,6 +2195,7 @@ static int dcmi_probe(struct platform_de
 	return 0;
 
 err_cleanup:
+	v4l2_async_nf_unregister(&dcmi->notifier);
 	v4l2_async_nf_cleanup(&dcmi->notifier);
 err_media_entity_cleanup:
 	media_entity_cleanup(&dcmi->vdev->entity);


