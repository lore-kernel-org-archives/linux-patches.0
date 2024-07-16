Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C651DDCE;
	Tue, 16 Jul 2024 16:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145936; cv=none; b=DM6SmuJ7RKgjAHWxcoUgU2ggQsacTiBu8DrRdR8YyzeRG+cp2vyNg0kI/P0eqDH7EB096qHC96/ODAiSK3qDq1bymBXrZamjyzkwJPMJ+brlMNaUwCR3ZoFS5/U6a7+EzpXhewyMyk4X7rhJFE/5uWiCKYnGqhwXgJYBrBX02+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145936; c=relaxed/simple;
	bh=XKpcAHgdA3cXlJobNuLUxx0mYTWR8mhKRHrVi3jfLJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GY+/9igeKFdj4tFaGXvpMQN1IWthuYNH93vwrHlay4iHSWxjWXv5iwGV7ESM3rscG/YH7H2yb/4lB1VVxZZfLUldvfSe6WgH5bwuN1Q7UuipDOZZDp+nlvslfmhHvz3L90vSgLHM2+PQpaYIV+iZ+An10kiipjGAUITT4z0JnhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IC+Ehmff; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IC+Ehmff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60883C4AF0B;
	Tue, 16 Jul 2024 16:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145935;
	bh=XKpcAHgdA3cXlJobNuLUxx0mYTWR8mhKRHrVi3jfLJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IC+Ehmff5f/egyWI5X3H9RecT4oKCun0ajwDxZfkQ3d6KWYQSRpQ8Bm4iut6R7R6b
	 /p3UJE65FEH+9+vz1g+EOvYY6wYWch84JOeXsHOetXOierfiBTA4vKmSEkl+Y4D3Ep
	 /c+UGL7znt8KjSJXOEiALu+PnycXi2t9tWlDbIWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fangrui Song <maskray@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas@fjasle.eu>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 120/121] kbuild: Make ld-version.sh more robust against version string changes
Date: Tue, 16 Jul 2024 17:33:02 +0200
Message-ID: <20240716152755.944659300@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



