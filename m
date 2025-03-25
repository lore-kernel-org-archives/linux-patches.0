Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4606E26AA8D;
	Tue, 25 Mar 2025 12:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906187; cv=none; b=hZ/VCxcdUcT+9mFLKAMiAaikMFAqNRxfiexSnca5Fhw+bJ1sI8v2nJYPBoSDL0gecR2xJK18INkNWqoYBBie/Cl5gpdvGYwWIx5bLle9XjPQqUVJCAb58H/6hFS46h0hjIejl6m2rupFcOcrbnPWvVmxufetEtzbIuM4zjF0ymo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906187; c=relaxed/simple;
	bh=mi1FKd2YDw4LOR2sKTTb6Dy32tBo0exmy/igh327Pok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k/pThiGMUiXOVymhPdUyNBwlAKVl3me8tZgbLDKxhPNm4/omlChY/Ga48IgzWmyVNa/yc6mAQ8N2AHjUg+O2GUe9lCrDA8/F0MgduRfGgnmIgwlO7x8ahT78xuEgOT4XXi+zyZg8ZpAKBYej4eWKEQPWgjZ8opMfGffIQPKj7Ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iI0TFYPZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iI0TFYPZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83EA2C4CEE4;
	Tue, 25 Mar 2025 12:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906186;
	bh=mi1FKd2YDw4LOR2sKTTb6Dy32tBo0exmy/igh327Pok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iI0TFYPZPJAXaLDspJzOQ36o0s8gJ21MRK8RQfjs3/cPK1oS3rvMwbRw8cJf1Wqmv
	 9t6silD0ix2yV/8WBPXx8zS8yswXZJgHv6pOoqDZPppM9ApBNCUP1qpIjHrv8cyx5t
	 SsTsz9HK9u2LrvVZthqpA12x6BuDVug5GMEKkNJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Leite Ladessa <igor-ladessa@hotmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 61/77] ksmbd: fix incorrect validation for num_aces field of smb_acl
Date: Tue, 25 Mar 2025 08:22:56 -0400
Message-ID: <20250325122145.945578503@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122144.259256924@linuxfoundation.org>
References: <20250325122144.259256924@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

commit 1b8b67f3c5e5169535e26efedd3e422172e2db64 upstream.

parse_dcal() validate num_aces to allocate posix_ace_state_array.

if (num_aces > ULONG_MAX / sizeof(struct smb_ace *))

It is an incorrect validation that we can create an array of size ULONG_MAX.
smb_acl has ->size field to calculate actual number of aces in request buffer
size. Use this to check invalid num_aces.

Reported-by: Igor Leite Ladessa <igor-ladessa@hotmail.com>
Tested-by: Igor Leite Ladessa <igor-ladessa@hotmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smbacl.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -398,7 +398,9 @@ static void parse_dacl(struct mnt_idmap
 	if (num_aces <= 0)
 		return;
 
-	if (num_aces > ULONG_MAX / sizeof(struct smb_ace *))
+	if (num_aces > (le16_to_cpu(pdacl->size) - sizeof(struct smb_acl)) /
+			(offsetof(struct smb_ace, sid) +
+			 offsetof(struct smb_sid, sub_auth) + sizeof(__le16)))
 		return;
 
 	ret = init_acl_state(&acl_state, num_aces);
@@ -432,6 +434,7 @@ static void parse_dacl(struct mnt_idmap
 			offsetof(struct smb_sid, sub_auth);
 
 		if (end_of_acl - acl_base < acl_size ||
+		    ppace[i]->sid.num_subauth == 0 ||
 		    ppace[i]->sid.num_subauth > SID_MAX_SUB_AUTHORITIES ||
 		    (end_of_acl - acl_base <
 		     acl_size + sizeof(__le32) * ppace[i]->sid.num_subauth) ||


