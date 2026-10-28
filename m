Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210199;
	b=1YC6zZiTVUZnqgbq273Kes8HmWtpvM9bou0YByr5fyWxIwN3+Z+p+spTbVBz823f6IOW
	 us7q81xeizCPGGoMcso8yJeEIHF4zGPn1zhdDOkSHWDPQcrX3q0XS/Oor+q6J/PO0+XDG
	 nr9ZnHDUtjkXmEQyswArIH1JAmf9r1LVpgUGNJndAkpvQqOpB6/7xCJweYVDpgYPi05sF
	 ahZ7IYNhZu5UdeATVetCW1VAHB5ZdQV/OxdBSWWJQMxrKFgOd+EfomJYgSreuNkFJvdbP
	 l3A8McbGRG9dJAgYLEIzdj6Yok6N/18Vpbgl3LLBoXWGtmE5MmAoAkHeMA79PvT+wdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210199;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YGWUz7D+QK6MXYIioslvdOH1NscRdsqRG99McvEyiFg=;
	b=eIygEE75cgEZVMyGp22H0L2HCb+Zl2mw8krROem9ECMWkTyE0nJ1zxJWxd4eAzi6G0If
	 33nWmei/VUxx6q53GIehch0bRx1xgCoczFgopBRwqQIOC5zPemQpYkmAPShorjKA4Cxkg
	 mL8n2JJiuIMO2ONpT5oK194tTwg5+K7StOsIgzsqbtFqDKKOhiSTTRn+vQH+n8Ci+Jjz6
	 z1W0WK/3KfY5FpLfV5WzbZkBXYvKBJfQaBDl9VXYrJea+GrhibVaXRZQbGddqgef5ME6V
	 rLAyTp8ASNpr7+wn3PMcRySctZAshQXD74/NEjRfKxHS2F6ZLMXYqLze+KLTZBuiunw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OBycraCM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8297606A31E;
	Wed, 28 Oct 2026 17:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OBycraCM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B5441F01825;
	Wed, 28 Oct 2026 17:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210198;
	bh=YGWUz7D+QK6MXYIioslvdOH1NscRdsqRG99McvEyiFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OBycraCMwC9lRNWix7exMi21Irfp6zRJ+DMaf8RRASjvc7cFxLtj5+iQtLZmkhlBv
	 L5R123v0LZKUXq6gG6sidvuLPWqClOe2foJozaywyePBNQeq89Rt0lnXKxho8zzPDH
	 0/UQZtr3TafGGci+gB2s/8rOhi1xX65OF4MRExRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 112/168] drm/amdgpu: free the userptr ranges when a CS fails after parser_bos
Date: Wed, 28 Oct 2026 18:00:48 +0100
Message-ID: <20261028165945.737720536@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <Jesse.Zhang@amd.com>

[ Upstream commit 1b4da805a0ba354a549ce07459c871c17dd94fe0 ]

amdgpu_cs_parser_bos() allocates an HMM range for every userptr entry of
the BO list and looks up the user pages. Those ranges are only freed when
amdgpu_cs_parser_bos() itself fails or when amdgpu_cs_submit() checks
them under the notifier lock. If amdgpu_cs_patch_jobs(),
amdgpu_cs_vm_handling(), amdgpu_cs_sync_rings() or the early part of
amdgpu_cs_submit() fails, nothing frees them: neither
amdgpu_cs_parser_fini() nor amdgpu_bo_list_free() touch e->range.

Each such CS then leaks the range, its hmm_pfns array (8 bytes per page
of the userptr BO) and the BO reference the range holds. An IB on a ring
that patches the CS in place (e.g. VCN) with an unmapped va_start fails
in amdgpu_cs_patch_ibs() and takes this path.

Free the ranges on those error paths. Ranges amdgpu_cs_submit() already
dropped are NULL, so freeing them again is a no-op.

Fixes: fec8fdb54e8f ("drm/amdgpu: fix userptr HMM range handling v2")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c52a9542ed7cfd527feb938bd0accada2ac8d267)
Cc: stable@vger.kernel.org
[ sashal: adapted cleanup to the existing error_backoff path using amdgpu_ttm_tt_get_user_pages_done() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index df7a5775d361e..6709041c4b94a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -1440,6 +1440,7 @@ static void amdgpu_cs_parser_fini(struct amdgpu_cs_parser *parser)
 int amdgpu_cs_ioctl(struct drm_device *dev, void *data, struct drm_file *filp)
 {
 	struct amdgpu_device *adev = drm_to_adev(dev);
+	struct amdgpu_bo_list_entry *e;
 	struct amdgpu_cs_parser parser;
 	int r;
 
@@ -1495,6 +1496,11 @@ int amdgpu_cs_ioctl(struct drm_device *dev, void *data, struct drm_file *filp)
 	return 0;
 
 error_backoff:
+	/* amdgpu_cs_submit() only drops the ranges once it got that far. */
+	amdgpu_bo_list_for_each_userptr_entry(e, parser.bo_list) {
+		amdgpu_ttm_tt_get_user_pages_done(e->bo->tbo.ttm, e->range);
+		e->range = NULL;
+	}
 	mutex_unlock(&parser.bo_list->bo_list_mutex);
 
 error_fini:
-- 
2.53.0



