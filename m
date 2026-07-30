Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C27443A92;
	Thu, 30 Jul 2026 16:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427688; cv=none; b=dyz/rRAN50Sx3gHVd+19IKbJgaNnZJ24yrbvmjb6ftJcqDOPZ1ksneVkberu4n5QqdWfH2r6vibgGJZ0dmGOt1477dG5U1FKPW3G8QGDPHyvinIbDMZIvMiXEnBr7P+DJrnngFk9pV3dU3y1PnTmNdYs4mmCQQJPAY1WIqKmVQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427688; c=relaxed/simple;
	bh=lm9UBkixYia5Bv6Sz+GQMKnfHBBibZzXjepKVVdAIZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sCrqWrnkX6C3Cknnv6SdM9YW+rc8q8s8rM52n1CRoan5jtYtEcExkCoadiU2qZJfnUTzR3mji2LFKg62RYNZQRaULQlpVG5sz+gaElhavDSZXSipIEj2ZezWpRv3oSjE1W1AWFl55YQvJ9GQg2pnRgkgymfj7cyLcc/q5aUuBFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J9Oka9va; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J9Oka9va"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D315D1F000E9;
	Thu, 30 Jul 2026 16:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427687;
	bh=+kDvt4Q6dH769iqgcjMXR7UZ6p5tOSw6u/jpdaBK8WM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J9Oka9vac4jYkmfgXxtcoQT6+ssEPIPVfcN8dJh5pumnJ402Urg8qHuNNcKUYHlPj
	 o/GsQTxEWvKsfTeTCfbPFhC25GPvPFxOUCVYSQz1PvumXvEzq9pIzFY9wmP27k6fnC
	 kV1RGjGOSlOIlP9mPJiGWam1kXPgllJfw92UosBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 257/484] media: stm32: dcmi: unregister notifier on probe failure
Date: Thu, 30 Jul 2026 16:12:34 +0200
Message-ID: <20260730141429.071972536@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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
@@ -2077,6 +2077,7 @@ static int dcmi_probe(struct platform_de
 	return 0;
 
 err_cleanup:
+	v4l2_async_nf_unregister(&dcmi->notifier);
 	v4l2_async_nf_cleanup(&dcmi->notifier);
 err_media_entity_cleanup:
 	media_entity_cleanup(&dcmi->vdev->entity);


