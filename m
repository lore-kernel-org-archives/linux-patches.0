Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3268172A;
	Mon,  8 Apr 2024 13:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582422; cv=none; b=LFwY2ZWlRvHzFuDamkWMLOUlOkbVIcGtOGkGC1BzyzWcwUz0KXCyCgNskwOOtrz/2RlkGAVQGWJCMuNk6oKZ7CfoQPIH5k4WH2RZEh5FEBk8hUwHjB8IDhMEX3iMU9bjTPFF1arC6p0csGs/W5USy1tR4xJHBxRM8q/m1IuAOfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582422; c=relaxed/simple;
	bh=xFPVqMzb5M/eqZrzW7wA+ZzVgXHJ1RfDkyfO8bLS9UA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eaxZ3uc3ITCM9+kRdlABzvBBUP4s8+TjoGHqFweWG/U9uqp0cKXBE2M2UNlSVaUgkWsM53v+AJt2ErLeBEbGsRBeBeZykTqnHJGlo2ndkqsRMp6mWuzKJ2iJK6TN6pjTz1YB5fcb2Kun1yzVZf2LARE+XfR6tMVAPmjHXo6t0Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KQigXOD3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KQigXOD3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72F45C43394;
	Mon,  8 Apr 2024 13:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582421;
	bh=xFPVqMzb5M/eqZrzW7wA+ZzVgXHJ1RfDkyfO8bLS9UA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KQigXOD3T21+bqLu0pOz21suTt5JdfyohgAgPq/1EMnRFN546y9qNc1AWJQDVEDrB
	 ljOGFcsi7qIF2UmU/KG6+F2uVkuNWuq1ylt3qi7KQffE//M8mK4TC2Mxs4Kx2H61ui
	 q6PIOUp7D0VhvbzGYPBeC+3xJZ+GK+zLFNOxaC4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 5.15 122/690] xfrm: Avoid clang fortify warning in copy_to_user_tmpl()
Date: Mon,  8 Apr 2024 14:49:48 +0200
Message-ID: <20240408125403.985300157@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1850,6 +1850,9 @@ static int copy_to_user_tmpl(struct xfrm
 	if (xp->xfrm_nr == 0)
 		return 0;
 
+	if (xp->xfrm_nr > XFRM_MAX_DEPTH)
+		return -ENOBUFS;
+
 	for (i = 0; i < xp->xfrm_nr; i++) {
 		struct xfrm_user_tmpl *up = &vec[i];
 		struct xfrm_tmpl *kp = &xp->xfrm_vec[i];


