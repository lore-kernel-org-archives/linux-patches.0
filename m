Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208406;
	b=bTmvPrpuarenvcYtDaIqIzenwa2opYkixwIG6jiARjLApjP0W2y4RqQ4qYWcit38SBG6
	 4vnzF2mxyQIGXyuRIUTqAsTyJXCihLXzkNDbBGxmn7qWFdek6I7V8h5t/I4vGQcGEQEwz
	 6LYmK3XgkMv3b4DWXw1fnjTXSe6Ho4ioPSCOqzIF+DBBZO79kMIkbNcBTlATfsfiyz6Zj
	 jxa0gN5OvetGnhSTpIV+ruMzgGsFzIL7agx/mz2wchukKlEAc/3qwx587iadfuWKjFDNn
	 3jORHjvdp3cS2IKunWIBR3OFTL1tkFZqV0w1iDl5+lRnktRgFCyKESAxUwGEGJSx5Aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208406;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EKDlCOhv37b6WTLlmLV41OkcyILQv6DaP688cUWHYXk=;
	b=lZg4MrcLdlU39+S+ndEiC21My2Smv5LiIa+AWG9skIM3YYY5xxRO9pwOD6e1fy3weJ40
	 1/iWRSBf+M//b4vUWXpyhlknIzFBvzExa7rZG51fcShlwKBYr8/NsFSOs8KdvOwGCRMlE
	 AdisrgrUhNelxqa+8qNW3MDZThbqq0X8WJRn++UFACxks/n8ccYYK0/IOVhPODN86Y1Hp
	 pEH5NZex8aBvb7QNXZMG0Y4Po7em0wZN7mPMsOPGqzWTrxZgFS/5t6c9Z9G3BHydu0/EG
	 i3acYOjSUSiJP18HZGQuhY5Ni6yng47W2hPPTPoEwXL1gs325XYLy3I+g+gpM5uH2ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IoMeSBFc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27DCE606A31A;
	Wed, 28 Oct 2026 17:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IoMeSBFc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A761F031E1;
	Wed, 28 Oct 2026 17:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208406;
	bh=EKDlCOhv37b6WTLlmLV41OkcyILQv6DaP688cUWHYXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IoMeSBFceZ/hHOP1dm90eRIfIHWqDL3PORtrJzZKJ20VDbaHhdnNunnDj9mwk1xq2
	 8seYY+o3r0wEBA3BvhcvksqbE25bWeh/jMSn1VJ/q/eqzcAHbOTP9XZf4IlhvQnOBX
	 MJ+PQNJC5q/Y2ga96Z6Kqe6W6ec+pJBREJK4OHW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 109/516] drm/amdgpu: Fix runtime PM leak in amdgpu_debugfs_test_ib_show()
Date: Wed, 28 Oct 2026 17:54:21 +0100
Message-ID: <20261028170006.100406842@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 2b86ab1bd6673c525adda88819d7658ba9e784ec ]

amdgpu_debugfs_test_ib_show() resumes the device with
pm_runtime_get_sync() before taking the reset domain semaphore with
down_write_killable().  If the write lock acquisition is interrupted,
the function returns without calling pm_runtime_put_autosuspend(),
leaking the runtime PM reference acquired for the device and keeping
the GPU awake.

Drop the runtime PM reference on the interrupted down_write_killable()
error path before returning.

Fixes: 6049db43d6dd ("drm/amdgpu: change reset lock from mutex to rw_semaphore")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit ec30a576c2d4c0364549e6c04218f50704ef56c8)
Cc: stable@vger.kernel.org
[ Adapted `down_write_killable(&adev->reset_domain->sem)` to `down_read_killable(&adev->reset_sem)`. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
index 8a1cb1de2b13a..5ba4fd1e9342f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
@@ -1259,8 +1259,10 @@ static int amdgpu_debugfs_test_ib(struct seq_file *m, void *data)
 
 	/* Avoid accidently unparking the sched thread during GPU reset */
 	r = down_read_killable(&adev->reset_sem);
-	if (r)
+	if (r) {
+		pm_runtime_put_autosuspend(dev->dev);
 		return r;
+	}
 
 	/* hold on the scheduler */
 	for (i = 0; i < AMDGPU_MAX_RINGS; i++) {
-- 
2.53.0



