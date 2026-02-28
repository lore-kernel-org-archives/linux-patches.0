Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED10373BE1;
	Sat, 28 Feb 2026 17:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301534; cv=none; b=a6WllcUQCK1bNI30AEpwJFvMOrsGQhgLCFmRt+VfrESoolgzuyxIv4J63i8uDtOXo6LafcMltgZ0eg4lsju+ugLQZ01sOkdhmhvlsyHKD9Y2QB+I5Do7BO4tJaTwtdCUtvHoJyI+KGJr7VZMOOAkDXtZLZFtcG7LOuPiUjWy9ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301534; c=relaxed/simple;
	bh=jrIlJDL/pjOdfkX9pYY0T+697pkl1IIOum/4Eo93nzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FiTQCVFJxTYVfVSZva4kWoQLFxg+wUUdq5PG2pgn58k1/kAXUHcsCoOY1ialm0i3OZXIHda+RFtiAShC4bGaoubEIj3LwMHvyoPZfZKWWqjVjxx8bdcGArUaBoqR/hJL8BDN70ri2vE4CQbDaEu8qESVCcaOLENkRiTg3/f71QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bo6DQQRq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bo6DQQRq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8A60C2BC87;
	Sat, 28 Feb 2026 17:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301534;
	bh=jrIlJDL/pjOdfkX9pYY0T+697pkl1IIOum/4Eo93nzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bo6DQQRqT70H8iUrEqinHW0lMS/PM+7Gp+CrofuMxBYgV2WcZqyh+YNNMX+107AIl
	 Fy9Dctk2uxa/AxWEXAW5cNNG9n6g61+ALlF6wzmDljM5sDxkSAB+7iCZGD8SKgpxBU
	 koJwi62Mza3JwED4CfRE7dDX8E+oH3citWZZ+swrtHpiOyuIHSuUxbAxHoooA3T5QH
	 RN1wSQZi38o39lsxpJPOGGlYNv6cuzno+DOkGGjBAupgZiRE2I8gqTyCuRdRZBd60D
	 lKE7UrM1m9JLgM7qP//5uu88Ai4pG8YH29WXBo8fvvRz7VzkME2KkdaPYu3vbdBwbF
	 rQXQjyiP/aLTQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Nathan Chancellor <nathan@kernel.org>,
	stable@vger.kernel.org,
	Lukas Herbolt <lukas@herbolt.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 716/752] kbuild: rpm-pkg: Fix manual debuginfo generation when using .src.rpm
Date: Sat, 28 Feb 2026 12:47:07 -0500
Message-ID: <20260228174750.1542406-716-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit afdfb71c018e9a0aa2e51fb8186d3fb1acdd3f0e ]

Commit 62089b804895 ("kbuild: rpm-pkg: Generate debuginfo package
manually") added uses of OBJCOPY and READELF, variables from Kbuild.
These variables are defined and work properly when using the binrpm-pkg
target because rpmbuild is run within Kbuild. However, these variables
are not defined when building from a source RPM package generated with
the srcrpm-pkg target, breaking the build when generating the debug info
subpackage.

Define a default value for these variables so that these commands
respect the value from Kbuild but continue to work when built from a
source RPM package.

Cc: stable@vger.kernel.org
Fixes: 62089b804895 ("kbuild: rpm-pkg: Generate debuginfo package manually")
Reported-by: Lukas Herbolt <lukas@herbolt.com>
Closes: https://lore.kernel.org/20260212135855.147906-2-lukas@herbolt.com/
Tested-by: Lukas Herbolt <lukas@herbolt.com>
Link: https://patch.msgid.link/20260213-fix-debuginfo-srcrpm-pkg-v1-1-45cd0c0501b9@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/package/kernel.spec | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/package/kernel.spec b/scripts/package/kernel.spec
index af682a7054779..bccf58bdd45fd 100644
--- a/scripts/package/kernel.spec
+++ b/scripts/package/kernel.spec
@@ -148,11 +148,11 @@ echo /usr/lib/debug/lib/modules/%{KERNELRELEASE}/vmlinux > %{buildroot}/debuginf
 while read -r mod; do
 	mod="${mod%.o}.ko"
 	dbg="%{buildroot}/usr/lib/debug/lib/modules/%{KERNELRELEASE}/kernel/${mod}"
-	buildid=$("${READELF}" -n "${mod}" | sed -n 's@^.*Build ID: \(..\)\(.*\)@\1/\2@p')
+	buildid=$("${READELF:-readelf}" -n "${mod}" | sed -n 's@^.*Build ID: \(..\)\(.*\)@\1/\2@p')
 	link="%{buildroot}/usr/lib/debug/.build-id/${buildid}.debug"
 
 	mkdir -p "${dbg%/*}" "${link%/*}"
-	"${OBJCOPY}" --only-keep-debug "${mod}" "${dbg}"
+	"${OBJCOPY:-objcopy}" --only-keep-debug "${mod}" "${dbg}"
 	ln -sf --relative "${dbg}" "${link}"
 
 	echo "${dbg#%{buildroot}}" >> %{buildroot}/debuginfo.list
-- 
2.51.0

