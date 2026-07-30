Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5776442FA2;
	Thu, 30 Jul 2026 15:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423951; cv=none; b=mOhKgUqTdC3dVmhnmXBEg3mHt4K7pBif3Lu2DCTgEZsPUgawiGtQgYu47l2aovL4XZs3wpHEMlgscCxBIas0vyxC60lVcUMRFBXMeKPlLj5I7aNp9b1O6KIiN2/U5EEjBNeXAAXm8K2nSm2mHBXm3KNpiHSx1g9kqrbebqXDxGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423951; c=relaxed/simple;
	bh=YJV4u8A9hRnxm4JDCj6xI3D9zDQ2HImBmBz+LGfAqF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UzG2qb86LKfAhU28zPNKrqvXXmz8DfoVqCFxdM367amaFcMZppBKSZRnA5sdWYBjJUfovJN/Bg1Hcp6Lalcnpu5QCykZOk6T/ybhY3GLy3Sttxkr4GXGHNcFQ0Al1VlDO+2nHRGQj/j9Sw5523wQFarm0HJurkwafDQ4l7AhT1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YawlKxB0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YawlKxB0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF5551F000E9;
	Thu, 30 Jul 2026 15:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423950;
	bh=SOYBvMTmiMUqpaeHxVyCMEpMe8m16g9movRzcTiUp/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YawlKxB0D0zCsvP6K3fUIHrQzoQXXRM1sGfQwVwpK28251PMWao+fvt4kxOOjwhfk
	 6S8BhuvrLN9clYQ38f+NM6KWxbPLpGiWHv9Gxm0ELmrTX9ZfSmkzRa7nBDYH9mI2R1
	 3EkNH8zhTfgQ/9VmOzCuw6txPN1uAEvumB53VYEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 178/675] firewire: net: Fix fragmented datagram reassembly
Date: Thu, 30 Jul 2026 16:08:28 +0200
Message-ID: <20260730141448.923270937@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
index e8294540895507..354c81409946a9 100644
--- a/drivers/firewire/net.c
+++ b/drivers/firewire/net.c
@@ -298,31 +298,34 @@ static struct fwnet_fragment_info *fwnet_frag_new(
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



