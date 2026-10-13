Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D294389104;
	Tue, 13 Oct 2026 11:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892504; cv=none; b=HzktbqvzROfzXrFilj8sZ1nRI/4Tlo9DYu4rqo7RXl299pVSnuX/LbnBKK7oJIwmnadhjICLLbh6SNixHOPvli5cOeTKp/j68fwa056sRDPUIWGBQER0ulVknvBjeqcXS0zaAhFRG3xXZqhKp7v3cvg2B66cTMATEXkLbp4+Cew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892504; c=relaxed/simple;
	bh=kjDWWl77X4QsbFh/ccE3ag5Sz/6WkUcAzQpRCPW3eZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F5GzCUjZsbhnJSaVcc4RlPmQ1mOA0Wpp44rbAT6T8/Sn7jeTugDaZs4IG0roQyKixiVlhgS4Q18cnW5Sp1u+PBEEojYeo4gb4H+mYnYUTOthOza75ScYVXv5BjOtAZqrnJVzm5E8vt76KhOmZQ2OOjUaGnpE93kNF0bdPw2EfNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MwMKoL44; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MwMKoL44"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F8B1F000FF;
	Tue, 13 Oct 2026 11:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892503;
	bh=3mTPe1cUHN1EgwpvmXchjR91ctlOTy5tmcMxho9ZLCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MwMKoL44pOdVe6OZNc45aKYqPUJWY2LHzVVCwv4p1mINWy5lSGsSgFQw9FdlrUxoV
	 cJothCgo7VQUbP1gA0KxRauNaZShNC/MJafuhzEEx7ZNGgudMWE6O8+ALogoQGkaFL
	 +c8jbTWa3H7cGBYExU5v4b82R39x64j+y19DacPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 195/281] drm/vc4: Free the BO cache size list on teardown
Date: Tue, 13 Oct 2026 13:38:31 +0200
Message-ID: <20261013112859.896715104@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 49ea2ed0996b4..ea1be891ac781 100644
--- a/drivers/gpu/drm/vc4/vc4_bo.c
+++ b/drivers/gpu/drm/vc4/vc4_bo.c
@@ -1052,6 +1052,7 @@ static void vc4_bo_cache_destroy(struct drm_device *dev, void *unused)
 	cancel_work_sync(&vc4->bo_cache.time_work);
 
 	vc4_bo_cache_purge(dev);
+	kfree(vc4->bo_cache.size_list);
 
 	for (i = 0; i < vc4->num_labels; i++) {
 		if (vc4->bo_labels[i].num_allocated) {
-- 
2.53.0



