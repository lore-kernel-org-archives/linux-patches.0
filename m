Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A14D625B680;
	Tue, 25 Mar 2025 12:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905975; cv=none; b=i4pb9Lns1mz9lPUjeL4YMZsjFsMqJfY8ALYfK8X7m4MdxvyPGXTQFu30Bki98LVyZol7Ic+DdkdUQccL6mo7z7985WY0rwSUnB+XEcQhvFg4SyIOY0ZoZHr/aRcHDkcZD06TTeTF73C9oVdAT9cz8HgLcCZYdDqgFLsqau8tyKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905975; c=relaxed/simple;
	bh=fz0yyzKnk4pgKBdCYifzDxwZ7VleVllt24J7npXoSgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d5JvLqxynJTs9a2QcGmczQ7ArqQN6YzyJbOIboeqrlclnaLyK0e5AHw0XCYFMBTjH9huwyGx+oqWiCsh6hpmT/8aYvEWOJbQQA+ZhzNqG0XDbDehVF3Pk5cHLKoPql8eDUuROY6a4ZUdMWeFBufClVmTT8yF4TTp6MwgiYrqayY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NXzzHbQw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NXzzHbQw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9F0C4CEE4;
	Tue, 25 Mar 2025 12:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905975;
	bh=fz0yyzKnk4pgKBdCYifzDxwZ7VleVllt24J7npXoSgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NXzzHbQwJvZdBp/dcfIlR/NTm6zX5fLuKSsR9YaRQL/3JuDSjhNuBcDipeKnwaVfh
	 ZbZ4b8wJC96W7s/Q+whGrZP7Hq0U1VBiF57HtGfxxPC9Yv4M/n5jlwHsXOcYiy7XTL
	 T/yrBGFmGVKJFWdPeczoSTCoPTg2w/hhDiwgH0CA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Eggers <ceggers@arri.de>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.13 067/119] regulator: check that dummy regulator has been probed before using it
Date: Tue, 25 Mar 2025 08:22:05 -0400
Message-ID: <20250325122150.769604297@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2025,6 +2025,10 @@ static int regulator_resolve_supply(stru
 
 		if (have_full_constraints()) {
 			r = dummy_regulator_rdev;
+			if (!r) {
+				ret = -EPROBE_DEFER;
+				goto out;
+			}
 			get_device(&r->dev);
 		} else {
 			dev_err(dev, "Failed to resolve %s-supply for %s\n",
@@ -2042,6 +2046,10 @@ static int regulator_resolve_supply(stru
 			goto out;
 		}
 		r = dummy_regulator_rdev;
+		if (!r) {
+			ret = -EPROBE_DEFER;
+			goto out;
+		}
 		get_device(&r->dev);
 	}
 
@@ -2167,8 +2175,10 @@ struct regulator *_regulator_get_common(
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
 


