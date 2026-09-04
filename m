Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39643D6664;
	Fri,  4 Sep 2026 05:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498927; cv=none; b=HTMdJIM/QvoIL0CCZFA/G+SwUDkadGBbEMNb3dipy6hvfhJWTKK5LuvYaKgMXZ1IxkWJdTQEu2mvMvO1KHXn8sZ9a64QEKYDV1+OePmszV9o0A7C45rlylxLsyIQBbBRCV98TrXEfOgGReArrRDTRP90q8VZrSqmV8oGK6mIOMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498927; c=relaxed/simple;
	bh=aexaGL4Fq4ElZt+iYyEJH8atEB0PUdxP0WtCriCE25U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GgmFd6nGzULWbteoB3VRfM5dqlOp2lQTQ/cwcfEilN3ZV2ynMAYybOvjXIYPxFSnQw5DNKsvE7dNpQfmExEkvGvie/VwFtsmNn1TxO+MvshBlggH0L1p9DckLNeMDPU/B8h/v4G4Ai+eIz46l/7vbrYz+IWnB4uifQwUty9MIT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SXZwc6W1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SXZwc6W1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA2571F00A3D;
	Fri,  4 Sep 2026 05:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498925;
	bh=4zO1jA9KT+JYqrIaRraepMiy41L6NadAsIgh50BbtOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SXZwc6W1WWkQGcMpl/lufWfspr0u2nN7SODS12fLKEofH9jcNfHvqP+hNSkNDonDi
	 jB5CJ7rKWHTMXHrsQzhEyzKMVsqgEPnd6V8T+WQrGkiuxYhjUph78o1lRsN2KmX29E
	 iaU4CszvlSj0VNor9aiQGOw8sVIXFkB+CgRC21sw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.2 236/713] smb: client: fix UAF and buffer leak in cifs_check_trans2() for malformed secondary T2
Date: Fri,  4 Sep 2026 06:53:24 +0200
Message-ID: <20260904045809.113979297@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Sorenson <sorenson@redhat.com>

commit 730d0bb19507b9e19c2fe5343109ac618e2fbce5 upstream.

When a valid primary TRANSACT2 response has been received (mid->resp_buf
set, mid->multiRsp true) and a subsequent secondary response causes
cifs_check_trans2() to return false -- either because the SMB header is
invalid (malformed != 0) or because check2ndT2() rejects the PDU --
handle_mid() overwrites mid->resp_buf with the new buffer (leaking the
primary buffer) and, because mid->multiRsp is set, skips the
server->smallbuf/bigbuf NULL-out.  When the user thread frees
mid->resp_buf, server->smallbuf or server->bigbuf is left dangling; the
demux thread reuses it for the next packet, resulting in a use-after-free.

Combine both early-exit conditions and, when mid->multiRsp is already
set, abort the pending transaction inline: set multiEnd, call
dequeue_mid() with malformed=true, and return true so handle_mid() exits
without touching mid->resp_buf or the server buffer pointers.

Fixes: 316cf94a910f ("CIFS: Move trans2 processing to ops struct")
Cc: stable@vger.kernel.org # cifs_check_trans2() is in smb1ops.c on kernels < 7.0
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb1transport.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/fs/smb/client/smb1transport.c
+++ b/fs/smb/client/smb1transport.c
@@ -430,10 +430,18 @@ bool
 cifs_check_trans2(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 		  char *buf, int malformed)
 {
-	if (malformed)
-		return false;
-	if (check2ndT2(buf) <= 0)
+	if (malformed || check2ndT2(buf) <= 0) {
+		/* mid->multiRsp blocks the server buf detach in handle_mid();
+		 * returning false here would leak resp_buf and leave a dangling
+		 * server->smallbuf/bigbuf after the user thread frees resp_buf.
+		 */
+		if (mid->multiRsp) {
+			mid->multiEnd = true;
+			dequeue_mid(server, mid, true);
+			return true;
+		}
 		return false;
+	}
 	mid->multiRsp = true;
 	if (mid->resp_buf) {
 		/* merge response - fix up 1st*/


