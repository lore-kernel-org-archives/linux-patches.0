Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48FCD2931C0;
	Thu, 20 Aug 2026 17:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247924; cv=none; b=MBBHFBUH9e1R8sQZx9GpdszsMfTc3+iWM71WimbTKE0mGD61lp+SdQ2c2wWiBK674Sta1i5UjmvZRkEl5REL6mBb1chcPLdMwPgBR6uyR6PIvS70NkPqCZVED4Ff0TUhbLYBj6BHgNQfJeYQJbpXJicEKkAgqwThK3MnQ34olVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247924; c=relaxed/simple;
	bh=lBjAM74HOLTupvngKkQAhqBhF98c0MMEoZoEeRXm+yU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mo9TcVa6m/nASusuuhyEyXMm2mMdenyeS3/1E7Ae9yN8+k59tv59nEoT7ZOxnYGSi99GLkpU67vSSVXCof5meTTpzni63qWVD8v83ug/yghttZuCEHNTlutXmVNNWBiMiZuexppypz5z/rptfzx76oOQE3yDbCB2P3x5otUTvUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oGd7qaAw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oGd7qaAw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F911F000E9;
	Thu, 20 Aug 2026 17:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247923;
	bh=UgrZIT2w/MYF6L7SZ5noinNvYj7qtKpa9x0ExrY2NyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oGd7qaAwSxMsta0Ahu1Zv1JzSevJEq3qiwjSWCmwrsi9JzZ8+3jVpmCSP2EpA5F+8
	 3mPrjoZzE0BOABC/mnLxvxB2MypqYh++qqIAlKhxC57jyHReunLkH2S+oKLqexZvGn
	 zBS/Ee8/omc0jAPUaD9h4p3xZAkjg22D2nXn3Hjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Rosca <david.rosca@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 048/303] drm/amdgpu: Reject UVD message with dimensions above 4096
Date: Thu, 20 Aug 2026 16:53:04 +0200
Message-ID: <20260820145254.619179148@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

From: David Rosca <david.rosca@amd.com>

commit 8c9aebcdd9f46f7a14b98d6ab18574b7a48fbb08 upstream.

Fixes potential overflow in DPB size calculations.

Signed-off-by: David Rosca <david.rosca@amd.com>
Acked-by: Leo Liu <leo.liu@amd.com>
Reviewed-by: Ruijing Dong <ruijing.dong@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 05e1387d151f71569fbe122d2c89f9db0c21dc10)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
@@ -630,8 +630,8 @@ static int amdgpu_uvd_cs_msg_decode(stru
 	unsigned image_size, tmp, min_dpb_size, num_dpb_buffer;
 	unsigned min_ctx_size = ~0;
 
-	/* Reject invalid dimensions to prevent division by zero */
-	if (width < 16 || height < 16) {
+	/* Reject invalid dimensions */
+	if (width < 16 || height < 16 || width > 4096 || height > 4096) {
 		dev_WARN_ONCE(adev->dev, 1,
 			      "Invalid UVD decoding dimensions (%dx%d)!\n",
 			      width, height);


