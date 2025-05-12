Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722B929614D;
	Mon, 12 May 2025 17:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072412; cv=none; b=BJySzWZB23VSPUxBrUiKsAkQxBTCZ7g+RzUKgygtddsYfdohJqGs4jU57p7Bsu6414J18a6i0wtFdL12/M6YshuuXQAWF7VXpoX1jCG1eRmALzYqYeXb03ZfLv9vN/DqGibniMfsS6z6Inzv68bPrCyXdzkUe/DnMYhR4u5zBK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072412; c=relaxed/simple;
	bh=tgBcSKjSlyHfh78DCALbCNAlx7ERSKDGuz9WeQL0DqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZpUGQSlQBPkoM6xrbU2kZHGDNnS5ZkG947P3YcGuRgzocZI1V1qh12pd9T4HYWpIzwqYYyqxRXvi0rN8ix3CqwAXcI1YVA8NCWP6QkXPiQWO6N3a4tS6w3bdn5CUuISESsEmS1HAvTW8YSscEiy7AsbunHYBxwyyoc0Bt2J0BtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ADlXsms+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ADlXsms+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64757C4CEE7;
	Mon, 12 May 2025 17:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072412;
	bh=tgBcSKjSlyHfh78DCALbCNAlx7ERSKDGuz9WeQL0DqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ADlXsms+wf76YPWCZXUCMnKTqVsd83KtpZ0xTpnuBZ6k2rkGSKXTAaZHZeLlt4f4Q
	 392kxIw0jnb+kvtdQpwRuyjjH6/kIKwf5hT46H2u/SeBmzPIxrtIFQcqii0JiKWdDd
	 pBGX2Ilzq33ncL1wF6YfK7KoUZYlbU4cWFLu/vXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Wayne Lin <Wayne.Lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.1 33/92] drm/amd/display: Shift DMUB AUX reply command if necessary
Date: Mon, 12 May 2025 19:45:08 +0200
Message-ID: <20250512172024.482458928@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172023.126467649@linuxfoundation.org>
References: <20250512172023.126467649@linuxfoundation.org>
User-Agent: quilt/0.68
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

commit 5a3846648c0523fd850b7f0aec78c0139453ab8b upstream.

[Why]
Defined value of dmub AUX reply command field get updated but didn't
adjust dm receiving side accordingly.

[How]
Check the received reply command value to see if it's updated version
or not. Adjust it if necessary.

Fixes: ead08b95fa50 ("drm/amd/display: Fix race condition in DPIA AUX transfer")
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Ray Wu <ray.wu@amd.com>
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit d5c9ade755a9afa210840708a12a8f44c0d532f4)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -10702,8 +10702,11 @@ int amdgpu_dm_process_dmub_aux_transfer_
 		goto out;
 	}
 
+	payload->reply[0] = adev->dm.dmub_notify->aux_reply.command & 0xF;
+	if (adev->dm.dmub_notify->aux_reply.command & 0xF0)
+		/* The reply is stored in the top nibble of the command. */
+		payload->reply[0] = (adev->dm.dmub_notify->aux_reply.command >> 4) & 0xF;
 
-	payload->reply[0] = adev->dm.dmub_notify->aux_reply.command;
 	if (!payload->write && p_notify->aux_reply.length &&
 			(payload->reply[0] == AUX_TRANSACTION_REPLY_AUX_ACK)) {
 


