Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D681A19AA5F;
	Thu, 25 Jul 2024 14:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918660; cv=none; b=nDQagG+azOiU3+d6FrRBUkbRraPuYH2LyYDP1xgNX280CVabHSWRp1027F2anL+iO5eulc/sV86hT2DjN2Z9JxLf/sy70YW7y6HcRaWbcMTibPSmO/KhBLkf0Uc/hD9nIvfsxWqHE4kTP08fwn4G+3pxT9wzWJEDwYJEFWdxq+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918660; c=relaxed/simple;
	bh=bfnSJhCtwOVyJG+jgpRU6YDG+NZCuFIuSND9LN6pws8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j83gZCiKb/QAZycq6jqCyvJajO4FAHDwBi3B1GPrRLtkWJHE36t9aB3cQ/m++gr3FhzJHGp8ZIkOrGofjBfvHrYClFPucqLjSCpO7BknuQ18bB+W5BIGNntMoBGVhSHlWq4QOeJUx1fqpVLkX+/sPc9q1wDAL5KSwAL9ZJBTQxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=krVa2jul; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="krVa2jul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53794C4AF0C;
	Thu, 25 Jul 2024 14:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918660;
	bh=bfnSJhCtwOVyJG+jgpRU6YDG+NZCuFIuSND9LN6pws8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=krVa2julr5Gm9+oFiJUJo3s/ovvZiS4MijL+2uf0TVgsgF6bPJ6oTfHyeQRycJ5Ge
	 1NyRsgTvVML4CyJvxCwxQk9vo4RM+C++9LmO/cV7DxTewhu7voF/CoQCpPMAGkjsz7
	 uXZZdoPnpEcOMnjsrajgujwXVGijOWM9cEV/Rmwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Zhou <bob.zhou@amd.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Siddh Raman Pant <siddh.raman.pant@oracle.com>
Subject: [PATCH 6.1 01/13] drm/amdgpu: Fix signedness bug in sdma_v4_0_process_trap_irq()
Date: Thu, 25 Jul 2024 16:37:10 +0200
Message-ID: <20240725142728.087209261@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142728.029052310@linuxfoundation.org>
References: <20240725142728.029052310@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2045,7 +2045,7 @@ static int sdma_v4_0_process_trap_irq(st
 				      struct amdgpu_irq_src *source,
 				      struct amdgpu_iv_entry *entry)
 {
-	uint32_t instance;
+	int instance;
 
 	DRM_DEBUG("IH: SDMA trap\n");
 	instance = sdma_v4_0_irq_id_to_seq(entry->client_id);


