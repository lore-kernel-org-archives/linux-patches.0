Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43FD71509BC;
	Tue, 20 Feb 2024 21:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462946; cv=none; b=Y3q5DPZMae3nlmCh3iNXilXnzZdfWJmV1eGvM+aGIFU/gVO/EJ3L7elwIkm0oF529Xhml5b0sHsPcE3ADpT/I7aDIKE87C6hbSzt4scnLm1L9jVFikCvv37s85bYFFXG3+XsW9SZSvJnahGJFhEYUEjT3zBWgaShzUZ6PXkIbFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462946; c=relaxed/simple;
	bh=rVh3TNGSlpHw1jTGuHp+39hKqMdO3JUhNdN2I6Rvx9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nFJcEURssuTF9gesPgdJ+402e+4qDfggHBuhfqNOYE3ZIJZWLJ+LTdRC7Sth0P1aB3ECvRtuXDtvz2V2sd1jTOluB/G/t9lEn3LXiz7A5bukbI2lKkXSdqnPxL6WXAsmjL4brq2/cRLUzpALQnKae5YpiKXWC+v2dzh9D27E2AE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W9AzFs7q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W9AzFs7q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB5B9C433C7;
	Tue, 20 Feb 2024 21:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462946;
	bh=rVh3TNGSlpHw1jTGuHp+39hKqMdO3JUhNdN2I6Rvx9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W9AzFs7q/Gobzk/uOlW5fp/Qwq1k+i/zKSCES6eZ8wQiLsAVdajS6ttpWmGESAiq1
	 5RkpYMpC3zUNY1QAM51bh5rUExNsyoUcSNUWr9fExb7Vhl9mWofyR04zDAqtrAfZGP
	 VEKISjkqhPP/ki4gGc34A9qlXRfiWqr9e437c030=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 6.1 087/197] modpost: Dont let "driver"s reference .exit.*
Date: Tue, 20 Feb 2024 21:50:46 +0100
Message-ID: <20240220204843.691168735@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Uwe Kleine-König" <u.kleine-koenig@pengutronix.de>

commit f177cd0c15fcc7bdbb68d8d1a3166dead95314c8 upstream.

Drivers must not reference functions marked with __exit as these likely
are not available when the code is built-in.

There are few creative offenders uncovered for example in ARCH=amd64
allmodconfig builds. So only trigger the section mismatch warning for
W=1 builds.

The dual rule that drivers must not reference .init.* is implemented
since commit 0db252452378 ("modpost: don't allow *driver to reference
.init.*") which however missed that .exit.* should be handled in the
same way.

Thanks to Masahiro Yamada and Arnd Bergmann who gave valuable hints to
find this improvement.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Stable-dep-of: 846cfbeed09b ("um: Fix adding '-no-pie' for clang")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/mod/modpost.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1087,9 +1087,20 @@ static int secref_whitelist(const struct
 				    "*_console")))
 		return 0;
 
-	/* symbols in data sections that may refer to meminit/exit sections */
+	/* symbols in data sections that may refer to meminit sections */
 	if (match(fromsec, PATTERNS(DATA_SECTIONS)) &&
-	    match(tosec, PATTERNS(ALL_XXXINIT_SECTIONS, ALL_EXIT_SECTIONS)) &&
+	    match(tosec, PATTERNS(ALL_XXXINIT_SECTIONS, ALL_XXXEXIT_SECTIONS)) &&
+	    match(fromsym, PATTERNS("*driver")))
+		return 0;
+
+	/*
+	 * symbols in data sections must not refer to .exit.*, but there are
+	 * quite a few offenders, so hide these unless for W=1 builds until
+	 * these are fixed.
+	 */
+	if (!extra_warn &&
+	    match(fromsec, PATTERNS(DATA_SECTIONS)) &&
+	    match(tosec, PATTERNS(EXIT_SECTIONS)) &&
 	    match(fromsym, PATTERNS("*driver")))
 		return 0;
 


