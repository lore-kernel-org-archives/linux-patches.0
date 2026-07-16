Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DBE43CEB92;
	Thu, 16 Jul 2026 14:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212074; cv=none; b=W0AduuneGzJ2tlmsgbMY3AEPDe4xMiJl7G2zVlKGt7j7ZgC9tZNp2IwAXgKNTLmK6k+5EQEk0Pjosh0y48t1Mgb23wAKn/ocVmhEFwmVNlLh2YmruNQp+OVCeYcQlryp05O8CkP3ZvniCekUWgoe7h73PgJ/VAIt1vMhY3bcvxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212074; c=relaxed/simple;
	bh=P/R1fbCH1+by7fFgapczyq52rvRL5prS9rgvbLrK7w8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tYgJgISYME8bWtMaqjSU7Wo92+C9NhcC0x7bmRwkfNtEpLxai0FV/iZ94FssgdqLOumX1qND3EQosBQZM9Qqxv5ySvJlV/KdZc9yU6FwwK0pHOSgJwHAsLSyB0vtq+UN9JtFx5lKqdKSp6ZFM3cMyFhSBCFTVUzLIVBHAEF6PWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oQyfccUg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oQyfccUg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F26951F00A3D;
	Thu, 16 Jul 2026 14:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212073;
	bh=HSyrUj3xqShW/b/CsRiojogd7M+LA3NIFIWjtHWLp8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oQyfccUgOrCX3OSqXyjv+KsqKYyf/qitEcANCl0jvtLPMAPT6GN4lL+rdFQxXWKRA
	 gtDGBwL1fE5R6cQipbtgJnBoGoTiStzPWwJNeUswqYr7rymAbxXYw83fHTKaZNLs4H
	 JR8m+hIN/ZhPFBLGG5LaXG2Eb0DofHXLCHP2U+AA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 6.12 187/349] OPP: of: Fix potential memory leak in opp_parse_supplies()
Date: Thu, 16 Jul 2026 15:32:01 +0200
Message-ID: <20260716133037.565370594@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -737,7 +737,7 @@ static int opp_parse_supplies(struct dev
 	 */
 	if (unlikely(opp_table->regulator_count == -1)) {
 		opp_table->regulator_count = 0;
-		return 0;
+		goto free_microwatt;
 	}
 
 	for (i = 0, j = 0; i < opp_table->regulator_count; i++) {
@@ -760,6 +760,7 @@ static int opp_parse_supplies(struct dev
 			opp->supplies[i].u_watt = microwatt[i];
 	}
 
+free_microwatt:
 	kfree(microwatt);
 free_microamp:
 	kfree(microamp);


