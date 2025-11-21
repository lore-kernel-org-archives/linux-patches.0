Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A20275B18;
	Fri, 21 Nov 2025 13:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731529; cv=none; b=HJxU5cYMFhrqOuCe/Z+7O+YT/vGp4fywDmsXJHzuxtIogOcPi3ncjdKJU6PVqHNBhfTkIdn6ifbdHUQsa5e5XFKqvgNBRVrhAeXSWKDsAXFfyCr6aVJhaQakV0OW6lTZLrUITLpw1T5lXpZVXf5ARY29BT/kSbn2bemelAEdsnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731529; c=relaxed/simple;
	bh=Y1NpoIfHDBHXTiMZ7HaeQk8GchA6wkqk0nC5djxAgzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pnotexdlbqiD4sEzPUsV+qpqU72BxRHwRLFTP8PzfLq/L0V4PRh9nxdCGKjUVmfO/Ez4H1N0RnyTy8jlxrQLdCXwwwZIJgmHP8VI7UGXcAfBzJPT+WvXq5Dx/XACq5wCGa0NT9WuCP0OpweTze9zZN+igyEqppzBgVlcJUw8VWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d5jQikxd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d5jQikxd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A74C4CEF1;
	Fri, 21 Nov 2025 13:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731529;
	bh=Y1NpoIfHDBHXTiMZ7HaeQk8GchA6wkqk0nC5djxAgzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d5jQikxdhtLO82LPWMpaje1UgJHK1Dsbw/b8EEGbKtna5+Y8eClz+o/6o6GYlXx4b
	 D8sKyFcoL9gzgiVjAiAn1R+tGC3OgevfT9V8xlM2jeI6EF5xO8DDjpoS/ZzP5VCJ7m
	 FqorW6QJsT6tnJmtKoCZOCkoxsXSTQ4Lp4KKV8Kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Llamas <cmllamas@google.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Breno Leitao <leitao@debian.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Puranjay Mohan <puranjay@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.17 240/247] scripts/decode_stacktrace.sh: fix build ID and PC source parsing
Date: Fri, 21 Nov 2025 14:13:07 +0100
Message-ID: <20251121130203.350974026@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

From: Carlos Llamas <cmllamas@google.com>

commit 7d9f7d390f6af3a29614e81e802e2b9c238eb7b2 upstream.

Support for parsing PC source info in stacktraces (e.g.  '(P)') was added
in commit 2bff77c665ed ("scripts/decode_stacktrace.sh: fix decoding of
lines with an additional info").  However, this logic was placed after the
build ID processing.  This incorrect order fails to parse lines containing
both elements, e.g.:

  drm_gem_mmap_obj+0x114/0x200 [drm 03d0564e0529947d67bb2008c3548be77279fd27] (P)

This patch fixes the problem by extracting the PC source info first and
then processing the module build ID.  With this change, the line above is
now properly parsed as such:

  drm_gem_mmap_obj (./include/linux/mmap_lock.h:212 ./include/linux/mm.h:811 drivers/gpu/drm/drm_gem.c:1177) drm (P)

While here, also add a brief explanation the build ID section.

Link: https://lkml.kernel.org/r/20251030010347.2731925-1-cmllamas@google.com
Fixes: 2bff77c665ed ("scripts/decode_stacktrace.sh: fix decoding of lines with an additional info")
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Matthieu Baerts <matttbe@kernel.org>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Puranjay Mohan <puranjay@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/decode_stacktrace.sh |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/scripts/decode_stacktrace.sh
+++ b/scripts/decode_stacktrace.sh
@@ -275,12 +275,6 @@ handle_line() {
 		fi
 	done
 
-	if [[ ${words[$last]} =~ ^[0-9a-f]+\] ]]; then
-		words[$last-1]="${words[$last-1]} ${words[$last]}"
-		unset words[$last] spaces[$last]
-		last=$(( $last - 1 ))
-	fi
-
 	# Extract info after the symbol if present. E.g.:
 	# func_name+0x54/0x80 (P)
 	#                     ^^^
@@ -292,6 +286,14 @@ handle_line() {
 		unset words[$last] spaces[$last]
 		last=$(( $last - 1 ))
 	fi
+
+	# Join module name with its build id if present, as these were
+	# split during tokenization (e.g. "[module" and "modbuildid]").
+	if [[ ${words[$last]} =~ ^[0-9a-f]+\] ]]; then
+		words[$last-1]="${words[$last-1]} ${words[$last]}"
+		unset words[$last] spaces[$last]
+		last=$(( $last - 1 ))
+	fi
 
 	if [[ ${words[$last]} =~ \[([^]]+)\] ]]; then
 		module=${words[$last]}


