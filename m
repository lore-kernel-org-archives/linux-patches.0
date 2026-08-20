Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95813BCD3B;
	Thu, 20 Aug 2026 15:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239535; cv=none; b=d4jfTOs2ehROZY9/Mboj9xgfMZ4mlfr1wdIwdx9WODYILCDufRI70RCLS5FrF2j111s/W+mzZyyMCHXMv7Zz2hVwUdiiGC+sSSklmKewubsOYeYPaGRrW1zgTwTr7i38QnXegukxtN9yfHWA8QDvOkePMKLNZkj7fQNUp8RR20s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239535; c=relaxed/simple;
	bh=fcB0j0FyzxzZNrBELQWsHbq60eSN8o/CZdJ/6J0hkgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lk8zcZ0oEGGOsHPhmgBnJg+mukNyV2addnDYxZYmjSDJdlwma8zp1sVainFArfDK92pFnVvEJfGMof2SO0jU31jaJhumDPXnkPhxHir9Y7/4Yr5OkmEvF+VoaagKy50bLYw0R/BGNH+HhTuX/8bUFygC6e4M4aeN0pJMyNBhqdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z+HfPcmr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z+HfPcmr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC5661F000E9;
	Thu, 20 Aug 2026 15:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239533;
	bh=0pNF8KAiiaQ5AT80HQJPxGCwwxusu47DTn35zgzzy0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z+HfPcmrSyi7ji4K8OTByOSJvr9gJlw+VFs0jGpdTn7t45lIdl4VA8jBkWbfqy9m7
	 dmxlkdJb4oatgPcMYPycnVVmPHMv9deZ8DPBeI6otzEL7dnXqvZsorROWFEMKiIBma
	 qTQOhmGY6z/OCF+ugn+tV6jkbIqUmfIyUxOoQC4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Rosca <david.rosca@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 082/220] drm/amdgpu: Reject UVD message with invalid number of h265 refs
Date: Thu, 20 Aug 2026 16:54:32 +0200
Message-ID: <20260820145225.949016937@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Rosca <david.rosca@amd.com>

commit 9fca434208f1f9ab977feac62df8ebb1cc7ce893 upstream.

Same change as for h264, avoids overflow later when calculating
min dpb size.

Signed-off-by: David Rosca <david.rosca@amd.com>
Reviewed-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit a4b0720e4f1601f97f59a2be9c1b4b94fa6527d5)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
@@ -802,6 +802,9 @@ static int amdgpu_uvd_cs_msg_decode(stru
 		image_size = ALIGN(image_size, 256);
 
 		num_dpb_buffer = (le32_to_cpu(msg[59]) & 0xff) + 2;
+		if (num_dpb_buffer > 17)
+			return -EINVAL;
+
 		min_dpb_size = image_size * num_dpb_buffer;
 		min_ctx_size = ((width + 255) / 16) * ((height + 255) / 16)
 					   * 16 * num_dpb_buffer + 52 * 1024;


