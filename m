Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6C91EE00B;
	Tue,  3 Dec 2024 16:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242782; cv=none; b=OfqJ/HpYJFSRWOTbXh2KGaftWhtg53MDAvQCt19eY7GZkjpIBu708y9/Wjec2LEQ/p2AArSq57ZRBJ5nEzERiPFMeW6KRT4xEOu0DbtlzJ/n150A0cpuLMGvZVbcqrPfDPxQuSVAGKpiMuinkK5p6IautSGC1tu3DG5SGTvV9oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242782; c=relaxed/simple;
	bh=chmiZrJBrLqynvQFzzyivrHdCQ5uuI+xUpEwA4o0Fnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RrZ1O0SsQquLn19dJ0OM+12pqEMgJETtv4NuEHGrnRhEstnFXoOTg/cecPLF6V9pgjcknYJmQVrVT1WhhG+Fcab00NbYZfOG/zO83ApUcZmodRIugNURZ7kb+/pd4xVCvfVlniPSM849GdsdgpPHCSE5whO85OwJNo0r7yMUyWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HUuRKbn5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HUuRKbn5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42959C4CECF;
	Tue,  3 Dec 2024 16:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242782;
	bh=chmiZrJBrLqynvQFzzyivrHdCQ5uuI+xUpEwA4o0Fnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HUuRKbn55WMEFxVfFj9qtFNKRSeMdXxH2RYUzP/oMghDmuqlbzmphww7hiFnCZ6B0
	 eRsSF9txWrUgQqARRkNaNk/SfUkBxm4KT82+c1zTHcHMSPZ5If4F0E9fibJRtGq1nA
	 aG5Hygsj9NSmpLEnjcD74Abd+3ivnWXiYRHf+FpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Fleming <mfleming@cloudflare.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 808/826] kbuild: deb-pkg: Dont fail if modules.order is missing
Date: Tue,  3 Dec 2024 15:48:55 +0100
Message-ID: <20241203144815.274778805@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Fleming <mfleming@cloudflare.com>

[ Upstream commit bcbbf493f2fa6fa1f0832f6b5b4c80a65de242d6 ]

Kernels built without CONFIG_MODULES might still want to create -dbg deb
packages but install_linux_image_dbg() assumes modules.order always
exists. This obviously isn't true if no modules were built, so we should
skip reading modules.order in that case.

Fixes: 16c36f8864e3 ("kbuild: deb-pkg: use build ID instead of debug link for dbg package")
Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/package/builddeb | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 441b0bb66e0d0..fb686fd3266f0 100755
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -96,16 +96,18 @@ install_linux_image_dbg () {
 
 	# Parse modules.order directly because 'make modules_install' may sign,
 	# compress modules, and then run unneeded depmod.
-	while read -r mod; do
-		mod="${mod%.o}.ko"
-		dbg="${pdir}/usr/lib/debug/lib/modules/${KERNELRELEASE}/kernel/${mod}"
-		buildid=$("${READELF}" -n "${mod}" | sed -n 's@^.*Build ID: \(..\)\(.*\)@\1/\2@p')
-		link="${pdir}/usr/lib/debug/.build-id/${buildid}.debug"
-
-		mkdir -p "${dbg%/*}" "${link%/*}"
-		"${OBJCOPY}" --only-keep-debug "${mod}" "${dbg}"
-		ln -sf --relative "${dbg}" "${link}"
-	done < modules.order
+	if is_enabled CONFIG_MODULES; then
+		while read -r mod; do
+			mod="${mod%.o}.ko"
+			dbg="${pdir}/usr/lib/debug/lib/modules/${KERNELRELEASE}/kernel/${mod}"
+			buildid=$("${READELF}" -n "${mod}" | sed -n 's@^.*Build ID: \(..\)\(.*\)@\1/\2@p')
+			link="${pdir}/usr/lib/debug/.build-id/${buildid}.debug"
+
+			mkdir -p "${dbg%/*}" "${link%/*}"
+			"${OBJCOPY}" --only-keep-debug "${mod}" "${dbg}"
+			ln -sf --relative "${dbg}" "${link}"
+		done < modules.order
+	fi
 
 	# Build debug package
 	# Different tools want the image in different locations
-- 
2.43.0



