Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFAF7FC08
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:39:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 254DAC433D2;
	Mon, 15 May 2023 17:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172371;
	bh=z9OfcpoRH7qG3tidyN1UjBAxE7V/GJrJlPi1fag2/Yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AWrSAcjTNdQ/0l8czR5mOFA6sdrmfBaCaFR2IEzYKIApZcg1qUcd1FlOjB32LrLuy
	 vQMY6QwnQ+RipoxkG55BCiPkbnbY1JxQ7WzAJICWssDEKkVABFFRWKi8+VJkF2bVCW
	 nGqXQcbSI6RJGTXyAszR0gp9VapqnyDSO3GaGf4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 103/381] regulator: core: Consistently set mutex_owner when using ww_mutex_lock_slow()
Date: Mon, 15 May 2023 18:25:54 +0200
Message-Id: <20230515161741.451375836@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit b83a1772be854f87602de14726737d3e5b06e1f4 ]

When a codepath locks a rdev using ww_mutex_lock_slow() directly then
that codepath is responsible for incrementing the "ref_cnt" and also
setting the "mutex_owner" to "current".

The regulator core consistently got that right for "ref_cnt" but
didn't always get it right for "mutex_owner". Let's fix this.

It's unlikely that this truly matters because the "mutex_owner" is
only needed if we're going to do subsequent locking of the same
rdev. However, even though it's not truly needed it seems less
surprising if we consistently set "mutex_owner" properly.

Fixes: f8702f9e4aa7 ("regulator: core: Use ww_mutex for regulators locking")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20230329143317.RFC.v2.1.I4e9d433ea26360c06dd1381d091c82bb1a4ce843@changeid
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 6dd698b2d0af3..bd2a3f44dd6ea 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -343,6 +343,7 @@ static void regulator_lock_dependent(struct regulator_dev *rdev,
 			ww_mutex_lock_slow(&new_contended_rdev->mutex, ww_ctx);
 			old_contended_rdev = new_contended_rdev;
 			old_contended_rdev->ref_cnt++;
+			old_contended_rdev->mutex_owner = current;
 		}
 
 		err = regulator_lock_recursive(rdev,
@@ -5800,6 +5801,7 @@ static void regulator_summary_lock(struct ww_acquire_ctx *ww_ctx)
 			ww_mutex_lock_slow(&new_contended_rdev->mutex, ww_ctx);
 			old_contended_rdev = new_contended_rdev;
 			old_contended_rdev->ref_cnt++;
+			old_contended_rdev->mutex_owner = current;
 		}
 
 		err = regulator_summary_lock_all(ww_ctx,
-- 
2.39.2



