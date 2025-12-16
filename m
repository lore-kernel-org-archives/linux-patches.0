Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F9133EAE4;
	Tue, 16 Dec 2025 12:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886441; cv=none; b=CSrrFOdIP29HV1lg7G3YYPEGa4+Z3OLTsPeB2/Lgg+lkA/1OuhVmaq+dVz1caODJE/H4jbiwupBpODgPBGrNJKMXtZxiOkFW2Yh9N7XgA91solDIy/nPyL3cXwRS7GRn4WPNVz0ui483bdQpWb420w+K1fnnrR/seaZKVFGmonY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886441; c=relaxed/simple;
	bh=zcwXyp1bU7e64VqmZOJvaHz3ZY7hqlaMu5p3dDS4ouk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qiASuc0kEb2J+MkuhudpxCwdmp6f0OLkO+PYUSDov6Ozh36V5GtyHJj4Iio7PYEkVI0FHFHNi9NHs954Pd2k1VwrLRZgSTpcRf5Q6Quyky9pMUD1PZuNSiGnXGAqNfhg+cJG+qynChbHksAWoRQL4sL86xQn58SahXOgmiqU2B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1RkfYAkl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1RkfYAkl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E3AC4CEF1;
	Tue, 16 Dec 2025 12:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886441;
	bh=zcwXyp1bU7e64VqmZOJvaHz3ZY7hqlaMu5p3dDS4ouk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1RkfYAklirJzwUNIRkeiJlDz4z/ePoFQnbfRLvQRB1qG8u/XJrJxduydvXb2hdsq+
	 fP2w+RRmbjGPtkM9OdtPXvpUCbh1lO72Y3ypp4LwXF4QxwOmj4DUYQgcP62qbD5oaP
	 fVJG3HvOaXrUJA2UjScj/SJyocu+ZUHq32+pDrrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Le Cuirot <chewi@gentoo.org>,
	Nicolas Schier <nsc@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 438/507] kbuild: install-extmod-build: Fix when given dir outside the build dir
Date: Tue, 16 Dec 2025 12:14:39 +0100
Message-ID: <20251216111401.326093175@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Le Cuirot <chewi@gentoo.org>

[ Upstream commit 5ff90d427ef841fa48608d0c19a81c48d6126d46 ]

Commit b5e395653546 ("kbuild: install-extmod-build: Fix build when
specifying KBUILD_OUTPUT") tried to address the "build" variable
expecting a relative path by using `realpath --relative-base=.`, but
this only works when the given directory is below the current directory.
`realpath --relative-to=.` will return a relative path in all cases.

Fixes: b5e395653546 ("kbuild: install-extmod-build: Fix build when specifying KBUILD_OUTPUT")
Signed-off-by: James Le Cuirot <chewi@gentoo.org>
Reviewed-by: Nicolas Schier <nsc@kernel.org>
Link: https://patch.msgid.link/20251016091417.9985-1-chewi@gentoo.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Stable-dep-of: 4ab2ee307983 ("kbuild: install-extmod-build: Properly fix CC expansion when ccache is used")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/package/install-extmod-build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/package/install-extmod-build b/scripts/package/install-extmod-build
index b96538787f3d9..054fdf45cc37a 100755
--- a/scripts/package/install-extmod-build
+++ b/scripts/package/install-extmod-build
@@ -63,7 +63,7 @@ if [ "${CC}" != "${HOSTCC}" ]; then
 	# Clear VPATH and srcroot because the source files reside in the output
 	# directory.
 	# shellcheck disable=SC2016 # $(MAKE) and $(build) will be expanded by Make
-	"${MAKE}" run-command KBUILD_RUN_COMMAND='+$(MAKE) HOSTCC='"${CC}"' VPATH= srcroot=. $(build)='"$(realpath --relative-base=. "${destdir}")"/scripts
+	"${MAKE}" run-command KBUILD_RUN_COMMAND='+$(MAKE) HOSTCC='"${CC}"' VPATH= srcroot=. $(build)='"$(realpath --relative-to=. "${destdir}")"/scripts
 
 	rm -f "${destdir}/scripts/Kbuild"
 fi
-- 
2.51.0



