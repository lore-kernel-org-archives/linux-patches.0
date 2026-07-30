Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D04F043B6EE;
	Thu, 30 Jul 2026 15:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426030; cv=none; b=djM1ZWAsQRrMZZIXfa1FUbqSsV7YRI9F4CkRzWmOAXTKAmISZWI6wf8Iz/KqBHffnEl+39U5BL6lgWFz8g99yrLh0kfJ/yVbk9epFtdw9n+p+EjPgVlX1gBpZ9LbMBSGyLjEZaoTMmV1uyncbEH2hhv/woMnDzMAtKOAzkc6Qco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426030; c=relaxed/simple;
	bh=EQjU35Hptb01+qJJIOc+LLO28XcsPTgoTB0iv/eMPa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DPJhh0CU+PUmzVW03OPwKJvB2pqFFpMrPkjyeUDCDkkjvdsl2E9kDxyIVCK3KIRZRYSpuY/0ViDwuPYv5uvdZnsABKOcsfq7F4e4FevlAPv6Wkq98R3+f9U6uq7+44/cZ9HJXXPnbAam4d7Pu5YcTRbKiweZ6EaCmsL3ajKyHeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gM9S0g4G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gM9S0g4G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03B5A1F000E9;
	Thu, 30 Jul 2026 15:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426029;
	bh=00eM5BLQry29H/F65ZVeB+XDEINpMCS9H3bOBpw0ZjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gM9S0g4GFsqH/m3yWrEoWpJxXladR0qXjyS8/DmjUqG5XrsyUWod8HYXm9tOE5bay
	 kA7PYOuCH8OoumXcb6b8z/eT+ch1nwJdQPgFdlfEL59XE/4OvbgT62IsD56fc2P/AN
	 o3v74WNnhe33qvN6efVbH9t1ON3MzmdecuQUuOxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Francis <David.Francis@amd.com>,
	David Yat Sin <david.yatsin@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 274/602] drm/amdkfd: Check bounds in allocate_event_notification_slot
Date: Thu, 30 Jul 2026 16:11:06 +0200
Message-ID: <20260730141441.728724871@linuxfoundation.org>
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


