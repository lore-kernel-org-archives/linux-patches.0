Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16833469E3;
	Wed,  3 Dec 2025 16:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779705; cv=none; b=tqgBEfVByiG8264xGZFlCUtiwlIG3BwGX3fYFAU8HILMK8iIks6rFcgPMSjPU7ugVWMSvuidH7YTCVCRwXpB65/EfD4thBgJP4N34zTHwcU/VPbX7rwoihKgYU76/0F3MWRY+Ly6q2THREIIOu6MHML+DISTCQvQdZL6g9QDNbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779705; c=relaxed/simple;
	bh=sjMbLp9WqDowPUq2UPZrAxl1+2wMRdh52BWvoC/Ko6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rvHaOGMQ1FsfrwCGbtG3vkArAv4L5V4VYjGdVUD1i6zDgPe2m7BzdUvMGm5yqpcjuFLQcisZulZiVmFxjpCpED7MfztxWDSP+lXsaggf3GVj/rL+ytmFEfawIXPk+x1I1bfCbUcdJLakREao3rLI6KRgIJYLAp4As1ZejfvqqKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZT2Q7xUz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZT2Q7xUz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A47C16AAE;
	Wed,  3 Dec 2025 16:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779705;
	bh=sjMbLp9WqDowPUq2UPZrAxl1+2wMRdh52BWvoC/Ko6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZT2Q7xUzTgqPH+11GBh9kPrl9c9d0ZzKRzzoSp2M+9P7cWKBROpDfXoIfVUfOiwjX
	 dsXKivLfNSEpBQxUSIksvKOb9Bxk67L/pJu8d4D1PYZu2rzC9g78kFu4zxnfhQUHFk
	 uTQAOR7iDCIrLDpbDABjhAL/VXomqz9G8quKBuLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 336/568] drm/amd: Fix suspend failure with secure display TA
Date: Wed,  3 Dec 2025 16:25:38 +0100
Message-ID: <20251203152453.015472463@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit b09cb2996cdf50cd1ab4020e002c95d742c81313 ]

commit c760bcda83571 ("drm/amd: Check whether secure display TA loaded
successfully") attempted to fix extra messages, but failed to port the
cleanup that was in commit 5c6d52ff4b61e ("drm/amd: Don't try to enable
secure display TA multiple times") to prevent multiple tries.

Add that to the failure handling path even on a quick failure.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4679
Fixes: c760bcda8357 ("drm/amd: Check whether secure display TA loaded successfully")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 4104c0a454f6a4d1e0d14895d03c0e7bdd0c8240)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index e22eaf9d450d3..9153459455910 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -1962,8 +1962,11 @@ static int psp_securedisplay_initialize(struct psp_context *psp)
 	if (!ret && !psp->securedisplay_context.context.resp_status) {
 		psp->securedisplay_context.context.initialized = true;
 		mutex_init(&psp->securedisplay_context.mutex);
-	} else
+	} else {
+		/* don't try again */
+		psp->securedisplay_context.context.bin_desc.size_bytes = 0;
 		return ret;
+	}
 
 	psp_prep_securedisplay_cmd_buf(psp, &securedisplay_cmd,
 			TA_SECUREDISPLAY_COMMAND__QUERY_TA);
-- 
2.51.0



