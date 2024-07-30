Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F056418454A;
	Tue, 30 Jul 2024 17:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359401; cv=none; b=ANqnlqQ1I4GKfgO+T4sYQVBblhxHcQ+k7KCptJWzDvSt6zr7GYYAXMw7kcpsMcw8ufl0FGv1V4HIwpelRsNbpe4Op1PMIshsmXRpl/PkkZa3hZLxoT4OsSmDr30nWOjlb5fIryRwJO75BkZZAJAmAeWVE6IqDfsjdoqz0htmROE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359401; c=relaxed/simple;
	bh=CHtNE4RR60e5r8/AFxwTukB99DyG/obKDZnwABGBk10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hgqJa5QUULtZyxmYpB29pctkR8hAvJcea5C2RBQdcCYsZWZUJJyiMNvt3oG5R4cNwgvkX/8ugFnkplCltu+UBozR5xHUqNkFGIpGvGNxnL1RSMny8P+j/7/KwIBK+mcUJUXxePQSoITCnaZ6fA+f5Jmu/MpLUGCnGDi6YA+2NPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i8w1/OuS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i8w1/OuS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F6F1C32782;
	Tue, 30 Jul 2024 17:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359400;
	bh=CHtNE4RR60e5r8/AFxwTukB99DyG/obKDZnwABGBk10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i8w1/OuSRidSfrD2t3oVCkT90roQee/ghpftzYSRY/W285kXtdbTNJByDmv4XIuou
	 GWAXnBDtpcst39XsztCtNxsGFLmkDbwVc2Ix4dSyqpy0aod2CEdZm0mpatdym9JlZa
	 f24vnSX1i4QaoU3HQGtj+bqqKDSH7rfhVZxVpIkU=
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
Subject: [PATCH 6.6 477/568] drm/dp_mst: Fix all mstb marked as not probed after suspend/resume
Date: Tue, 30 Jul 2024 17:49:44 +0200
Message-ID: <20240730151658.670674273@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


