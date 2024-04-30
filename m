Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9F38801;
	Tue, 30 Apr 2024 11:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475590; cv=none; b=ghQNFhyTggeXi4b+Vxxk6dwW8b9LL0+jk/kVBzyY+S97196WMXvpb2U2iVYcQfpiS1g8/nlAUcPdeFOxKvN7DiKiPTckal5B90fdJY1dBh0GFsL55xUsk7IZugJFz961ww/D/x5cIX1QFpdYyU9Iim9WWQZ0yOONKp4MiC2nNWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475590; c=relaxed/simple;
	bh=9JmD5si2/W5mxS5MU4youPPHtWdjdGBebuWYqQLmSGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qZmIsyKwSIDyzVzae74YVq/wNpQQUKELnrb34iOhUX+aX/rdEBUD2Qdg/YOSEjv7nYcHcwKqf+FRb270Y/him73J0FophiAvO7cGRXtbDKaj2o3aH2bTo2fifKKkmUim9Z88ElCfLW5FZarZmHJRP7f4Aj44fzBDprP7O0+eTbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zQokegoc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zQokegoc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEBF1C2BBFC;
	Tue, 30 Apr 2024 11:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475590;
	bh=9JmD5si2/W5mxS5MU4youPPHtWdjdGBebuWYqQLmSGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zQokegoccKpCvqZVrglfvoXz5oMr8WpDNmVjk/3NuJNvXtAvtbOPBnilPqFT/zQ9S
	 uXLJeV7M8i8PsesuPxpkZbsIWWOu5HQnwbnL9tA2SyAYi7/CabRO2zU2ECoTI2nUcf
	 /FYF5+Dxm5zaU0FDlp8ZgAbwn+uCyIFuAIj5/qsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukul Joshi <mukul.joshi@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 143/186] drm/amdgpu: Fix leak when GPU memory allocation fails
Date: Tue, 30 Apr 2024 12:39:55 +0200
Message-ID: <20240430103102.184499360@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mukul Joshi <mukul.joshi@amd.com>

commit 25e9227c6afd200bed6774c866980b8e36d033af upstream.

Free the sync object if the memory allocation fails for any
reason.

Signed-off-by: Mukul Joshi <mukul.joshi@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1785,6 +1785,7 @@ err_node_allow:
 err_bo_create:
 	amdgpu_amdkfd_unreserve_mem_limit(adev, aligned_size, flags, xcp_id);
 err_reserve_limit:
+	amdgpu_sync_free(&(*mem)->sync);
 	mutex_destroy(&(*mem)->lock);
 	if (gobj)
 		drm_gem_object_put(gobj);


