Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A288E3A5433;
	Thu, 30 Jul 2026 14:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421677; cv=none; b=FivrCFs0tL9nd5Bjjtke4xvqNQ5+8/eAEAz1O+hxpYMsqBDB0kdv+s6j0zQkdeAmx9Q1Oc7oUQbhikCIimVPTCkoZzxaWmeXHxBzbgAspdRbNmguFJQ02xAbKJULnKKzczY40I/MKD/9gL+CtAKcWRhYzCaRMgu339kbwzeIVn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421677; c=relaxed/simple;
	bh=dpan2z+tOT5NAMzAmlnchMlWSejLJ34B2HJUCArpeok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s8Lt3tQ0T46LoSkTQNBKjELk2/5S3y+ADTCvhob2vMedqILPzzQ5zSXF1Z2qcANaoF6Ch4v4N9lvC+FESSGBbh/KYjGtDJn3Da+gnqgXLEOd6Xh4JjwDuaBX+j5Qf2cLPsqnzk+EQAX6UfTg5P+4LXbkzh8ZxyCxYFcdQhpHNDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OvVz8S9O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OvVz8S9O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E49081F000E9;
	Thu, 30 Jul 2026 14:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421676;
	bh=f23iu79Zdl8RxMraOapHFsqfbdVzVbcO9CDg7uSEWsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OvVz8S9OOm7HwSbVb/nyHJoq/y5veEEc2KSbBVfxc7mCvq7ssHZMDuX4dFTJPOENE
	 KvaRBb1FKycgEqBRQ7i8yNCWjaylZNwCXORui3SxGEmWWCtZQDAab4bQEc4z0OiWsE
	 BCDSPc/gX14F7GXvehjm8T0nPp5t7So3bou4gLeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 185/744] firewire: net: Fix fragmented datagram reassembly
Date: Thu, 30 Jul 2026 16:07:38 +0200
Message-ID: <20260730141448.218894760@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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
index 82b3b6d9ed2df6..2a0727935d7367 100644
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



