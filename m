Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586FF1BDFF;
	Wed,  3 Jan 2024 17:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lYQ6s5c4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7756BC433C8;
	Wed,  3 Jan 2024 17:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301409;
	bh=l4Fl0VxmK2rNm571kKx8EGWrdudXV015XAjL3C2eMoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lYQ6s5c47BLCuCR4ch6jaB4Kk75QjY9dM1GcnZHPJE2nMP8YVei6dSXo3IyAuOFnD
	 be0LyUYnHtHWOhgPZ1l6f/rsGfIaMsipbt8FFN8x/aUGlrl9gmA/56L0e/Xeuspsr6
	 Vz9JytP3r/cBzg0XNoTyW58/35DTljSSCdI/viGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 03/95] reset: Fix crash when freeing non-existent optional resets
Date: Wed,  3 Jan 2024 17:54:11 +0100
Message-ID: <20240103164854.400058582@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164853.921194838@linuxfoundation.org>
References: <20240103164853.921194838@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 4a6756f56bcf8e64c87144a626ce53aea4899c0e ]

When obtaining one or more optional resets, non-existent resets are
stored as NULL pointers, and all related error and cleanup paths need to
take this into account.

Currently only reset_control_put() and reset_control_bulk_put()
get this right.  All of __reset_control_bulk_get(),
of_reset_control_array_get(), and reset_control_array_put() lack the
proper checking, causing NULL pointer dereferences on failure or
release.

Fix this by moving the existing check from reset_control_bulk_put() to
__reset_control_put_internal(), so it applies to all callers.
The double check in reset_control_put() doesn't hurt.

Fixes: 17c82e206d2a3cd8 ("reset: Add APIs to manage array of resets")
Fixes: 48d71395896d54ee ("reset: Add reset_control_bulk API")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/2440edae7ca8534628cdbaf559ded288f2998178.1701276806.git.geert+renesas@glider.be
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/reset/core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/reset/core.c b/drivers/reset/core.c
index 61e6888826432..320412e513c07 100644
--- a/drivers/reset/core.c
+++ b/drivers/reset/core.c
@@ -806,6 +806,9 @@ static void __reset_control_put_internal(struct reset_control *rstc)
 {
 	lockdep_assert_held(&reset_list_mutex);
 
+	if (IS_ERR_OR_NULL(rstc))
+		return;
+
 	kref_put(&rstc->refcnt, __reset_control_release);
 }
 
@@ -1016,11 +1019,8 @@ EXPORT_SYMBOL_GPL(reset_control_put);
 void reset_control_bulk_put(int num_rstcs, struct reset_control_bulk_data *rstcs)
 {
 	mutex_lock(&reset_list_mutex);
-	while (num_rstcs--) {
-		if (IS_ERR_OR_NULL(rstcs[num_rstcs].rstc))
-			continue;
+	while (num_rstcs--)
 		__reset_control_put_internal(rstcs[num_rstcs].rstc);
-	}
 	mutex_unlock(&reset_list_mutex);
 }
 EXPORT_SYMBOL_GPL(reset_control_bulk_put);
-- 
2.43.0



