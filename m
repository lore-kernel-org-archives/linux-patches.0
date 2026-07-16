Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C785A79B;
	Thu, 16 Jul 2026 14:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210945; cv=none; b=elw0yZjdqGO5euuqke+iP9zYJnlryaPiELtw554uwJR3j4I8U7NLwrnpHCiKS2TdxVSr0D0vIz+i40ECbVXg2jcFPP8oEFn7uI9rSwvV48vC0COKNl/gRWGt2fa3JyCvqDc0Si9FPS891rkRQs6YxLhFUT4WGCizgN3hI/zeZP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210945; c=relaxed/simple;
	bh=6Vf6MUToA3QO1I0IhaY+EVdvNiKNk3AmaBuUwJCj0b4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TizSDjo/TAjAeOE0p0wCW7JMzpm4I0cD8aTl7AlVb88CljSfGEFNkvmFdoULGXeIghoVJFG9rJ/44kpgpyezVRNGIios0JS8PtqBKFivgQH73EKwqYBG4DTln2eAni1bofAiUC476jmgI4QlYRAPcaujhQ5uhIjp42W6oTIaVf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Biv3trLg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Biv3trLg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 826A01F00ADF;
	Thu, 16 Jul 2026 14:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210944;
	bh=At97cN0nte6jMA88DrlTNkPG0aO/d7cFIZ7SoYyMexI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Biv3trLgcoL72//OQAPHK3dMf7W21p1queydKCcBi81EbnCAsL5TQdzYGctlNgu+Q
	 2ly4Iso4Ia6F65qzhICffPHQ0o6Oc91LW2U3w+vJAecmRzbGu0jmNtop3hJQ3s3Gr9
	 ebwyOF/t1roAG+Hn00mE735fSveX83+H5dUPVMh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 6.18 241/480] OPP: of: Fix potential memory leak in opp_parse_supplies()
Date: Thu, 16 Jul 2026 15:29:48 +0200
Message-ID: <20260716133050.033954351@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit 69f888381d2ecbe18ed9f112c096f8fd3623db98 upstream.

The memory allocated for microvolt, microamp and microwatt is not freed
in one of the paths in opp_parse_supplies() which returns directly.
Fix that by adding a goto to the error unwind ladder.

Fixes: 2eedf62e66c2 ("OPP: decouple dt properties in opp_parse_supplies()")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/opp/of.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/opp/of.c
+++ b/drivers/opp/of.c
@@ -669,7 +669,7 @@ static int opp_parse_supplies(struct dev
 	 */
 	if (unlikely(opp_table->regulator_count == -1)) {
 		opp_table->regulator_count = 0;
-		return 0;
+		goto free_microwatt;
 	}
 
 	for (i = 0, j = 0; i < opp_table->regulator_count; i++) {
@@ -692,6 +692,7 @@ static int opp_parse_supplies(struct dev
 			opp->supplies[i].u_watt = microwatt[i];
 	}
 
+free_microwatt:
 	kfree(microwatt);
 free_microamp:
 	kfree(microamp);


