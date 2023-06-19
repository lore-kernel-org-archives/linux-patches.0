Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD8710944
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:35:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCF17C433CC;
	Mon, 19 Jun 2023 10:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687170908;
	bh=pp30uccY/S7yXCXQWq8vn19ZLjHq3aAbNKyLFjSt3fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rGcJsjmJ6qjF1oNgZ7eiFvTdSOXqZFWUjm0XkhmIn/J0bk3RFsVOI+pObJxX1ZdSc
	 joG6HxFA9k81UzvNMs39j6w5iRCLWXmOssGzu/V/iwbCpY6KffXFgFGlCkNymbpbm0
	 Odx4/8dSI76zXHV6qLPp1sf8zxchS1UfNPXV/zns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sonny Jiang <sonjiang@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.3 079/187] drm/amdgpu: vcn_4_0 set instance 0 init sched score to 1
Date: Mon, 19 Jun 2023 12:28:17 +0200
Message-ID: <20230619102201.443660819@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sonny Jiang <sonjiang@amd.com>

commit 9db5ec1ceb5303398ec4f899d691073d531257c3 upstream.

Only vcn0 can process AV1 codecx. In order to use both vcn0 and
vcn1 in h264/265 transcode to AV1 cases, set vcn0 sched score to 1
at initialization time.

Signed-off-by: Sonny Jiang <sonjiang@amd.com>
Reviewed-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
@@ -129,7 +129,11 @@ static int vcn_v4_0_sw_init(void *handle
 		if (adev->vcn.harvest_config & (1 << i))
 			continue;
 
-		atomic_set(&adev->vcn.inst[i].sched_score, 0);
+		/* Init instance 0 sched_score to 1, so it's scheduled after other instances */
+		if (i == 0)
+			atomic_set(&adev->vcn.inst[i].sched_score, 1);
+		else
+			atomic_set(&adev->vcn.inst[i].sched_score, 0);
 
 		/* VCN UNIFIED TRAP */
 		r = amdgpu_irq_add_id(adev, amdgpu_ih_clientid_vcns[i],


