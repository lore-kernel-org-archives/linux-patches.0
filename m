Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4626328B7B;
	Thu, 28 May 2026 20:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001168; cv=none; b=it66qjZPRkin50dFGW0ZqlfY2U6plHC0wzj5hXG9PMSgljv0z90Tfmf8O5suoRKFyQ3UaVcYfavbihT+21DMP1CE1ZKrklZxitsGuosMNkf9IcKThVa9LXBmfWLAs0ScfKuRrgNi7joH+X8+DE2fyxjzCP+w9+5jdVLTlDCSyEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001168; c=relaxed/simple;
	bh=UACN2cfkX9FVcr4WJUqq9mgUIyfCDgK5SDII1YizK/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PkikPIMHOUbBT/UR7i4+5NHYcCoEFxvyRbhXSaMQiXU3In49Q43b87qm+5cJI3tBMGexLUMhkG4Xr4L3ZpuUDuLdbdWAv32WEycuw6LyruTKKcVdQOy/yjx52zhdv9OcgJCCoB6H9iNZPokb51EjO5KsYHyueXuBloLEDA0Gs+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YT6KBO2M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YT6KBO2M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD561F00A3A;
	Thu, 28 May 2026 20:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001167;
	bh=dFjd3+yoAu57c530fhg6swz1Pci6POk59sQT71HWyko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YT6KBO2MQ+JA51MY58r7u9udbz2xJMlq4hAOttR8bN6vDaqiM5TtL1f+CqDxUpCMN
	 kNV06V/zJrlQC1qY7rXEdryuPjzZR1TkrH06KtffWS0x+K5ZPdV2w1gYCQvJ8ONN4R
	 2MAy8X96tiCFiEjiy8V6djGirFqBIFZXBzSuL2Oc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Laratro <research@aradex.io>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 024/186] ksmbd: fix null pointer dereference in compare_guid_key()
Date: Thu, 28 May 2026 21:48:24 +0200
Message-ID: <20260528194929.614056211@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeremy Laratro <research@aradex.io>

commit 4b83cbc4c15f09b000cc06f033f64b0824b6dc87 upstream.

session_fd_check() walks the per-inode m_op_list during durable-handle
session teardown and sets op->conn = NULL for every opinfo whose conn
matched the closing session's connection. The matching opinfo, however,
stays linked in its per-ClientGuid lease_table_list entry's lb->lease_list
because destroy_lease_table() only runs on full TCP-connection teardown,
not on SESSION_LOGOFF.

If the same TCP connection then negotiates a fresh session with the
same ClientGuid (ClientGuid is bound to NEGOTIATE, not the session, and
is unchanged across LOGOFF + SETUP) and issues a SMB2 CREATE with a
lease context on a different inode, find_same_lease_key() walks
lb->lease_list, reaches the stale opinfo, and calls compare_guid_key(),
which unconditionally dereferences opinfo->conn->ClientGUID. The conn
pointer is NULL and the kernel panics.

Reproducer requires only a successful SMB2 SESSION_SETUP and a share
configured with 'durable handles = yes'. KASAN report on mainline
70390501d194:

  general protection fault, probably for non-canonical address
  0xdffffc0000000069: 0000 [#1] SMP KASAN PTI
  KASAN: null-ptr-deref in range [0x0000000000000348-0x000000000000034f]
  Workqueue: ksmbd-io handle_ksmbd_work
  RIP: 0010:bcmp+0x5b/0x230
  Call Trace:
   compare_guid_key+0x4b/0xd0
   find_same_lease_key+0x324/0x690
   smb2_open+0x6aea/0x8e60
   handle_ksmbd_work+0x796/0xee0
   ...

Faulting address 0x348 is the offset of ClientGUID within struct
ksmbd_conn, confirming opinfo->conn was NULL.

Read opinfo->conn once and bail out if it has been cleared by a
concurrent session_fd_check(). A half-detached opinfo cannot be the
owner of an active lease, so returning 0 is the correct match result.

Fixes: c8efcc786146 ("ksmbd: add support for durable handles v1/v2")
Cc: stable@vger.kernel.org
Signed-off-by: Jeremy Laratro <research@aradex.io>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/oplock.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -484,8 +484,12 @@ static inline int compare_guid_key(struc
 				   const char *guid1, const char *key1)
 {
 	const char *guid2, *key2;
+	struct ksmbd_conn *conn;
 
-	guid2 = opinfo->conn->ClientGUID;
+	conn = READ_ONCE(opinfo->conn);
+	if (!conn)
+		return 0;
+	guid2 = conn->ClientGUID;
 	key2 = opinfo->o_lease->lease_key;
 	if (!memcmp(guid1, guid2, SMB2_CLIENT_GUID_SIZE) &&
 	    !memcmp(key1, key2, SMB2_LEASE_KEY_SIZE))


