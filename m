Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241F8FC19;
	Thu, 25 Jul 2024 14:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919000; cv=none; b=LB/IP2Bdb57fcOPfIgRdq9Ye856xBkMXKrQaL60J6UvnPGvtLh1E9VH0pMGlt+7TT8j/I20zMHVMLQ5ww/tmTHI6oNgT0V8ec8E9ntw2Y6igxAK/mlkwI3w1Wsh7P/+jRq8g1V15Bj2YEOUd3NQIGvrKaxZC0MlpBep/UjcW5WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919000; c=relaxed/simple;
	bh=qTJikoGy3Hf8OKZMcc13FnbQNP+HZ1i5gVTQL3J1y20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h94t4NArJzZW0g78SxLLz/CWRoyxCcfKJOUofJ6o8XHKf6GiI/mnu6m0pXajtSvsvRuFcMRcJgk0xMhvSVmiD9XqurweQnovErdU7MYKNGvsOgAofo5JFtNuFLVXi1+H6VYot6wW24oCRDbnITnjyUa99DmIW3QlFQXuB8OYvLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E3QO2MB9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E3QO2MB9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FEE2C116B1;
	Thu, 25 Jul 2024 14:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919000;
	bh=qTJikoGy3Hf8OKZMcc13FnbQNP+HZ1i5gVTQL3J1y20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E3QO2MB9Q5KDGAKiObl6V3BSx+mVnyrK+fXTg7REx/jkf9FCI1M8kNvKbVYG2rzWl
	 ZeCu5t2tfdienLd5DUFCsY8Wnx1yN85oyDXVeKMB2dtYdR/UpfEA8INexHV4lVci3b
	 hma9/yAjYLtxkhtU96kYlJ3ZiwSnub4QTl7x8H+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Zhou <bob.zhou@amd.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Siddh Raman Pant <siddh.raman.pant@oracle.com>
Subject: [PATCH 5.10 51/59] drm/amdgpu: Fix signedness bug in sdma_v4_0_process_trap_irq()
Date: Thu, 25 Jul 2024 16:37:41 +0200
Message-ID: <20240725142735.184338562@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142733.262322603@linuxfoundation.org>
References: <20240725142733.262322603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2069,7 +2069,7 @@ static int sdma_v4_0_process_trap_irq(st
 				      struct amdgpu_irq_src *source,
 				      struct amdgpu_iv_entry *entry)
 {
-	uint32_t instance;
+	int instance;
 
 	DRM_DEBUG("IH: SDMA trap\n");
 	instance = sdma_v4_0_irq_id_to_seq(entry->client_id);


