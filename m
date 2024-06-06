Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABAAB1991B4;
	Thu,  6 Jun 2024 14:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683149; cv=none; b=OmnufMOcrvKsrpLfqAquW3ubY1cHbW5vcx5ZwszcpSGL00ectOWIxm9i9uO4hDV8P83wgj5GgvJnTi6UPOGDBfMoYolMbIsV4TKazwSvwDWdXJn38CWRgrmvQVzH9uruBUDYEqQpVdtD4P4eJmdYAtuqrTzus4UwkV9sQi7CiAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683149; c=relaxed/simple;
	bh=hXD5Mkbbrj5kTvAmHZ8adhkmk/+onaoDAED1WlTUZUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bhJ+ddl0Jpojh4gBrj48xG5Dd6zH6NHA2hGe8VyrH0ch6CQupS+2Vd8+OFcCf6yZzLTd1ASsfTRE+uOmF0Um4faYX++EfU+4xm9dqXHvubDpjguS+60C1s0WGeN4XWtJTWgfW9AM2YjyaMDxPevnJTjdPe8fvJchq010lhgTh2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fswa8IwJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fswa8IwJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83CC6C2BD10;
	Thu,  6 Jun 2024 14:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683149;
	bh=hXD5Mkbbrj5kTvAmHZ8adhkmk/+onaoDAED1WlTUZUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fswa8IwJDwjkYPW4dWuelmKHRVjPhjNR8OJsUWO7Z1Olp36vxTdOM0+f3Xjn3WB4w
	 8NwEUmSJbvldBoou/Y5IY6lmdycf+2eYmjEks11ITGmFptzkRfWauxTbMzjQ24QXmQ
	 xR4WThIssa7EFqcTgvyqicT5QX0Cvk+tJJJLoL0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 021/473] ksmbd: avoid to send duplicate oplock break notifications
Date: Thu,  6 Jun 2024 15:59:10 +0200
Message-ID: <20240606131700.561821469@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit c91ecba9e421e4f2c9219cf5042fa63a12025310 upstream.

This patch fixes generic/011 when oplocks is enable.

Avoid to send duplicate oplock break notifications like smb2 leases
case.

Fixes: 97c2ec64667b ("ksmbd: avoid to send duplicate lease break notifications")
Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/oplock.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -613,19 +613,24 @@ static int oplock_break_pending(struct o
 		if (opinfo->op_state == OPLOCK_CLOSING)
 			return -ENOENT;
 		else if (opinfo->level <= req_op_level) {
-			if (opinfo->is_lease &&
-			    opinfo->o_lease->state !=
-			     (SMB2_LEASE_HANDLE_CACHING_LE |
-			      SMB2_LEASE_READ_CACHING_LE))
+			if (opinfo->is_lease == false)
+				return 1;
+
+			if (opinfo->o_lease->state !=
+			    (SMB2_LEASE_HANDLE_CACHING_LE |
+			     SMB2_LEASE_READ_CACHING_LE))
 				return 1;
 		}
 	}
 
 	if (opinfo->level <= req_op_level) {
-		if (opinfo->is_lease &&
-		    opinfo->o_lease->state !=
-		     (SMB2_LEASE_HANDLE_CACHING_LE |
-		      SMB2_LEASE_READ_CACHING_LE)) {
+		if (opinfo->is_lease == false) {
+			wake_up_oplock_break(opinfo);
+			return 1;
+		}
+		if (opinfo->o_lease->state !=
+		    (SMB2_LEASE_HANDLE_CACHING_LE |
+		     SMB2_LEASE_READ_CACHING_LE)) {
 			wake_up_oplock_break(opinfo);
 			return 1;
 		}


