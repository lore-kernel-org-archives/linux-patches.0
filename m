Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D6A1494DB;
	Thu,  5 Sep 2024 10:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530519; cv=none; b=tbZDZdprHfj846ugei9G8xBamSCaVMybuDgFbPXyvwsm+5iOzXbBxsGsB5drsfSxouXvvd2MtG163Jpnxd9qTBxosBhkiY2WTU+oCkRlZCzMKPT42bd85mefeb2xUqd8MiGnRLh7kN3+kzzQoEZnwRSYSeTXQoXatWJ8b1Sua+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530519; c=relaxed/simple;
	bh=P9ciHimHvFuh06KeD0J5amSrcAvasmUeq0XtjdhI2qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hyP5/tnhhi+J6XtJrnF9avbrfaDZ+ZtDnK82jdxcztQ/KC+bIb0JlyiUOQeLgJM9VkAoq2DVYx7+z96yRuKBBySDNFuv7yo9xtRrnelZMv9+zhtrXARjCJf6UEsRIwJ8XILrOHAxuMgrdkT0GMYv6uGU/fr49opfsC9U/+MvgZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SVq4PZcd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SVq4PZcd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 038ABC4CEC3;
	Thu,  5 Sep 2024 10:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530519;
	bh=P9ciHimHvFuh06KeD0J5amSrcAvasmUeq0XtjdhI2qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SVq4PZcdyK/mu25+CnRGeBeCnmoPWzYyEutUTNpCH1QvD4kgbiGFt1tkJwjpE2FWs
	 k20QoyFjRuqSscSgmWlNH2cNkRJywQxlvTJ5ae9/FzDlahQxvua5lKVc3e94gwMjGW
	 O0eCVhv532wQvL2szaP7g2hCr5tQw7dMsu81Q6gk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asad Kamal <asad.kamal@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 049/101] drm/amd/amdgpu: Check tbo resource pointer
Date: Thu,  5 Sep 2024 11:41:21 +0200
Message-ID: <20240905093718.056407701@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asad Kamal <asad.kamal@amd.com>

[ Upstream commit 6cd2b872643bb29bba01a8ac739138db7bd79007 ]

Validate tbo resource pointer, skip if NULL

Signed-off-by: Asad Kamal <asad.kamal@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 4d1c2eb63090..1319fdd37e7a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4560,7 +4560,8 @@ static int amdgpu_device_recover_vram(struct amdgpu_device *adev)
 		shadow = vmbo->shadow;
 
 		/* No need to recover an evicted BO */
-		if (shadow->tbo.resource->mem_type != TTM_PL_TT ||
+		if (!shadow->tbo.resource ||
+		    shadow->tbo.resource->mem_type != TTM_PL_TT ||
 		    shadow->tbo.resource->start == AMDGPU_BO_INVALID_OFFSET ||
 		    shadow->parent->tbo.resource->mem_type != TTM_PL_VRAM)
 			continue;
-- 
2.43.0



