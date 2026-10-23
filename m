Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774781;
	b=3fG8+1tjs1SMe4u4kNjXnx5Dg2TtVGNfJddunfKUejodhFl21o31FqYW7I56cAT11nHx
	 n3uQi/DryAPx2SXgIhzb7V34Srz7ZZ/uIT06OrZwL0QS3VkswPLjPc7gkON/2LZPAf+o0
	 yH0Z2l/vKTFdBYVXSYFm9CZOS07TlFNyEcQSNmf9TQ9RilCQz6IEq7WaUurNNmUal9H+z
	 YsPti35MjWWtswL3dha2F2qPKo6NL6VrcF2YsAP/1qJTtEtq5PbAhiN53x1PBYpMzc9xB
	 QR7CvuZhJgGv02bC4TP4pcu5KGlizSH7Dgxe0D80sP+VYz2vsXKBdwNIeQOlLbPIpoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774781;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=zeg69Mpl5opMdrN8B5U1REK5dDxC886PS0jToQ8e+RE=;
	b=T3btaniF2I5GbFuES+gvz8E6F+CNtREIE0TR2Ar54XbmEZvIyvO8OLGFJARb2Nh4swYk
	 Ji7U0RdFOkT8NzdOdDSYscvaf73qCGDDQpojxls8yjR3inIfKaD6CHo7YB/sRs7uJKtV+
	 dR7q2fPlPrvftX3CVy0IxisrnY11IESsh5i4N9MPE/eZC715fExYEMcoGwIsnTiEJN42/
	 n1P152rlbk3TGd8ve1MNqXA7u5cHcHnfXLLa2h32KsQCD2wSPOZn9p8TtcmkpsUaDopG7
	 vKtH+aIHYRc7ibuaxZVkkzPK65Wkdv97+mwPvFGlDyMDbVMOSCA8yuyoNFYjuj3MJXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nl4393W4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E772D606A31A;
	Fri, 23 Oct 2026 16:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nl4393W4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F13541F01825;
	Fri, 23 Oct 2026 16:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774780;
	bh=zeg69Mpl5opMdrN8B5U1REK5dDxC886PS0jToQ8e+RE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nl4393W4T+qVU41/vQwLiU3s2Ar0pYPdm4Aa+PRZQVP2Ag5VbwTBGOFU5U/w7X32p
	 XBm8f6EW86LptY8sKihYGEMP+kiUv1EWTxe7YhIhz320eWL/chyoN/kpoH21/S4A1e
	 Fuk+raDGhdQ0nPC1tVbAO11pSNhhbda8n6ePz+Gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Perry Yuan <perry.yuan@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 156/242] drm/amdgpu: fix GEM object leak on ENOMEM in userptr ioctl
Date: Fri, 23 Oct 2026 18:39:58 +0200
Message-ID: <20261023163717.471969844@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Perry Yuan <perry.yuan@amd.com>

commit 3c516a5646285442e1cd71dff2584b77eb4fc421 upstream.

When amdgpu_hmm_range_alloc() fails amdgpu_gem_userptr_ioctl() returns
-ENOMEM right away and skips the cleanup every other error path goes
through. The GEM object, the bo->parent reference on the VM root and the
MMU notifier registration are all left behind.

Use release_object here, not user_pages_done, range is still NULL at
this point.

Fixes: e095b55155ef ("drm/amdgpu: use user provided hmm_range buffer in amdgpu_ttm_tt_get_user_pages")
Signed-off-by: Perry Yuan <perry.yuan@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit bbe739e407a542073ec1a7872b14843566b4919e)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
@@ -567,8 +567,10 @@ int amdgpu_gem_userptr_ioctl(struct drm_
 
 	if (args->flags & AMDGPU_GEM_USERPTR_VALIDATE) {
 		range = amdgpu_hmm_range_alloc(NULL);
-		if (unlikely(!range))
-			return -ENOMEM;
+		if (unlikely(!range)) {
+			r = -ENOMEM;
+			goto release_object;
+		}
 		r = amdgpu_ttm_tt_get_user_pages(bo, range);
 		if (r) {
 			amdgpu_hmm_range_free(range);


