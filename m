Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707F346AA80;
	Tue, 21 Jul 2026 15:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648300; cv=none; b=X0B/08ze0PyVFlEaEHLVIWKCnqUlQUzQnM5m58gw6BGhmnAh+0Bscdw5f+mT64+xFN0nOOdr4Uy6Jun2X2aqcGy6EiCK6L0W2tFLY1WOW46cjTFgWVIRfMrdk4F1y1yD+55OMCDjO7LTO2qhec/gZBbRvk1a7XFjgvcbWPh0YNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648300; c=relaxed/simple;
	bh=5uOy+Nj3vrAlzxiQs23HEFLJlRV6hiFFM06KSjYVEmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KS8nxtkJIne71g/4O804YIaExA7cHCh8uJDwyiE5QwBEhkESNveU/xpx7ukrd7ndODHgxRkIU9tCQsf1edS+oAcoMVTMEULqn60S0XEf5nsmUiFz9cpvD46rFpD5upXbs8nOuuaIF1nzAoUfcHCzTKnJsujvZVoU4qOQI16P0rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0KTqSjHT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0KTqSjHT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D62811F00A3A;
	Tue, 21 Jul 2026 15:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648299;
	bh=K12LBXILhpFSDDB2jtNu90fgaTR5AnzBn5VJTZHL3Ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0KTqSjHTbGqkbGzvICSbOquRg6hbL395/1NieiU2SQov4ktIHhHll9GDu6jbiGGQr
	 bLGpzHbKA+iWhNc/439ZoVyOYgR6Mzwz7U1bgbXUD6vXO3JGM3DsH3ZGl7IUAfhKz0
	 5vMkdkJan7XMlU3FZ9JQ7gnQ0jkbedGO86B8q0PI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Liu <song@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0130/2077] klp-build: Fix hang on out-of-date .config
Date: Tue, 21 Jul 2026 16:56:43 +0200
Message-ID: <20260721152555.759901038@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit cc39ccce7d5bc623100f07dcda070cef1bf690f6 ]

If .config is out of date with the kernel source, 'make syncconfig'
hangs while waiting for user input on new config options.  Detect the
mismatch and return an error.

Fixes: 6f93f7b06810 ("livepatch/klp-build: Fix inconsistent kernel version")
Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/livepatch/klp-build | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index 0ad7e663131420..e19d93b78fcba0 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -306,7 +306,12 @@ set_kernelversion() {
 
 	stash_file "$file"
 
-	kernelrelease="$(cd "$SRC" && make syncconfig &>/dev/null && make -s kernelrelease)"
+	if [[ -n "$(make -s listnewconfig 2>/dev/null)" ]]; then
+		die ".config mismatch, check your .config or run 'make olddefconfig'"
+	fi
+	make syncconfig &>/dev/null || die "make syncconfig failed"
+
+	kernelrelease="$(make -s kernelrelease)"
 	[[ -z "$kernelrelease" ]] && die "failed to get kernel version"
 
 	sed -i "2i echo $kernelrelease; exit 0" scripts/setlocalversion
-- 
2.53.0



