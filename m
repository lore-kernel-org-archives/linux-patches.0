Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661453112C1;
	Sat, 30 May 2026 18:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164525; cv=none; b=MpX5KWeZdK/wVC9ZS4HxnvFirS2JbMvBgwU3tzhb328Fb2CuQcZ58I1en+rp7ZHqVSpnYOPiWC/VPUYHj1+w+qH0xDHc+H4/CTQKFAEdZzoErN4BJav4yMoTTBhgGDuP8U8Xhkh0PL3ADLanE72azF8UhxvlKbN84fTz3Koo+3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164525; c=relaxed/simple;
	bh=jHF1NwVb0BxLv16iZrZ+e2HRHS2yCRfdovZiWTcxQi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tG3/kNJCFUcFKi6Tw4sbzIEQNJOm/dtyxR9hl10HGldoRBljNFBQesx2sV97nYmsZ+7ID6BUi4XKOCdpEujrQcPeE+Ns0+ffRJMS2dzpNh5umawvDMzvremMWvZo3y4dxlP5I1USO6OOaytDPsnVKX6tQZmvxdUqZXdkPy+DUJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ObYHkCGe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ObYHkCGe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85DEC1F00893;
	Sat, 30 May 2026 18:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164524;
	bh=+H6JrJefD7UUMXDFV4ypa1eBHKw9CAdQ1GBqcCnAALw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ObYHkCGeKdYI4YT/Jz0GjNE65Z43zfabuhy6+gVWhWBry9C+qXE845u7u18rZ2ydt
	 Oi37gYVI4W4ioIuLJr5S7tJ8mw69wWBoL4AE7Oiem5x3tk8kcCj90FJVD9SKEisrp6
	 OwmmZ1vbq+AS/wGwo0j9cHkNNJT13AAtm0MGfR/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Weiming Shi <bestswngs@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 580/776] slip: bound decode() reads against the compressed packet length
Date: Sat, 30 May 2026 18:04:54 +0200
Message-ID: <20260530160255.079773466@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3474792a37a67..ef586ab250747 100644
--- a/drivers/net/slip/slhc.c
+++ b/drivers/net/slip/slhc.c
@@ -80,9 +80,9 @@
 #include <asm/unaligned.h>
 
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



