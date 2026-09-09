Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A6F53ED1E;
	Wed,  9 Sep 2026 14:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963024; cv=none; b=s1GNp2J/J+UvxRVrO3XFIBzxg6y7kHl7Tknex7JZaZWQtcicpa2qNi1c8pUHNs2HMYSW1ADZLVE60i5Ba/j701Ho/tzNxW/AzucZjXa3Eqy6WVYM7oPC9OfDABKGpqlPyLclQYmBoyiNdnu9BDWJzDdngkmtRVmvQIMyOahlyz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963024; c=relaxed/simple;
	bh=3yzAXawjc4ff05HjrisNWyMTfeGvqQMX3k7I2BwK2jc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VnIYv1tJy43CRN2CzB5BmGz5hMqp34etBJbbR2vcNdhT4mKE9OgjWw4NupDiD8I/W69wu8+A+2AQn45xcmbsq9korccB4S+bPj5uYrayTeuWCjkJnnkP649lDaCKjKW3DkyKfVIgpGwQlhjZfrKhHNRDTvzRjzfthmVBh2jkF9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JFQ1Ahm7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JFQ1Ahm7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4AE51F00A3D;
	Wed,  9 Sep 2026 14:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963023;
	bh=l3Jrl+DLNKTmq8Vo1+bvxZJuiScvD00dfNisnzHGjso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JFQ1Ahm7syiBl4KAScBt2I4K3oFIO2JSAwxCf/BSkY33uhUeYk1u/rhg92fhb1x7A
	 +V9FRR6NJTfXNLLCoU+Rp/y2Ub0eAQMfqN0s5XocQlTnP+bw7+lIMXUR+cyGPUvqEB
	 aFFfeYuhRNdX15TMsbz9h+1Wj3BuFsDzslXC3gi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <jesse.zhang@amd.com>,
	Kent Russell <kent.russell@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 494/556] drm/amdgpu/gfx8: only apply compute quantums to KCQs
Date: Wed,  9 Sep 2026 15:42:54 +0200
Message-ID: <20260909134247.863397549@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 7346a046c6a9b9f30cb1f7d301449300a9174c71 upstream.

Don't apply to KIQ.  Seems to cause problems on KIQ
on some ARM platforms.

Closes: https://gitlab.freedesktop.org/drm/amd/-/work_items/5658
Fixes: 91cf34bc5a55 ("drm/amdgpu/gfx8: align mqd settings with KFD")
Reviewed-by: Jesse Zhang <jesse.zhang@amd.com>
Reviewed-by: Kent Russell <kent.russell@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 6aae7bab029cdccae9a7157facfe36bfc35fc940)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
@@ -4533,9 +4533,11 @@ static int gfx_v8_0_mqd_init(struct amdg
 	/* set static priority for a queue/ring */
 	gfx_v8_0_mqd_set_priority(ring, mqd);
 	tmp = RREG32(mmCP_HQD_QUANTUM);
-	tmp = REG_SET_FIELD(tmp, CP_HQD_QUANTUM, QUANTUM_EN, 1);
-	tmp = REG_SET_FIELD(tmp, CP_HQD_QUANTUM, QUANTUM_SCALE, 1);
-	tmp = REG_SET_FIELD(tmp, CP_HQD_QUANTUM, QUANTUM_DURATION, 10);
+	if (ring != &adev->gfx.kiq[0].ring) {
+		tmp = REG_SET_FIELD(tmp, CP_HQD_QUANTUM, QUANTUM_EN, 1);
+		tmp = REG_SET_FIELD(tmp, CP_HQD_QUANTUM, QUANTUM_SCALE, 1);
+		tmp = REG_SET_FIELD(tmp, CP_HQD_QUANTUM, QUANTUM_DURATION, 10);
+	}
 	mqd->cp_hqd_quantum = tmp;
 
 	/* map_queues packet doesn't need activate the queue,


