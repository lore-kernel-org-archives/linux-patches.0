Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F7A30C366;
	Fri,  4 Sep 2026 06:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502141; cv=none; b=fuwE/ZNP39XuQx8MU/iF0Y9iUKhB4pPpuzlwP5uUOOrj9y5AKpp3mmKJyuGvCD18LM+UZTypZSGjz4dI/Iua9ts7CC9pVW6d7nwg+O7UDHVziy+6fBKFv8jcf3lq9WRw7vOjIS9CL6lX+aLqVOvydLS9C5tSLzFWViH4JF+R9Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502141; c=relaxed/simple;
	bh=tiFRUfx9A9kk0Oxe3+xW5ikPOZZtYl0eBFOK7hqE6m0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TJRMq8usoCsi//Q/lYd6HQb4LCstJV0vHeNMxTIxQXQdSqpC/JJoVb1xl8gPCf1b2fk4ou+Z0NWRfd1TNRjj9e3sgpNl85K95b+bo4vO+PnqHRK/93L5GJp1rU0bYCMtM+fQ0gT9YEtfHLctAsRWTkzOq182kmnB3FwlELC6YTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GO5lgTY/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GO5lgTY/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E37C1F00A3D;
	Fri,  4 Sep 2026 06:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502139;
	bh=tZrZCg/ETG1OLnYetBYzBvoNoeaURXaR+HOYk1XQe/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GO5lgTY/DQyMpBZyDwlN/x+4g2+YbrlTscAgQrk6aJ6TFkm+0pEWCDZ9qPbuwO7FG
	 nQFeLLFVYKPWgSShVa99IQ12q7HIQWAmOS1wtBP6aWlZoZ0pvRujarK6MER7zVRHNt
	 AEd6O2CXWj3Wqi+V14lCc5rVy2PScdcGARRN1lYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robbie Ko <robbieko@synology.com>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 104/403] nfsd: reject out-of-range useconds in NFSv2 SETATTR/CREATE
Date: Fri,  4 Sep 2026 06:58:27 +0200
Message-ID: <20260904045737.194227274@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

From: Robbie Ko <robbieko@synology.com>

commit 26709c8ffe73772eb69e68d553ac71d91228dccc upstream.

The NFSv2 sattr decoder converts the wire useconds to nanoseconds in
svcxdr_decode_sattr():

	iap->ia_atime.tv_nsec = tmp2 * NSEC_PER_USEC;

tmp2 is a u32 and NSEC_PER_USEC is 1000, so the product is computed in
unsigned long. On ILP32 that is 32 bits, and an out-of-range useconds
value such as 4294968 wraps to tv_nsec == 704. The corruption therefore
happens during decode, before any proc function can inspect the value,
and a later range check on tv_nsec would see an in-range result and
accept it. Rejecting in the decoder yields an RPC GARBAGE_ARGS reply.
NFSv2 defines no NFSERR_INVAL, so there is no NFS-level status to return
for a malformed time argument, and the check cannot move to the proc
function the way the v3/v4 nsec range checks do.

Guard the raw useconds before the multiplication and reject values
greater than 1000000. useconds == 1000000 is kept: it is the Sun
convention for "set to the current server time", and the in-tree Linux
NFSv2 client emits it in both the atime and the mtime field for a plain
touch / utimes(file, NULL) (see encode_sattr() and
xdr_encode_current_server_time() in fs/nfs/nfs2xdr.c). Rejecting 1000000
would turn that common operation into a hard decode failure for both
SETATTR and CREATE. 1000000 * NSEC_PER_USEC is 10^9, which does not wrap
on ILP32, so the Sun convention value passes through safely. Only
genuinely out-of-range values (> 1000000) are rejected. The atime and
mtime guards are therefore symmetric.

The decoder only applied the Sun convention in the mtime block, which
clears ATTR_ATIME_SET|ATTR_MTIME_SET when mtime useconds == 1000000. If a
client puts 1000000 in the atime field but not in the mtime field, the
atime block stored an out-of-range tv_nsec (10^9) and left ATTR_ATIME_SET
set, so the bogus value reached the filesystem. Apply the convention in
the atime block as well, clearing ATTR_ATIME_SET so the server uses its
current time and ignores the value. Only ATTR_ATIME_SET is cleared there.
The mtime block keeps its existing behavior, where 1000000 means "set
both atime and mtime to now".

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Robbie Ko <robbieko@synology.com>
[ cel: various tweaks, addenda, and clean-ups ]
Link: https://patch.msgid.link/20260616054027.2360930-1-robbieko@synology.com
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsxdr.c |   32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

--- a/fs/nfsd/nfsxdr.c
+++ b/fs/nfsd/nfsxdr.c
@@ -10,6 +10,16 @@
 #include "auth.h"
 
 /*
+ * Sun convention: a sattr time-useconds field of one full second (an
+ * otherwise out-of-range value) means "set this time to the current
+ * server time." It's needed to make permissions checks for the "touch"
+ * program across NFSv2 mounts work correctly. See description of
+ * sattr in section 6.1 of "NFS Illustrated" by Brent Callaghan,
+ * Addison-Wesley, ISBN 0-201-32750-5
+ */
+#define NFS2_SATTR_SET_TO_SERVER_TIME	(1000000)
+
+/*
  * Mapping of S_IF* types to NFS file types
  */
 static const u32 nfs_ftypes[] = {
@@ -172,27 +182,29 @@ svcxdr_decode_sattr(struct svc_rqst *rqs
 	tmp1 = be32_to_cpup(p++);
 	tmp2 = be32_to_cpup(p++);
 	if (tmp1 != (u32)-1 && tmp2 != (u32)-1) {
+		/*
+		 * Range test here to prevent the multiplication from
+		 * wrapping to a valid (but incorrect) value on 32-bit
+		 * platforms.
+		 */
+		if (tmp2 > NFS2_SATTR_SET_TO_SERVER_TIME)
+			return false;
 		iap->ia_valid |= ATTR_ATIME | ATTR_ATIME_SET;
 		iap->ia_atime.tv_sec = tmp1;
 		iap->ia_atime.tv_nsec = tmp2 * NSEC_PER_USEC;
+		if (tmp2 == NFS2_SATTR_SET_TO_SERVER_TIME)
+			iap->ia_valid &= ~ATTR_ATIME_SET;
 	}
 
 	tmp1 = be32_to_cpup(p++);
 	tmp2 = be32_to_cpup(p++);
 	if (tmp1 != (u32)-1 && tmp2 != (u32)-1) {
+		if (tmp2 > NFS2_SATTR_SET_TO_SERVER_TIME)
+			return false;
 		iap->ia_valid |= ATTR_MTIME | ATTR_MTIME_SET;
 		iap->ia_mtime.tv_sec = tmp1;
 		iap->ia_mtime.tv_nsec = tmp2 * NSEC_PER_USEC;
-		/*
-		 * Passing the invalid value useconds=1000000 for mtime
-		 * is a Sun convention for "set both mtime and atime to
-		 * current server time".  It's needed to make permissions
-		 * checks for the "touch" program across v2 mounts to
-		 * Solaris and Irix boxes work correctly. See description of
-		 * sattr in section 6.1 of "NFS Illustrated" by
-		 * Brent Callaghan, Addison-Wesley, ISBN 0-201-32750-5
-		 */
-		if (tmp2 == 1000000)
+		if (tmp2 == NFS2_SATTR_SET_TO_SERVER_TIME)
 			iap->ia_valid &= ~(ATTR_ATIME_SET|ATTR_MTIME_SET);
 	}
 


