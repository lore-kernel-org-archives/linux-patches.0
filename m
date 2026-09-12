Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A118033A9E2;
	Sat, 12 Sep 2026 15:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226731; cv=none; b=d8qhLoZms98ytOoP2n6TYDZiaHlUNC3F/VbLsndXp4WggaOUWwWKNSUDDf898TeOBIqPBBjEVmC6x+SUskrmFXSYVafFHFTxtCz+8JJEOFy0Z9QMT6DtAAuEcDI8tPF5ef4UoQ5H6YT/vk9DoQAdAQ3jvNGv9cjUVEsOesx+81k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226731; c=relaxed/simple;
	bh=uM9Ka9tV1Y7y9g3gV+fLqM+Z3x1/J8euNyf3cvSlsdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nEaNlkWaLZQ51rCu8vilf8bchtvMJElLgzcBuMsvpxeMLrQ2OYNzK3NTWo0TdLFPkwe9qgK8tyFBe1WwkPWFExP9waVWF0q7VFg169fBMF29huWts+c2PxlFolNwYJ2bRoRWmEf8EPSjip8WeQRfzFw+FY8kgtLeaVkC++ATKvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gsf/FnXt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gsf/FnXt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C8911F000FF;
	Sat, 12 Sep 2026 15:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226727;
	bh=loKZCobvmbS5ggFzpDfZcFieHAbIJ4Jyyv4d77H8/tA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gsf/FnXtM1dLR2qdxYjerhXdFFr2wNpaSpHKoNs5qS2lgtcb1o3tO8CUnGO/Islz9
	 aqgCbE5uXLY0+Ff+hk0wsa4oinHl3NzZ5ERlLyNG/V3/rE2Dmh4YsIdkNmaVIKoS1l
	 97ucVZ40MXHBWsHrNWDzLxFyXgJqvT2JNF27fYkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.1 0036/1191] of: fix out-of-bounds read in of_alias_scan() stem parser
Date: Sat, 12 Sep 2026 08:46:04 +0200
Message-ID: <20260912065548.940786941@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdurrahman Hussain <abdurrahman@nexthop.ai>

commit 5bb01c657ff9fc807c2c592ca18af34c4fc3bc6f upstream.

The stem parser tests isdigit(*(end - 1)) before checking end > start
and so reads one byte before the property name when the name is empty
or all digits. Check the bound first.

Fixes: 611cad720148 ("dt: add of_alias_scan and of_alias_get_id")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-fable-5 [Claude Code]
Signed-off-by: Abdurrahman Hussain <abdurrahman@nexthop.ai>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260805-nh-of-alias-overlay-v6-1-74f21d440819@nexthop.ai
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1952,7 +1952,7 @@ void of_alias_scan(void * (*dt_alloc)(u6
 
 		/* walk the alias backwards to extract the id and work out
 		 * the 'stem' string */
-		while (isdigit(*(end-1)) && end > start)
+		while (end > start && isdigit(*(end - 1)))
 			end--;
 		len = end - start;
 


