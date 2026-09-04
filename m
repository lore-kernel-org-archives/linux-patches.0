Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DF73EC6AE;
	Fri,  4 Sep 2026 05:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500536; cv=none; b=nqZ/4r2SFnAojOHx82UYiThNip9mED/fSywAkx3fXxTVZlDXvqCtyUL1DM4Lt6oyIKALgC5Yierff5LXJIW9OODtMNfWEs8bDBLzFypEQNDmOzA7k7Y96vP9oKyFCjaSt9xvQuXWgYMD4U98uzGak0gYQ43tHOsJdaT9RiYidZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500536; c=relaxed/simple;
	bh=RA3ZnCQex2R2I/b8XrHKnbYRKa3dYngkE7v7ceJFAhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WiUJi5yz87p34CE/OZH3/7hxSSBsie2lzaKlg4F1mWd71lcz1unGCHacws3H3yYPiMqakGwr0MRyLdI88aFar6kTCguPPsimfJInKssfYWAM0kxdSPYNmVY/1cRcNtJL9gbeyrASV2i0iYBagMgjA0TRf1MGfCr3i+irvf9Y1Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fr7nabJR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fr7nabJR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D45771F00A3D;
	Fri,  4 Sep 2026 05:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500535;
	bh=iplLPNBEy6ptXDpvWuUGvLgYy4ZQCW1dLMGn5Z1ZWfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fr7nabJRi245iiJN9bR0LMYHzzWQPmd4OaV43ek0V1FaXfQ1QGnGN097aKrQ20WJF
	 cFkWQ9qPOORgEIBpIb9XTA3VP7ZQplOBs6mO8kaqdFYOT4d7/UZqeQ3zn4F+fOqey8
	 WILbpCWwQlA8lWx3rX2hvfev0N1Q64NkTaB95Xs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.18 091/552] of: fix out-of-bounds read in of_alias_scan() stem parser
Date: Fri,  4 Sep 2026 06:54:08 +0200
Message-ID: <20260904045749.943361013@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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
@@ -1891,7 +1891,7 @@ void of_alias_scan(void * (*dt_alloc)(u6
 
 		/* walk the alias backwards to extract the id and work out
 		 * the 'stem' string */
-		while (isdigit(*(end-1)) && end > start)
+		while (end > start && isdigit(*(end - 1)))
 			end--;
 		len = end - start;
 


