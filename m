Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F84BBE5A;
	Tue,  2 Jul 2024 17:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940167; cv=none; b=cfafcFyfM20AaZj7EqYNTERvi3BdHoRG3eiTBjmripYz1tOMiAnEEfyiAvT36xpRZ5RtQG5dBamsykWLG9NTNKsoKWduAqEAhzZ/un65XbKUdS1qia+1ohHYOPowoJXknK5Rvpb4LFueNyndsm1tQuL/CLjJcFJ1UuFQ+dr29Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940167; c=relaxed/simple;
	bh=7xJL3FB2do9fC11Zl+S0a06nFqJpZwHOhXVU/K9i+EY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AHECuzCUDh19jqvESoJgJjeqwya0GitCpUMF6TwGSyF09WObKIf3eC/xE5Ki3ugw4EEMrM3Fq9Gp7IVjSTY8Gl5w6pHUQUoUFLbgZsUvBGhRSwoSdhaQAcUkDbWmf1QA7TJ/P+fo8/rcCP7Tf/IJkhmDTBCBQ1i8fyvARqPREKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sTQAB3br; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sTQAB3br"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0A03C116B1;
	Tue,  2 Jul 2024 17:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940167;
	bh=7xJL3FB2do9fC11Zl+S0a06nFqJpZwHOhXVU/K9i+EY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sTQAB3brbnXq0S93gbgJ2EYUKEnQ3AHrI2aaFaQy4Oilm8yH1tpxWgj7ITCUEvK/D
	 uvEUQjStuKVN+EWFNVWQ9X+cDsqghPfoPpDDDSr0U67VH5amwjtyySvXT1OOWwc6Js
	 YndF/H90UIBKtPyFmec/C4vM7CQwfVYG/FqH3xdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 072/222] drm/xe: Add a NULL check in xe_ttm_stolen_mgr_init
Date: Tue,  2 Jul 2024 19:01:50 +0200
Message-ID: <20240702170246.732865129@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nirmoy Das <nirmoy.das@intel.com>

[ Upstream commit a6eff8f9c7e844cb24ccb188ca24abcd59734e74 ]

Add an explicit check to ensure that the mgr is not NULL.

Cc: Matthew Auld <matthew.auld@intel.com>
Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240319130925.22399-1-nirmoy.das@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_ttm_stolen_mgr.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_ttm_stolen_mgr.c b/drivers/gpu/drm/xe/xe_ttm_stolen_mgr.c
index 3107d2a12426c..fb35e46d68b49 100644
--- a/drivers/gpu/drm/xe/xe_ttm_stolen_mgr.c
+++ b/drivers/gpu/drm/xe/xe_ttm_stolen_mgr.c
@@ -207,6 +207,11 @@ void xe_ttm_stolen_mgr_init(struct xe_device *xe)
 	u64 stolen_size, io_size, pgsize;
 	int err;
 
+	if (!mgr) {
+		drm_dbg_kms(&xe->drm, "Stolen mgr init failed\n");
+		return;
+	}
+
 	if (IS_SRIOV_VF(xe))
 		stolen_size = 0;
 	else if (IS_DGFX(xe))
-- 
2.43.0



