Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32FF144CF44;
	Tue, 16 Jun 2026 15:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624560; cv=none; b=kgQTAlZVeFMxWov+o3MCd+oN4Ioao4Ni6M10+wa3TVN8sT99U6jHrNdkx7PDuD8fT6pASj6zO4ORh/emKQMgHmDkfALWWjaDm738gwhs/ewXdqB9WmflBocHGoRfXc0pXZ8x7+spWJRKjkOmJn8kakwIm7lBH7jZyuC9D+x0DpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624560; c=relaxed/simple;
	bh=3N5ZVKGx/+pEtQwOZeioll6aMksYXiGE9ZFP+LvFKxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H1X2F9Nv82k9teXo8G9auoRXaWAoOYQ9K0BbT66PcEyBwVlvlsEy/weSV4eSjPXHsKCHaGbakeaRBXbvtImzOYR5YORXNx+bMAe/MgDXSB1XTzivsPhZS3bl6zWYHh0PBCUamzE7LhBl4o/n3dQyqnQ50ANsk8MAff25+NgIP/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x4l9QXHT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x4l9QXHT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D5021F00A3A;
	Tue, 16 Jun 2026 15:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624559;
	bh=wIv3bCO7koGVOiCKPPLMc0im4ueljunDGQgmGnFPqTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x4l9QXHThnmEjj16lgib7zMr5c6htOAInvIcIaZhgxzXtibkFLa5VEctVqoEgVmE1
	 Y9sE5k0Jx+nHJhA38WNlK3K5fGPTz7fQUxXNMtA5BFLD5uOH1liYRaY3FtHQ5Rgz3W
	 mXEkW6N3Ya47mMRJgSR1YB6pVRXdkIyTNOvFM8yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.0 358/378] drm/amd/display: Use krealloc_array() in dal_vector_reserve()
Date: Tue, 16 Jun 2026 20:29:49 +0530
Message-ID: <20260616145128.991808370@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


