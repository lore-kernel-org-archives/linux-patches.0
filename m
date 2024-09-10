Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40CB19EEB4;
	Tue, 10 Sep 2024 10:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963447; cv=none; b=RUDvR57dKAc5HX+xpfArIi9G99Cfe5KFhn4T7qTTXfg3WFfOcykVI8CJQw+5CTrLcqpEPoX+Y4en13n/mIl8Bs2++N1YeDwLUgEd2sk+BrnXjyqgjLI4RaGZAsQgWR5W3ZnFs9nIOjJ4/g3eYiQ3ib9tlmNf9jh5zryS2RsZWLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963447; c=relaxed/simple;
	bh=G7rJmVe3mZBW0b6oq/WCplhGfENX794JUXrtZfMz4Do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B9VX/HoB3hFR6gZfPfFyP6JLp4G6X6y4WEEF4wRDN4fBcH2mMZW/wUHAlNGxTlh25pxpntPUpTpzpPnNpbXt3WF2DTvVPp+QAJsVayalBljpxJx6tdvLddNCaTxjgPOo6AZK14jaTejF3PSOT+fU1j2xHknEtIet3CCWbn2NCcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1HE9kJKX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1HE9kJKX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0868EC4CEC3;
	Tue, 10 Sep 2024 10:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963447;
	bh=G7rJmVe3mZBW0b6oq/WCplhGfENX794JUXrtZfMz4Do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1HE9kJKXVflB1n9MWzHseDNrNLTAj+HI/woXQ5hrnpvoYeGvR2NBseY5KyS9eYOjx
	 UIOX5qdUVPRYWDM2rgnfcj2l3sWRuLsiLpb/DCveonzdWZbH5b+iyQXRUPa4bkj83v
	 yq42psivGT2oczS0Z1mJ1ojj/ktr72koKTMqDZaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asad Kamal <asad.kamal@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 023/214] drm/amd/amdgpu: Check tbo resource pointer
Date: Tue, 10 Sep 2024 11:30:45 +0200
Message-ID: <20240910092559.722242382@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 300d3b236bb3..042f27af6856 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4406,7 +4406,8 @@ static int amdgpu_device_recover_vram(struct amdgpu_device *adev)
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



