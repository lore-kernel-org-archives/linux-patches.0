Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F033370FB;
	Fri, 17 Oct 2025 15:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715061; cv=none; b=c8gjDVyhwvN1KHM9HOROK5zgVVcHXWWxS5GP8vSwVXjLbCmikYNel/wdHrnVufR5LJ4FrGm+rL2k8MCQvm2pDAuKRlUowN3pTkiiChEtQCQh2PaDcmw2PfXP1s9v+WUCOEqp3KVaNFszVloSoNYQBQirKSkbuJoV7DawdDUaQFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715061; c=relaxed/simple;
	bh=TPvulGeYaVaKGeTksUcjuySdRUjqe6+V3iUb7cxRujE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ouj5Kf8OSrLl8fmy48LnkMTs5yo+MTCFArN/yyUiZpbRK5ZoAiZaDVa0fhpzJanJNTd0gk46bTjoljpRSJVQmBDsbImAI2SHFdO9Ai6sr4OmS29E5BJHp8SvVio6xjSPdDPw5fYp2tF9sy56VAP95AoRLSlcKFz4Lj9rw78bmKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NxM+gmFY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NxM+gmFY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B25C4CEE7;
	Fri, 17 Oct 2025 15:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715061;
	bh=TPvulGeYaVaKGeTksUcjuySdRUjqe6+V3iUb7cxRujE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NxM+gmFYTFp0h1WrvQoc65qcyDnDOOCU7eydLZtSt4Mj6os8kA5GpEeulCWIxTGlU
	 NQso/mYXk1ZsQXwC6tMvypFhyl9Yc5Pjk8VT68M1UKHomPY8y6/AX0ocB8djAAXWA+
	 pcwQy7NyPiGn0aojubPqQKtZ+ePBTK1KeUuAxTLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raag Jadav <raag.jadav@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 083/371] drm/xe/i2c: Dont rely on d3cold.allowed flag in system PM path
Date: Fri, 17 Oct 2025 16:50:58 +0200
Message-ID: <20251017145204.942180796@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raag Jadav <raag.jadav@intel.com>

[ Upstream commit 1af59cd5cc2b65d7fc95165f056695ce3f171133 ]

In S3 and above sleep states, the device can loose power regardless of
d3cold.allowed flag. Bring up I2C controller explicitly in system PM
path to ensure its normal operation after losing power.

v2: Cover S3 and above states (Rodrigo)

Fixes: 0ea07b69517a ("drm/xe/pm: Wire up suspend/resume for I2C controller")
Signed-off-by: Raag Jadav <raag.jadav@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://lore.kernel.org/r/20250918103200.2952576-1-raag.jadav@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit e4863f1159befcd70df24fcb5458afaf2feab043)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_pm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_pm.c b/drivers/gpu/drm/xe/xe_pm.c
index bb9b6ecad2afc..3e301e42b2f19 100644
--- a/drivers/gpu/drm/xe/xe_pm.c
+++ b/drivers/gpu/drm/xe/xe_pm.c
@@ -194,7 +194,7 @@ int xe_pm_resume(struct xe_device *xe)
 	if (err)
 		goto err;
 
-	xe_i2c_pm_resume(xe, xe->d3cold.allowed);
+	xe_i2c_pm_resume(xe, true);
 
 	xe_irq_resume(xe);
 
-- 
2.51.0



