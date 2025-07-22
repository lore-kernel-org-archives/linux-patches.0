Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4C42E9ECA;
	Tue, 22 Jul 2025 14:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193299; cv=none; b=M/O/prfwq/+Laq9XirEkq5pzhoF8HNzCMDDoYovmW5JnAH2TLPYemNYKndWOD3nShwggmtdweQR8QcXqkoEVtSEQdC/vU6FYH8eGbmynfNCiKJ1Mnbow3t16RfLAd2C9RDmkJvRx3eVFR/ZVipmBtek8vORXDklaX9EERUuwZWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193299; c=relaxed/simple;
	bh=GYSMXA9bYKIJ6g+SWwiqlcrpbNnQjGPItDgVuqO76E0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i1VY7B6osFLv+NffME1Z9/7HdOHkpvDjn9jqRB1WoDFr1wR5YrMh6J3wYGoyzWiqfnAWWCnLhuQYUUm+HP50u6JwAbaGWtWFvmCdTG2H89xgZtH1HueWUvubqbyrHMWnpV/5ojzZZn/Lyf+yowHqILJfX9fXjnmhBENSMDf4078=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aRLU6Qa+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aRLU6Qa+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF538C4CEEB;
	Tue, 22 Jul 2025 14:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193299;
	bh=GYSMXA9bYKIJ6g+SWwiqlcrpbNnQjGPItDgVuqO76E0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aRLU6Qa+1Zhi7xDLua+KC6KvvW3hfeZJX0x3JmBkSXdiZE+dOmk+0BZ2LtbKbyhjW
	 3QXtm48n6K4WZGwJshmh/vK0uoHx38SrUGD3GVMKwUcK/HuCtFBIWRaSMs5gFcam1F
	 IawOb0Buq8Z9jwCMjfm+V3NHrPwQi0odlM+SAi3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eeli Haapalainen <eeli.haapalainen@protonmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.15 033/187] drm/amdgpu/gfx8: reset compute ring wptr on the GPU on resume
Date: Tue, 22 Jul 2025 15:43:23 +0200
Message-ID: <20250722134346.992023904@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eeli Haapalainen <eeli.haapalainen@protonmail.com>

commit 83261934015c434fabb980a3e613b01d9976e877 upstream.

Commit 42cdf6f687da ("drm/amdgpu/gfx8: always restore kcq MQDs") made the
ring pointer always to be reset on resume from suspend. This caused compute
rings to fail since the reset was done without also resetting it for the
firmware. Reset wptr on the GPU to avoid a disconnect between the driver
and firmware wptr.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3911
Fixes: 42cdf6f687da ("drm/amdgpu/gfx8: always restore kcq MQDs")
Signed-off-by: Eeli Haapalainen <eeli.haapalainen@protonmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 2becafc319db3d96205320f31cc0de4ee5a93747)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
@@ -4664,6 +4664,7 @@ static int gfx_v8_0_kcq_init_queue(struc
 			memcpy(mqd, adev->gfx.mec.mqd_backup[mqd_idx], sizeof(struct vi_mqd_allocation));
 		/* reset ring buffer */
 		ring->wptr = 0;
+		atomic64_set((atomic64_t *)ring->wptr_cpu_addr, 0);
 		amdgpu_ring_clear_ring(ring);
 	}
 	return 0;


