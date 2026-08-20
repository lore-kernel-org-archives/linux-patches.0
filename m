Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A17D37DE87;
	Thu, 20 Aug 2026 15:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238089; cv=none; b=lwP7oWVw2p4IxEuNaiPmh27lq5q8Pz10YZ6LWIRWdr9Nf/+hTXpGZu4tATZjbF4HChYmP0eFdnUF+IXXZ8opFkJZLBVYDhhasuabxGNw9/0+iaSuV/oqR0vIAMEK4N5Nh0PZxyIh/y5Zf7EhDrhWmgJtZWDfkzTkrk2VI0tBZK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238089; c=relaxed/simple;
	bh=L3QrQWRGS+JIpge1GXaDpfE2SCT+MxRYsNw9Ngy7ioo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FNHVrNi9lPp5HTZFgSLOVNlXfxG5UUBvEq+H/Dg0zkXBm3cKTGOy4oWhqsVmhCKF8Oan7bLyFjy5TXxhUrqhBDdQQRsq/rMS+hDgubuYzpkcrZ4mJnyfFHAp2owsqRM9PUwQia3EaLO1vpCVFOmvazD1zvRREu6v2vtBzueKObw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LNGFL/7q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LNGFL/7q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CB021F000E9;
	Thu, 20 Aug 2026 15:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238088;
	bh=N8M4LzwxFipet5taWw+lcAzfR05/AbAv0ral79mVix4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LNGFL/7qFpC+uA/gj/2lvhgp3QlM0SgTUYFjtT+pdrLpoXaDaSucDtE4ekGCI6Vkx
	 ksTXGGuNmNRbIf4lG/15jNKM6BwzkhkYic+ss+EkbZZcNT7f4Q0sZbf3g7JcDaFJ3Q
	 Ama0GWz4Qm48X8HKfNmpBZdgySpAuoaJPmJl6sqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>
Subject: [PATCH 7.1 029/228] drm/amdgpu/userq: serialize queue map against GPU reset
Date: Thu, 20 Aug 2026 16:52:51 +0200
Message-ID: <20260820145245.348272837@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

From: Jesse Zhang <Jesse.Zhang@amd.com>

commit b77a725e50c87c091f51affc8e46710badea0d49 upstream.

Creating a user queue can race with a GPU reset. While recovery holds
reset_domain->sem for write, MES is unresponsive, so the ADD_QUEUE from
amdgpu_userq_map_helper() times out (-110) and an otherwise valid queue
create fails:

  amdgpu: MES(0) failed to respond to msg=ADD_QUEUE
  [drm:mes_userq_map [amdgpu]] *ERROR* Failed to map queue in HW, err (-110)
  amdgpu: [drm] *ERROR* ... Failed to map Queue
  amdgpu: [drm] *ERROR* ... Failed to create usermode queue

Take reset_domain->sem for read around the map so it runs only once MES
is back up. This mirrors amdgpu_userq_cleanup() and honors the
userq_mutex -> reset_domain->sem order; the reset path never takes
userq_mutex, so there is no deadlock.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit a8e151fe629c63b0eb08aa57de0d434614db3e1b)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
@@ -700,7 +700,12 @@ amdgpu_userq_create(struct drm_file *fil
 	if (!adev->userq_halt_for_enforce_isolation ||
 	    ((queue->queue_type != AMDGPU_HW_IP_GFX) &&
 	     (queue->queue_type != AMDGPU_HW_IP_COMPUTE))) {
+		/* Serialize the map against an in-progress GPU reset (MES is
+		 * unresponsive during recovery), matching amdgpu_userq_cleanup().
+		 */
+		down_read(&adev->reset_domain->sem);
 		r = amdgpu_userq_map_helper(queue);
+		up_read(&adev->reset_domain->sem);
 		if (r) {
 			drm_file_err(uq_mgr->file, "Failed to map Queue\n");
 			mutex_unlock(&uq_mgr->userq_mutex);


