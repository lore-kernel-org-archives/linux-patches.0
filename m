Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F663BC68E;
	Wed, 30 Sep 2026 18:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794780; cv=none; b=NMCTEAYtTCaVFcadY+iV1tmLPXjX77xmnA9dxhJdiansyeqLxFMc8XCoixK3iDnnfgn4YbsXSvFeXGf8hmuylS5buYd5eyTpaAUGVUKekUY0KBel2xt5bogLeKHQeqeqOiY1G4SMBZvYr+ceWS29A+icIPK5cgES8WehbJtXybs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794780; c=relaxed/simple;
	bh=g8Kv9MKYXdnEPARGuTOs9k9Kz3js14jKd6tDdq+EXfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jma8Z0/pKMYnqbx97Iq5pszEhhZZBUe+Gq3PsBz+O5N/jfgyMpQGiNZjtfoIiaAOMh4zgerImhPvxkgd5MX7jL5gLZkceBmGaJ+SRQpnm1sjSENpgxzkOvvJt4HsrpQsw7DlDR1WpLBg+j/Jqfwfhlb7mL7Ai3kk6/lnC+HIBQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2MtnCKhj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2MtnCKhj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC951F000FF;
	Wed, 30 Sep 2026 18:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794779;
	bh=f84KDxX0rOOAz1UpQTTHrgOPUPFKaLGnwtcsZrqUKIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2MtnCKhj4YuxlkyB/Z0cot/yegjImsOXIc8qZcrI7FwblSv9VabZfgobI4leh0mmp
	 Sg4rSK1n1UUVcDh3kJKMcRhynUL6P5WjnKLmY0d26R+NKAvhuftL1XP+y38Qewh1oh
	 Kr4esHIUpjJQa8Xu4PcLa+O9y6x7CVJ8f5mHw2VE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kamal Wadhwa <kamal.wadhwa@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0324/1193] regulator: core: clamp voltage constraints before applying apply_uV
Date: Wed, 30 Sep 2026 17:16:48 +0200
Message-ID: <20260930152441.337546407@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Kamal Wadhwa <kamal.wadhwa@oss.qualcomm.com>

[ Upstream commit a45cc646a3aa83eb4ab4c7ed2685785ea51dc5e6 ]

machine_constraints_voltage() currently applies apply_uV against the
machine-supplied [min_uV, max_uV] range, and only afterwards clamps
that range down to what the regulator can actually supply (via
ops->list_voltage()).

If the machine-supplied range is wider than the regulator's actual
range, apply_uV's rounding can pick a selector outside the (correct)
clamped range, so the regulator ends up programmed outside its clamped
min/max. At bring-up this shows up as a voltage read-back outside the
clamped range.

Fix this by moving the clamping block ahead of the apply_uV block, so
apply_uV always targets an already-clamped range. Whether apply_uV
should run is decided from the unclamped constraints beforehand and
stored in a local bool, since clamping must not itself change whether
apply_uV fires.

No functional change to the clamping logic itself, only its position
relative to apply_uV. Its early return 0 exits become fallthroughs
since the apply_uV logic now follows it.

Assisted-by: Claude:claude-sonnet-5
Signed-off-by: Kamal Wadhwa <kamal.wadhwa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260720-b4-regulator-core-clamp-voltage-v1-1-8e5eec076a8e@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 163 +++++++++++++++++++++------------------
 1 file changed, 90 insertions(+), 73 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 35729234c375d..ce69d37cfaa90 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1242,10 +1242,98 @@ static int machine_constraints_voltage(struct regulator_dev *rdev,
 {
 	const struct regulator_ops *ops = rdev->desc->ops;
 	int ret;
+	bool apply_uV;
+
+	/*
+	 * Decide up front, from the constraints as handed to us, whether
+	 * apply_uV needs to run below. The clamping pass right after this
+	 * may rewrite constraints->min_uV/max_uV (e.g. the fixed-voltage
+	 * autoconfigure case), and we don't want that to change whether
+	 * apply_uV fires.
+	 */
+	apply_uV = rdev->constraints->apply_uV &&
+		   rdev->constraints->min_uV && rdev->constraints->max_uV;
+
+	/*
+	 * Constrain machine-level voltage specs to fit the actual range
+	 * supported by this regulator before apply_uV (below) tries to
+	 * force hardware to a value from that range: otherwise apply_uV
+	 * can target a constraint value that doesn't correspond to any
+	 * real voltage selector and fail registration outright, even
+	 * though the clamping pass would have narrowed it to a value
+	 * the regulator can actually hit.
+	 */
+	if (ops->list_voltage && rdev->desc->n_voltages) {
+		int	count = rdev->desc->n_voltages;
+		int	i;
+		int	min_uV = INT_MAX;
+		int	max_uV = INT_MIN;
+		int	cmin = constraints->min_uV;
+		int	cmax = constraints->max_uV;
+
+		/* it's safe to autoconfigure fixed-voltage supplies
+		 * and the constraints are used by list_voltage.
+		 */
+		if (count == 1 && !cmin) {
+			cmin = 1;
+			cmax = INT_MAX;
+			constraints->min_uV = cmin;
+			constraints->max_uV = cmax;
+		}
+
+		/* voltage constraints are optional */
+		if ((cmin == 0) && (cmax == 0)) {
+			/* nothing more to do */
+
+		/* else require explicit machine-level constraints */
+		} else if (cmin <= 0 || cmax <= 0 || cmax < cmin) {
+			rdev_err(rdev, "invalid voltage constraints\n");
+			return -EINVAL;
+
+		/* no need to loop voltages if range is continuous */
+		} else if (rdev->desc->continuous_voltage_range) {
+			/* nothing more to do */
+
+		} else {
+			/* initial: [cmin..cmax] valid, [min_uV..max_uV] not */
+			for (i = 0; i < count; i++) {
+				int	value;
+
+				value = ops->list_voltage(rdev, i);
+				if (value <= 0)
+					continue;
+
+				/* maybe adjust [min_uV..max_uV] */
+				if (value >= cmin && value < min_uV)
+					min_uV = value;
+				if (value <= cmax && value > max_uV)
+					max_uV = value;
+			}
+
+			/* final: [min_uV..max_uV] valid iff constraints valid */
+			if (max_uV < min_uV) {
+				rdev_err(rdev,
+					 "unsupportable voltage constraints %u-%uuV\n",
+					 min_uV, max_uV);
+				return -EINVAL;
+			}
+
+			/* use regulator's subset of machine constraints */
+			if (constraints->min_uV < min_uV) {
+				rdev_dbg(rdev, "override min_uV, %d -> %d\n",
+					 constraints->min_uV, min_uV);
+				constraints->min_uV = min_uV;
+			}
+			if (constraints->max_uV > max_uV) {
+				rdev_dbg(rdev, "override max_uV, %d -> %d\n",
+					 constraints->max_uV, max_uV);
+				constraints->max_uV = max_uV;
+			}
+		}
+	}
 
 	/* do we need to apply the constraint voltage */
-	if (rdev->constraints->apply_uV &&
-	    rdev->constraints->min_uV && rdev->constraints->max_uV) {
+	if (apply_uV) {
 		int target_min, target_max;
 		int current_uV = regulator_get_voltage_rdev(rdev);
 
@@ -1300,77 +1388,6 @@ static int machine_constraints_voltage(struct regulator_dev *rdev,
 		}
 	}
 
-	/* constrain machine-level voltage specs to fit
-	 * the actual range supported by this regulator.
-	 */
-	if (ops->list_voltage && rdev->desc->n_voltages) {
-		int	count = rdev->desc->n_voltages;
-		int	i;
-		int	min_uV = INT_MAX;
-		int	max_uV = INT_MIN;
-		int	cmin = constraints->min_uV;
-		int	cmax = constraints->max_uV;
-
-		/* it's safe to autoconfigure fixed-voltage supplies
-		 * and the constraints are used by list_voltage.
-		 */
-		if (count == 1 && !cmin) {
-			cmin = 1;
-			cmax = INT_MAX;
-			constraints->min_uV = cmin;
-			constraints->max_uV = cmax;
-		}
-
-		/* voltage constraints are optional */
-		if ((cmin == 0) && (cmax == 0))
-			return 0;
-
-		/* else require explicit machine-level constraints */
-		if (cmin <= 0 || cmax <= 0 || cmax < cmin) {
-			rdev_err(rdev, "invalid voltage constraints\n");
-			return -EINVAL;
-		}
-
-		/* no need to loop voltages if range is continuous */
-		if (rdev->desc->continuous_voltage_range)
-			return 0;
-
-		/* initial: [cmin..cmax] valid, [min_uV..max_uV] not */
-		for (i = 0; i < count; i++) {
-			int	value;
-
-			value = ops->list_voltage(rdev, i);
-			if (value <= 0)
-				continue;
-
-			/* maybe adjust [min_uV..max_uV] */
-			if (value >= cmin && value < min_uV)
-				min_uV = value;
-			if (value <= cmax && value > max_uV)
-				max_uV = value;
-		}
-
-		/* final: [min_uV..max_uV] valid iff constraints valid */
-		if (max_uV < min_uV) {
-			rdev_err(rdev,
-				 "unsupportable voltage constraints %u-%uuV\n",
-				 min_uV, max_uV);
-			return -EINVAL;
-		}
-
-		/* use regulator's subset of machine constraints */
-		if (constraints->min_uV < min_uV) {
-			rdev_dbg(rdev, "override min_uV, %d -> %d\n",
-				 constraints->min_uV, min_uV);
-			constraints->min_uV = min_uV;
-		}
-		if (constraints->max_uV > max_uV) {
-			rdev_dbg(rdev, "override max_uV, %d -> %d\n",
-				 constraints->max_uV, max_uV);
-			constraints->max_uV = max_uV;
-		}
-	}
-
 	return 0;
 }
 
-- 
2.53.0



