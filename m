Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ADE2266580;
	Tue,  8 Apr 2025 12:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115007; cv=none; b=Riiwk0al9S9sALghPkJEzOO9CiyJ9IL4q70Wx48D4zGnekn20dELJB3fRdINeFCOhbbjvD52UYgUisT1sDK+HQZ8a1dAeV7KkwSciUVnnPX9toC+CnoDUCe8zaVy4OJJ4JTBveEA9NIgqpmVyMHg4EJHZrfnGp7MMhAzedGPrjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115007; c=relaxed/simple;
	bh=WKDBpxQTork8LS1VYeQZb0dtOTs+1BJYfFo1d4RzIxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=js63chBcczO/Os9S3LtrVoaWv9/rmj+CZKZN2zUSiRLF0jFGZwn4bUP1zKXeY3nc4Js57lK6i4sp6ExYaib3EeGuUpXjeWHt6mIN5XGR3cxEru0dXOZwpgFMXgYGu1XFveUxjnzI0wkI+4phdRbVNd89BjYiWRq/bXIyFJMyVUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iKkdmGym; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iKkdmGym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84BF0C4CEE5;
	Tue,  8 Apr 2025 12:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115007;
	bh=WKDBpxQTork8LS1VYeQZb0dtOTs+1BJYfFo1d4RzIxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iKkdmGymIuLmCAZjhlvQ5IGkaz9+yKpvzco2KnFAC1y4Ew6qAn6PEw7FXoGdWlVQD
	 tsZJSGG7/VwsFXJ2G9IG9r7dozoMePH6smK5pSK+CDHbBtb7hR3sdNBEjRTwPx1HfY
	 dPL/JD39Q0xWpF2QuQJk0H2gjBZR3GZXzTMH66QA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 315/499] cifs: fix incorrect validation for num_aces field of smb_acl
Date: Tue,  8 Apr 2025 12:48:47 +0200
Message-ID: <20250408104859.074755716@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit aa2a739a75ab6f24ef72fb3fdb9192c081eacf06 ]

parse_dcal() validate num_aces to allocate ace array.

f (num_aces > ULONG_MAX / sizeof(struct smb_ace *))

It is an incorrect validation that we can create an array of size ULONG_MAX.
smb_acl has ->size field to calculate actual number of aces in response buffer
size. Use this to check invalid num_aces.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsacl.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index 7d953208046af..64bd68f750f84 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -778,7 +778,8 @@ static void parse_dacl(struct smb_acl *pdacl, char *end_of_acl,
 	}
 
 	/* validate that we do not go past end of acl */
-	if (end_of_acl < (char *)pdacl + le16_to_cpu(pdacl->size)) {
+	if (end_of_acl < (char *)pdacl + sizeof(struct smb_acl) ||
+	    end_of_acl < (char *)pdacl + le16_to_cpu(pdacl->size)) {
 		cifs_dbg(VFS, "ACL too small to parse DACL\n");
 		return;
 	}
@@ -799,8 +800,11 @@ static void parse_dacl(struct smb_acl *pdacl, char *end_of_acl,
 	if (num_aces > 0) {
 		umode_t denied_mode = 0;
 
-		if (num_aces > ULONG_MAX / sizeof(struct smb_ace *))
+		if (num_aces > (le16_to_cpu(pdacl->size) - sizeof(struct smb_acl)) /
+				(offsetof(struct smb_ace, sid) +
+				 offsetof(struct smb_sid, sub_auth) + sizeof(__le16)))
 			return;
+
 		ppace = kmalloc_array(num_aces, sizeof(struct smb_ace *),
 				      GFP_KERNEL);
 		if (!ppace)
-- 
2.39.5



