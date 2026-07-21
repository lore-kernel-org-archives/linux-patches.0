Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8413224B05;
	Tue, 21 Jul 2026 22:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674620; cv=none; b=EJE0KZjMyql+8elBAB2eZHwIkNobfoiQ23TM70ko7A7JHrtlfjyIxqihAZev69sHTKu4WKEroCDrj8K8Pmc9AqdVAUtVrLBfVxDptq4u5en9eV0fVCpJyultq+gR9TILWduBztyXHq1EMmWbWZ41G77PwsAhEN8OgSMCOEBmpm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674620; c=relaxed/simple;
	bh=P8/6JiLN/G798TKj6ynHHCar44i2CInoGpSg/m/OE1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZtYjhE6ImNKAaH3sU9a9Yg5hTDjqZ2unNNNrhxlaN2BetjRvnZcl93Rdtulg1zPSwTsKrjGtoN9zGNFDucmQQxn9F4LnABjP7r65kUju1n7kowy/5sQqpDPsTTCRHeLU2Lm/6RDxiNJvOoc824oeKAZpwTb1scfUnJ61X1ImBh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p7GUWhnp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p7GUWhnp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B0B1F00A3A;
	Tue, 21 Jul 2026 22:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674618;
	bh=cwBT/p0BdYzeDVlOut60HEXFVVUQG+o3OOBQPpBd58w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p7GUWhnp0+mEEF78cLTQjTBXIkKwGr6v5zV5R8I9/XA4hebtfFxZ1tV/oR7kNdaMZ
	 5rDZOZanWGPwHpVU1wnlcTRa/bTN3E87I583Ms0jdnhXVnlBrUE+7V8Lyfu7iBdmgm
	 FrKMRdPMuf5IKmfc5d9IMpWmwWkceAXACB5DfNzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Jakob Koschel <jakobkoschel@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 609/699] cifs: remove check of list iterator against head past the loop body
Date: Tue, 21 Jul 2026 17:26:08 +0200
Message-ID: <20260721152409.477309703@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 fs/cifs/smb2misc.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -154,19 +154,18 @@ smb2_check_message(char *buf, unsigned i
 		struct smb2_transform_hdr *thdr =
 			(struct smb2_transform_hdr *)buf;
 		struct cifs_ses *ses = NULL;
-		struct list_head *tmp;
+		struct cifs_ses *iter;
 
 		/* decrypt frame now that it is completely read in */
 		spin_lock(&cifs_tcp_ses_lock);
-		list_for_each(tmp, &srvr->smb_ses_list) {
-			ses = list_entry(tmp, struct cifs_ses, smb_ses_list);
-			if (ses->Suid == le64_to_cpu(thdr->SessionId))
+		list_for_each_entry(iter, &srvr->smb_ses_list, smb_ses_list) {
+			if (iter->Suid == le64_to_cpu(thdr->SessionId)) {
+				ses = iter;
 				break;
-
-			ses = NULL;
+			}
 		}
 		spin_unlock(&cifs_tcp_ses_lock);
-		if (ses == NULL) {
+		if (!ses) {
 			cifs_dbg(VFS, "no decryption - session id not found\n");
 			return 1;
 		}


