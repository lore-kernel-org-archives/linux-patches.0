Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9BD29A30A;
	Tue, 11 Nov 2025 01:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825540; cv=none; b=NxpVAWYS8jWgCLRMPFKGyHmtblqY0myrfWhDdkRIFRa/LvqRztbQrBUwZPrz4N93IQ1LSJPEd8UammV/7YBTbneSK0CsdieztQgaGkN0ylG8ePV5quIkKS1YmsyJz3FiE7491mlYbgsrxTq+jPVAYCi1sEfgbpj4uAemnxVQZpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825540; c=relaxed/simple;
	bh=2m6nStoP5wYtlJ//pevfJEPMiwDZB9NDt0qPoNMvLxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mzRwtqkzzwLkyhGsitCkgxw3Mr+1F1Sx+dKW2mjpG6Pk2mGQtS7YB3ao2kdl6pO/RgafQ4CvwBUWGBtyoM9/dLLkd4lC/cBOgggWxHrsLLbhiyc+6KTZbg0aoK/BitiGLbm5JNaA5UhXH5eDy89mBcq8YIHSdyJtTyTE8OagP+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lv6z3SRm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lv6z3SRm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67510C19422;
	Tue, 11 Nov 2025 01:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825540;
	bh=2m6nStoP5wYtlJ//pevfJEPMiwDZB9NDt0qPoNMvLxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lv6z3SRmwsAX4WwOdNU6bAo7T2ZA5y06UQ2WJyyUBBRIHnob8wszwJjzBRYqnwv/S
	 LHI1k0IzLDOkgTQX92U6ndqGS2XY9YOsjm1QUKutQRxCsmGyPalZBcx8YI4rBUaNsH
	 q6CG6OSjsj1kEVRYNYrCm2DH86NRunnfmvZapuFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prike Liang <Prike.Liang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.17 844/849] drm/amdgpu/userq: assign an error code for invalid userq va
Date: Tue, 11 Nov 2025 09:46:54 +0900
Message-ID: <20251111004556.824718318@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prike Liang <Prike.Liang@amd.com>

commit 883bd89d00085c2c5f1efcd25861745cb039f9e3 upstream.

It should return an error code if userq VA validation fails.

Fixes: 9e46b8bb0539 ("drm/amdgpu: validate userq buffer virtual address and size")
Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
@@ -71,6 +71,7 @@ int amdgpu_userq_input_va_validate(struc
 		return 0;
 	}
 
+	r = -EINVAL;
 out_err:
 	amdgpu_bo_unreserve(vm->root.bo);
 	return r;
@@ -476,6 +477,7 @@ amdgpu_userq_create(struct drm_file *fil
 	if (amdgpu_userq_input_va_validate(&fpriv->vm, args->in.queue_va, args->in.queue_size) ||
 	    amdgpu_userq_input_va_validate(&fpriv->vm, args->in.rptr_va, AMDGPU_GPU_PAGE_SIZE) ||
 	    amdgpu_userq_input_va_validate(&fpriv->vm, args->in.wptr_va, AMDGPU_GPU_PAGE_SIZE)) {
+		r = -EINVAL;
 		kfree(queue);
 		goto unlock;
 	}


