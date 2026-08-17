Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB6E315D5D;
	Mon, 17 Aug 2026 13:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974202; cv=none; b=LxrurcZGieF5/y7ZfDApTg5KWQtNsYHiyVr5WviK25Tz225Izmh5Iy9/28xLg/z8lC9QLNTeD4T1zE5n/wyI0dTyqvUpmG3Oeiz5MJSKi5AxKUCpxhEpmhI3RWfuz1DAAlm1aHTJljZNtfBpj5q1MENICv0nTTHqCqK2asKpAa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974202; c=relaxed/simple;
	bh=SV4i6LuD+CDZ7FVd82NXxnetcEAE8Rr+KgzuM+Uz2Vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a7/Pam2lYTP0600G6aNqm1hSPi2ZwiP8c2fACSvfF1p/FFcR3EAmH3sJANX9Q1/rwh7XtP4lLKORDzi/4dJlJuX0yIXv6HN23dpsdo7QAZzxeWYworVYelA370WWfeA+xOi7uOMT8+e9NeSsSE0y/Re8cfMbqAOFzxJ+T5ph9x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=prlWf/J5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="prlWf/J5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9FF01F000E9;
	Mon, 17 Aug 2026 13:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974201;
	bh=H8QW7HDImFTligrdM3agl3VOg1aaMzKIMhvqubXlsAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=prlWf/J5aNOWSb4xXdx3mvHGUUoO4SLRRCwCdJqip9BQZZ+ovx7JPooESJkbf22OU
	 vkQDwvcUtnUMumaFBy7cIFFApFVMyn/+u64sEpTh7wxeo9iTgIwgOOZ8ih0CUYrney
	 Bw6Y7w0YhhTXMjwX3GbF+G7M4AbjscY9kEau+aF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Hodo <martin.hodo@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 085/271] drm/xe: Fix memory leak in exec_queue_set_hang_replay_state()
Date: Mon, 17 Aug 2026 15:30:10 +0200
Message-ID: <20260817132540.249958925@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michał Winiarski <michal.winiarski@intel.com>

[ Upstream commit c5f500161709f27719701334190dff2325868ef0 ]

The q->replay_state is blindly overwritten, which can potentially leak
memory that was previously allocated by vmemdup_user().
Return an error if q->replay_state is not empty.

Discovered using AI-assisted static analysis confirmed by Intel Product
Security.

Reported-by: Martin Hodo <martin.hodo@intel.com>
Fixes: 1026c1a73a96 ("drm/xe: Implement DRM_XE_EXEC_QUEUE_SET_HANG_REPLAY_STATE")
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20260624111421.1258364-1-michal.winiarski@intel.com
Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
(cherry picked from commit f6b6cc1118bdbc4265fa8b3bdf8565b26f13e56e)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_exec_queue.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_exec_queue.c b/drivers/gpu/drm/xe/xe_exec_queue.c
index 071b8c41df43e..85778958f5803 100644
--- a/drivers/gpu/drm/xe/xe_exec_queue.c
+++ b/drivers/gpu/drm/xe/xe_exec_queue.c
@@ -801,6 +801,9 @@ static int exec_queue_set_hang_replay_state(struct xe_device *xe,
 	u64 __user *address = u64_to_user_ptr(value);
 	void *ptr;
 
+	if (q->replay_state)
+		return -EINVAL;
+
 	ptr = vmemdup_user(address, size);
 	if (XE_IOCTL_DBG(xe, IS_ERR(ptr)))
 		return PTR_ERR(ptr);
-- 
2.53.0



