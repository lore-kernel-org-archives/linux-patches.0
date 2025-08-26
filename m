Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F121DF75A;
	Tue, 26 Aug 2025 14:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217850; cv=none; b=nTz55JZnuXtKoQjV+FyLDCmR2k8SluC1Zbed09g/HqVxBZBgnN1OfnfqZYciFt1in8oFG7/wRlK9FuUKW5xDiXQm0aYfA1ErwUn6TZme6CzdYWNHrMi4s5KuPcsDX5IttkdlPihUN1OIgO6OMZ/MAfzg/jflCVdk+Kd/u2Oht/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217850; c=relaxed/simple;
	bh=RYXE/WX0KbJ8CqQ10A7iarmXQolqmj+4Jd8RBfOKyHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eGk9zBtLbPOohUzHbQxAjnM1Q5KE/JSYENMTyLzfSdaDUAEf0WczjY+lxu3kPEyVi4nakXil09T29xlPrGlkpk94pqbqMZF4+Mly+h6xXi4Bz8mU67JUFly1CQX3SzlxQNym/12U+AeXmM6cOOt0kFH/IHh3CNApnz0YrTtm4pU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RZuWdHuE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RZuWdHuE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F29C113CF;
	Tue, 26 Aug 2025 14:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217850;
	bh=RYXE/WX0KbJ8CqQ10A7iarmXQolqmj+4Jd8RBfOKyHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RZuWdHuEdl5uf68ZbJQri+qeYHlA7LNEqRM4xT+geH/IAyuU5I2iiLyF4F0+NkzPm
	 zc/SNLagGzE6aD9Wg0ZcMowXZdpMhTCZgeM4+jffVjl4GgIX3QaJmRMrBmnj2jpudx
	 GxguShd7gBbYh/bISPpXEdLRsmQR3el/bBan75nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	jackysliu <1972843537@qq.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 297/523] scsi: bfa: Double-free fix
Date: Tue, 26 Aug 2025 13:08:27 +0200
Message-ID: <20250826110931.774782009@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: jackysliu <1972843537@qq.com>

[ Upstream commit add4c4850363d7c1b72e8fce9ccb21fdd2cf5dc9 ]

When the bfad_im_probe() function fails during initialization, the memory
pointed to by bfad->im is freed without setting bfad->im to NULL.

Subsequently, during driver uninstallation, when the state machine enters
the bfad_sm_stopping state and calls the bfad_im_probe_undo() function,
it attempts to free the memory pointed to by bfad->im again, thereby
triggering a double-free vulnerability.

Set bfad->im to NULL if probing fails.

Signed-off-by: jackysliu <1972843537@qq.com>
Link: https://lore.kernel.org/r/tencent_3BB950D6D2D470976F55FC879206DE0B9A09@qq.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/bfa/bfad_im.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 22f06be2606f..6dcf1094e01b 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -707,6 +707,7 @@ bfad_im_probe(struct bfad_s *bfad)
 
 	if (bfad_thread_workq(bfad) != BFA_STATUS_OK) {
 		kfree(im);
+		bfad->im = NULL;
 		return BFA_STATUS_FAILED;
 	}
 
-- 
2.39.5



