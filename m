Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5F0423A8B;
	Tue, 31 Mar 2026 16:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975671; cv=none; b=ZVKYZxpOK3sTHuEpY8MB2TsYEZ8Nts8YYn9C6m5hQRceyNe8GYyK3ib8i61N+ElWmFWuCRzxQeSQoP+ivtHYxx7HHeRyfLWJukU8HjxtzKWDKs3oneKzSAnzHuyHH31aLPCIiI3ZchY/YVMqs7Yxh6IYMZLRO1qSsivFQ9SlitA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975671; c=relaxed/simple;
	bh=hVdm5iW8tHYsj49ThAImLh5mO7K6RvI2tcdpMmr27s8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GheJNswDpyjeY2/yTVERfPtX+wDTNNN5KVPNUFxE6zWiuvZs3vimrb0lci6NHEeKAh8hYGxrhQPYESLWjv1IcLUfaX2BUpg+8pY3JafMG6tnRIkeUfL96Dmi4adi5EMTkrjo7+TYVe5O8eq5qIvVdCdeQ1dKeOOg+w9V4JmKKNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ToewToz3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ToewToz3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 879C1C19424;
	Tue, 31 Mar 2026 16:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975670;
	bh=hVdm5iW8tHYsj49ThAImLh5mO7K6RvI2tcdpMmr27s8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ToewToz3QGn7Zlgz6eUqU4aaqp/Au0jtuGndk5yR60t7y3Uv73jC0hDP3sXeQqs8W
	 0/VRwBG1h6+rz0j67u4jdhs6+TESIz3iqwoPCZJ7HqyvAHa1XBEJlToRTHPcW60wt2
	 x59Lxil0TMFqgWYY5a4pccGogE4ST0UAGSbn73nI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 042/244] drm/amdgpu: fix gpu idle power consumption issue for gfx v12
Date: Tue, 31 Mar 2026 18:19:52 +0200
Message-ID: <20260331161743.251959866@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

From: Yang Wang <kevinyang.wang@amd.com>

[ Upstream commit a6571045cf06c4aa749b4801382ae96650e2f0e1 ]

Older versions of the MES firmware may cause abnormal GPU power consumption.
When performing inference tasks on the GPU (e.g., with Ollama using ROCm),
the GPU may show abnormal power consumption in idle state and incorrect GPU load information.
This issue has been fixed in firmware version 0x8b and newer.

Closes: https://github.com/ROCm/ROCm/issues/5706
Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 4e22a5fe6ea6e0b057e7f246df4ac3ff8bfbc46a)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/mes_v12_0.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c b/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
index 333a31da85568..945016712157d 100644
--- a/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
@@ -567,6 +567,9 @@ static int mes_v12_0_set_hw_resources(struct amdgpu_mes *mes, int pipe)
 	int i;
 	struct amdgpu_device *adev = mes->adev;
 	union MESAPI_SET_HW_RESOURCES mes_set_hw_res_pkt;
+	uint32_t mes_rev = (pipe == AMDGPU_MES_SCHED_PIPE) ?
+		(mes->sched_version & AMDGPU_MES_VERSION_MASK) :
+		(mes->kiq_version & AMDGPU_MES_VERSION_MASK);
 
 	memset(&mes_set_hw_res_pkt, 0, sizeof(mes_set_hw_res_pkt));
 
@@ -621,7 +624,7 @@ static int mes_v12_0_set_hw_resources(struct amdgpu_mes *mes, int pipe)
 	 * handling support, other queue will not use the oversubscribe timer.
 	 * handling  mode - 0: disabled; 1: basic version; 2: basic+ version
 	 */
-	mes_set_hw_res_pkt.oversubscription_timer = 50;
+	mes_set_hw_res_pkt.oversubscription_timer = mes_rev < 0x8b ? 0 : 50;
 	mes_set_hw_res_pkt.unmapped_doorbell_handling = 1;
 
 	if (amdgpu_mes_log_enable) {
-- 
2.51.0



