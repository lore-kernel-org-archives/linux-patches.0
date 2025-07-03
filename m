Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B1F22069F;
	Thu,  3 Jul 2025 15:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555216; cv=none; b=A2+TxibgAe5BiVtiOQdBqA0iTZk+tztk30SfbzjYSNB0HXfMRKd/GD1E7pJc6mWLDH/h1PfcePqt5uEC1jVa3ZfJocfYNSfbGcGVRL7VBJc4mXfw4iZ7EPSJFFgJyGmb07Ahqi8w8iVCuNkXtbX1bkLAnDRMGvUr5ADQQeZ/V/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555216; c=relaxed/simple;
	bh=ysnSyECkftrwFPR4zsdC51FnlG3cy4alkqgxv4tvBAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vFqFA/ovQNV2lmuv5Hmb0EE4unSMw2Bb53rHokULeI1eNdufNJsxyPC065bDmtzIvVGiCB+mdDQ+8ThbYWBgzWaxCFWrMnC1rlLPyPeGAv4xIdcPg5OMqQxpGVYNwO0UIq54uLAH6Izv9fk8G1oKwEkc/ZM76B65f/5kbs70pOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d56jTUs3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d56jTUs3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12684C4CEE3;
	Thu,  3 Jul 2025 15:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555216;
	bh=ysnSyECkftrwFPR4zsdC51FnlG3cy4alkqgxv4tvBAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d56jTUs3s5vsqfe0TRXpyrNVeM/eh0tKqgm+cERdKzKTovqdfEtfv8YcSKbuIxxrj
	 JUzuFf5rgwQU0UDebBrzriBx4MuGqAWHyuCLe0x8alv6rjFC4XDgKl8CJl03UeffTv
	 JdWIzxvgMCK/PjvU1YHYMi/r86X8j6t8qEZd5xus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Cornwall <jay.cornwall@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.15 211/263] drm/amdkfd: Fix race in GWS queue scheduling
Date: Thu,  3 Jul 2025 16:42:11 +0200
Message-ID: <20250703144012.850680070@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jay Cornwall <jay.cornwall@amd.com>

commit cfb05257ae168a0496c7637e1d9e3ab8a25cbffe upstream.

q->gws is not updated atomically with qpd->mapped_gws_queue. If a
runlist is created between pqm_set_gws and update_queue it will
contain a queue which uses GWS in a process with no GWS allocated.
This will result in a scheduler hang.

Use q->properties.is_gws which is changed while holding the DQM lock.

Signed-off-by: Jay Cornwall <jay.cornwall@amd.com>
Reviewed-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit b98370220eb3110e82248e3354e16a489a492cfb)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_packet_manager_v9.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_packet_manager_v9.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_packet_manager_v9.c
@@ -237,7 +237,7 @@ static int pm_map_queues_v9(struct packe
 
 	packet->bitfields2.engine_sel =
 		engine_sel__mes_map_queues__compute_vi;
-	packet->bitfields2.gws_control_queue = q->gws ? 1 : 0;
+	packet->bitfields2.gws_control_queue = q->properties.is_gws ? 1 : 0;
 	packet->bitfields2.extended_engine_sel =
 		extended_engine_sel__mes_map_queues__legacy_engine_sel;
 	packet->bitfields2.queue_type =


