Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C5346AA82;
	Tue, 21 Jul 2026 15:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648329; cv=none; b=QNJg/kHuHtfvxRvtB23pqUOwXyxWnWyfd1ovcV9aFWkvkarV3hEWra7TB24o9EFMptZ1+yOgp4vnJh6YIY/gu4MROsUJouwsWvslaiVD2fGWUrosINxn34Z8ZOXivbyPq5sJSigllw0uNPdtX5700bAPqAYZ1h2j73y4sDcwZQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648329; c=relaxed/simple;
	bh=l4NDMH3JHOcu1HanEnY1k5vYv903OgvwbYhXiBEebdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P1D5FDSxrcJNg3YQG4g4EypUwq+4kwf6F/dnjwAe1pfINp4f68br8IBUJDMQRRrYIuFUgm4O4b+gXDw9xjsKmHCNryhYwDy+6fIf1KRZNN4S4t/QTkYxmSYsmVcB/5KP7SnHb1qqPfOlspwzh0iRquBjCCHQkYJFzfBbQpkKK+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UDh8YVHp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UDh8YVHp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE3661F00A3A;
	Tue, 21 Jul 2026 15:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648328;
	bh=U/m1UoehoorPYBtrhfq/l+x/b2KraTdxZaLSPxSA17A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UDh8YVHp/0GfKueTYpPzSfKIRu2JJJRauz/4XZi8+uYnuQ/QuZSNoaXaRxSu/crGZ
	 EaPwd3MBOKtYlMaCPSBWXIleYgCRHham1PjXLn+Qao05YTrcwGv7CYHN4x5UZpO50w
	 RNbxClu0H86cNWgMvLhLaPsPnC3IH31V7LjRerQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Liu <song@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0131/2077] klp-build: Fix checksum comparison for changed offsets
Date: Tue, 21 Jul 2026 16:56:44 +0200
Message-ID: <20260721152555.782473326@linuxfoundation.org>
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

[ Upstream commit ba77fe55781a2464f68b6c13b4b31d05abd2abcf ]

The klp-build -f/--show-first-changed feature uses diff to compare
checksum log lines between original and patched objects.  However, diff
compares entire lines, including the offset field.  When a function is
at a different section offset, the offset field differs even though the
instruction checksum is identical, causing the wrong instruction to be
printed.

Only compare the checksum field when looking for the first changed
instruction.  Also print both the original and patched offsets when they
differ.

Fixes: 78be9facfb5e ("livepatch/klp-build: Add --show-first-changed option to show function divergence")
Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/livepatch/klp-build | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index e19d93b78fcba0..8f0ea56f264005 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -727,13 +727,29 @@ diff_checksums() {
 		)
 
 		for func in ${funcs[$file]}; do
-			diff <( grep0 -E "^DEBUG: .*checksum: $func " "$orig_log"    | sed "s|$ORIG_DIR/||")	\
-			     <( grep0 -E "^DEBUG: .*checksum: $func " "$patched_log" | sed "s|$PATCHED_DIR/||")	\
-				| gawk '/^< DEBUG: / {
-					gsub(/:/, "")
-					printf "%s: %s: %s\n", $3, $5, $6
-					exit
-			}' || true
+			local -a orig patched
+			paste <(grep0 -E "^DEBUG: .*checksum: $func " "$orig_log") \
+			      <(grep0 -E "^DEBUG: .*checksum: $func " "$patched_log") |
+			while IFS= read -r line; do
+				read -ra orig <<< "${line%%$'\t'*}"
+				read -ra patched <<< "${line#*$'\t'}"
+
+				if [[ ${#patched[@]} -eq 0 ]]; then
+					printf "%s: %s: %s (removed)\n" "${orig[1]%:}" "${orig[3]}" "${orig[-2]}"
+					break
+				elif [[ ${#orig[@]} -eq 0 ]]; then
+					printf "%s: %s: %s (added)\n" "${patched[1]%:}" "${patched[3]}" "${patched[-2]}"
+					break
+				fi
+
+				[[ "${orig[-1]}" == "${patched[-1]}" ]] && continue
+
+				printf "%s: %s: %s" "${orig[1]%:}" "${orig[3]}" "${orig[-2]}"
+				[[ "${orig[-2]}" != "${patched[-2]}" ]] && \
+					printf " (patched: %s)" "${patched[-2]}"
+				printf "\n"
+				break
+			done || true
 		done
 	done
 }
-- 
2.53.0



