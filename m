Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684813A641D;
	Thu, 30 Jul 2026 14:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423240; cv=none; b=o7MYNHlqMSxh3b+qD27w8VGcbyMagMzu+fSCiXMbZ9OMqmJVtq4PdrAVJoY0Ev9Bb4fc6NOdJr6EVobA0lbighAcU/qgcWAyGEMGVvn4jYCu9DhH0loYOAVf7B6pPThUX1hJWu0M26EXm5/Gq5uNDggwXMqWblin9QlEGZ43Vqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423240; c=relaxed/simple;
	bh=OCKCXrHcyF1opJcg6oX4SRFqkYwSBOEVHPdjRaIc3vE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BmKyNKoKsTXlwIMA8VGKW0WZGXG0I1ttG1KJgdPc4Jl0HNY9zPd49JyCvlZ3p//OQru9yAl4WFN/MqXUAmHxial14Q8oZqvERGm2E3SAILxNGnFqy4Ptu8wVoMmvO1cfUPYb6bgl/NVdNEHaiL8vSpDR8QeUkMqTPgO/R8YhCN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vn1j3AwR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vn1j3AwR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD74D1F000E9;
	Thu, 30 Jul 2026 14:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423239;
	bh=i4Tn0KRfXHHxPcrY1tClRlPVCQFm/kn/Lj3g3v4ovnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vn1j3AwRzBdPYuxy6HkoLUR1pYvUkIi/TUO+nF7F4YW6AfjOb8iIwOBZoWCdZpWws
	 UO1xgZ8mThKJqRy8klmdcXrkTSo1Yfv2QidpSrmxHPyerjOmlbUrcFBPY1FFHWxYDc
	 ZUemdxUx77fu3vYWP1pmdB1NAOFoc6b3qdFc5l/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Lingshan <lingshan.zhu@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 715/744] drm/amdgpu: reject mapping a reserved doorbell to a new queue
Date: Thu, 30 Jul 2026 16:16:28 +0200
Message-ID: <20260730141459.476585709@linuxfoundation.org>
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

From: Zhu Lingshan <lingshan.zhu@amd.com>

commit a609b6278bf3cde17eeee6620091465521e4b02c upstream.

When creating an user-queue, the user space
provides a doorbell BO handle and an offset within
the bo to obtain a doorbell.

However current implementation using xa_store_irq()
to store a doorbell, which allows a later queue created
with the same BO and offset parameters to overwrite an
existing queue and doorbell mapping.

This can cause problems like misrouting fence IRQ
processing to a wrong queue, and mislead the cleanup
process of one queue erasing the mapping of another queue.

This commit fixes this issue by replacing xa_store_irq with
xa_insert_irq, which rejects mapping a reserved
doorbell to a newly created queue

Signed-off-by: Zhu Lingshan <lingshan.zhu@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 6244eae22966350db52faf9c1369d3b2ffc5de4e)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
@@ -689,8 +689,8 @@ amdgpu_userq_create(struct drm_file *fil
 	/* Update VM owner at userq submit-time for page-fault attribution. */
 	amdgpu_vm_set_task_info(&fpriv->vm);
 
-	r = xa_err(xa_store_irq(&adev->userq_doorbell_xa, index, queue,
-				GFP_KERNEL));
+	r = xa_insert_irq(&adev->userq_doorbell_xa, index, queue,
+			  GFP_KERNEL);
 	if (r)
 		goto clean_mqd;
 


