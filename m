Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF464EF13A;
	Tue, 13 Oct 2026 11:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892208; cv=none; b=sbvs6aClVCuaBgeDtju2uoWlO/aJsUHIpjiqiW+qxpNAspeFSWp+HGhWYD8eRR9l9JQeBLcIJ/iUjkei3cAMca3PtBSD7daUmVd+PQ8+Wq3iieAXmAnn33cfy7O5f7Rg9pqN75+U06VLuLxS5772/2yTDiyRsefBP93rQP4b7yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892208; c=relaxed/simple;
	bh=UFvzuuTai2L5HttmV7y0q5yDmypXxcePItZ14gSRUNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A24Iuhqx1lKYV0AyXQ6wkjGMWFTfEnk98326q9xir9xrpRMGSMTSIKNMysZ/V2bgqBNzr/Z6z+dRUeAA9hORSFL9gCulCOFVYcEnOGpQHZdXuFfjAONaKqW6sK+GYEkf5kRhE65mAgDG4UiGuiV35saa/6xr5TrsSyTMKD6gYro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a8SKD+rI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a8SKD+rI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4967D1F000FF;
	Tue, 13 Oct 2026 11:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892206;
	bh=esWpzMcyVfhujcqr/W2PXpBIE9Dm6qMG99geRFHACw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a8SKD+rIgqTE3U+wSOpckU0ktcaMf8MAbjj6Y+x5rdWc6t5TKyrFqFwqpJSEG5gNS
	 PYeVexZCT2CBCyC27kA7a6IdFfhhO9D3amNYOtLnlAKbmy9IMEms3t8Qo4OjvMq5tC
	 Gl5WSk/tWd2sBVneR/2b6UQAfiZeLM4wwlRypeio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Alexey Charkov <alchark@flipper.net>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 096/281] regulator: of: fill in supply names in of_regulator_bulk_get_all()
Date: Tue, 13 Oct 2026 13:36:52 +0200
Message-ID: <20261013112857.468134809@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Charkov <alchark@flipper.net>

commit e2151c29cec73f6cc70abf1c7cbc7b9b202489f5 upstream.

of_regulator_bulk_get_all() returns an array it allocated itself, and
fills in only the consumer of each entry. Every other way of getting a
bulk array has the supply name set, because the caller provides it, and
the core expects it to be there: regulator_bulk_enable() prints it when
a supply fails to enable, so a caller that hands such an array to it
dereferences uninitialised memory on that path.

Copy each name into the array's own allocation, right behind the
entries, so that it shares the array's lifetime and callers still have
nothing extra to free. That also retires the fixed 64 byte stack buffer
the names were assembled in, which is_supply_name() never bounded the
copy against.

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260928-b4-rk3576-reboot-mode-v1-0-65486b03bd41@flipper.net?part=3
Fixes: 27b9ecc7a9ba ("regulator: Add of_regulator_bulk_get_all")
Signed-off-by: Alexey Charkov <alchark@flipper.net>
Link: https://patch.msgid.link/20260930-regulator-get-all-v2-1-ca82070d22f2@flipper.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/of_regulator.c |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -935,15 +935,15 @@ static int is_supply_name(const char *na
 int of_regulator_bulk_get_all(struct device *dev, struct device_node *np,
 			      struct regulator_bulk_data **consumers)
 {
-	int num_consumers = 0;
+	int num_consumers = 0, names_len = 0;
 	struct regulator *tmp;
 	struct regulator_bulk_data *_consumers = NULL;
 	struct property *prop;
+	char *names;
 	int i, n = 0, ret;
-	char name[64];
 
 	/*
-	 * first pass: get numbers of xxx-supply
+	 * first pass: get numbers of xxx-supply and the room their names take
 	 * second pass: fill consumers
 	 */
 restart:
@@ -953,16 +953,19 @@ restart:
 			continue;
 		if (!_consumers) {
 			num_consumers++;
+			names_len += i + 1;
 			continue;
 		} else {
-			memcpy(name, prop->name, i);
-			name[i] = '\0';
-			tmp = regulator_get(dev, name);
+			memcpy(names, prop->name, i);
+			names[i] = '\0';
+			tmp = regulator_get(dev, names);
 			if (IS_ERR(tmp)) {
 				ret = PTR_ERR(tmp);
 				goto error;
 			}
+			_consumers[n].supply = names;
 			_consumers[n].consumer = tmp;
+			names += i + 1;
 			n++;
 			continue;
 		}
@@ -973,9 +976,16 @@ restart:
 	}
 	if (num_consumers == 0)
 		return 0;
-	_consumers = kmalloc_objs(struct regulator_bulk_data, num_consumers);
+	/*
+	 * The supply names are kept in the same allocation as the array, so
+	 * that they share its lifetime and the caller has nothing extra to
+	 * free.
+	 */
+	_consumers = kzalloc(size_add(size_mul(num_consumers, sizeof(*_consumers)),
+				      names_len), GFP_KERNEL);
 	if (!_consumers)
 		return -ENOMEM;
+	names = (char *)(_consumers + num_consumers);
 	goto restart;
 
 error:


