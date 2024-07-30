Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288F31898EB;
	Tue, 30 Jul 2024 16:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358336; cv=none; b=iGHcTt688SvWLTDtCBv64pq4yiQGHuV51P2VvC7COs7oQ7FxlhS713Ckhr89GXIoWj8DFE21p3dqO7Jj9vQ7j5COluyGZbgQ9pCtJt6NWFwrPPrySvBHe1eo2S6E6kTMo2my+2mOHk+Xd4HCjtMY0OEHk+ABUAKXvqOar4eoFB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358336; c=relaxed/simple;
	bh=8irBEXBJcl3nr448p33z+2cIk7KFx7lCIxvtTPb60JY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JpqlIISS++//qtjpJ9WYIrn+sSxKkVNCg8lWMgN2ffQLmak4JoU0lxcBSpNDFdHZcnuQ7EydjDKhxt1rLELlGb/p59wl3LlbIQ28eLEM1UAuBiRotRORnNEtaOohvC/d2KYsc1t3QbpYRhIr/nsu87zvGYMDEqp9SwE4wZQmfDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EvugxLrp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EvugxLrp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB31DC32782;
	Tue, 30 Jul 2024 16:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358335;
	bh=8irBEXBJcl3nr448p33z+2cIk7KFx7lCIxvtTPb60JY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EvugxLrpXPx8GKlvvGB0c83HNy2Ou/vOMkoBd09225ITnUAHGS2G27UdBfQxHJxVA
	 xPjbPxuglpYQW4/enlwdH14M1GhdhNLSE7yD7GhfcSWynJ06eyew7YWgJB8bRfSiTt
	 ojOWheAv/GdwWKdx9RlFlx0q+zrraV9copjHUKRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyude Paul <lyude@redhat.com>,
	Harry Wentland <hwentlan@amd.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Daniel Vetter <daniel@ffwll.ch>,
	Wayne Lin <Wayne.Lin@amd.com>
Subject: [PATCH 6.1 360/440] drm/dp_mst: Fix all mstb marked as not probed after suspend/resume
Date: Tue, 30 Jul 2024 17:49:53 +0200
Message-ID: <20240730151629.876072220@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Wayne Lin <Wayne.Lin@amd.com>

commit d63d81094d208abb20fc444514b2d9ec2f4b7c4e upstream.

[Why]
After supend/resume, with topology unchanged, observe that
link_address_sent of all mstb are marked as false even the topology probing
is done without any error.

It is caused by wrongly also include "ret == 0" case as a probing failure
case.

[How]
Remove inappropriate checking conditions.

Cc: Lyude Paul <lyude@redhat.com>
Cc: Harry Wentland <hwentlan@amd.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Imre Deak <imre.deak@intel.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: stable@vger.kernel.org
Fixes: 37dfdc55ffeb ("drm/dp_mst: Cleanup drm_dp_send_link_address() a bit")
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240626084825.878565-2-Wayne.Lin@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/display/drm_dp_mst_topology.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
@@ -2923,7 +2923,7 @@ static int drm_dp_send_link_address(stru
 
 	/* FIXME: Actually do some real error handling here */
 	ret = drm_dp_mst_wait_tx_reply(mstb, txmsg);
-	if (ret <= 0) {
+	if (ret < 0) {
 		drm_err(mgr->dev, "Sending link address failed with %d\n", ret);
 		goto out;
 	}
@@ -2975,7 +2975,7 @@ static int drm_dp_send_link_address(stru
 	mutex_unlock(&mgr->lock);
 
 out:
-	if (ret <= 0)
+	if (ret < 0)
 		mstb->link_address_sent = false;
 	kfree(txmsg);
 	return ret < 0 ? ret : changed;


