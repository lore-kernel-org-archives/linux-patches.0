Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76AB2D5A01;
	Mon, 17 Aug 2026 14:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975689; cv=none; b=WyFVwQvZiVAQ3Ajcx+zmvXjUEf2VuBoutHzyRlAWznuXVk7/KK6kBI3Kh9MO7xuVqQHK/OFon7I0h0ozUsuMKgvpaIldCuGGoK7kcy8fYQv4200CVtSDGLiK9UGETKL1JPxfgHXO60QV0zg9tzQuWGNUp9DZGkTktVsELwJ4UKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975689; c=relaxed/simple;
	bh=fog8tWHSycMPI3uyoB+GRzNBsqiU5iUuDghWaW2aJ1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eL+U3e/JhNnRplPwq/3dS9qdMGq1cixNM8hO2ktZhe+FjktDvqucaQi/5hrhttniHHR+06F5xcWDOYr9UX/d942hM6YT3gkv1rqhz7D63P11A2PGSfOCQ2X8NdzhnKdWQFFMUA3Jb60i6bp2tb/KTorjPAlXvQBxXMq9VUxp+C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Af6lqElo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Af6lqElo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF1C1F000E9;
	Mon, 17 Aug 2026 14:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975687;
	bh=vKf0zb1QCHElnRAldyGwDjVFGljHy1nAMRw3x+2RPXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Af6lqEloL1oCcjDk46c43qDMO/0pViM/bTK9dPwWzPZlCoe7PpUo2a3kFQLbPLEqL
	 KgyxVBpZ8/+sCXL/12lixDvyDKyH/oB6cSz+fgKjW55fKuGBDulfBlsxp7jSvbhha6
	 9rpnB7Btzt8j/esTt3s+N3VzIJJq+p8v4OHUl4W8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 065/389] firewire: net: Fix fragmented datagram reassembly
Date: Mon, 17 Aug 2026 15:28:24 +0200
Message-ID: <20260817132541.632122370@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit d52a13adbb8ccbab99cd3bad36804e87d8b5c052 ]

fwnet_frag_new() keeps a sorted list of received fragments for a partial
datagram. When a new fragment is adjacent to an existing fragment, the
code checks whether the new fragment also closes the gap to the next or
previous list entry.

Those neighbor lookups currently assume that the current fragment always
has a real next or previous fragment. At a list edge, the next or
previous entry is the list head, not a struct fwnet_fragment_info.

The gap checks also compare against the old edge of the current fragment
instead of the edge after adding the new fragment. As a result, a
fragment that bridges two existing ranges may leave two adjacent ranges
unmerged, so fwnet_pd_is_complete() can miss a complete datagram.

Check for the list head before looking up the neighboring fragment, and
compare the neighbor against the new fragment's far edge when deciding
whether to merge all three ranges.

This issue was found by a static analysis checker and confirmed by
manual source review.

Fixes: c76acec6d551 ("firewire: add IPv4 support")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Link: https://lore.kernel.org/r/20260707150454.2265951-1-ruoyuw560@gmail.com
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firewire/net.c | 39 +++++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/firewire/net.c b/drivers/firewire/net.c
index 715e491dfbc333..8678ded9360a63 100644
--- a/drivers/firewire/net.c
+++ b/drivers/firewire/net.c
@@ -306,31 +306,34 @@ static struct fwnet_fragment_info *fwnet_frag_new(
 		if (fi->offset + fi->len == offset) {
 			/* The new fragment can be tacked on to the end */
 			/* Did the new fragment plug a hole? */
-			fi2 = list_entry(fi->fi_link.next,
-					 struct fwnet_fragment_info, fi_link);
-			if (fi->offset + fi->len == fi2->offset) {
-				/* glue fragments together */
-				fi->len += len + fi2->len;
-				list_del(&fi2->fi_link);
-				kfree(fi2);
-			} else {
-				fi->len += len;
+			if (!list_is_last(&fi->fi_link, &pd->fi_list)) {
+				fi2 = list_next_entry(fi, fi_link);
+				if (offset + len == fi2->offset) {
+					/* glue fragments together */
+					fi->len += len + fi2->len;
+					list_del(&fi2->fi_link);
+					kfree(fi2);
+
+					return fi;
+				}
 			}
+			fi->len += len;
 
 			return fi;
 		}
 		if (offset + len == fi->offset) {
 			/* The new fragment can be tacked on to the beginning */
 			/* Did the new fragment plug a hole? */
-			fi2 = list_entry(fi->fi_link.prev,
-					 struct fwnet_fragment_info, fi_link);
-			if (fi2->offset + fi2->len == fi->offset) {
-				/* glue fragments together */
-				fi2->len += fi->len + len;
-				list_del(&fi->fi_link);
-				kfree(fi);
-
-				return fi2;
+			if (!list_is_first(&fi->fi_link, &pd->fi_list)) {
+				fi2 = list_prev_entry(fi, fi_link);
+				if (fi2->offset + fi2->len == offset) {
+					/* glue fragments together */
+					fi2->len += fi->len + len;
+					list_del(&fi->fi_link);
+					kfree(fi);
+
+					return fi2;
+				}
 			}
 			fi->offset = offset;
 			fi->len += len;
-- 
2.53.0



