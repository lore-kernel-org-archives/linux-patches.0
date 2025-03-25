Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD99025DB14;
	Tue, 25 Mar 2025 12:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906373; cv=none; b=JTmHd5ALeMQCeEndbTNEoYpzmCp+ciZ9+8QjPy7JYxIdLxeULgzzhQdP9mkv8k1O9ubQ5PrREY7ero6h+t5GIXB3i3NZdOZ+45/5y9NOpjNq6GaxEYKvBSwvdQjv8FTWVnBgFd66hX4AOXmIgiZWtCFR7Ssan/mzSdAMgE5Epdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906373; c=relaxed/simple;
	bh=fmvEn8kGrb0ZaFk5xFX9BZA/hC69HAM4Hy4k9Vf7Bnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SBJtyDAWaYzv2/uuPD5A3yuLO/6uu9xeluV4sq7zDxo4IQkNobUmk/XUiYpaJQ57/nzVrrcx9ZRsb1gpkUgK3vdzkcc9i8POcw+mwkjQaz20ktzbQ2Y6Sxa+2YP8X2BaTaBF5K4brVlVt9Q5W7lFnkDcFm1cl0h1ZBQoFxnXG+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h3v0A5jP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h3v0A5jP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89E95C4CEE4;
	Tue, 25 Mar 2025 12:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906372;
	bh=fmvEn8kGrb0ZaFk5xFX9BZA/hC69HAM4Hy4k9Vf7Bnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h3v0A5jPd104VBpLphFvkH/9pNl1lZAzdJSduM0Y2pDknL2NpHISLRl/sxemhYrDW
	 zdli3CP6Zz7pDMFAhHG1I7NUUQkqiiIHqNn2xGyuYmB9v2wd8ob8Q8+u6OrUs2B3XO
	 3XLkKclUDFEg79l46LIVaIJ501HA+5mlPYTn0BJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Eggers <ceggers@arri.de>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 065/116] regulator: check that dummy regulator has been probed before using it
Date: Tue, 25 Mar 2025 08:22:32 -0400
Message-ID: <20250325122150.871559389@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2024,6 +2024,10 @@ static int regulator_resolve_supply(stru
 
 		if (have_full_constraints()) {
 			r = dummy_regulator_rdev;
+			if (!r) {
+				ret = -EPROBE_DEFER;
+				goto out;
+			}
 			get_device(&r->dev);
 		} else {
 			dev_err(dev, "Failed to resolve %s-supply for %s\n",
@@ -2041,6 +2045,10 @@ static int regulator_resolve_supply(stru
 			goto out;
 		}
 		r = dummy_regulator_rdev;
+		if (!r) {
+			ret = -EPROBE_DEFER;
+			goto out;
+		}
 		get_device(&r->dev);
 	}
 
@@ -2166,8 +2174,10 @@ struct regulator *_regulator_get_common(
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
 


