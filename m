Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC31343D72;
	Sat, 30 May 2026 16:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780158179; cv=none; b=BNSdr57LfXvFFX3Dk5/HNv1nhqG9bMYXXUtFg8OdPzOaUbx5QUrNKWIV4PPJQLc/nJ1zl7zzT1QCqPGMiek4lwZfrcAS3cDl451X4ARPrvnwjyU7eDgZksmJw7EJUc/RkDsD6KiSnu2jByyqwliskvOZ9Os+9eyqHVwq5wQOtA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780158179; c=relaxed/simple;
	bh=ctIAC6Te0OVtCf6EO7OC/6txHEqqRzEnMeseYwOGb6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RjX8NZCvNc0Jrlw/5kdwcSw1n/f1D20wLvvw2UimaWyga3zdnB4Kg2BJ6WAhh5/dwgsmkKw/Mss4+1uWr4iRmWAsx69VM3L4BNskvKa5qdPWn0tsZuHxOfRFqNl9PlTZ1mc/8h6698OWcwqEgG3nmM6pTMwsH2Suo/mtFQt2Tn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zcix+J6Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zcix+J6Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55BC01F00893;
	Sat, 30 May 2026 16:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780158178;
	bh=3C0D5e+MMXWSF2ETk1N0FbJLt1eN5FzGprRAe/GVdzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zcix+J6ZM0asjv0MkXVsBuvRk7Zo5IbvLAXokibRhSvIELqZVuNTApgsPi4WAZq4b
	 hnnejloVc3pBK+7fYcxpggBIoujMaxFmd+CEW5ubbiQkNXwPsWs0KALp90Ghi1xCn+
	 T+Cbah7JU5E1AUnZVWSDSCPnt0WgBwG2hfdt8XCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 028/969] drm/vc4: Fix memory leak of BO array in hang state
Date: Sat, 30 May 2026 17:52:32 +0200
Message-ID: <20260530160301.219029976@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 628d40ff3aa1c..c446684a72183 100644
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



