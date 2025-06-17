Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3222FA626;
	Tue, 17 Jun 2025 16:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179429; cv=none; b=iHgazVYymBytCmFv/7skqrKFuMN4Za4ifdkr+dRfGLH4D/lgj3HOLW8QtUOY/6fsFNN/1K1aCP8fk2DqZStSkOiGu0g2QeM5dcowD8943iMpip7WX+eGZhYuQEygLfdoQIXq4EL2I8+ZplEeDNYeeAw/jo648K7FXMRqw0QfRXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179429; c=relaxed/simple;
	bh=a93mryXsw2+NQBx3VQBsVXUHcovCqyeys4MQsL7XgpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HpsnnFVFnnwam2MJTfUlOPeKlhhNlfAvLxNIHxSDCoH9p85iHQePXXnSEHHKeeZ+NjWXP/vlrIerk4tE76pFBprOzy55rsvwEGMUTMwGzg61i2SAj/IkfnrCtyKqN3ZsbZan2VpVxOjOO++avROA1246J+99yqoe0vEyUtZAOeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sJ5+745w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sJ5+745w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42061C4CEE7;
	Tue, 17 Jun 2025 16:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179429;
	bh=a93mryXsw2+NQBx3VQBsVXUHcovCqyeys4MQsL7XgpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sJ5+745wpeagg1Fp1SFh1+BT8mJ/S6nQujaxxN5alU7G4K/cCliaYIAvewl3cFReJ
	 WNjya0icI8Ctd+eUkQZpB7e2uhf8GWCkh2nEszYxRYTHxxSFklL+cHUIAvHmi0rNNv
	 XJVAyM1eiFAUfB1OatnPyEQRubmGQDVV2OEtz8ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suleiman Souhlal <suleiman@google.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 6.15 744/780] tools/resolve_btfids: Fix build when cross compiling kernel with clang.
Date: Tue, 17 Jun 2025 17:27:32 +0200
Message-ID: <20250617152521.799113513@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suleiman Souhlal <suleiman@google.com>

commit a298bbab903e3fb4cbe16d36d6195e68fad1b776 upstream.

When cross compiling the kernel with clang, we need to override
CLANG_CROSS_FLAGS when preparing the step libraries.

Prior to commit d1d096312176 ("tools: fix annoying "mkdir -p ..." logs
when building tools in parallel"), MAKEFLAGS would have been set to a
value that wouldn't set a value for CLANG_CROSS_FLAGS, hiding the
fact that we weren't properly overriding it.

Fixes: 56a2df7615fa ("tools/resolve_btfids: Compile resolve_btfids as host program")
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/bpf/20250606074538.1608546-1-suleiman@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/bpf/resolve_btfids/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/bpf/resolve_btfids/Makefile
+++ b/tools/bpf/resolve_btfids/Makefile
@@ -17,7 +17,7 @@ endif
 
 # Overrides for the prepare step libraries.
 HOST_OVERRIDES := AR="$(HOSTAR)" CC="$(HOSTCC)" LD="$(HOSTLD)" ARCH="$(HOSTARCH)" \
-		  CROSS_COMPILE="" EXTRA_CFLAGS="$(HOSTCFLAGS)"
+		  CROSS_COMPILE="" CLANG_CROSS_FLAGS="" EXTRA_CFLAGS="$(HOSTCFLAGS)"
 
 RM      ?= rm
 HOSTCC  ?= gcc


