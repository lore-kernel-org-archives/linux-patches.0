Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E285B19D087;
	Thu, 25 Jul 2024 14:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919261; cv=none; b=QYYBX6mwQH4KBuid03NsigtuGVI/M+0P7Y8K1bRanY7aW0jzNIHer7nOm/GH2SlCnAbCtwDI6dWOFltXMkofFwwb9l/sRrvK1uk2n+IFZcTRYTM5afAig+QxR+t6406eZnGP/W0YCrWzX7qNkmKVKKTVCXFjZRDnTXp2xHE1Ayc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919261; c=relaxed/simple;
	bh=01Wr3pWNci7Y2LSUA2f6sR/f6WfgWU8DLof+aMD4Sn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D58N2aIRVBcvLJHhYN5zulwNM/7nM6lsnBJI/4gln7IeX2ygmC5h1PG4rd4ht95ner8KbEuvvHNgEUw43tlPszC28Fb2GtXoFZ8Qeg4JjQN2Xf3+sVgw0HzsbRFAwnbjrEc7x5djVismKf6I1BxuK8w6wrEWclyf1rjWEx2T+S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VkAV09yq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VkAV09yq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1060CC116B1;
	Thu, 25 Jul 2024 14:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919260;
	bh=01Wr3pWNci7Y2LSUA2f6sR/f6WfgWU8DLof+aMD4Sn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VkAV09yq3koT8mI+GX15IJz24C9wfX5GepVVyCkcKjyMMLPr7NdAhHpqqv7gmQQn3
	 q4j6AhDPoeptAnI5XE2md40OXq5evOoKhhXEUN5dBLm3UJfC00pthUhiSLBpzx4jSV
	 MvH3VzyixA0xrSm54HgZWQ2C6v/T+VXZPxGP8ruU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Zhou <bob.zhou@amd.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Siddh Raman Pant <siddh.raman.pant@oracle.com>
Subject: [PATCH 5.15 73/87] drm/amdgpu: Fix signedness bug in sdma_v4_0_process_trap_irq()
Date: Thu, 25 Jul 2024 16:37:46 +0200
Message-ID: <20240725142741.192590375@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142738.422724252@linuxfoundation.org>
References: <20240725142738.422724252@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2148,7 +2148,7 @@ static int sdma_v4_0_process_trap_irq(st
 				      struct amdgpu_irq_src *source,
 				      struct amdgpu_iv_entry *entry)
 {
-	uint32_t instance;
+	int instance;
 
 	DRM_DEBUG("IH: SDMA trap\n");
 	instance = sdma_v4_0_irq_id_to_seq(entry->client_id);


