Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321A7146A64;
	Thu, 11 Apr 2024 10:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830689; cv=none; b=CxRU2v3W3Y5zaybASfU448yTwWhikzHQ7IoEP5jWENzw1FZvp02MaZxZT2QxCqlOmHTgZF0B88CMeYQ66St4I3apEs+SgtISCHON1p6pHU95rtBpiTkX5qJE2QaSVVf66Q/iNS/SM2PChvA9GoioQAFLtJXRJyeIytlIKFD/oRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830689; c=relaxed/simple;
	bh=6eY/sj7M+AUAx8I9ZsdU3Uk+pYZqWilBfbmAxsS/TZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=szZZRY7JqqPWTI8xfEsPnvpqT8g/h+OnJyuqQ3WJpd7G2Miq2Jq9KKRMYE6uOsxcq46yBGlU29kj1s5GKFdcJ4XE1wlpbIdMCo7K4AxHDemzD1JSiYfS6TM3lFNOLkBtuSbNZAGM75/DJCysBwruzSRa8Vip5OFfu80Mg4e2yBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YwpRX1sI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YwpRX1sI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6164DC433C7;
	Thu, 11 Apr 2024 10:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830688;
	bh=6eY/sj7M+AUAx8I9ZsdU3Uk+pYZqWilBfbmAxsS/TZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YwpRX1sIB9/doVmFL8jjU+9pcojtCZVBNqKrQIiLLXI63S12yo7tsVw+KrbsOWjps
	 uDhN47WoyLjpBLO43TpSGxbegoEfGX/tevyDCkXprYXU/h+bt2GRjYSDC23Mgr06Er
	 7Z9tKWytYnJqg0tAMSuJs8fDOMI7ZEBeq2NGBhwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 5.4 084/215] xfrm: Avoid clang fortify warning in copy_to_user_tmpl()
Date: Thu, 11 Apr 2024 11:54:53 +0200
Message-ID: <20240411095427.432219749@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1704,6 +1704,9 @@ static int copy_to_user_tmpl(struct xfrm
 	if (xp->xfrm_nr == 0)
 		return 0;
 
+	if (xp->xfrm_nr > XFRM_MAX_DEPTH)
+		return -ENOBUFS;
+
 	for (i = 0; i < xp->xfrm_nr; i++) {
 		struct xfrm_user_tmpl *up = &vec[i];
 		struct xfrm_tmpl *kp = &xp->xfrm_vec[i];


