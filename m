Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B432F0C64;
	Mon, 22 Sep 2025 19:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570087; cv=none; b=eyHVPx7d/wPhjuATCBnAwqVjYQkm3mfq5fr0t2rWzwBMvpz3eK5rhEIFI65NDMFw2CxdtrzwTAcegYgOn9saFL0HBAfLpm8uG8F4tARTqq9mrjNzmaILcpidOgVzEOHmLQo2QpTSPQPuMopNwkDJgRUSJ7PQqJZjuRRbmKiR+ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570087; c=relaxed/simple;
	bh=U0YYQgIpMtjNQapKOdSxGijadJwXDSLYPAL+emSjPBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o1nn3lOhXE/ygq22Txbv3HxHhbQcKqwuGURVPM1N7fv9RGeM0Y+u0TfmchKhnLyVnKVWryth/OIcB4O9y9uRXm5Zzll5DhbUBvj+0ajn8FABk/6+gula18v/MntUBqZR3YKjh20GP048bAhk2kLMLc6id7hjNRdgURTxTWyYR/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1tDqyFcj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1tDqyFcj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44A47C4CEF0;
	Mon, 22 Sep 2025 19:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570086;
	bh=U0YYQgIpMtjNQapKOdSxGijadJwXDSLYPAL+emSjPBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1tDqyFcj0MBLUjmRUuidfWMOlzMuX/+kOxmf4wbH96MfMolefFbZwSRiszCBnbPo9
	 PopYh9ZwkbF0zVk4GpYp72T0YI+R41s41gqm1Dhv+1mreBq1HtGDrCZk4wPElquRn+
	 QexUnEdw7qfzKkUPPx7Fa8R7me3bdfOQ6tlrE89I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 004/149] perf maps: Ensure kmap is set up for all inserts
Date: Mon, 22 Sep 2025 21:28:24 +0200
Message-ID: <20250922192413.005033800@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 20c9ccffccd61b37325a0519fb6d485caeecf7fa ]

__maps__fixup_overlap_and_insert may split or directly insert a map,
when doing this the map may need to have a kmap set up for the sake of
the kmaps. The missing kmap set up fails the check_invariants test in
maps, later "Internal error" reports from map__kmap and ultimately
causes segfaults.

Similar fixes were added in commit e0e4e0b8b7fa ("perf maps: Add
missing map__set_kmap_maps() when replacing a kernel map") and commit
25d9c0301d36 ("perf maps: Set the kmaps for newly created/added kernel
maps") but they missed cases. To try to reduce the risk of this,
update the kmap directly following any manual insert. This identified
another problem in maps__copy_from.

Fixes: e0e4e0b8b7fa ("perf maps: Add missing map__set_kmap_maps() when replacing a kernel map")
Fixes: 25d9c0301d36 ("perf maps: Set the kmaps for newly created/added kernel maps")
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/maps.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/maps.c b/tools/perf/util/maps.c
index 85b2a93a59ac6..779f6230130af 100644
--- a/tools/perf/util/maps.c
+++ b/tools/perf/util/maps.c
@@ -477,6 +477,7 @@ static int __maps__insert(struct maps *maps, struct map *new)
 	}
 	/* Insert the value at the end. */
 	maps_by_address[nr_maps] = map__get(new);
+	map__set_kmap_maps(new, maps);
 	if (maps_by_name)
 		maps_by_name[nr_maps] = map__get(new);
 
@@ -502,8 +503,6 @@ static int __maps__insert(struct maps *maps, struct map *new)
 	if (map__end(new) < map__start(new))
 		RC_CHK_ACCESS(maps)->ends_broken = true;
 
-	map__set_kmap_maps(new, maps);
-
 	return 0;
 }
 
@@ -891,6 +890,7 @@ static int __maps__fixup_overlap_and_insert(struct maps *maps, struct map *new)
 		if (before) {
 			map__put(maps_by_address[i]);
 			maps_by_address[i] = before;
+			map__set_kmap_maps(before, maps);
 
 			if (maps_by_name) {
 				map__put(maps_by_name[ni]);
@@ -918,6 +918,7 @@ static int __maps__fixup_overlap_and_insert(struct maps *maps, struct map *new)
 			 */
 			map__put(maps_by_address[i]);
 			maps_by_address[i] = map__get(new);
+			map__set_kmap_maps(new, maps);
 
 			if (maps_by_name) {
 				map__put(maps_by_name[ni]);
@@ -942,14 +943,13 @@ static int __maps__fixup_overlap_and_insert(struct maps *maps, struct map *new)
 				 */
 				map__put(maps_by_address[i]);
 				maps_by_address[i] = map__get(new);
+				map__set_kmap_maps(new, maps);
 
 				if (maps_by_name) {
 					map__put(maps_by_name[ni]);
 					maps_by_name[ni] = map__get(new);
 				}
 
-				map__set_kmap_maps(new, maps);
-
 				check_invariants(maps);
 				return err;
 			}
@@ -1019,6 +1019,7 @@ int maps__copy_from(struct maps *dest, struct maps *parent)
 				err = unwind__prepare_access(dest, new, NULL);
 				if (!err) {
 					dest_maps_by_address[i] = new;
+					map__set_kmap_maps(new, dest);
 					if (dest_maps_by_name)
 						dest_maps_by_name[i] = map__get(new);
 					RC_CHK_ACCESS(dest)->nr_maps = i + 1;
-- 
2.51.0



