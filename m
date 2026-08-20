Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3C442AF95;
	Thu, 20 Aug 2026 16:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244058; cv=none; b=C9XdaQCiTbBo1ApPj3zElbJavvbqGu/IJwnhN/+5uLfnIRbs/MHK3m7Z1Y2Rr6zE4BzHoFAFBmftlpjNpm7zKjKufMWpvLm3YeJAlDbyYsUE/3+rMQvAv2IqXuk6lmluIGJ9BugviIiG0h6RZR5x8SBgh0+1jGPxiqwjWtWpOhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244058; c=relaxed/simple;
	bh=A49vwTs69kDZ7iwOurjHXMuvU1ynv9QXqY9VJtrH/Nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qnlNqn6d8xsgjS1oLS64UlD/pPnL2b4W90DRHZBInP4GcYol9LgN3W3ZocHzyRfxdf5+QYn5UdCpSFI7nbYizNxUnq3BVjUYJQC62e5CtGtSkImJkN+gVIoWUijdiYFkodvE/uGKJtdK/s5wZpbQxQJ1SmHJvM8m6FmfrctMvBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N0jDBqYS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N0jDBqYS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2108F1F000E9;
	Thu, 20 Aug 2026 16:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244057;
	bh=hE1FLFHUkJq2A000Z5Gmev6232Wi2JuduIdHVynw9AU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N0jDBqYS5w1aVRvfcRkqDPb43D2jKIVPLDrue9WaWNEvG76LdqTqh25JBJL7cHewK
	 9wXtlE2BTJq1/TE27vD111fitmcvcDSfLMut4uL4cI6hcB/T229wjP69Vx01QyyxH8
	 EIL+3/fduhGHVFD7zpSUpjBufc+oeheJVNvOAaqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Rosca <david.rosca@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 037/235] drm/amdgpu: Reject UVD message with dimensions above 4096
Date: Thu, 20 Aug 2026 16:54:33 +0200
Message-ID: <20260820145217.559276464@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -567,8 +567,8 @@ static int amdgpu_uvd_cs_msg_decode(stru
 	unsigned image_size, tmp, min_dpb_size, num_dpb_buffer;
 	unsigned min_ctx_size = ~0;
 
-	/* Reject invalid dimensions to prevent division by zero */
-	if (width < 16 || height < 16) {
+	/* Reject invalid dimensions */
+	if (width < 16 || height < 16 || width > 4096 || height > 4096) {
 		dev_WARN_ONCE(adev->dev, 1,
 			      "Invalid UVD decoding dimensions (%dx%d)!\n",
 			      width, height);


