Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C95328B7DB;
	Tue, 17 Mar 2026 17:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767901; cv=none; b=RRiNEIMKNjWJjod5x30h1044sBl6fIhJwukrEJ5QFT+ICKUUwlAcutEPAPfdCne7sgGo4+Wpeq5gLzAptohQDvXoKW3Lyzmg18R6Oca13t8GA9VJQ5GVQwI5vp30hQyzQCqdNHOvC41ry4TI0GFbi7TTXzjGLnH9fwLnWO7r/iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767901; c=relaxed/simple;
	bh=nRC8kkjNKP7NplvOmBcxC5Brtf02xKo9XTHuXrz1HmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=acg2LvMqCC4HxA6QRBm//kbVEHxZoFXEIwnxLk6hSTsYfXKOV+6H9G6s6uuIf1b3BE67fcCdZ1iynlqXIO5jxX4ByN0Xca1HFGomrrKmeSVNOmqKnHIuxc2Txeos+vkJhJ01IpyhaQkfIAa/I7tJqPFSOKmeX0btnh7B1Nu1hx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wst3W59H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wst3W59H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B288BC4CEF7;
	Tue, 17 Mar 2026 17:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767901;
	bh=nRC8kkjNKP7NplvOmBcxC5Brtf02xKo9XTHuXrz1HmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wst3W59HKUxBUPy1u3q1b8y4NOP26fpMgtfr7liWnuVROML46uLtTXCKCiXt1kN3L
	 NYYm5nxcIUCq3TPIrerPXj29N5Ztyqcbi3iFCslfI24a3eSXGmImeDy2RZeU3Thwu/
	 najoRJCFlOQl+EDl4I+u3UxwISdFDwmV6uSPVX0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunil Khatri <sunil.khatri@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 185/333] drm/amdgpu: add upper bound check on user inputs in wait ioctl
Date: Tue, 17 Mar 2026 17:33:34 +0100
Message-ID: <20260317163006.216154779@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sunil Khatri <sunil.khatri@amd.com>

commit 64ac7c09fc44985ec9bb6a9db740899fa40ca613 upstream.

Huge input values in amdgpu_userq_wait_ioctl can lead to a OOM and
could be exploited.

So check these input value against AMDGPU_USERQ_MAX_HANDLES
which is big enough value for genuine use cases and could
potentially avoid OOM.

v2: squash in Srini's fix

Signed-off-by: Sunil Khatri <sunil.khatri@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit fcec012c664247531aed3e662f4280ff804d1476)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
@@ -667,6 +667,11 @@ int amdgpu_userq_wait_ioctl(struct drm_d
 	if (!amdgpu_userq_enabled(dev))
 		return -ENOTSUPP;
 
+	if (wait_info->num_syncobj_handles > AMDGPU_USERQ_MAX_HANDLES ||
+	    wait_info->num_bo_write_handles > AMDGPU_USERQ_MAX_HANDLES ||
+	    wait_info->num_bo_read_handles > AMDGPU_USERQ_MAX_HANDLES)
+		return -EINVAL;
+
 	num_read_bo_handles = wait_info->num_bo_read_handles;
 	bo_handles_read = memdup_user(u64_to_user_ptr(wait_info->bo_read_handles),
 				      size_mul(sizeof(u32), num_read_bo_handles));


