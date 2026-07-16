Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441EE425884;
	Thu, 16 Jul 2026 13:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209604; cv=none; b=g6EWKfkdkNqVHPnYDcGhCA7asGnWVfuUpNpPQdwU9OK3LfhLNXFvH7jXm9rSs0dVDCBhmfAFnL3ghSIThwnaV8rkLkXwVOX1+SAPbCIqwJkm9ys28skC+v0j1z97oKSJgw24wggQ6pkbO406Z4nVOK4FrhhCB6SxetOM5CxSEDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209604; c=relaxed/simple;
	bh=IX3UOlldFA0VrbVwcH7qyqBAdbCjxFvTbLG5Jvmfl2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZmzdhSKaItCfObdzSv3kllNZJM2FLNPR4OkamBPOoVg6Q+yasc5qYlxoV7UBN9QtANbZ1yFN6npbdMI+OdYvZveDU9i7939LqnXXAVfJL7nfZBt2sUAPjTF3GerYH7ypsJZXLLB1QecL9yw4/+wuSIxlD9tczVQmm6x2GXC6wF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eR1YXCeJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eR1YXCeJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A93361F00A3F;
	Thu, 16 Jul 2026 13:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209597;
	bh=Fwg+OskGfapwxgmRo8oZUyC2sC0nPmlufCQyLujAwJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eR1YXCeJmfZNtDX+GYWHwBNT4wMf7fIvv28P2ldBCppKU82cvgoayVSsA7159lI/d
	 fZ3165XqhNDkIxGBAzFoF/9qQLAB7Mu1EJHUG3CGemgNrk5USE2hnTZyKsFYR9QkJE
	 YgV4RC5NNTI4szXx49r0GhK19GdWMfx9ou/VZyiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 7.1 245/518] OPP: of: Fix potential memory leak in opp_parse_supplies()
Date: Thu, 16 Jul 2026 15:28:33 +0200
Message-ID: <20260716133053.178430415@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -673,7 +673,7 @@ static int opp_parse_supplies(struct dev
 	 */
 	if (unlikely(opp_table->regulator_count == -1)) {
 		opp_table->regulator_count = 0;
-		return 0;
+		goto free_microwatt;
 	}
 
 	for (i = 0, j = 0; i < opp_table->regulator_count; i++) {
@@ -696,6 +696,7 @@ static int opp_parse_supplies(struct dev
 			opp->supplies[i].u_watt = microwatt[i];
 	}
 
+free_microwatt:
 	kfree(microwatt);
 free_microamp:
 	kfree(microamp);


