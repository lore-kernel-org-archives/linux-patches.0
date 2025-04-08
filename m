Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0DD219AD5C;
	Tue,  8 Apr 2025 11:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112519; cv=none; b=MXPn1Ns9P9fl8GRAj7P/dz7p/OOqjcOMUsbrFrgn00K/krlZAZm9ud3upAFT8rSSqrEz6KTdUfNytwZaGyAIEvBOmVVpB2aNaJu3y8B/Qe0RuYMQJp4fCeDUtibWtgMltDT+dAZeqvozFWmNnMWv24/1yPPXhh5jb19JojdR788=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112519; c=relaxed/simple;
	bh=kX7eBGhg1xNNZJj1Ryl4hB8e0mhx3rc/tWUU7SWGytU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IwhWpnyrVXCwwseEiXd7BMtAnEhUN5XSeab8DurwNiwHLio2pCvlDVVshj/pE2y+7ofcvEaC9lQ2YHPG3Ja0DDNa8ef3e5hRbn6Z5g0dLPs/UrJUy72pCusLK3wnIYDOuPpeJaSbpb3Sos6DgtIqzvoocDzqLKRaUHLF3zDHsdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G7t4n/Mh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G7t4n/Mh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC609C4CEE5;
	Tue,  8 Apr 2025 11:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112519;
	bh=kX7eBGhg1xNNZJj1Ryl4hB8e0mhx3rc/tWUU7SWGytU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G7t4n/MhjL5oCoxCTfA1V5NB6u84XgSSYkOvGCqd8mHg94NWeXIVRVqtt0nATeBEu
	 eLdupmymgOuqU9sF4DuGqXmNo0XypobGNxN7SWtEEcUuUA4ZmAeAjqAIkfnnCP4W7R
	 4ry9i+v3iXMEW09S9t7DfPOHXe+uVy8s2Toh/AP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Eggers <ceggers@arri.de>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 098/279] regulator: check that dummy regulator has been probed before using it
Date: Tue,  8 Apr 2025 12:48:01 +0200
Message-ID: <20250408104828.996816164@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2047,6 +2047,10 @@ static int regulator_resolve_supply(stru
 
 		if (have_full_constraints()) {
 			r = dummy_regulator_rdev;
+			if (!r) {
+				ret = -EPROBE_DEFER;
+				goto out;
+			}
 			get_device(&r->dev);
 		} else {
 			dev_err(dev, "Failed to resolve %s-supply for %s\n",
@@ -2064,6 +2068,10 @@ static int regulator_resolve_supply(stru
 			goto out;
 		}
 		r = dummy_regulator_rdev;
+		if (!r) {
+			ret = -EPROBE_DEFER;
+			goto out;
+		}
 		get_device(&r->dev);
 	}
 
@@ -2172,8 +2180,10 @@ struct regulator *_regulator_get(struct
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
 


