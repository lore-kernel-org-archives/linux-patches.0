Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E49281369;
	Thu, 13 Feb 2025 14:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457664; cv=none; b=asE9+9/pbM6zpxyBw3LzGar7Shp05lDg7syOiv2cXMnok05KKtcK5efjP8WJiQ1mxbrrdFPk5eKRme+fzti7UauMj979Z5ZQTBfX4mb+4GKxHFu3Afg1VC3S9Xgi0gAbRbxwHGmokL/ZOR0XOYQAeCO1xqGYJ12izfsf0kR7PLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457664; c=relaxed/simple;
	bh=vL2dJi67WTW9HmOOhOziDx4SaYOLyRzlY39f84roaCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i6oGW9GSLTv1rbKpSjy3p4rKAGGJgFJFW0ceKqt/naXI7DiLXDxqgDO/Lh893UVd/Wbia7mV6C9s5T6kS5HDygxCKS7v900v1ns8w0k/IlChO9mqGtPaYY9JMXKtEm4ih+/LW4dsAOpDmoAUxO2j6CgoeuVerW1NsFjSHg/iWZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B/qs3xL2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B/qs3xL2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C4DEC4CED1;
	Thu, 13 Feb 2025 14:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457664;
	bh=vL2dJi67WTW9HmOOhOziDx4SaYOLyRzlY39f84roaCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B/qs3xL20chbbgGa4Vxp7voA/WDLQdlB6s9oSfYOldmNBUqhv1IzYO51So787q+4C
	 qsD6028uDDNhOAc7o+ndcnGava1uO1iX3bmh3WrbGSoA8UuFLG8/dDo1xjvmD30Jvx
	 sm010JzIVT/iyef15maf5tNOxkDLwhw0r9+6tVU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Cornwall <jay.cornwall@amd.com>,
	Jonathan Kim <Jonathan.Kim@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 160/422] drm/amdkfd: Block per-queue reset when halt_if_hws_hang=1
Date: Thu, 13 Feb 2025 15:25:09 +0100
Message-ID: <20250213142442.718671700@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jay Cornwall <jay.cornwall@amd.com>

commit f214b7beb00621b983e67ce97477afc3ab4b38f4 upstream.

The purpose of halt_if_hws_hang is to preserve GPU state for driver
debugging when queue preemption fails. Issuing per-queue reset may
kill wavefronts which caused the preemption failure.

Signed-off-by: Jay Cornwall <jay.cornwall@amd.com>
Reviewed-by: Jonathan Kim <Jonathan.Kim@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.12.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -2290,9 +2290,9 @@ static int unmap_queues_cpsch(struct dev
 	 */
 	mqd_mgr = dqm->mqd_mgrs[KFD_MQD_TYPE_HIQ];
 	if (mqd_mgr->check_preemption_failed(mqd_mgr, dqm->packet_mgr.priv_queue->queue->mqd)) {
+		while (halt_if_hws_hang)
+			schedule();
 		if (reset_queues_on_hws_hang(dqm)) {
-			while (halt_if_hws_hang)
-				schedule();
 			dqm->is_hws_hang = true;
 			kfd_hws_hang(dqm);
 			retval = -ETIME;


