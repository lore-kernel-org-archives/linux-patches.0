Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2DF82E3FD;
	Fri,  5 Jan 2024 14:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GnzcqeTd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 343B0C433C8;
	Fri,  5 Jan 2024 14:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704465746;
	bh=uPvubaph/so3GhfHoLvbztdwyfG4VfccNGjBuc7Fcr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GnzcqeTdbs0/ac5vh998wbXYrnoPFb8dkC8lvD/KrOiPcdAnCh6GQqjwmvDtD6HG+
	 qm//swgUhty7W8G69Z8dPNbdxhMwff3lknGW8c6fcoPucbe9g6FR+9nK+k/oJlcgZR
	 Xoyf1cgeKTTpINr8RPqk1XY2eABXxb+e9tj5m8DY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 04/47] reset: Fix crash when freeing non-existent optional resets
Date: Fri,  5 Jan 2024 15:38:51 +0100
Message-ID: <20240105143815.694448982@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240105143815.541462991@linuxfoundation.org>
References: <20240105143815.541462991@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/reset/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/reset/core.c b/drivers/reset/core.c
index 688b4f6227fcb..57219aa22ee87 100644
--- a/drivers/reset/core.c
+++ b/drivers/reset/core.c
@@ -597,6 +597,9 @@ static void __reset_control_put_internal(struct reset_control *rstc)
 {
 	lockdep_assert_held(&reset_list_mutex);
 
+	if (IS_ERR_OR_NULL(rstc))
+		return;
+
 	kref_put(&rstc->refcnt, __reset_control_release);
 }
 
-- 
2.43.0



