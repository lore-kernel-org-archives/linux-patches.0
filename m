Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E210F2D5426;
	Tue, 15 Jul 2025 13:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587666; cv=none; b=sVB3Cw76CJKz2Tm3VxQj/A2Cd/r/FWhdK+N9+OqE2m2sYIphoF2Q7f4tLNwfxKP+3FCFAa6GbixvcZ73XNaYNpWX2ceAEFCWemskHdYVS6Ioj1Rk9Aj/ewV/c82cd06oL1oZtAtI3/v7Xf64Iy/tvN8nhQ6OMeXeWSJClcw/3ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587666; c=relaxed/simple;
	bh=kfaTlKk5btNBorNwaudKt1ibwgyJZP7oI4nSr9G3R5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nid+BF46k5Ji3zkJWqYFEOR0b0GXudGewhuTFWne/o5fkVhpsND4n8RxvU1yYDsnzwY1vgRfk5a3vVdjHVS59Rmabb+nkUmG8uwP10zhCVYIZtELKF7HaK94KKJ3WT+IxD58WLVj7QubTYIvVvcGQUlTOXbGmpuj7+MZnhzwz0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AGCd5aw6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AGCd5aw6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7636EC4CEF1;
	Tue, 15 Jul 2025 13:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587665;
	bh=kfaTlKk5btNBorNwaudKt1ibwgyJZP7oI4nSr9G3R5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AGCd5aw6gg1+3MggmcZ2pY7wwNwRbkAlpw7H2ap7mIfhDhtgwRG1m0evtY8n8WaN0
	 sIdSwBz+OrWsy5AmWe62CcdJrDKQ0GutOTWwjDjnu1bcl7Hxkt5fEPg7OsTaJ9mWHu
	 tEBI4J1/FttZFAmK3OOtLMPMzCNT3WUYt0Yuk5AQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Cornwall <jay.cornwall@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 066/208] drm/amdkfd: Fix race in GWS queue scheduling
Date: Tue, 15 Jul 2025 15:12:55 +0200
Message-ID: <20250715130813.597686476@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -156,7 +156,7 @@ static int pm_map_queues_v9(struct packe
 
 	packet->bitfields2.engine_sel =
 		engine_sel__mes_map_queues__compute_vi;
-	packet->bitfields2.gws_control_queue = q->gws ? 1 : 0;
+	packet->bitfields2.gws_control_queue = q->properties.is_gws ? 1 : 0;
 	packet->bitfields2.extended_engine_sel =
 		extended_engine_sel__mes_map_queues__legacy_engine_sel;
 	packet->bitfields2.queue_type =


