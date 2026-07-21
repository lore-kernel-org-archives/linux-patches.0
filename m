Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7ED643E4B5;
	Tue, 21 Jul 2026 22:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672765; cv=none; b=h1tm2wu5UaUl84Bgp7A/UkVVMN3gfOPYuWYnVzrzsbbQGrx1VNPdVQ8BOFqEXTiC/PDFSyF1iimB6tGPPYF8Kg6Q0zwHLHdPQ6mIEI6RRCu7JoKTZWyOFw0MlTVFii9b2YsPbLCKEt0G3tkAUf/EBSTBaCHnbPCHucJ3NyX58DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672765; c=relaxed/simple;
	bh=1olc9dHwz+zau09mvhWPCAjb6E8T7gPbvXz4exqN5wE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I4OIT6G5kfhr68/B6q/0m6CZ1HCIkS9nGosfm9/kZtt+gqeWf8Kz7+LJwAQNB9ptUn4iyRKY8I706esi9k5BUW5l3qUd+UXKgiIkg+4u7gb7f0Sc+dl5/ismPaTgoUYtOTW6s+ffhD3vQ7ADmnw7k6NXuna2rc7KOhKhGbiZwK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dvrtxjhe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dvrtxjhe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 294CB1F00A3A;
	Tue, 21 Jul 2026 22:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672764;
	bh=l3RGwvqAmsf3sJOtuxdl6yJLy3TKG1au6upKZe3fPX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DvrtxjhetOzE7YqNCe4FXKZ6t8DBUauZnh6M4gwv38HLJjW8LbCmxFyYhfeNy93MI
	 4wi5PRszU7sXyyLtQR9sZRddAxY19l8IdrYN3i4b2L6Xfelm0JU4vWTerkqdQsFp+u
	 u93rhudvO4w2hQcN60pZKT19kCxNglfMSGrAAsD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Jakob Koschel <jakobkoschel@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 748/843] cifs: remove check of list iterator against head past the loop body
Date: Tue, 21 Jul 2026 17:26:23 +0200
Message-ID: <20260721152422.877417663@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

From: Jakob Koschel <jakobkoschel@gmail.com>

[ Upstream commit 00c796eecba4898194ea549679797ee28f89a92f ]

When list_for_each_entry() completes the iteration over the whole list
without breaking the loop, the iterator value will be a bogus pointer
computed based on the head element.

While it is safe to use the pointer to determine if it was computed
based on the head element, either with list_entry_is_head() or
&pos->member == head, using the iterator variable after the loop should
be avoided.

In preparation to limit the scope of a list iterator to the list
traversal loop, use a dedicated pointer to point to the found element [1].

Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/ [1]
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 53b7c271f06b ("smb: client: restrict implied bcc[0] exemption to responses without data area")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2misc.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -150,16 +150,18 @@ smb2_check_message(char *buf, unsigned i
 		struct smb2_transform_hdr *thdr =
 			(struct smb2_transform_hdr *)buf;
 		struct cifs_ses *ses = NULL;
+		struct cifs_ses *iter;
 
 		/* decrypt frame now that it is completely read in */
 		spin_lock(&cifs_tcp_ses_lock);
-		list_for_each_entry(ses, &srvr->smb_ses_list, smb_ses_list) {
-			if (ses->Suid == le64_to_cpu(thdr->SessionId))
+		list_for_each_entry(iter, &srvr->smb_ses_list, smb_ses_list) {
+			if (iter->Suid == le64_to_cpu(thdr->SessionId)) {
+				ses = iter;
 				break;
+			}
 		}
 		spin_unlock(&cifs_tcp_ses_lock);
-		if (list_entry_is_head(ses, &srvr->smb_ses_list,
-				       smb_ses_list)) {
+		if (!ses) {
 			cifs_dbg(VFS, "no decryption - session id not found\n");
 			return 1;
 		}


