Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B8247F53;
	Fri,  6 Dec 2024 14:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496407; cv=none; b=j323lg4zSCswGpqL1xSbeOyUrC8hdQJlKqDqZoyVbcDN98pVmTVjiqFpmBX9yCJciU5gL+zHvRRFrsf56pYUgJSNh0T1dLqXMxcmQqKA1/ZQbVYy3T/OXlTN8n8Vxu28J9RzHaoTU0NIbc1pcpUvhZ/OE4pvFePhPPwI0OwV9AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496407; c=relaxed/simple;
	bh=NK74DuAHtuNu4nNwICpBw6eOpEjGrGQ+9CU6am+/5Ik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AaxNT7lL+fxCzxLqFfHTb+OIKJWWGCFdfAYbdchjqDWuRAt3kZlf+7tcAPqq+Tb0jMbUGBdm4hEzNdtxI4mSxwx+wkiO7XzwsJpgWhDOav7dWbRzNFehfm/XKxj4iiqrBqh6ag+Bi16b3tvALdMs5pwLXh0jbtJD7Zq1fWIYius=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B3/3dB1F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B3/3dB1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D590EC4CED1;
	Fri,  6 Dec 2024 14:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496407;
	bh=NK74DuAHtuNu4nNwICpBw6eOpEjGrGQ+9CU6am+/5Ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B3/3dB1FTriM7YJCHtQ8lhRieZRlmuVb66zoxGpHQfU5BY3JJnFtweTXMqKNtmIdq
	 YLZQkanTY8MxrVtmUPMF7zO6pm7SXqNz3HwtlKWQf4eCbaZ0lbnSpFlX2tx8p7pbjH
	 gF2NEDhFpvXXMBO7f5YMUr3FP4FKlman3tHKPm8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josip Pavic <josip.pavic@amd.com>,
	Joshua Aberback <joshua.aberback@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 143/146] drm/amd/display: Fix handling of plane refcount
Date: Fri,  6 Dec 2024 15:37:54 +0100
Message-ID: <20241206143533.159349667@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Aberback <joshua.aberback@amd.com>

commit 27227a234c1487cb7a684615f0749c455218833a upstream.

[Why]
The mechanism to backup and restore plane states doesn't maintain
refcount, which can cause issues if the refcount of the plane changes
in between backup and restore operations, such as memory leaks if the
refcount was supposed to go down, or double frees / invalid memory
accesses if the refcount was supposed to go up.

[How]
Cache and re-apply current refcount when restoring plane states.

Cc: stable@vger.kernel.org
Reviewed-by: Josip Pavic <josip.pavic@amd.com>
Signed-off-by: Joshua Aberback <joshua.aberback@amd.com>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -3066,7 +3066,10 @@ static void restore_planes_and_stream_st
 		return;
 
 	for (i = 0; i < status->plane_count; i++) {
+		/* refcount will always be valid, restore everything else */
+		struct kref refcount = status->plane_states[i]->refcount;
 		*status->plane_states[i] = scratch->plane_states[i];
+		status->plane_states[i]->refcount = refcount;
 	}
 	*stream = scratch->stream_state;
 }


