Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499FF166F32;
	Thu, 13 Feb 2025 15:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459249; cv=none; b=YgcgK0xUnx/0GLJuExUQvJJjcODqd1QgaPFPSmodnsMudWC+1hYwbVxun5t0DBK8/SOCLoKbI0NyhOMqP5i/Ffa9jug4h81lg+vgJ60dSdBF68/RKmnk5ZT15vTF5zLXSbG1ua+fuc2znwibva7ItnKpcPX2S1GZZDfKsSCYaM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459249; c=relaxed/simple;
	bh=ZgsJ1NU1PwCQtN+o87p92RZg+EbSjyG6byS945PbQbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EBQfRJGh7TVuDPjdKrT4UZ1CRWyfnKQPSlcOTti1YEhCML1zX0507TDiiDsQQJPQdpprpIRvXhStpTJY9iaOQpZHCUB40cd0SVUUirM7220oqwTugpN6pWjDykufXQCu54RhFf1BhskkmZqtsG3QxM/TE2q9HOA07FHXfXiQuAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ML50MDZ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ML50MDZ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8927C4CEE4;
	Thu, 13 Feb 2025 15:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459249;
	bh=ZgsJ1NU1PwCQtN+o87p92RZg+EbSjyG6byS945PbQbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ML50MDZ48tqqvCNWCbkSRrufuhtUtI+1mr4o9GzpAGjRRCetsrmYhijGJHhee9IMd
	 SXyjiT8iWyTaUUDKXTbsKqYudCsI7phomCNUspWJ0qP0yoHmvyWhkb4oNc8l8r4NZR
	 36J4Hkx78uPgzQA1eoDOLmLMG7riGRQqqbeU10AQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Cornwall <jay.cornwall@amd.com>,
	Jonathan Kim <Jonathan.Kim@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.13 177/443] drm/amdkfd: Block per-queue reset when halt_if_hws_hang=1
Date: Thu, 13 Feb 2025 15:25:42 +0100
Message-ID: <20250213142447.434413697@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2325,9 +2325,9 @@ static int unmap_queues_cpsch(struct dev
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


