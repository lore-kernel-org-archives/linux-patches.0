Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A777343C07E;
	Mon, 17 Aug 2026 14:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978149; cv=none; b=l2LYlzzAPgNBaHb409x3GVO7xSwZvutXPxlTmHGyyPBNrhlW6DHzGbLYKclI9OoPD5c838iZeYtk3+9CTZ2OekppoFg5I3uaLgAWXc/JPw4d2uGDeq8OOH9omQnPM/qa3vRerYGoQc2gGivodw/SlVZe8BNjk/GvozA6iAsWXxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978149; c=relaxed/simple;
	bh=JHRIA/+07Z76uj+JIN2ddwG6yz4wj2IVop3WD6edNc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aAe8ltvFYKHCGHHuHHbHOSg6/K+QUde04InusZU19UIAneGGRgLuxOWxiBf0o7BOqDDyCak1jQFpzCHrVVbjwEDFDeefHnkIBNNgt1DbNvCGqtr40ZAjxJM20XlDCHckPTZ8jgSpZ46RXWQUAreM3C+8mTg0Y+gUtI5oBzrI4h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JIbWWOnv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JIbWWOnv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 528CD1F00A3A;
	Mon, 17 Aug 2026 14:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978144;
	bh=JCDGkH8Lh9kRpLmEtDu/EbgdcSau5xVpnNA6vr/7nW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JIbWWOnvbGMEmGH6ZB2c6PYqgI+XRCc3wTPuqn3Mpx38i+zYLSE4C+70Xvlue7B93
	 aKHoTs+cA2pwMwhaZJ6OrOo6ASx9lOgVHjw1JU5e8W+0YMP6X5Fe8VdqxxDeiajnXC
	 DMywQf0grD+/A0Qa8hWl6/tUQK+MoXtz1FsO0iuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	=?UTF-8?q?Jannik=20Gl=C3=BCckert?= <jannik.glueckert@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 116/181] kunit/fortify: Add back "volatile" for sizeof() constants
Date: Mon, 17 Aug 2026 15:33:30 +0200
Message-ID: <20260817132540.099821342@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

commit 10299c07c94aa0997fa43523b53301e713a6415d upstream.

It seems the Clang can see through OPTIMIZER_HIDE_VAR when the constant
is coming from sizeof. Adding "volatile" back to these variables solves
this false positive without reintroducing the issues that originally led
to switching to OPTIMIZER_HIDE_VAR in the first place[1].

Reported-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://github.com/ClangBuiltLinux/linux/issues/2075 [1]
Cc: Jannik Glückert <jannik.glueckert@gmail.com>
Suggested-by: Nathan Chancellor <nathan@kernel.org>
Fixes: 6ee149f61bcc ("kunit/fortify: Replace "volatile" with OPTIMIZER_HIDE_VAR()")
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20250628234034.work.800-kees@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/fortify_kunit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/fortify_kunit.c b/lib/fortify_kunit.c
index 1541b2a1694e4..d0810e4e65e5b 100644
--- a/lib/fortify_kunit.c
+++ b/lib/fortify_kunit.c
@@ -986,8 +986,8 @@ static void fortify_test_memcmp(struct kunit *test)
 {
 	char one[] = "My mind is going ...";
 	char two[] = "My mind is going ... I can feel it.";
-	size_t one_len = sizeof(one) - 1;
-	size_t two_len = sizeof(two) - 1;
+	volatile size_t one_len = sizeof(one) - 1;
+	volatile size_t two_len = sizeof(two) - 1;
 
 	OPTIMIZER_HIDE_VAR(one_len);
 	OPTIMIZER_HIDE_VAR(two_len);
-- 
2.53.0



