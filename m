Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505A9371048;
	Wed, 20 May 2026 18:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301363; cv=none; b=lporepmlOwx3GFrl6UD+LSzj6bHKAY+ixuKS3y+unr7m3QxgnSFdpEuAW6hgb01gtP2iNqrOqghW4K6wKaBCG2OB3uQDiIahdLgDGt65Zl3BZUrt6I3UD6ZRqaWwhyIhtSiry/qRNE5/wmUY7nru/PHBmy1TcL6KGeyw6HGh11w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301363; c=relaxed/simple;
	bh=9Z6faMLma62nEyU68be42B0qiFiHeHZEbHJIwXYRIqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gQC6AuIdJ3QzNAn7BJGrGgJwxaINj48oxpU/M8//igytqQr0tRAvj3SqfVlUKT8eNLZ6dJnDbYS5G7HF0hhJ5U2Vm1T1rwgwCaHY4k04qVLMEg3JSPGOCVuYKEunNkbOFTZyE13yRvOugOYhC6Br+5mf1ONcFu7nXRaAWjHF2j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MhNwu3GK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MhNwu3GK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71E41F000E9;
	Wed, 20 May 2026 18:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301362;
	bh=wj1/MrVEmlFeIKQYhTOAYxthkSVeyDGiTY5PMqsfRoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MhNwu3GK9G7fm+57F2yFpLWWmgND+qJrHCcoCQM+BBmZ42bQRdyhltMzE5CbNTbaQ
	 3ETFyxnDaLw+/+YgRzfCRgi7E+2Z2OegDqy5JYFCpyf3lv6JWo88MNxdXyuBP2HTN8
	 ZGd1VVDlFB+pRtlczaOeEUl/qrlGoAtVYFJo6DbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Weiming Shi <bestswngs@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 475/666] slip: bound decode() reads against the compressed packet length
Date: Wed, 20 May 2026 18:21:26 +0200
Message-ID: <20260520162121.563761334@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit 4c1367a2d7aad643a6f87c6931b13cc1a25e8ca7 ]

slhc_uncompress() parses a VJ-compressed TCP header by advancing a
pointer through the packet via decode() and pull16(). Neither helper
bounds-checks against isize, and decode() masks its return with
& 0xffff so it can never return the -1 that callers test for -- those
error paths are dead code.

A short compressed frame whose change byte requests optional fields
lets decode() read past the end of the packet. The over-read bytes
are folded into the cached cstate and reflected into subsequent
reconstructed packets.

Make decode() and pull16() take the packet end pointer and return -1
when exhausted. Add a bounds check before the TCP-checksum read.
The existing == -1 tests now do what they were always meant to.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Simon Horman <horms@kernel.org>
Closes: https://lore.kernel.org/netdev/20260414134126.758795-2-horms@kernel.org/
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260416100147.531855-5-bestswngs@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/slip/slhc.c | 43 ++++++++++++++++++++++++-----------------
 1 file changed, 25 insertions(+), 18 deletions(-)

diff --git a/drivers/net/slip/slhc.c b/drivers/net/slip/slhc.c
index fcb3eebe7311c..daf086c283423 100644
--- a/drivers/net/slip/slhc.c
+++ b/drivers/net/slip/slhc.c
@@ -80,9 +80,9 @@
 #include <linux/unaligned.h>
 
 static unsigned char *encode(unsigned char *cp, unsigned short n);
-static long decode(unsigned char **cpp);
+static long decode(unsigned char **cpp, const unsigned char *end);
 static unsigned char * put16(unsigned char *cp, unsigned short x);
-static unsigned short pull16(unsigned char **cpp);
+static long pull16(unsigned char **cpp, const unsigned char *end);
 
 /* Allocate compression data structure
  *	slots must be in range 0 to 255 (zero meaning no compression)
@@ -190,30 +190,34 @@ encode(unsigned char *cp, unsigned short n)
 	return cp;
 }
 
-/* Pull a 16-bit integer in host order from buffer in network byte order */
-static unsigned short
-pull16(unsigned char **cpp)
+/* Pull a 16-bit integer in host order from buffer in network byte order.
+ * Returns -1 if the buffer is exhausted, otherwise the 16-bit value.
+ */
+static long
+pull16(unsigned char **cpp, const unsigned char *end)
 {
-	short rval;
+	long rval;
 
+	if (*cpp + 2 > end)
+		return -1;
 	rval = *(*cpp)++;
 	rval <<= 8;
 	rval |= *(*cpp)++;
 	return rval;
 }
 
-/* Decode a number */
+/* Decode a number. Returns -1 if the buffer is exhausted. */
 static long
-decode(unsigned char **cpp)
+decode(unsigned char **cpp, const unsigned char *end)
 {
 	int x;
 
+	if (*cpp >= end)
+		return -1;
 	x = *(*cpp)++;
-	if(x == 0){
-		return pull16(cpp) & 0xffff;	/* pull16 returns -1 on error */
-	} else {
-		return x & 0xff;		/* -1 if PULLCHAR returned error */
-	}
+	if (x == 0)
+		return pull16(cpp, end);
+	return x & 0xff;
 }
 
 /*
@@ -499,6 +503,7 @@ slhc_uncompress(struct slcompress *comp, unsigned char *icp, int isize)
 	struct cstate *cs;
 	int len, hdrlen;
 	unsigned char *cp = icp;
+	const unsigned char *end = icp + isize;
 
 	/* We've got a compressed packet; read the change byte */
 	comp->sls_i_compressed++;
@@ -536,6 +541,8 @@ slhc_uncompress(struct slcompress *comp, unsigned char *icp, int isize)
 	thp = &cs->cs_tcp;
 	ip = &cs->cs_ip;
 
+	if (cp + 2 > end)
+		goto bad;
 	thp->check = *(__sum16 *)cp;
 	cp += 2;
 
@@ -566,26 +573,26 @@ slhc_uncompress(struct slcompress *comp, unsigned char *icp, int isize)
 	default:
 		if(changes & NEW_U){
 			thp->urg = 1;
-			if((x = decode(&cp)) == -1) {
+			if((x = decode(&cp, end)) == -1) {
 				goto bad;
 			}
 			thp->urg_ptr = htons(x);
 		} else
 			thp->urg = 0;
 		if(changes & NEW_W){
-			if((x = decode(&cp)) == -1) {
+			if((x = decode(&cp, end)) == -1) {
 				goto bad;
 			}
 			thp->window = htons( ntohs(thp->window) + x);
 		}
 		if(changes & NEW_A){
-			if((x = decode(&cp)) == -1) {
+			if((x = decode(&cp, end)) == -1) {
 				goto bad;
 			}
 			thp->ack_seq = htonl( ntohl(thp->ack_seq) + x);
 		}
 		if(changes & NEW_S){
-			if((x = decode(&cp)) == -1) {
+			if((x = decode(&cp, end)) == -1) {
 				goto bad;
 			}
 			thp->seq = htonl( ntohl(thp->seq) + x);
@@ -593,7 +600,7 @@ slhc_uncompress(struct slcompress *comp, unsigned char *icp, int isize)
 		break;
 	}
 	if(changes & NEW_I){
-		if((x = decode(&cp)) == -1) {
+		if((x = decode(&cp, end)) == -1) {
 			goto bad;
 		}
 		ip->id = htons (ntohs (ip->id) + x);
-- 
2.53.0



