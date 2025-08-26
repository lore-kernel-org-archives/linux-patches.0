Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5E8238C07;
	Tue, 26 Aug 2025 13:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213427; cv=none; b=bfbzeY0XFaka/SVi/ZcNy7lgsvBethfwCoztnSRJwRBm2C+9MSZJGpqySVzX6/zTgKpnP2Wsuhh7dXyb7WcgpFTOiLQTX/6xwXjiiIEFrbZ35XIe7hV92vZiM34n0r0kRMubrviKSe5uAea9rsnbpKx+1gEE1hZxe+oSti7aGiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213427; c=relaxed/simple;
	bh=EP9hBYyJHAnv6BCDI7J2dAJ+cx5sBGjEIKhCffrogjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c3vlzQRVRPhF21althHyE96+eHHWQ5awc+xlnErm3IVua+s9ZgGbzhMT7cOdarohftA1ZdkUCNQEZKdFQAteHllnxWfqZW1Dtfp4vUSJmqPk4iq/qr0ezSgJgtiJzQX8v3ahf3nM1YkFihW/rns0Xgi7bQPZW4gA4+Tv3TgqjKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gwqlBjq5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gwqlBjq5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50212C4CEF1;
	Tue, 26 Aug 2025 13:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213427;
	bh=EP9hBYyJHAnv6BCDI7J2dAJ+cx5sBGjEIKhCffrogjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gwqlBjq5ovfeXsTBgh+Ot1EmPsaD5lvhRrCjhhfqL/UzOAOMANx7JfR+0/UL69KPs
	 FHHB06HxR3Y3aN4MppdRY6dHxXEyWVtSqmXRL7XU7U/b1dLF24U1lJWwHpG44ErRCX
	 Sx3YnH7DcYCT49codFJ44mcXwThgc1m6/AlPXn9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyan Xu <ziyan@securitygossip.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 345/587] ksmbd: fix refcount leak causing resource not released
Date: Tue, 26 Aug 2025 13:08:14 +0200
Message-ID: <20250826111001.690652929@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ziyan Xu <ziyan@securitygossip.com>

commit 89bb430f621124af39bb31763c4a8b504c9651e2 upstream.

When ksmbd_conn_releasing(opinfo->conn) returns true,the refcount was not
decremented properly, causing a refcount leak that prevents the count from
reaching zero and the memory from being released.

Cc: stable@vger.kernel.org
Signed-off-by: Ziyan Xu <ziyan@securitygossip.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/oplock.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1102,8 +1102,10 @@ void smb_send_parent_lease_break_noti(st
 			if (!atomic_inc_not_zero(&opinfo->refcount))
 				continue;
 
-			if (ksmbd_conn_releasing(opinfo->conn))
+			if (ksmbd_conn_releasing(opinfo->conn)) {
+				opinfo_put(opinfo);
 				continue;
+			}
 
 			oplock_break(opinfo, SMB2_OPLOCK_LEVEL_NONE, NULL);
 			opinfo_put(opinfo);
@@ -1139,8 +1141,11 @@ void smb_lazy_parent_lease_break_close(s
 			if (!atomic_inc_not_zero(&opinfo->refcount))
 				continue;
 
-			if (ksmbd_conn_releasing(opinfo->conn))
+			if (ksmbd_conn_releasing(opinfo->conn)) {
+				opinfo_put(opinfo);
 				continue;
+			}
+
 			oplock_break(opinfo, SMB2_OPLOCK_LEVEL_NONE, NULL);
 			opinfo_put(opinfo);
 		}
@@ -1343,8 +1348,10 @@ void smb_break_all_levII_oplock(struct k
 		if (!atomic_inc_not_zero(&brk_op->refcount))
 			continue;
 
-		if (ksmbd_conn_releasing(brk_op->conn))
+		if (ksmbd_conn_releasing(brk_op->conn)) {
+			opinfo_put(brk_op);
 			continue;
+		}
 
 		if (brk_op->is_lease && (brk_op->o_lease->state &
 		    (~(SMB2_LEASE_READ_CACHING_LE |


