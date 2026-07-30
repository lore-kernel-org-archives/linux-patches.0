Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C713769FD;
	Thu, 30 Jul 2026 15:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426076; cv=none; b=g/Qk48vse4dpMWlnXYj9BxuxOfjLEXXZNmT6FSLai58OQhlwEtoo3EkSF86DGD3GoxpmFGtUG/Wr70ML5w+AReHv3f2il4etQ1d7uDiXgrM13q8GzbQwdjumwuW2KVff8dlQ55hrUSnFiQiLIUK8QbsZd9bI3sTCvr0VJr2ZJMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426076; c=relaxed/simple;
	bh=+eyNUtI1N28Hxemr3ojJjXNHLmOeNPiX6QwSCDTQrBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N+I5Zy/2z7i3LHkF20/Uj41BdrN2v46Bp70NdYab1Zgx3Jg2ZdqjI/d5hghjS9JZvRuQATnooTMjLQbGWW78dvqLwQVx2zpQbuCtsSyc+gGzn/jXBHMbtfc4ZGPH2d27+bEDIfI72rzoQ+mcBu941Gx1Mke+rmERxS0i9DD5Z0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0tcXMfCC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0tcXMfCC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E521F000E9;
	Thu, 30 Jul 2026 15:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426075;
	bh=MLlHb4rXGk2mV9B/1HluYKVkuI+/jVjluc1KfHWk/yA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0tcXMfCC2jun/2AqpAW0gM5H/xHjtZ1PL/p3wZaXFH8W9UdGv8ZhVkbtUdlQpsR6s
	 aVMquFzhLgfmPfwnudkD1ZB9iWnj6F+7yBlet5o1LwhxrWkB9eUGKWqUsGTKfSkVRs
	 3YwZcAO68PIJT/Qyn+LDV/6P4SP5IzXVX8PncSCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	George Zhang <george.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 293/602] drm/amd/display: set new_stream to NULL after release
Date: Thu, 30 Jul 2026 16:11:25 +0200
Message-ID: <20260730141442.128970599@linuxfoundation.org>
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

From: WenTao Liang <vulab@iscas.ac.cn>

commit 9fa26b9eed6195bf840f39ac183b9a6237548755 upstream.

In dm_update_crtc_state(), the skip_modeset path releases new_stream
via dc_stream_release() but does not set the pointer to NULL.

If a later error (e.g., color management failure) triggers the fail
label, the error path calls dc_stream_release() again on the same
dangling pointer, causing a double release and potential use-after-free.

Fix this by setting new_stream to NULL after the initial release.

Fixes: 9b690ef3c704 ("drm/amd/display: Avoid full modeset when not required")
Signed-off-by: WenTao Liang <vulab@iscas.ac.cn>
Reviewed-by: George Zhang <george.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 99f3af19073b3ddbfd96e789124cce12c4277b28)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -10836,6 +10836,7 @@ skip_modeset:
 	/* Release extra reference */
 	if (new_stream)
 		dc_stream_release(new_stream);
+	new_stream = NULL;
 
 	/*
 	 * We want to do dc stream updates that do not require a


