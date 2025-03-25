Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24F72571AB;
	Tue, 25 Mar 2025 12:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906051; cv=none; b=h/6Qgs744feHKn0sc/8I0QGPl44D5Ez08MgWbzIJp9tQAHGQkVCxLQkiRxmxO8w046cfJNPWWnKK7BQ6qsaIKd5xkxsWidJ0I56wrLRwg5SG17ATHAzQCDzDmV2Tso0NScW8//Vbv3hN02fMYMMaRUlhB3nWYjudBU6URqmUsNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906051; c=relaxed/simple;
	bh=rjg/uKQ4r4qvQCzKa8WkJGSx1WX3/xJDjlrXNO5Sc4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CGEx78j4HHq4IEHPt2XFlgPVgoGnK2sBe4JxVpxcyh2kGIaPUZhecg0kpGt7LPkHvG3+sBJk4Nqs/wAwO+N6l63PdcOu71KXNTANKNQEF+FIs9mPzfp1L/C7XOO7JYyr4FP4kir/QcIj1Z8Yn2qUvnEHrU2vmoBLIlWeqdklruw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IrXGXmsB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IrXGXmsB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F019C4CEE4;
	Tue, 25 Mar 2025 12:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906051;
	bh=rjg/uKQ4r4qvQCzKa8WkJGSx1WX3/xJDjlrXNO5Sc4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IrXGXmsBtEzg5wmBUMLnlhXZcCm0LnGS2Nws+gVrrz0uoXeT4HrgSBxY/BIObn56R
	 hD6dJ+AGr8rYhuGmnbLmesULrTJPrGrbyGvybP9eKIwZB+jA/TwiZKShxmYB2qfFxD
	 4pId3ti0Me02m1EDPIIz3cu4+bXO7Y1yiDbf7zjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Leite Ladessa <igor-ladessa@hotmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.13 108/119] ksmbd: fix incorrect validation for num_aces field of smb_acl
Date: Tue, 25 Mar 2025 08:22:46 -0400
Message-ID: <20250325122151.812469396@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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


