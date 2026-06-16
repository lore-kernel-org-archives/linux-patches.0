Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF073A16AC;
	Tue, 16 Jun 2026 16:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626327; cv=none; b=ov/B1DEGdupC1Jd4jmSOJXTTBV28sCzcB2RPrU6OX1cZ33KvdbDrp3PamHY+S+8NtUZwKewIkmqasKbpRPfLixSdKY2hmv1598LL21w7pVkrAlVA19md5e3o9zEDK/xbmmvwISJ5OEDrHcV+jFiue6oBZ0gEVUYEWrY7f8Q35u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626327; c=relaxed/simple;
	bh=LrfG1ta2MlTN1oEE3sTu77kFsV/DAZI5RvDk8vLROKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RV1gk2CsslA7PbMU4hEHu+FOIP4alm76YLOkgNkwOvsq7UR9LBgY7ZvLMQVMPAmF9gLnd4rLTBpQACOf0+zBM/aLpNIO6utLjYtl3hV9RaDhLuhFJzcQdeb5lSwt3tszpIv4FnPFrJHyuFUn4hyXF1YDCI6QrA562LBTnYYAh3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KE0D4aS1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KE0D4aS1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 570DD1F000E9;
	Tue, 16 Jun 2026 16:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626326;
	bh=lAtFJHATujh6Wi3s9zypPPsQfonDxGIPfIBXcmH8nk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KE0D4aS1zVlIE1eaGiTdCPYYghwq+y82ZrXaJbHHRPszxYHS2iOQOqGar6ssRehz6
	 6bpjlPN9qlC2lZSIo8IAlbZ06TATNeCm7I2H24aikLzcV/Lq5bPU8IiM3HefZu7g/f
	 7HiNFLftqUJMGgVUJ0jlXaPEpyT+R8e9ZHzhUV/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 303/325] drm/amd/display: Use krealloc_array() in dal_vector_reserve()
Date: Tue, 16 Jun 2026 20:31:39 +0530
Message-ID: <20260616145114.053396367@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

From: Harry Wentland <harry.wentland@amd.com>

commit da48bc4461b8a5ebfb9264c9b191a701d8e99009 upstream.

[Why & How]
dal_vector_reserve() computes the allocation size as
"capacity * vector->struct_size" using uint32_t arithmetic, which can
silently wrap to a small value on overflow. This would cause krealloc to
return a smaller buffer than expected, leading to heap overflows on
subsequent vector appends.

Replace krealloc() with krealloc_array() which performs an internal
overflow check and returns NULL on wrap, preventing the issue.

Fixes: 2004f45ef83f ("drm/amd/display: Use kernel alloc/free")
Assisted-by: Copilot:claude-opus-4.6
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 37668568641ccc4cc1dbca4923d0a16609dd5707)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/basics/vector.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/basics/vector.c
+++ b/drivers/gpu/drm/amd/display/dc/basics/vector.c
@@ -288,8 +288,8 @@ bool dal_vector_reserve(struct vector *v
 	if (capacity <= vector->capacity)
 		return true;
 
-	new_container = krealloc(vector->container,
-				 capacity * vector->struct_size, GFP_KERNEL);
+	new_container = krealloc_array(vector->container,
+				       capacity, vector->struct_size, GFP_KERNEL);
 
 	if (new_container) {
 		vector->container = new_container;


