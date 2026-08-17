Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59581445AC1;
	Mon, 17 Aug 2026 15:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979379; cv=none; b=qKxkRLwWa0F1oMtuVfihUcqAVSk7Ah+rsNB67zBARFx5rgZIdxk53Kne/UGnm/V4ZY6G+m183+piHba+uqBr6KXGf/5sKt13aaiE+d2pd22RxrmMpRn3zibXlVAXDF5tkRUSLpDegUxOxwliYzJ+EnhtMDXTb8fCzviX1/yPAYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979379; c=relaxed/simple;
	bh=pkeuEmxEQE7nkJEejj32cFXLRI9KGIzq5QIXgG8RZKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V86cYN6s7CZc4aiUMPQGSGB+o0VRzKWslngMfcvSpZ2UVGwJJDknyuzlcqIdmh66yOHHpv8ccwXaZG7l4i5fjRi7TYXElIi1UKrqrvcORQQydvZyJlQ9b1MkAe3OIrs84RPOUsMfpjQ4/oCQ8nWgeMLa2KF5uLMeb9AKGCxo9ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nxso99eY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nxso99eY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 831241F00A3A;
	Mon, 17 Aug 2026 15:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979378;
	bh=mwgLXErljFqBdjOAvzv+QxFUPeDbpbtB2ne/AXVjLnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nxso99eYiyhQcEsUJ6w4mdrRMWlemiGwhnqqLhTmXLP93/fp+nknRy8AyS47TO/Ui
	 I5e6wPRCxsm74k7s5+uAinUurb4VSJVx7MLBvAhSftJ9RXZme7HtpS//7Zw0j/nngH
	 LkBOR3TkcHzybRwCPmVIVeS17bj10NA6nlhM07O0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 206/609] media: stm32: dcmi: unregister notifier on probe failure
Date: Mon, 17 Aug 2026 15:28:22 +0200
Message-ID: <20260817132550.992975026@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2122,6 +2122,7 @@ static int dcmi_probe(struct platform_de
 	return 0;
 
 err_cleanup:
+	v4l2_async_nf_unregister(&dcmi->notifier);
 	v4l2_async_nf_cleanup(&dcmi->notifier);
 err_media_entity_cleanup:
 	media_entity_cleanup(&dcmi->vdev->entity);


