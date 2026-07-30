Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3302C37883C;
	Thu, 30 Jul 2026 14:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423209; cv=none; b=Jd5KCNNuqgV9Hir9/QQCzWcX2kKmBNMRQqta499I0WaQiGAGphuuWPVg87/vPValFusuCJ/yTnnpISvgN6KdN7OYjs7zrT4lve7rIRErmbrhR9AqVq61zpaM3KVClgYoJ4bw2mKZd/Jc8PQM8n7Vxb4wXugTe5zIhGidPviRdUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423209; c=relaxed/simple;
	bh=jRhcMmkokV5NmT59YYkQqtfMm7oc7GcQ2G5liwvdDXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RoOoONCgFtPBRT0wvTHd4s6jRixUr/XG02B3sBCV4eb8/qtI5XvIwCkXcQVDim6myj37MhiqAOQbfVz6B8FH4MBUx2mSfA2CntZ8iEEZMfEX5CNAlvIRJYurQvWHI87ceFEbppltXVIdy9AYSqiwoTnJefjhEod0ol+0JhyYgYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pvQGyW0g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pvQGyW0g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 879B51F000E9;
	Thu, 30 Jul 2026 14:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423208;
	bh=oWv2w/b5I3NCCeOVj9lzPLmixEbD8iRPqYvqpHWyfMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pvQGyW0gpKe0YXGJZZjr4eyUChv0WzvKCu3mr9emqQHkwHTCWMulLQs0bcerMGFVO
	 0kSthbdydokjimPHg/PcROjZn2M9IWz6DqwByfWSagHkvN9s2wMVO5R03AdZgxvLn1
	 q5aEiDkylTpPr9iXmR0GaBLpbAswsgTX2mBMRdFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prike Liang <Prike.Liang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 705/744] drm/amdgpu/mes11: set doorbell offset for suspending userq
Date: Thu, 30 Jul 2026 16:16:18 +0200
Message-ID: <20260730141459.260955490@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prike Liang <Prike.Liang@amd.com>

commit 96f222efc9e798165079def83d7f94f22ca9c384 upstream.

Updating the union MESAPI__SUSPEND and union MESAPI__RESUME to
add the doorbell offset for suspending userq.

Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 30af09db33696f7e0de5c0c505cbb0cb92b6e25b)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c        |    2 ++
 drivers/gpu/drm/amd/include/mes_v11_api_def.h |    2 ++
 2 files changed, 4 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
@@ -557,6 +557,7 @@ static int mes_v11_0_suspend_gang(struct
 	mes_suspend_gang_pkt.gang_context_addr = input->gang_context_addr;
 	mes_suspend_gang_pkt.suspend_fence_addr = input->suspend_fence_addr;
 	mes_suspend_gang_pkt.suspend_fence_value = input->suspend_fence_value;
+	mes_suspend_gang_pkt.doorbell_offset = input->doorbell_offset;
 
 	return mes_v11_0_submit_pkt_and_poll_completion(mes,
 			&mes_suspend_gang_pkt, sizeof(mes_suspend_gang_pkt),
@@ -576,6 +577,7 @@ static int mes_v11_0_resume_gang(struct
 
 	mes_resume_gang_pkt.resume_all_gangs = input->resume_all_gangs;
 	mes_resume_gang_pkt.gang_context_addr = input->gang_context_addr;
+	mes_resume_gang_pkt.doorbell_offset = input->doorbell_offset;
 
 	return mes_v11_0_submit_pkt_and_poll_completion(mes,
 			&mes_resume_gang_pkt, sizeof(mes_resume_gang_pkt),
--- a/drivers/gpu/drm/amd/include/mes_v11_api_def.h
+++ b/drivers/gpu/drm/amd/include/mes_v11_api_def.h
@@ -427,6 +427,7 @@ union MESAPI__SUSPEND {
 		uint32_t		suspend_fence_value;
 
 		struct MES_API_STATUS	api_status;
+		uint32_t		doorbell_offset;
 	};
 
 	uint32_t	max_dwords_in_api[API_FRAME_SIZE_IN_DWORDS];
@@ -444,6 +445,7 @@ union MESAPI__RESUME {
 		uint64_t		gang_context_addr;
 
 		struct MES_API_STATUS	api_status;
+		uint32_t		doorbell_offset;
 	};
 
 	uint32_t	max_dwords_in_api[API_FRAME_SIZE_IN_DWORDS];


