Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C3428B50C;
	Wed, 23 Apr 2025 15:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422443; cv=none; b=Q43va4JF/XcmdJgWfK1f6JjVxiDiMIOdz4+VLXQdAFSx9bA30ptB0itfEYlvy92AjNgibh5dQDny9+fimhWTTlb6hk/VFFagGpoC8Vk8NNcoGMf1AcCD/XU5eNqhT/NKAOvPEDEZCdEj8SsvxkdNvWYNUYlpOAy6cdoUKRif7CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422443; c=relaxed/simple;
	bh=jzUr/Fi6HqzLXMtUqgX7lmdCwnBGLMOSZLKX+0XSf1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JKnj+P1JWMZRenrOl9RDFeOzDNjA9wsJ2+4vaCkogKeW8m0KP0FrtW/K7iY3dYnOXidkX2vnHE7gZFWaVuWPfeuwHAoT8BjwSD2c/7t/JCNGTLQ9LR4BHXjrlZPx0sMsBRbb9TKb63LrVKBwCvdmNU6zt/oek83T3BJI4PaHEgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u0lKxhPw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u0lKxhPw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E02C4CEEB;
	Wed, 23 Apr 2025 15:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422443;
	bh=jzUr/Fi6HqzLXMtUqgX7lmdCwnBGLMOSZLKX+0XSf1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u0lKxhPw4CR4K4LDdDdcQM8IeiYl9yKmx6u41jr/PjD6/LgEJyeAXkDFQhP/Lq9gA
	 qLOXB55ycJ8Mv6l0ZUZMAfmzgrImZzAoR+b2uehGzLZXpZWk+9gjpNQJyfzQGj1YYB
	 2Ki4ibdsD+wycvz4uqf2NaO3T89Nevq8urFBoMPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 351/393] drm/amd/pm/smu11: Prevent division by zero
Date: Wed, 23 Apr 2025 16:44:07 +0200
Message-ID: <20250423142657.834600412@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Denis Arefev <arefev@swemel.ru>

commit 7ba88b5cccc1a99c1afb96e31e7eedac9907704c upstream.

The user can set any speed value.
If speed is greater than UINT_MAX/8, division by zero is possible.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 1e866f1fe528 ("drm/amd/pm: Prevent divide by zero")
Signed-off-by: Denis Arefev <arefev@swemel.ru>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit da7dc714a8f8e1c9fc33c57cd63583779a3bef71)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
@@ -1202,7 +1202,7 @@ int smu_v11_0_set_fan_speed_rpm(struct s
 	uint32_t crystal_clock_freq = 2500;
 	uint32_t tach_period;
 
-	if (speed == 0)
+	if (!speed || speed > UINT_MAX/8)
 		return -EINVAL;
 	/*
 	 * To prevent from possible overheat, some ASICs may have requirement


