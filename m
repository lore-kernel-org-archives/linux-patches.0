Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500B73644C1;
	Wed, 30 Sep 2026 18:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794016; cv=none; b=QGvvxcvDnaRobwJgOCg4A/lHRTGtfYQd3J5d+hzVFjQ9bLb4fH5jhDJ8Aneedl8klT5qs79v8GQToQ5w66gz3sy+gQ9SpsM0JcKq4S0iBv+/tEMrJX4TOdXN7WxG8gTU9OZ8UHLUIOLGFHGeaEWQxPZW6F8eU2F5esvtlOz7HX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794016; c=relaxed/simple;
	bh=45nUpegP35q7QiLwgB1qb5wpbb3w1MeEkzwSzR3chOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DitVxIKqN/FWkl96SaWJWlsBiKGccGCWXhftUI69P2yPO7cFTzz5uOhotdQqdyWRKKz7YnP1UdGKb45hhc7TwyEo9CVS2YEXVZzDm4Pd7CEnSKfkqajIBvaVqsC7V2Ux+Cwq3guX3hD2RfvTYf/XAtE3PWroP5BHPI0hTu84y5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AiUFPr4B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AiUFPr4B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 694CA1F000FF;
	Wed, 30 Sep 2026 18:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794015;
	bh=SogmKqqJWSLS6So//1dAMXIAp4OjxYOuZKVNACTCJHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AiUFPr4Bjt9HYTP77abR/3ST6J37W1du6r1Qkmu05F3ub4tZW3qmzkpFfWNW83tyh
	 dHgWHUTjuBUPDyYVk0chCD4fCaYJPoGlikFMVSUFhM91+reN+ehh9YPTj52itmY/W8
	 q9aCi4eIfUT9FhetCJXioqqnnPUHIrMvQ7VEwf0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Francis <David.Francis@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0063/1193] drm/amdkfd: Check bounds on allocate_doorbell
Date: Wed, 30 Sep 2026 17:12:27 +0200
Message-ID: <20260930152435.674021613@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

[ Upstream commit 1f087bb8cf9e8797633da35c85435e557ef74d06 ]

allocated_doorbell has an option to set the doorbell id
to a specific value (used by CRIU). This value was not
bounds checked.

Check to confirm it's less than KFD_MAX_NUM_OF_QUEUES_PER_PROCESS.

Signed-off-by: David Francis <David.Francis@amd.com>
Reviewed-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
index f4f7c65be2139..01481112a4ae3 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -385,6 +385,9 @@ static int allocate_doorbell(struct qcm_process_device *qpd,
 	} else {
 		/* For CP queues on SOC15 */
 		if (restore_id) {
+			if (*restore_id >= KFD_MAX_NUM_OF_QUEUES_PER_PROCESS)
+				return -EINVAL;
+
 			/* make sure that ID is free  */
 			if (__test_and_set_bit(*restore_id, qpd->doorbell_bitmap))
 				return -EINVAL;
-- 
2.53.0



