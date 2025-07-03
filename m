Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97AC19CC3D;
	Thu,  3 Jul 2025 15:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555767; cv=none; b=TiwGzkJZzm5hwzan+IPeq77IW+kct6KuZpR3XVzGQzJAvrDF6ISuRkqsYnq/K/ORTGrAZe5ytCweBnMYIuoHZ+gnCB9dC3h+Qx4GgSIHLjb9CmMM7nbLsQMzgUi6+SZXFGV8zJEjmyJh1nH68xrF/t4tNebZIFxsucVcPCrE18g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555767; c=relaxed/simple;
	bh=enRekMKt15r21xSni/yAuuDAWTMlKmXK71EB6xlu9VE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0cz2OzVqEQBDnMpctrRY14NFesQ/Fz+cjlwAs+3i0OGGfr84i/rYXDV9sHjrLxPyreeYaASFbIEcNCncMUopqRqN8X2yWBlDqFG2UbSr6Y8Mmr1PIz9j5ii9mYCaDLjV3tbG6YqZvLEKZ0ymqDHxz0JXfmLnH+0wCnKMFGuxEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j6Oz/tTq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j6Oz/tTq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49168C4CEE3;
	Thu,  3 Jul 2025 15:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555767;
	bh=enRekMKt15r21xSni/yAuuDAWTMlKmXK71EB6xlu9VE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j6Oz/tTqyvg2+Aomt8UNdUNCVYC1uipXg5OgVbR9plPzNauCNWPTuA38LNon+81uU
	 XOUgnEG/hwKv8GOn8NjpTYJzDB92FCjbfh4OosC/qoVBe1LKbXoGHs05FnpC8sd1kd
	 ynOESG9y88lWVzNDAOoqi1hnkqHOA0bdBco/RdRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Cornwall <jay.cornwall@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 116/139] drm/amdkfd: Fix race in GWS queue scheduling
Date: Thu,  3 Jul 2025 16:42:59 +0200
Message-ID: <20250703143945.723410776@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -225,7 +225,7 @@ static int pm_map_queues_v9(struct packe
 
 	packet->bitfields2.engine_sel =
 		engine_sel__mes_map_queues__compute_vi;
-	packet->bitfields2.gws_control_queue = q->gws ? 1 : 0;
+	packet->bitfields2.gws_control_queue = q->properties.is_gws ? 1 : 0;
 	packet->bitfields2.extended_engine_sel =
 		extended_engine_sel__mes_map_queues__legacy_engine_sel;
 	packet->bitfields2.queue_type =


