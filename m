Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7BCE3D8105;
	Tue, 16 Jun 2026 18:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634332; cv=none; b=mrPhdCysR9jPqMgB6IJ7MguHmbpmO824tfTx/whOV/OtR8j5LITvZ3WWfwZBq6kwxKftVl9GqQTDljmNjXS5uM6CPIO5N4rs+aKbZwepgu+B/OCww6oGvPzn9ZDl5Q+fQbLwRwFoT/WfGUWnmAKWQ0nWvuCtvL2VsuGUisX1X+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634332; c=relaxed/simple;
	bh=0XSuHKk7EP4bTyDXmJpeoRhUVH4VH4xnsxWOUATf5ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a9Kewd6IvxWuNVJwGiRnbNo7ZpMjSFR1Gjan8l7crRyQaSoZQ7JUB5Feqy34iexvpITMNj62Tekf65cGYrk23cy0GdcWObHMV/1zkdk5TmQVq2H5Jqk2p0Ya1RkziQXnNTtz8/Hyrnbn+IazJFTQemXF3mZGxwHOY7ZYkWZyRyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oiVOUzJ5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oiVOUzJ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B231F000E9;
	Tue, 16 Jun 2026 18:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634331;
	bh=LdKxbOrSdoGVpBsdbxGta7O+EGwEFriRQLw20Qr6dxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oiVOUzJ56IwmC114YvNFw/fW8SMYHWFTS9USPT8mFekpj2oK0L1fZqxlsy7FVwnQb
	 n3WlupTYTIgsuE4mPlZ+YoVJ26Vk2+vxMYoh/+kIMD9sPoGjVzKM+TYWdl3jY7p3RR
	 0GycdqHlPnw02quRWsjfRzVcbM/i3fDzgFlG3fEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 245/411] drm/amd/display: Use krealloc_array() in dal_vector_reserve()
Date: Tue, 16 Jun 2026 20:28:03 +0530
Message-ID: <20260616145113.960481695@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -291,8 +291,8 @@ bool dal_vector_reserve(struct vector *v
 	if (capacity <= vector->capacity)
 		return true;
 
-	new_container = krealloc(vector->container,
-				 capacity * vector->struct_size, GFP_KERNEL);
+	new_container = krealloc_array(vector->container,
+				       capacity, vector->struct_size, GFP_KERNEL);
 
 	if (new_container) {
 		vector->container = new_container;


