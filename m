Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F71B2676E1;
	Tue,  8 Apr 2025 10:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109889; cv=none; b=IZH0VMeCRRkf/whlA3SnDIn7EyI1tMlbpS/+AirJrbgSZGgCFxnSkzIX4ead09dnEYHEStdniohdRLZNkUy85nUd8TyhS7gyJP131nDmK81gif3lUbgiBMA2/Q3cso4Hod3fwI5b8AgcXDxtoXaBo0JtUhMoDMb7vefEaugAsH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109889; c=relaxed/simple;
	bh=RLmunSpY+eT4btsqY9/QqxlhrNco2L6q4UhWsYYeXbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gwyr/aWBGgg9hrLN8LsgFZp4gjq4AjBgWJvJV+ttjzwGpBERCQsKHV8ejug/ZvF1XumTD270xSU7XGB+yCvLBtYSV5rjxJqFSVaaVv6TgfztSl2nMDkG17NzC12v777WAwgG8iKFJY1aPNOpQo1Oj7busgywr+5mUdwpuqFOfVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KCj50uIb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KCj50uIb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A22C9C4AF0B;
	Tue,  8 Apr 2025 10:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109889;
	bh=RLmunSpY+eT4btsqY9/QqxlhrNco2L6q4UhWsYYeXbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KCj50uIbAgRFiNQFvLaOTAgjWEhG2D8qcW0vFnYsVsvu+l3NA2xZA3EyRinjcH2yW
	 4w2nxW+rZwbS82zms3t7JpAjbqa54cN4gXPBNujBIdfasqVVXvk6w4Ehqaq/49nTzs
	 K/X8LqVNFJQIQMqjB17B3oxVgJgJU1vYdQdrkpTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Eggers <ceggers@arri.de>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 083/227] regulator: check that dummy regulator has been probed before using it
Date: Tue,  8 Apr 2025 12:47:41 +0200
Message-ID: <20250408104822.875585062@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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
@@ -1924,6 +1924,10 @@ static int regulator_resolve_supply(stru
 
 		if (have_full_constraints()) {
 			r = dummy_regulator_rdev;
+			if (!r) {
+				ret = -EPROBE_DEFER;
+				goto out;
+			}
 			get_device(&r->dev);
 		} else {
 			dev_err(dev, "Failed to resolve %s-supply for %s\n",
@@ -1941,6 +1945,10 @@ static int regulator_resolve_supply(stru
 			goto out;
 		}
 		r = dummy_regulator_rdev;
+		if (!r) {
+			ret = -EPROBE_DEFER;
+			goto out;
+		}
 		get_device(&r->dev);
 	}
 
@@ -2049,8 +2057,10 @@ struct regulator *_regulator_get(struct
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
 


