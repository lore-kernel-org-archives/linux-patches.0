Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDE958E2CE;
	Wed,  9 Sep 2026 14:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964798; cv=none; b=FIOsJBPZ0MNOEjJCXkTnhN6Blqx4FitWEfjWSymbSPy7maVuJBkgMjYtxFcoZZkMr6GYcMG5gaea7SRYXX34gFNDOX6QcgP2F3Yoh7zNqMoLuMh4X09SuAWR6MzshLRKeP5bXuAGdF3TrV+Kwg5NO1wC7iN9LO0hi4xM/1+J4/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964798; c=relaxed/simple;
	bh=wnCK6ZBejtEuvAoraAJYZHMHEJpnf5eY1Gg4RUCsLW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cEzgSp2MHZvLHtum+TrOUOIwUyiLHfwhd2HqUh04L+U9PCB2ZWGe6XHTLHdp46vFXbpJVEPuzaFq+4A5QoLiawuMo4VlrMwAOuyci4rTtet5ZzbBG+59GMq8TFl2jh/Le+o4cCP7ZsZkNdZWo0u9Hqw+AFZxsvX3d7I5z/t+0Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gq7AV4mr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gq7AV4mr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22AEA1F00A3A;
	Wed,  9 Sep 2026 14:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964797;
	bh=OBlzEaMpfKuUXHwXX97+Bein7SSZEZdgpdn9Ohm8wdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gq7AV4mrWxGc+flSAxYAMZmN8C5IP0mCoB5bihWFXtOrz+TGBVQGX1tHp1JQtCXHY
	 baOXhoBgNfms8mE0Yq9ARu0o1aJD45sFDHQP3yzA79KRP74nKLy8d6TZgjp6qEjnqz
	 5ddpcua1pVrQMJnwAuF9nuLs557zk2tzwvbhDkBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 546/583] smb: client: fix UAF and buffer leak in cifs_check_trans2() for malformed secondary T2
Date: Wed,  9 Sep 2026 15:43:51 +0200
Message-ID: <20260909134256.653337511@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Frank Sorenson <sorenson@redhat.com>

[ Upstream commit 730d0bb19507b9e19c2fe5343109ac618e2fbce5 ]

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
[ changed dequeue_mid(server, mid, true) to the older dequeue_mid(mid, true) API ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb1transport.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/fs/smb/client/smb1transport.c
+++ b/fs/smb/client/smb1transport.c
@@ -708,10 +708,18 @@ bool
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
+			dequeue_mid(mid, true);
+			return true;
+		}
 		return false;
+	}
 	mid->multiRsp = true;
 	if (mid->resp_buf) {
 		/* merge response - fix up 1st*/


