Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A3846AA86;
	Tue, 21 Jul 2026 15:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648358; cv=none; b=As8bFNeZ3BaCe6N29JlMTgtNFCPDC+m+zU7FYl2xfP8v2a5fTBsVD6BJR7bYpZzAycaMzMBt1ByUAHkAE6IPWQhUMkZWaFge7WGOjPZnXOxTRdF+qdp2UUuNUOR53CRc90zmlQg5Fr+EW5I3efGXjy2+5xC4R9yBmvP/NsBRqcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648358; c=relaxed/simple;
	bh=5ffhWQp1cKWGlnDxLFjNiLjrbctg/jY8sIXP2Oq0+V8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hr70SLFc4NaZCKPzi4xf5l4EJkmyZig8MXvZS5gh22pTwXbJC6hE/VO7Lvtokbp+Yk09xmc4DCzO/teFnbZavp5/vZsOMrEIPT6rY0D39V8LCC6bGzavkuiqlaPvssjjQCzhW1HXsBuksIx/F8NiB6Tv+C2U6OwNylTOdcvHS1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zv2NrD+3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zv2NrD+3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C831F000E9;
	Tue, 21 Jul 2026 15:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648357;
	bh=M11MjTgk+Tp77ITCMrEZX6EvXVPDfIpac1H0pyNxWaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zv2NrD+341xssa1wE6a6zdMl9NczuLOusL3fgGJSG3hwVx7n5D4CAwgOy/I/omvQo
	 PFWcD8iorWBo71YQhhDNF2OftQJB2k45eqvNVfJwMU+yc1mXktW7XImA/SUv4H7bfJ
	 2l8piYLi/SEtWJPzZXvuEG4M137prX+FNcsrG1TI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Liu <song@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0132/2077] klp-build: Fix patch cleanup on interrupt
Date: Tue, 21 Jul 2026 16:56:45 +0200
Message-ID: <20260721152555.806685233@linuxfoundation.org>
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

[ Upstream commit f3048888ea62ac1c573db91e74e0dcabe058e89f ]

If a build error occurs and the user hits Ctrl-C while a large patch is
being reverted during cleanup, the cleanup EXIT trap gets re-triggered
and tries to re-revert the already partially-reverted patch.  That
causes 'patch -R' to repeatedly prompt

  "Unreversed patch detected!  Ignore -R? [n]"

for each already-reverted hunk, with no way to break out.

Fix it by adding '--force' to the patch revert command in
revert_patch(), which causes it to silently ignore already-reverted
hunks.  And ignore errors, as the cleanup is always best-effort.

For similar reasons, add to APPLIED_PATCHES before (rather than after)
applying the patch in apply_patch() so an interrupted apply will also
get cleaned up.

Fixes: d36a7343f4ba ("livepatch/klp-build: switch to GNU patch and recountdiff")
Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/livepatch/klp-build | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index 8f0ea56f264005..ab5ea13c87004e 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -381,15 +381,15 @@ apply_patch() {
 		warn "${patch} applied with fuzz"
 	fi
 
-	patch -d "$SRC" -p1 --no-backup-if-mismatch -r /dev/null "${extra_args[@]}" --silent < "$patch"
 	APPLIED_PATCHES+=("$patch")
+	patch -d "$SRC" -p1 --no-backup-if-mismatch -r /dev/null "${extra_args[@]}" --silent < "$patch"
 }
 
 revert_patch() {
 	local patch="$1"
 	local tmp=()
 
-	patch -d "$SRC" -p1 -R --silent --no-backup-if-mismatch -r /dev/null < "$patch"
+	patch -d "$SRC" -p1 -R --force --no-backup-if-mismatch -r /dev/null &> /dev/null < "$patch" || true
 
 	for p in "${APPLIED_PATCHES[@]}"; do
 		[[ "$p" == "$patch" ]] && continue
-- 
2.53.0



