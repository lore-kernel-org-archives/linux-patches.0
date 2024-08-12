Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9FCE178CE4;
	Mon, 12 Aug 2024 16:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479340; cv=none; b=ag5mPd1upveVUOzDWEOxSO42IMhGc4sjHQc/65B34TTE+HVf3v5nIsZGO7H7PGHPlRaQhgWp6zdCHc9juU6ONwzuGwa7Dw/0HiI1a5zNnR5IG+wQmkByJcEJdck8UwFvMEQxCL0JEG/jaxJOWCEVxLIdBwnjsb9nPjD/HgmWhfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479340; c=relaxed/simple;
	bh=QBeoLbIJB1GYZ8wfJfnmyL6LA5UoL4UXdOPkcivLSuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kMqaX/tay2WefV1/chTeJpSVp9+U8dqcd2RKTDNAO/qzLalBcaUPWoCqZG0yUwirj49EyXWnt6O/ots8zGRQeuaG+PlJIktnNR2fGznqGsnuZr60jjVdTYaJSNNm3cdCvJ4tKrScilmCKd600Yb7gqCrZZB6emFC3ELTjtM/vlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j6t7dRoM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j6t7dRoM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52418C4AF0D;
	Mon, 12 Aug 2024 16:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479340;
	bh=QBeoLbIJB1GYZ8wfJfnmyL6LA5UoL4UXdOPkcivLSuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j6t7dRoMfovu1S/Ikh0E/a3WAICupdkMQT92vsDzfTLzD9fG8RjBVdgbNM3Ce5iht
	 yman6kMnxXJvqwR6T7vB8MxATeBWAtxrK4u07vtedq+uGcHX+PDxA2sH8IU6+q3wZT
	 VQHMZ+obbb8l0njZ0EVdpFna6/I6KWjQJVeKQHCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 055/189] drm/admgpu: fix dereferencing null pointer context
Date: Mon, 12 Aug 2024 18:01:51 +0200
Message-ID: <20240812160134.263720009@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

From: Jesse Zhang <jesse.zhang@amd.com>

[ Upstream commit 030ffd4d43b433bc6671d9ec34fc12c59220b95d ]

When user space sets an invalid ta type, the pointer context will be empty.
So it need to check the pointer context before using it

Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Suggested-by: Tim Huang <Tim.Huang@amd.com>
Reviewed-by: Tim Huang <Tim.Huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c
index ca5c86e5f7cd6..8e8afbd237bcd 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c
@@ -334,7 +334,7 @@ static ssize_t ta_if_invoke_debugfs_write(struct file *fp, const char *buf, size
 
 	set_ta_context_funcs(psp, ta_type, &context);
 
-	if (!context->initialized) {
+	if (!context || !context->initialized) {
 		dev_err(adev->dev, "TA is not initialized\n");
 		ret = -EINVAL;
 		goto err_free_shared_buf;
-- 
2.43.0



