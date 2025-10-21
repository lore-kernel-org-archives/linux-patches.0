Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13161274652;
	Tue, 21 Oct 2025 19:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076751; cv=none; b=cM2kKUUdQ0GbwmXic3pifqNQylla1qds2ERCMCXh5fCy+zZOmCou6LgColU4ETHFCiGotdyJmJrY/qGJro0w96i/25xfmzYoG5dOQzETbc+xddoOguwRjWfPa0+1NsRxUn70fbBMFTi9CGIoVd7Iz0Qa4kZ6RKURSsUV4PC6FAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076751; c=relaxed/simple;
	bh=a9nXNNSeRoqS8OLH0Ow2TVGw4pforG2OWKOZFdwFI/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N1ALA3RVTh45Xfq7g8nEbta6VzWvI2LAFjlt0vTR9hbNyNHxFq204WWBUd0+8bDM3eeBEVLiAEGWMQUoFgOUlTOaddGu8kTs7Ix+Yyaj0hPfKLhbEqi5tQGhh9L7btJZGL4ofJ+otSpwG7XAbU7AVr+cJCNnU9nk+2ojfBlzEQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k+T40p2L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k+T40p2L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96AAAC4AF09;
	Tue, 21 Oct 2025 19:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076750;
	bh=a9nXNNSeRoqS8OLH0Ow2TVGw4pforG2OWKOZFdwFI/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k+T40p2LbLryz0lg+Tvnzyrh0E4BJf2GBXqxVi8xZGCC4vCujLaVUWCAGzRZ1ZJvK
	 +uMRr1QFgM8WTDwqUCKhn04RCc+FbQU+y9rkW/MwSB/4pLJ0GRrlckZzqaKoG3weWO
	 0DpwGHcSw8MjEM/1EKTY8Ojy43gGdPqfSuqHYyF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Adrian Yip <adrian.ytw@gmail.com>
Subject: [PATCH 6.12 026/136] drm/amd: Check whether secure display TA loaded successfully
Date: Tue, 21 Oct 2025 21:50:14 +0200
Message-ID: <20251021195036.605136873@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

commit c760bcda83571e07b72c10d9da175db5051ed971 upstream.

[Why]
Not all renoir hardware supports secure display.  If the TA is present
but the feature isn't supported it will fail to load or send commands.
This shows ERR messages to the user that make it seems like there is
a problem.

[How]
Check the resp_status of the context to see if there was an error
before trying to send any secure display commands.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/1415
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Adrian Yip <adrian.ytw@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -2171,7 +2171,7 @@ static int psp_securedisplay_initialize(
 	}
 
 	ret = psp_ta_load(psp, &psp->securedisplay_context.context);
-	if (!ret) {
+	if (!ret && !psp->securedisplay_context.context.resp_status) {
 		psp->securedisplay_context.context.initialized = true;
 		mutex_init(&psp->securedisplay_context.mutex);
 	} else


