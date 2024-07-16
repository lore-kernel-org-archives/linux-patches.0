Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D75219AD72;
	Tue, 16 Jul 2024 15:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145233; cv=none; b=GCQlzqrNooJxbSYXlM42zeHwXPspPO259P6tNFmscRSO3+KnqIhM2oeuIrSu/xu2fOSMK6Q+4refZZsrjfDLwtTW5+FK3g48W+w94UbAvXAFUS4KaGBMpl3iGXNU2GPZGPD5pubzeSqEQVJ7uYkWfEH/iEuI+m6yEYNNZYfzzsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145233; c=relaxed/simple;
	bh=yCeQzn7QmSdyRagB25E/BN7snfPYAtWPj/t/Vl43pDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BAD4WrKsbLjEd3Yi6KcVrP0YEso6hbky3fnZwEpVQ3NmtVjnCRy0XR7Wcn5B/zZgLxQqnuzNUeyhiOpvm6KBuOlws+qaY0bHGiMjVuhYrLmn36vrScSOOkRXq1PGkdPgdzo7aCR7e9ZXcbMce/ao5VPY4YN6E2znwIp890IubWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d9tyMYMt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d9tyMYMt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A270C116B1;
	Tue, 16 Jul 2024 15:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145233;
	bh=yCeQzn7QmSdyRagB25E/BN7snfPYAtWPj/t/Vl43pDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d9tyMYMtiAr4Tz1AixBRBOWioI8D7S1K1Hs+ZPWTwdXDFVSVylxSL6lx+4m6s2uxn
	 rZQng/WQV1HX6wXJzt3bm/JPkf1wMJHskXF4XtngP2PlVQ7DUh94Z1bxoFoBn7QmKb
	 Ald5P34cxWZoKTQVvB2zoruIrZYhKdg9Db/YPoNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fangrui Song <maskray@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas@fjasle.eu>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 142/143] kbuild: Make ld-version.sh more robust against version string changes
Date: Tue, 16 Jul 2024 17:32:18 +0200
Message-ID: <20240716152801.457847776@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 9852f47ac7c993990317570ff125e30ad901e213 ]

After [1] in upstream LLVM, ld.lld's version output became slightly
different when the cmake configuration option LLVM_APPEND_VC_REV is
disabled.

Before:

  Debian LLD 19.0.0 (compatible with GNU linkers)

After:

  Debian LLD 19.0.0, compatible with GNU linkers

This results in ld-version.sh failing with

  scripts/ld-version.sh: 18: arithmetic expression: expecting EOF: "10000 * 19 + 100 * 0 + 0,"

because the trailing comma is included in the patch level part of the
expression. While [1] has been partially reverted in [2] to avoid this
breakage (as it impacts the configuration stage and it is present in all
LTS branches), it would be good to make ld-version.sh more robust
against such miniscule changes like this one.

Use POSIX shell parameter expansion [3] to remove the largest suffix
after just numbers and periods, replacing of the current removal of
everything after a hyphen. ld-version.sh continues to work for a number
of distributions (Arch Linux, Debian, and Fedora) and the kernel.org
toolchains and no longer errors on a version of ld.lld with [1].

Fixes: 02aff8592204 ("kbuild: check the minimum linker version in Kconfig")
Link: https://github.com/llvm/llvm-project/commit/0f9fbbb63cfcd2069441aa2ebef622c9716f8dbb [1]
Link: https://github.com/llvm/llvm-project/commit/649cdfc4b6781a350dfc87d9b2a4b5a4c3395909 [2]
Link: https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html [3]
Suggested-by: Fangrui Song <maskray@google.com>
Reviewed-by: Fangrui Song <maskray@google.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nicolas Schier <nicolas@fjasle.eu>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/ld-version.sh | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/scripts/ld-version.sh b/scripts/ld-version.sh
index a78b804b680cf..b9513d224476f 100755
--- a/scripts/ld-version.sh
+++ b/scripts/ld-version.sh
@@ -57,9 +57,11 @@ else
 	fi
 fi
 
-# Some distributions append a package release number, as in 2.34-4.fc32
-# Trim the hyphen and any characters that follow.
-version=${version%-*}
+# There may be something after the version, such as a distribution's package
+# release number (like Fedora's "2.34-4.fc32") or punctuation (like LLD briefly
+# added before the "compatible with GNU linkers" string), so remove everything
+# after just numbers and periods.
+version=${version%%[!0-9.]*}
 
 cversion=$(get_canonical_version $version)
 min_cversion=$(get_canonical_version $min_version)
-- 
2.43.0



