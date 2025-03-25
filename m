Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4DA629C354;
	Tue, 25 Mar 2025 12:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906195; cv=none; b=lTsU/FLvK+D/mmhqQs4zuqZiF/fd4qgIm1No/P78nzTHW7wqjyYl/7LFwf65VCKYOuaeT7zEEIlSfSqTTzWcLeK+/YxdAPKEsDLpLipwMGm1I/soDr6NrCwTFc3570BSngy+f1/LmAuao+ZFFAj1qAi952/bBTMXeSKvJQqCiuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906195; c=relaxed/simple;
	bh=K4VqFj7PK9nrpOzN2O3fU2rG3fAyj9Nzu3XEoU/9XZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gTpXapW4Co4Mnuziajetoz+gyciUmWRNpkczujbUeornMDyJTrXbFyKYg3s6hcwo2SQFQafuu8eld8HnbzqNYezOJfjZpomSyaCpsed6vIVwheDTlaJWsZZcpJND9uyKL8raWIWHfTwMT70xqIELuD5GGzuzXpaI4Xq44z+387Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BICAHKIL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BICAHKIL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BB01C4CEE4;
	Tue, 25 Mar 2025 12:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906195;
	bh=K4VqFj7PK9nrpOzN2O3fU2rG3fAyj9Nzu3XEoU/9XZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BICAHKILuXEu/JvbPdF8QJUekt5ghtIqSB29yvBqd6Un6u5ncwULKOkwanWfay2qa
	 0foL1ZM7sUm5ZQRjvpEbAd8w78y6nvsqelXg3qZHm/CKwrzdY5TGmDgrPui4VZIBAr
	 UtjznMTFWkyh/lDjtWceVaY6+vYh0M8Ag+ilLD5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Eggers <ceggers@arri.de>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 37/77] regulator: check that dummy regulator has been probed before using it
Date: Tue, 25 Mar 2025 08:22:32 -0400
Message-ID: <20250325122145.324670626@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122144.259256924@linuxfoundation.org>
References: <20250325122144.259256924@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2084,6 +2084,10 @@ static int regulator_resolve_supply(stru
 
 		if (have_full_constraints()) {
 			r = dummy_regulator_rdev;
+			if (!r) {
+				ret = -EPROBE_DEFER;
+				goto out;
+			}
 			get_device(&r->dev);
 		} else {
 			dev_err(dev, "Failed to resolve %s-supply for %s\n",
@@ -2101,6 +2105,10 @@ static int regulator_resolve_supply(stru
 			goto out;
 		}
 		r = dummy_regulator_rdev;
+		if (!r) {
+			ret = -EPROBE_DEFER;
+			goto out;
+		}
 		get_device(&r->dev);
 	}
 
@@ -2209,8 +2217,10 @@ struct regulator *_regulator_get(struct
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
 


