Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E624156C6;
	Tue, 13 Oct 2026 12:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894374; cv=none; b=cVTeW8o7tQKtevzEGy9bxsW3xYv0e3HtqpT/nK1JjpsaKklumDRinUrAj1F/s01qm8AQHFH9vvVkz07C2itQctidoXVX6NQZDlOUwfdPcftS+n7sqZNloDqeUlLFEbzmMoutHwVMEbkvXuQWDaL8AD0vPsHkYkhEY4rXA/kCyg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894374; c=relaxed/simple;
	bh=EQrobMLbYGCRefuKC2ZsccUbNMtHYJRoL9r4TnoKq0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HY6Rl2R0gvPGF54GTgiPwUnWTMmOQGxveblehzI9Z6dhn6Wf1JvfULWcyRV1TqqgtIcq+ZTks5LyE6SMrmb4LrJj4LwWcFMMNQrECx+/Le8ZIBGg5nnf2HTb6yD+AM5ZwTZdozNvVJNbAIC94F3B6/8IkpV6ba6BjLH+GW8pH/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bpXsZB5k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bpXsZB5k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D051F00893;
	Tue, 13 Oct 2026 12:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894373;
	bh=8PIhcEQ3PceEBlYn/z5WvUq08+re5/aTfLPhhz06B2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bpXsZB5ku3GAvQGZhK6dzCMp7OIHdXr6I0X8TLxJkIV2mpFca6ykgYvxUPmm1SMXO
	 YKztwl0MFUXHhhvN2x0IzKxi6TGODTGPcamAjkud+JjGXrFK+KxLFWdHdWBV4a/j5D
	 sTKxeIo9H1knJazUoKQdEKB6usfpLwdIlRQNF/2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 540/621] drm/vc4: Free the BO cache size list on teardown
Date: Tue, 13 Oct 2026 13:38:55 +0200
Message-ID: <20261013112933.634604726@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit b41ff8b529278216cba22a5dcdc93fea2a3a9619 ]

vc4_bo_cache_destroy() purges the cached BOs but never frees the size
list, leaking it on every unbind.

Fixes: c826a6e10644 ("drm/vc4: Add a BO cache.")
Assisted-by: LLM
Reviewed-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Link: https://patch.msgid.link/20260930190721.1897264-1-mcanal@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_bo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/vc4/vc4_bo.c b/drivers/gpu/drm/vc4/vc4_bo.c
index cd7996592db37..206be4336b0bd 100644
--- a/drivers/gpu/drm/vc4/vc4_bo.c
+++ b/drivers/gpu/drm/vc4/vc4_bo.c
@@ -1054,6 +1054,7 @@ static void vc4_bo_cache_destroy(struct drm_device *dev, void *unused)
 	cancel_work_sync(&vc4->bo_cache.time_work);
 
 	vc4_bo_cache_purge(dev);
+	kfree(vc4->bo_cache.size_list);
 
 	for (i = 0; i < vc4->num_labels; i++) {
 		if (vc4->bo_labels[i].num_allocated) {
-- 
2.53.0



