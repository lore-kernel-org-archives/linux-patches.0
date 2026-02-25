Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ABFF1F03DE;
	Wed, 25 Feb 2026 01:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983079; cv=none; b=qDm5sQ0tk3Kg6OGipoBByikW5c7r55d1Ea3PyT6hkPaT8ysT2ON+H7S5WzwrXYzXEHIENnVOLdOmt1AipIaGkOZ2Wc89yq2/tFfcJbW6sRNB4xWCZQHsuI7FM2edD7L6/M+BJC5hveeRTup5OkFzp3ZPc6R1J/QUvpK1UnfYKUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983079; c=relaxed/simple;
	bh=uupLbhheLodnc8cTBl3DJo2mQWN6TLbKWc2nC6QIjow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GfwkS1xlasM0Aikbbge6i4VLqbBgJ0dWxXXzYnLyIsOlu531WcyVDJ0MIlqUDK4omXhkKNkovL7dG8QTVnuoTkucedOA8AfXxkQeErG0iqeXT4xER9dY73WxQOB7wUOPFdEAZLdO6AR2COR5DH8/JdK9Kpo/trYA2qOKxtNl60g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QMFXUnpJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QMFXUnpJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10FF8C116D0;
	Wed, 25 Feb 2026 01:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983079;
	bh=uupLbhheLodnc8cTBl3DJo2mQWN6TLbKWc2nC6QIjow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QMFXUnpJkt8B9ks/SpKaZXCLav3Fx4Oiw4FgKR9po4Rr30VpxpvEpMXZjzy0XSVcM
	 k2vMiooq2zXCsc7jfDgfU6J5xe9uydhSww3iR4zjArKcRrh+YNpqVaxc9uaSJs1tM5
	 as+JT+kbCEiEHs+cTx1GMc8fiQswLlTsH9Mlj6HM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	Gang BA <Gang.Ba@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 240/781] drm/amdkfd: Fix signal_eviction_fence() bool return value
Date: Tue, 24 Feb 2026 17:15:49 -0800
Message-ID: <20260225012405.595947263@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit 31dc58adda9874420ab8fa5a2f9c43377745753a ]

signal_eviction_fence() is declared to return bool, but returns -EINVAL
when no eviction fence is present.  This makes the "no fence" or "the
NULL-fence" path evaluate to true and triggers a Smatch warning.

v2: Return true instead to explicitly indicate that there is no eviction
fence to signal and that eviction is already complete. This matches the
existing caller logic where a NULL fence means "nothing to do" and
allows restore handling to proceed normally. (Christian)

Fixes the below:
drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_process.c:2099 signal_eviction_fence()
warn: '(-22)' is not bool

drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_process.c
    2090 static bool signal_eviction_fence(struct kfd_process *p)
                ^^^^

    2091 {
    2092         struct dma_fence *ef;
    2093         bool ret;
    2094
    2095         rcu_read_lock();
    2096         ef = dma_fence_get_rcu_safe(&p->ef);
    2097         rcu_read_unlock();
    2098         if (!ef)
--> 2099                 return -EINVAL;

		This should be either true or false.
		Probably true because presumably
		it has been tested?

    2100
    2101         ret = dma_fence_check_and_signal(ef);
    2102         dma_fence_put(ef);
    2103
    2104         return ret;
    2105 }

Fixes: 37865e02e6cc ("drm/amdkfd: Fix eviction fence handling")
Reported by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Philip Yang <Philip.Yang@amd.com>
Cc: Gang BA <Gang.Ba@amd.com>
Cc: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_process.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process.c b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
index a085faac9fe1a..5c15168f4faf6 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -1996,7 +1996,7 @@ static int signal_eviction_fence(struct kfd_process *p)
 	ef = dma_fence_get_rcu_safe(&p->ef);
 	rcu_read_unlock();
 	if (!ef)
-		return -EINVAL;
+		return true;
 
 	ret = dma_fence_signal(ef);
 	dma_fence_put(ef);
-- 
2.51.0



