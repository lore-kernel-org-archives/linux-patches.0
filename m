Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40EA83EBF35;
	Wed, 20 May 2026 17:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298731; cv=none; b=gOT5Ub1xfZGl31C1ooNpvRKowAtgQ+jK0vmG+m7M6j9NPUN5OTbE7OWuB5vOudJPW1WDX56729bhZX3LsKRavJyf6KpoMKrKMoPVX83kAHB4ScCeiRFrfpuutiS/v1wLthlSMOYItIW+ZdUjtlTn6wKB1iEcJ084q5lSaYLTu3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298731; c=relaxed/simple;
	bh=eW3SoQEUI8aeoe0JWlZKr829VX8CK7D0AyljsGejEaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rKku7H7ITEqaWm2Y5Iypqu0JlSFTvdHa0pgg2xyZXeCXU5YVZeCTfmLVVkRaHkEbCxwmxLbnPOdcljqUXBN0WIINeRAzHaIJsNXcH3x6ujdWZbC85o9PW5G4T89zMzKW2VQyLt9fj1odzGRxiMiZcJ0EymT8hi3RUzx9BZPgIiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F8YUwahY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F8YUwahY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A71F61F000E9;
	Wed, 20 May 2026 17:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298730;
	bh=CH+oIATs090m6gNBh5Oq53e/KXL18ng3VWdf+gadahM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F8YUwahYxtdosAkpNNdO4b363TxHAF/Rm6iK+XpUEivPheI+pzeSo4dLziEUDnEdw
	 lnZwSO30P+/zOZCRYY+VfwzWksUXxL5hrcIiLmNjyVyP+wCjNNZThG+6QAbpTMtts6
	 zSU2icTlHxcE2Sy6cT7QaX1hMD2u2+ghjTmZGpCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 521/957] perf maps: Fix copy_from that can break sorted by name order
Date: Wed, 20 May 2026 18:16:44 +0200
Message-ID: <20260520162145.832798900@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit f552b132e4d5248715828e7e5c2bf7889bf05b2e ]

When an parent is copied into a child the name array is populated in
address not name order. Make sure the name array isn't flagged as sorted.

Fixes: 659ad3492b91 ("perf maps: Switch from rbtree to lazily sorted array for addresses")
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/maps.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/maps.c b/tools/perf/util/maps.c
index ff82d1d937b2f..23aa8a95d0454 100644
--- a/tools/perf/util/maps.c
+++ b/tools/perf/util/maps.c
@@ -1032,16 +1032,9 @@ int maps__copy_from(struct maps *dest, struct maps *parent)
 				map__put(new);
 		}
 		maps__set_maps_by_address_sorted(dest, maps__maps_by_address_sorted(parent));
-		if (!err) {
-			RC_CHK_ACCESS(dest)->last_search_by_name_idx =
-				RC_CHK_ACCESS(parent)->last_search_by_name_idx;
-			maps__set_maps_by_name_sorted(dest,
-						dest_maps_by_name &&
-						maps__maps_by_name_sorted(parent));
-		} else {
-			RC_CHK_ACCESS(dest)->last_search_by_name_idx = 0;
-			maps__set_maps_by_name_sorted(dest, false);
-		}
+		RC_CHK_ACCESS(dest)->last_search_by_name_idx = 0;
+		/* Values were copied into the name array in address order. */
+		maps__set_maps_by_name_sorted(dest, false);
 	} else {
 		/* Unexpected copying to a maps containing entries. */
 		for (unsigned int i = 0; !err && i < n; i++) {
-- 
2.53.0



