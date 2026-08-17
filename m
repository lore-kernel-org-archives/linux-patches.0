Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086762E8DEC;
	Mon, 17 Aug 2026 15:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979296; cv=none; b=Vb011qSP4/UPa43DDn6U+rIruHKMHYuBtyZZNG2fQQqp4Ko2DJUp1OdvG1Tqv725Du1fn/ZeEaPDyyNwr2kG5qLT1m3HeI/Lr+d+rm9RlCVjoUSP+ZH8XaMHQW31oGlu/wykyjiaDY97nyeQ+5OV+dGrZEGw3yxRxmGJWC9zgoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979296; c=relaxed/simple;
	bh=EeJG+E1nwii5fzBxvm11f2sA4AMMT3yaqakbxDpkCz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YOO7aOoO5DcxNx9zBAfyHk9N2LgIjBqChxnAstMl3IQkEXwmG132rw5zjhuZpgrK2PQBjSO8t3jg4vj4IVs5bM3n/v0FkJxlm6jhlUc38Nyx07H7y9An63TIXdksp+s5pNrWuHrx+i4AI/WyTjX73deONAgKjlb8a7gdXQ+bxqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JsMqt5F2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JsMqt5F2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B911F000E9;
	Mon, 17 Aug 2026 15:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979294;
	bh=RHougHfSvChFD5HX1ookkuYih7PRyEWTb9Pagpphqqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JsMqt5F2EhjHbXis4RzER8pNswsEZXUEwWW1sM5mQqDIkub/HFOqxoYFT1jxff9T7
	 sVqEc4kk66Ug4KGq3Qyjb4UGephJlOJOAKMH0Z1ApTk6yveCppX+5rOvCiSElOzeh1
	 CodCWPO6yCCOiS/IvSY14bpwmiPvP1miW2XUbhF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Francis <David.Francis@amd.com>,
	David Yat Sin <david.yatsin@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 176/609] drm/amdkfd: Check bounds in allocate_event_notification_slot
Date: Mon, 17 Aug 2026 15:27:52 +0200
Message-ID: <20260817132549.962209353@linuxfoundation.org>
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


