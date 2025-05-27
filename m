Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55DBB1AF0BB;
	Tue, 27 May 2025 17:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367655; cv=none; b=WZb5+9T6tWdllSYN30Tvn/EuMoFu/E7Cttnceok94YwXwh4PO1VJdb1igd2SQtp2Fc4mbcvKri7t76oMFfsc2srBAMSxI7jkFxTYmJm7SahqygqhE+tJy2NlmgF7t8yMi1cIm2F7qctpRAEWhXgBz6knrehiQVW8rIF54w7sWek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367655; c=relaxed/simple;
	bh=nTcS+f5RCFsGbHHgFb6r/L6ACGahSfmM14azeQ677Q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=To+11BKKLUt5KmRbUXDmiHHVJjSzrlvhADMIU6oyVTX0ZHZLWeqJRTM7BQirbOztk2ii9KfLmkbiTrQVd6SJdfCbcfhfDMQoEqNYwOtcRRSqvbOWeNfXXNWcG6rKSP0y3hnCVHujUgWPhL0N+P2exqiSrmud8TJIRXx2qRk6K+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kv0Zt9zt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kv0Zt9zt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDDCDC4CEE9;
	Tue, 27 May 2025 17:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367655;
	bh=nTcS+f5RCFsGbHHgFb6r/L6ACGahSfmM14azeQ677Q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kv0Zt9ztDVAEn0RjAaZ7Usp01q8XUs7yvVgmqH2LKI99b8FEICI1+0qX/qMVq9ncS
	 gCYhF1A0bgdukvN91YdlPC8JYnLcN8bCjMCMKnUY+RHZ5pR3ZxlroUE92mqRj/Lcsd
	 dbBlAWfxdwYp9lOY6ThIsgu27HmvttBCY95jI3VI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francois Dugast <francois.dugast@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 457/783] drm/xe: Fix xe_tile_init_noalloc() error propagation
Date: Tue, 27 May 2025 18:24:14 +0200
Message-ID: <20250527162531.733294897@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas De Marchi <lucas.demarchi@intel.com>

[ Upstream commit 0bcf41171c64234e79eb3552d00f0aad8a47e8d3 ]

Propagate the error to the caller so initialization properly stops if
sysfs creation fails.

Reviewed-by: Francois Dugast <francois.dugast@intel.com>
Reviewed-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250213192909.996148-4-lucas.demarchi@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_tile.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_tile.c b/drivers/gpu/drm/xe/xe_tile.c
index 07cf7cfe4abd5..37f170effcd67 100644
--- a/drivers/gpu/drm/xe/xe_tile.c
+++ b/drivers/gpu/drm/xe/xe_tile.c
@@ -176,9 +176,7 @@ int xe_tile_init_noalloc(struct xe_tile *tile)
 
 	xe_wa_apply_tile_workarounds(tile);
 
-	err = xe_tile_sysfs_init(tile);
-
-	return 0;
+	return xe_tile_sysfs_init(tile);
 }
 
 void xe_tile_migrate_wait(struct xe_tile *tile)
-- 
2.39.5



