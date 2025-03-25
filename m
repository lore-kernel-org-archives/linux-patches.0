Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13BF5267B9F;
	Tue, 25 Mar 2025 12:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905856; cv=none; b=ddbtx+9MJn2q2moohVVw56P88ZhXFNpFIdu5hYRbAQXP6IUqKCcbb03FBgsgUdIb2woqWOkgnrzWtRMuc1ymvU9RA8hbEFy5LSQKnb1BSQLLtJiVUuiF4TsanhD8BKGDwq5nGbCLdmNW8fP3xU+RGGeKY77tBLWSQBqtaLKTz30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905856; c=relaxed/simple;
	bh=TWHJs0Rgtgi/gjhepEJSMveLJDGM7aytLh+EYC+hBNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=plIWcNM5gLLDYirM+L3VWHoFrM7ov7wv6FltvUj8x8Fpwwman6gXChwJo0atuaGfOB7mYELZlGOU2KUDqyaiG8Qam2ISbnfYNsXUtDU0+3lhNqCmETNJt/7eTA3egvKiZyDwOgC+/LQxQVgf1PzNH83+hx1g8VahJ28P8slB474=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SZVWCkuw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SZVWCkuw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F66C4CEE4;
	Tue, 25 Mar 2025 12:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905856;
	bh=TWHJs0Rgtgi/gjhepEJSMveLJDGM7aytLh+EYC+hBNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SZVWCkuwUqynREwBj2IfmAag9RXrViAnQJV1eT7d1iOCXmbuCugdutYIp6Q4Qf53X
	 IZCyKkOyEjRWQO99v3b8B/kOShFupHIYqi9HtA9HJUYyRHIovqSJTePoQe1ghIOP9g
	 +wwSF/pNS4fxbbx+y4rFx8/cIrEGPO7GQFBa+kAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Eggers <ceggers@arri.de>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 173/198] regulator: check that dummy regulator has been probed before using it
Date: Tue, 25 Mar 2025 08:22:15 -0400
Message-ID: <20250325122201.183300195@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Eggers <ceggers@arri.de>

commit 2c7a50bec4958f1d1c84d19cde518d0e96a676fd upstream.

Due to asynchronous driver probing there is a chance that the dummy
regulator hasn't already been probed when first accessing it.

Cc: stable@vger.kernel.org
Signed-off-by: Christian Eggers <ceggers@arri.de>
Link: https://patch.msgid.link/20250313103051.32430-3-ceggers@arri.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/core.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2091,6 +2091,10 @@ static int regulator_resolve_supply(stru
 
 		if (have_full_constraints()) {
 			r = dummy_regulator_rdev;
+			if (!r) {
+				ret = -EPROBE_DEFER;
+				goto out;
+			}
 			get_device(&r->dev);
 		} else {
 			dev_err(dev, "Failed to resolve %s-supply for %s\n",
@@ -2108,6 +2112,10 @@ static int regulator_resolve_supply(stru
 			goto out;
 		}
 		r = dummy_regulator_rdev;
+		if (!r) {
+			ret = -EPROBE_DEFER;
+			goto out;
+		}
 		get_device(&r->dev);
 	}
 
@@ -2216,8 +2224,10 @@ struct regulator *_regulator_get(struct
 			 * enabled, even if it isn't hooked up, and just
 			 * provide a dummy.
 			 */
-			dev_warn(dev, "supply %s not found, using dummy regulator\n", id);
 			rdev = dummy_regulator_rdev;
+			if (!rdev)
+				return ERR_PTR(-EPROBE_DEFER);
+			dev_warn(dev, "supply %s not found, using dummy regulator\n", id);
 			get_device(&rdev->dev);
 			break;
 


