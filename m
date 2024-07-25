Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAD98468;
	Thu, 25 Jul 2024 14:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918759; cv=none; b=OrBWsZE5aKrHMXvE/+83CFzi0qlsdACDbAzDGn6vlWh8bpLR1bRCCz4HwN89ZgSI+TX79BYwQiQOpEb5Q+3GHCYGBS1PxelDcyvUxyB05775iw0c5uuSQY1jtwSA+FFf2sHTPjv+rv+bHE7hrU48VYnWgjfxTGu+F5lvaXc7wx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918759; c=relaxed/simple;
	bh=4WIXVWztvjgBCWti4waoQpWoQDXun46DqzjMSOUeGuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tiKsSixDzZNX45wlxo/HUg2AjsfgzAhlrV3jszdst531GXVzXzYz2VpslTjVftMj9DiSq86aZsn5z8XmRj+PYIa+ckRLZzPrR9nmke3OcC1cxUilYoI3MLwnL+GsXmu0ArBKCJSIJgO4d8KnYWXxYPl75FAhP/U5qzSozS2GWkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oD3SktKs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oD3SktKs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34BA9C116B1;
	Thu, 25 Jul 2024 14:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918759;
	bh=4WIXVWztvjgBCWti4waoQpWoQDXun46DqzjMSOUeGuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oD3SktKsqmKvrYU1fCGWDE1Ru63wuKic+z2JAcSj6lpzymImBl7WrcqJMkT/VpdPy
	 pDX7rIT+AmCdcJRPmMhrXvwLz8dB3VLjdOglKYZey6kSfpApNOCRKK6XD7qjJMiAR9
	 f8AHX7KhdAVmUYKhz/u2eAOYu9aZ6mck3DEFw+N8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Zhou <bob.zhou@amd.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Siddh Raman Pant <siddh.raman.pant@oracle.com>
Subject: [PATCH 6.9 01/29] drm/amdgpu: Fix signedness bug in sdma_v4_0_process_trap_irq()
Date: Thu, 25 Jul 2024 16:37:11 +0200
Message-ID: <20240725142731.736351433@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142731.678993846@linuxfoundation.org>
References: <20240725142731.678993846@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 6769a23697f17f9bf9365ca8ed62fe37e361a05a upstream.

The "instance" variable needs to be signed for the error handling to work.

Fixes: 8b2faf1a4f3b ("drm/amdgpu: add error handle to avoid out-of-bounds")
Reviewed-by: Bob Zhou <bob.zhou@amd.com>
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Siddh Raman Pant <siddh.raman.pant@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
@@ -2017,7 +2017,7 @@ static int sdma_v4_0_process_trap_irq(st
 				      struct amdgpu_irq_src *source,
 				      struct amdgpu_iv_entry *entry)
 {
-	uint32_t instance;
+	int instance;
 
 	DRM_DEBUG("IH: SDMA trap\n");
 	instance = sdma_v4_0_irq_id_to_seq(entry->client_id);


