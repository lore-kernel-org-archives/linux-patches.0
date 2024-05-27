Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE14A168C4;
	Mon, 27 May 2024 19:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837495; cv=none; b=jFZ8SvKxy1AuH0BYvU7l2Cp076/68wUAmTiBbpi0kL86K+6TI4LR+6uvcOn2ZeTDmkc9roKuytQmZLJJ1X33TSgtFdIpWX7uh3lFSSJaTYzmLyZpiBeDliw/qFERGv53MiqG/CJhNk6kHNxXxtGVEvDs989IvTLc7y6RTVjwv9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837495; c=relaxed/simple;
	bh=1o4HSpaflHZCBZI1HVP2ybS+npokdLg4FEJv425+gKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jW/FuC95EzSNzWBCJ4JyKUwNsq7UfAVToO9GqZRRUdRoXFzFrqfs/IIdW0T8rUkw7LEQNggjf8NtBbGy2RD1l0lVWFGvX6KD2aq8ONeS0o8LzPB/GJ6HmN/zzQr854VCMnsI8ufwMTTKmgM0kPfFBd0q+OLxW6XrjQFDFnSfNFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fKP4s9Gz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fKP4s9Gz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 609F2C2BBFC;
	Mon, 27 May 2024 19:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837495;
	bh=1o4HSpaflHZCBZI1HVP2ybS+npokdLg4FEJv425+gKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fKP4s9GzFj9qQwaAFY9C1KmCaoxyC7g9bVs/LqO/fSLPCv1LRThI9gLJzuvwFkSBb
	 xlH//wY4l3pGeA9mh+j1NHxJZ5w76na5q5xJZnizIAPjaCvxbhflQznWJoaIyFO41h
	 OcwVcjWqLF9KCsDaLTZOXWv++mYeH5atMcgyGurI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.8 032/493] ksmbd: avoid to send duplicate oplock break notifications
Date: Mon, 27 May 2024 20:50:34 +0200
Message-ID: <20240527185629.492032955@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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


