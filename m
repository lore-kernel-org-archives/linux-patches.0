Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B7139060A;
	Thu, 30 Jul 2026 16:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427580; cv=none; b=SDPHSjkAzKBQ7cMbDL4DPG7YShhZiQLAQ/yRvvs3olAHr6i/VQLEv5i2jzAqKZUNzazWzk7eg8i40eDzX8O8DlzhXAesW9A+MNNyrELzh7Us3Xu7opVyAPIh35Fy8tw8LXZ8Odl9Fb/VUgycr38ryETRYTKyTX933/NKxJ1foeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427580; c=relaxed/simple;
	bh=a0TpuGClg7+Ts3QWg1De2EBZFO3cMLpSdI9cxmaDg38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E0PR/SJFawcqWpHF57e4oFjmndJvEo0tirfzIvzhs78egTl83u+qi8QaoPr+TFR6bFOdu7AVAVWxq+Zg2byXrfS4hggOLGVfdd9PKESo2nbE4PRGFgt2/sLytJV6wTGUcPb3LjIHRyl9HX8ak/TfwPvctu/Xds6+/1L1FIuHvD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DBSP6G4R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DBSP6G4R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93DEE1F000E9;
	Thu, 30 Jul 2026 16:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427579;
	bh=YL7quch1hzahQdzPpKoly+bAhBh5o/9N9Fk+YEvmZcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DBSP6G4RX/ujSLwGCdngkNIvet8yJ1+gEfmx48j6W6spmmNdMlP+jehFhT7kDQnNH
	 46DWj6etgsRtcSpFC8G2Dvnh0DLsBl8s2yiaJTFtKXUR1fOh0avCFeeTJ+RF6fjGDK
	 Fn9BNd4ZH6MAtJ9urSqJBQPqFYOrNHEbxAyoyZbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Francis <David.Francis@amd.com>,
	David Yat Sin <david.yatsin@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 218/484] drm/amdkfd: Check bounds in allocate_event_notification_slot
Date: Thu, 30 Jul 2026 16:11:55 +0200
Message-ID: <20260730141428.208497505@linuxfoundation.org>
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
@@ -106,6 +106,9 @@ static int allocate_event_notification_s
 	}
 
 	if (restore_id) {
+		if (*restore_id >= KFD_SIGNAL_EVENT_LIMIT)
+			return -EINVAL;
+
 		id = idr_alloc(&p->event_idr, ev, *restore_id, *restore_id + 1,
 				GFP_KERNEL);
 	} else {


