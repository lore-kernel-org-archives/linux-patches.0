Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62FAD3D3D04;
	Fri, 24 Apr 2026 13:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037688; cv=none; b=HHoj8VVFM7i7q+u/IMuc1ahb3f7qhLQWyzfR118e6jeAEiQbPyoMTWgAwzL1XuYLS2LvdICUPMWdU02MCSxyEagH/FvKuAFx1nqYV1SFpRNBtqv0fW6sp/b+gFBtpz1Oxv3t7N5EHhB5F5ryx/2qeHSIMJGoOLceBRRXq4utGWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037688; c=relaxed/simple;
	bh=UFYPwI+TcerZ5ERp3zcllnsKg4ZCHtn4hDmWZ8dId8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WfEB8n5VqYJTPwMWL4o4eOa0wzpCiL0Kk8Xen2NJGYxCGjAAkhlDa4azHjNFfnNbSmPI0wIb3iAalamFb21jpaempE00Z4iC9HARgZo8YgoTrH/h4xUaHSti1rp84C4408HRxjjFAApr7y0fLaUgAt9UYawUdRKg/Wbl+JUhqpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qeevDmNK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qeevDmNK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED1EEC19425;
	Fri, 24 Apr 2026 13:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037688;
	bh=UFYPwI+TcerZ5ERp3zcllnsKg4ZCHtn4hDmWZ8dId8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qeevDmNKyNqTHDYZJ9RR4SjY3VP60XXqBwsi1MgHVylCKte8j8FxMZpERWGg2twLg
	 YDRTBSsTkVCSfGyn1PCEtbsPuS0EWwmYvDZagg+fJW655suwuVnKT4DKqW65v+2p+w
	 AlzG47tov+Aju5ryC/HTopGqivYBMhLPWe1npcsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 031/166] drm/vc4: Fix memory leak of BO array in hang state
Date: Fri, 24 Apr 2026 15:29:05 +0200
Message-ID: <20260424132539.396295847@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit f4dfd6847b3e5d24e336bca6057485116d17aea4 ]

The hang state's BO array is allocated separately with kzalloc() in
vc4_save_hang_state() but never freed in vc4_free_hang_state(). Add the
missing kfree() for the BO array before freeing the hang state struct.

Fixes: 214613656b51 ("drm/vc4: Add an interface for capturing the GPU state after a hang.")
Reviewed-by: Melissa Wen <mwen@igalia.com>
Link: https://patch.msgid.link/20260330-vc4-misc-fixes-v1-2-92defc940a29@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_gem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/vc4/vc4_gem.c b/drivers/gpu/drm/vc4/vc4_gem.c
index 03648f954985e..fe535c6fc95a8 100644
--- a/drivers/gpu/drm/vc4/vc4_gem.c
+++ b/drivers/gpu/drm/vc4/vc4_gem.c
@@ -60,6 +60,7 @@ vc4_free_hang_state(struct drm_device *dev, struct vc4_hang_state *state)
 	for (i = 0; i < state->user_state.bo_count; i++)
 		drm_gem_object_put(state->bo[i]);
 
+	kfree(state->bo);
 	kfree(state);
 }
 
-- 
2.53.0



