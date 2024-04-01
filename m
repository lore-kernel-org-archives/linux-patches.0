Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66990C129;
	Mon,  1 Apr 2024 16:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988631; cv=none; b=JvyHG1gCWwXIk1yN2ulbgs4kFSvYg2YU9xc0XLWpQrDMT0l0apxVS2DLv2bK/eT46x2tRJyWqCOjHu3vW/n1GfHWm9n6rqZZV1SWYYIJnpEtTSc4e5LvcmhdK3nfKo7a3jwafNt4MGkejYcublVcjk3kz/490VPpKqvkVEo1s/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988631; c=relaxed/simple;
	bh=xhgo8PQnkMkQc7FnSLsmwRiNF5zs8tC7tGk6OvIYdP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RqDfYsQUttW924hxu7AsLfnTFIu4V4ah4R53T5K+f25hEoTCMx7Jv081vfh7WdiYk7MCGCOtslt9RDfDc9F9pgmm6g88Nwn36HvgxJ3SbSniP7i7GjxVkyiK3pJ5EEprhJJ8XUGyXkwzOMZIYHkvTLJw1UkFwWXjv21cTTViSuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CFd0BP0d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CFd0BP0d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C83A3C433F1;
	Mon,  1 Apr 2024 16:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988631;
	bh=xhgo8PQnkMkQc7FnSLsmwRiNF5zs8tC7tGk6OvIYdP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CFd0BP0diTTDFG5yL6TW6YgeQoZR4MMqR++a9P/zOIZjMsskzdttCts0fLlpTf24z
	 g5tBNbhMmgn00ryxLven1pjh3xH8BuAJZU0uynA+6qLBz91v+nIFhqSGM5Z9+46aQJ
	 06cF6XPq28NGdAw67hDB1WTxtXhqA61ZiPi2Y5O4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 6.7 243/432] xfrm: Avoid clang fortify warning in copy_to_user_tmpl()
Date: Mon,  1 Apr 2024 17:43:50 +0200
Message-ID: <20240401152600.383950345@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 1a807e46aa93ebad1dfbed4f82dc3bf779423a6e upstream.

After a couple recent changes in LLVM, there is a warning (or error with
CONFIG_WERROR=y or W=e) from the compile time fortify source routines,
specifically the memset() in copy_to_user_tmpl().

  In file included from net/xfrm/xfrm_user.c:14:
  ...
  include/linux/fortify-string.h:438:4: error: call to '__write_overflow_field' declared with 'warning' attribute: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror,-Wattribute-warning]
    438 |                         __write_overflow_field(p_size_field, size);
        |                         ^
  1 error generated.

While ->xfrm_nr has been validated against XFRM_MAX_DEPTH when its value
is first assigned in copy_templates() by calling validate_tmpl() first
(so there should not be any issue in practice), LLVM/clang cannot really
deduce that across the boundaries of these functions. Without that
knowledge, it cannot assume that the loop stops before i is greater than
XFRM_MAX_DEPTH, which would indeed result a stack buffer overflow in the
memset().

To make the bounds of ->xfrm_nr clear to the compiler and add additional
defense in case copy_to_user_tmpl() is ever used in a path where
->xfrm_nr has not been properly validated against XFRM_MAX_DEPTH first,
add an explicit bound check and early return, which clears up the
warning.

Cc: stable@vger.kernel.org
Link: https://github.com/ClangBuiltLinux/linux/issues/1985
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_user.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -2017,6 +2017,9 @@ static int copy_to_user_tmpl(struct xfrm
 	if (xp->xfrm_nr == 0)
 		return 0;
 
+	if (xp->xfrm_nr > XFRM_MAX_DEPTH)
+		return -ENOBUFS;
+
 	for (i = 0; i < xp->xfrm_nr; i++) {
 		struct xfrm_user_tmpl *up = &vec[i];
 		struct xfrm_tmpl *kp = &xp->xfrm_vec[i];


