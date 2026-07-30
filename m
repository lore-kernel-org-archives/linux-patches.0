Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444B05C613;
	Thu, 30 Jul 2026 14:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422497; cv=none; b=fHlfad/Ws4NVQlDr70pIYFGrh2a+Q5JwLuX5MjlejbjnnzEbOOMryUik2lAL+V4MYp/Mqnx1wwmPtDkfUS2bdOSlfR4MjSmoH66ge9N8km+cu/SGjT1SensrTbXl6lkkpnYOZW0JqD9ueXDsd8Da97y4XKr0tcXZmtN7qAx4F1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422497; c=relaxed/simple;
	bh=rGhEuTxJ31t3Ii9Ze74Zc0QlgxQ5g16GWz1S1S+kuzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cHPTNYnw50xgdlQMxy2qAwFskSJbD36Ndcz4FLNy4GCK5ioZqF4IisX7nTXvUugz/H1GFDF7a3Y3e9B5xsZvKA9kOrDrwYJELswpxTJ7NMzIqqXJ450yo7Z5oHcHEs62kZRz0XxWQ3ZIBiv35aHKlCJfoA9GOTGcuyeQIdMJ0PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y/mLCJgT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y/mLCJgT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A158D1F000E9;
	Thu, 30 Jul 2026 14:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422496;
	bh=T+dMceZvDGYxZ3euTIDUAO4Mo85fGYcQZdpqHFNFkxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y/mLCJgTqX4Y6jdr3LINEWjqJ5DsWdr9RZpGIbspQl3if3/thI7PDoyGO5ftIosa/
	 fvloXyduqiVvzB0njs6e3LEx06glnD2nwBztF6BSSKui8ufCrXVRMqrsIUZ9LghOss
	 NFVmixcFDoJUN3YvBOix48OMYUSN0owitCfURAGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Francis <David.Francis@amd.com>,
	David Yat Sin <david.yatsin@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 414/744] drm/amdkfd: Check bounds in allocate_event_notification_slot
Date: Thu, 30 Jul 2026 16:11:27 +0200
Message-ID: <20260730141453.095470920@linuxfoundation.org>
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


