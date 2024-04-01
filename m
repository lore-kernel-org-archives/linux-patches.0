Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47241DFF4;
	Mon,  1 Apr 2024 17:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991145; cv=none; b=AggdKhf5aiSBa3YZRPnuXqWB1PAujFD4cL/CshyxSmh0pKksmRIPnhrPC0x7wWVduCZe/qvKcxQkCOTWapqiA/5r43LIkO1A5A1OBnGQjtu8vc7VkgmJirw6PIYwu2vI6HQvFMcucuXASn2WyASxnhjL3HtFnUpExsq/z9I1K50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991145; c=relaxed/simple;
	bh=2PMGuIQP9jlPCKZ/UrCaDF4o8pIJ+A9FDuSS1P14DFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SMu0HBLcNp8Su7NPj5A/cABEcz6YP22alrRrbxHGHz3u9p4n7TYib8Jcp1OAbwbf2HHfudoJKVzDz5EBwAgo8YEFr5WKOM8Ey+cHIRo9osjaMusm7SE1ca54yx5U3F8Cf33ZAmjCLZdSujOpIMFOo1m6JHZkMBFT2HHWjGykqto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M3t5pgOp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M3t5pgOp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B320C433F1;
	Mon,  1 Apr 2024 17:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991145;
	bh=2PMGuIQP9jlPCKZ/UrCaDF4o8pIJ+A9FDuSS1P14DFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M3t5pgOpRHttMPOIGyekggvOmrF1/w/v2kirM/f/2SWxg7JSFoaSzUmFJb1cL9s+W
	 uRD9hv++VEs5VYyUFXeC+6fkv74v3hAfeq17q3mpKM/euYrZEh/NFYn4MkSwAVW4O1
	 O3v0N/W0HYK1/6xPrHMwAKp0h30rYtzl4uzl3dK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 6.1 149/272] xfrm: Avoid clang fortify warning in copy_to_user_tmpl()
Date: Mon,  1 Apr 2024 17:45:39 +0200
Message-ID: <20240401152535.357438895@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1979,6 +1979,9 @@ static int copy_to_user_tmpl(struct xfrm
 	if (xp->xfrm_nr == 0)
 		return 0;
 
+	if (xp->xfrm_nr > XFRM_MAX_DEPTH)
+		return -ENOBUFS;
+
 	for (i = 0; i < xp->xfrm_nr; i++) {
 		struct xfrm_user_tmpl *up = &vec[i];
 		struct xfrm_tmpl *kp = &xp->xfrm_vec[i];


