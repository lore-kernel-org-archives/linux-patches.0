Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E720A43F0B4;
	Thu, 30 Jul 2026 15:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424330; cv=none; b=e4pq8T7b4H1s/ROs3Q+DRCtj6XGQJha2ZKdZwmxgwM0na5JM0Lc1eHPK6n7ekuIefIorCJSV3Gxt6bb8aGaIKsj5r5eG9an+ViZXjDRmjeeZT5oi0tBEpWq0nl2Ww8UL+WY4waUebUFn6Pr6BB+CrKuAZZuy3IIk7qmjseQUUrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424330; c=relaxed/simple;
	bh=QGIPTQH+uHuhkyTtgclalksO8YagYW8VWp/9SQBsLzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mRPKDv6XxoG9W9mXUrkzEAqKqhXgt1InIYzcHR9BhU89LW53Q5SHkfIvmGO+YyWuTdW7ytYoYg2FGmOdmS2+zIwgC2GkkKUR4026KDoW2o2wcohZ9Xm8Om+30TFUw8AKs4Jfm4EaQvzhxKYdeIbfCqvSgBAErpV6AnfD7HgtOmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1moUX9HB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1moUX9HB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 399421F000E9;
	Thu, 30 Jul 2026 15:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424327;
	bh=hbDcEbMaT84y/rs6IcHu1rau2QzzW0IHcemQ4Tf6bgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1moUX9HBSRwwP32YI0SRjziQXRhbaNWAAosa/dXt0MxPWihXRpG5S4WkRaceZGv04
	 dfjOugj8wrGBRQdLAJpjk+s4JePFcayYc+SX+896roYm1eU583/aQJwlexp5gy2EBv
	 SDZpNjsa8DRojvbThCF43lzD3XhLETWBG3mx/mYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Francis <David.Francis@amd.com>,
	David Yat Sin <david.yatsin@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 353/675] drm/amdkfd: Check bounds in allocate_event_notification_slot
Date: Thu, 30 Jul 2026 16:11:23 +0200
Message-ID: <20260730141452.637039334@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Francis <David.Francis@amd.com>

commit bb52249fbbe948875155ccd45cd8d74bf4ae747b upstream.

The valid event ids go from 0 to KFD_SIGNAL_EVENT_LIMIT

allocate_event_notification_slot has an option to specify
an event id to allocate at, used by CRIU. We weren't checking
the bounds on that value.

Check them.

v2: Lower bounds check is unecessary because of idr_alloc
already rejecting negative numbers. Upper bounds check should
be KFD_SIGNAL_EVENT_LIMIT since the signal mode mappings might
not yet exist

Signed-off-by: David Francis <David.Francis@amd.com>
Reviewed-by: David Yat Sin <david.yatsin@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 6853f1f6cbbeb3f53ebbbd7286536aeb2c5d5f50)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_events.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_events.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
@@ -107,6 +107,9 @@ static int allocate_event_notification_s
 	}
 
 	if (restore_id) {
+		if (*restore_id >= KFD_SIGNAL_EVENT_LIMIT)
+			return -EINVAL;
+
 		id = idr_alloc(&p->event_idr, ev, *restore_id, *restore_id + 1,
 				GFP_KERNEL);
 	} else {


