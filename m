Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D9D33FE09;
	Fri,  4 Sep 2026 05:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498723; cv=none; b=hNJ4RWa3oeYr7h/xfG9xGyIK43qPGzAX/ovFgUaTeEwJwc0yb7FrHPyoP/C47SWMrrGnYkUSAtKdjNaLvqrvwBkyx0HYzeIO/agakABexpalZs2LVmv9R+1xRRYm4SzE/zuyilA+CrGtg4RR8m0DABptnFX9Xl4UgBFPTiVbl1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498723; c=relaxed/simple;
	bh=m3mCmol/fzLFfn7UPhsam5dFSV0mkOIZxRWi114fZZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJ1mav+wufWARjZeaCn137jAEXtJvezk9oKqep9mQetnZk7V7FilKxOMd0QsP10RwzUM9lR0F15QMOrOzuHGhePxMzIK1VVZskwNxyoqG8/lFZV/SmeLCxQ2IwgmHQGIvKD1uHeidRifsOW1kKe8Gaa2+rAQO7zRM9wPBHedp3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BY8g0UJC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BY8g0UJC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236E31F00A3D;
	Fri,  4 Sep 2026 05:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498722;
	bh=zmwlJek/zyolcVqNqyPEVBmVBO3o2o+9qR48QuaqMjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BY8g0UJCWJqy4oQkJcFaGnwRfrrkK4tEnXti6/A/D+VmZxvbBGNqNsJtPPmNbELBt
	 QC2kFlRUZyHFJy3If3wgRCd8XSpXjur9APoCEVdfmsc4w9eHd/45V2xtzTCqW2tDPN
	 ru+u/rGFSRNe902JnYd0rdaO3vFHzkFpHHTmBz50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 7.2 127/713] of: fix out-of-bounds read in of_alias_scan() stem parser
Date: Fri,  4 Sep 2026 06:51:35 +0200
Message-ID: <20260904045806.681042767@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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
@@ -1967,7 +1967,7 @@ void of_alias_scan(void * (*dt_alloc)(u6
 
 		/* walk the alias backwards to extract the id and work out
 		 * the 'stem' string */
-		while (isdigit(*(end-1)) && end > start)
+		while (end > start && isdigit(*(end - 1)))
 			end--;
 		len = end - start;
 


