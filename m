Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A642432144B;
	Tue, 26 Aug 2025 11:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207057; cv=none; b=TCQY/Lo+6hinyJOehMo5pF+fXAMiapUf2tSIh8pBOsYPY999JyYJ8P11baggj2bTGNt6hikRUaALLnSZUt22qv1R+GBBjcYldGAyTzMwJKqro4T1wYSvmIwWFUrnWpkZ3igVQnCoAXceRPHKA9wciST+1BwZJ/Fn8l5W5werY1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207057; c=relaxed/simple;
	bh=a/Dcr/ECzc27RN4V/Ncif98amfeDLxXwjyuzV68mpoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mtqG/E3rjgq0sh+hcMyzWCTQEAu2c1oPLh/FUf2EX4INlUhNH8VihnI72Mrt7nbGsBadutFVDQYI1ck7dJmW0HyB+2krkKb1Du1SL+Rhj45Gtr1xRD9R5KWLpsC2jqdlnN0RPaS5+M0FuXoPvGp05wgW7qsbRomyN5PJgARDX1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m6+G5vNB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m6+G5vNB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40B40C113CF;
	Tue, 26 Aug 2025 11:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207057;
	bh=a/Dcr/ECzc27RN4V/Ncif98amfeDLxXwjyuzV68mpoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m6+G5vNBmrMba6RyqUQkQYGtlFca1xiSvtFuEX92hZFvvRJr2Tg0Atg4qOsbYYJFq
	 mi2f4D3wHxEkq+XVPUe2VT9tJXg59NqJSbM6JpnNL6mreIdOxCWIW2ozpOS8KTFOPG
	 5uq5CmJcKXNQc19nNSQhDdQGINE7CSLq7reFG/60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyan Xu <ziyan@securitygossip.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.16 034/457] ksmbd: fix refcount leak causing resource not released
Date: Tue, 26 Aug 2025 13:05:18 +0200
Message-ID: <20250826110938.184287364@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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


