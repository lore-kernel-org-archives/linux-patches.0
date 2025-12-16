Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699AE341AAF;
	Tue, 16 Dec 2025 12:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886781; cv=none; b=ayw+Ou4vTHidrROgVuY8YxltgkRk11Y9memgR11cGsx6gtKS28i9twwTZdSebAmS8ehAobygLkUcJwBTwAigmwLOO9oWUiw2NQzLeuW3gjJqutZH/EMveB425JRePsLV5iEoBFiXgtrN+ll3rnvYwr0vCS4Oz2UVr2niTYhROGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886781; c=relaxed/simple;
	bh=u5v6wfc4ksiWF+NWZPJwBphEcGPSh82RZkyfWfEt744=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CVac9bwKRH2rj+gk+2p9S7ueQ9S3thDtqp+VuP3r0BAnz48HQbQCfpLwq8xC3cXL1t7zc1QIELr2m4do7qCHAjUXelNURIXnfaFbPIEeruHjV47ePDEZcs76FT9f3q9AAQkV8xXHt3QYnEybXwqTIX9rMwgovoLyQnwIl4msLqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FxLTSlrW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FxLTSlrW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4424C4CEF1;
	Tue, 16 Dec 2025 12:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886781;
	bh=u5v6wfc4ksiWF+NWZPJwBphEcGPSh82RZkyfWfEt744=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FxLTSlrWEDUf9r6UNfrPk5gwGYL4xJLB/k8ZTybH8iyzFNc5sarFyK8/NvUOa/+tM
	 AWXfpfB9TpT3iYQg8puo7yxhJBp/g2vXtN/mWD5uvcEpvD85AyZgt85mORZr1L6F8+
	 NSSyXI3aVN5W6M2/VWP2OFgJEEIVoNjixZOq2g6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Maciej Falkowski <maciej.falkowski@linux.intel.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 009/614] accel/amdxdna: Fix an integer overflow in aie2_query_ctx_status_array()
Date: Tue, 16 Dec 2025 12:06:16 +0100
Message-ID: <20251216111401.634173667@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit 9e16c8bf9aebf629344cfd4cd5e3dc7d8c3f7d82 ]

The unpublished smatch static checker reported a warning.

drivers/accel/amdxdna/aie2_pci.c:904 aie2_query_ctx_status_array()
warn: potential user controlled sizeof overflow
'args->num_element * args->element_size' '1-u32max(user) * 1-u32max(user)'

Even this will not cause a real issue, it is better to put a reasonable
limitation for element_size and num_element. Add condition to make sure
the input element_size <= 4K and num_element <= 1K.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/dri-devel/aL56ZCLyl3tLQM1e@stanley.mountain/
Fixes: 2f509fe6a42c ("accel/amdxdna: Add ioctl DRM_IOCTL_AMDXDNA_GET_ARRAY")
Reviewed-by: Maciej Falkowski <maciej.falkowski@linux.intel.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://lore.kernel.org/r/20250909154531.3469979-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/aie2_pci.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/accel/amdxdna/aie2_pci.c b/drivers/accel/amdxdna/aie2_pci.c
index 87c425e3d2b99..6e39c769bb6d8 100644
--- a/drivers/accel/amdxdna/aie2_pci.c
+++ b/drivers/accel/amdxdna/aie2_pci.c
@@ -898,6 +898,12 @@ static int aie2_query_ctx_status_array(struct amdxdna_client *client,
 
 	drm_WARN_ON(&xdna->ddev, !mutex_is_locked(&xdna->dev_lock));
 
+	if (args->element_size > SZ_4K || args->num_element > SZ_1K) {
+		XDNA_DBG(xdna, "Invalid element size %d or number of element %d",
+			 args->element_size, args->num_element);
+		return -EINVAL;
+	}
+
 	array_args.element_size = min(args->element_size,
 				      sizeof(struct amdxdna_drm_hwctx_entry));
 	array_args.buffer = args->buffer;
-- 
2.51.0



