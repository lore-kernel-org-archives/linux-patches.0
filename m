Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B517E186E20;
	Mon, 12 Aug 2024 16:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479321; cv=none; b=JjdGKspMdI+ur+qbGJEbzegPBb4CdeW6HfSTNpJyK7ZmqTJCZcm9JZ60TaxbH4df7KueDViQyteDuycbwHByfryc+lXSXWzIqtH5DDRJvZ7OB7PAyM00p/1MQi2I/QIRQmTg+S+LE2Sea/OXJ1JvZ7okY7ZeWL1iNSoVSUmLeAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479321; c=relaxed/simple;
	bh=aHS5+CrPnCBL7QWhTl/mg8LIAVucJ/lkTWJAKlFpUdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ndFBMrtgMoYzmx7QZIrywEivk/KZWfEI1i7oi5NlOb7EK9CIu+42F/L0YAOSOue4lzw4wusIUKsDsPUrnfi6vOURXKYxrA0IuJSkrj0FOMHrDKuH7XoITOTV2AFKw9xlrXl5fWyvkOHS8aYk6uA8opGnKYk0urvXru68x2GKNcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HOZQjVOJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HOZQjVOJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC917C32782;
	Mon, 12 Aug 2024 16:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479321;
	bh=aHS5+CrPnCBL7QWhTl/mg8LIAVucJ/lkTWJAKlFpUdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HOZQjVOJgLWisEBxioqydI4kjUjaBhpY/sOHw/gENxuJEms3e8Wq3Vz+DrhmuzHB5
	 uyY1h9JMx5ngrLuXO5uKii9qS3b2dMOuGv/HkeDEdLYRZnxEqMzOyXO21zyhHonZgD
	 xSgrk0EaNFDLlXH3jTaufSYtDMD2deYzFPKwlNFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 050/189] drm/amdgpu: fix potential resource leak warning
Date: Mon, 12 Aug 2024 18:01:46 +0200
Message-ID: <20240812160134.069786762@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Huang <Tim.Huang@amd.com>

[ Upstream commit 22a5daaec0660dd19740c4c6608b78f38760d1e6 ]

Clear resource leak warning that when the prepare fails,
the allocated amdgpu job object will never be released.

Signed-off-by: Tim Huang <Tim.Huang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c
index 349416e176a12..1cf1498204678 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_sdma.c
@@ -102,6 +102,11 @@ static int amdgpu_vm_sdma_prepare(struct amdgpu_vm_update_params *p,
 	if (!r)
 		r = amdgpu_sync_push_to_job(&sync, p->job);
 	amdgpu_sync_free(&sync);
+
+	if (r) {
+		p->num_dw_left = 0;
+		amdgpu_job_free(p->job);
+	}
 	return r;
 }
 
-- 
2.43.0



