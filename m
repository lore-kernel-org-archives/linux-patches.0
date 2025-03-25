Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68F725DAEB;
	Tue, 25 Mar 2025 12:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906442; cv=none; b=uYvMJ32LGEVtQ/yTevFKzXQkKkwd3dzYFjrGaDSMCIffPmeEl8Sz5U8xfp50WXhhBTtzrDRPlUTFJNg9JVT6zzdnLVUA7XDHfrOjOHadRRIXJGFxqCPP7MVna8IJA0TRgjuOOBKKuwQdJy+c9a+EXV2wSdLdtcnAbx3eAm1ZoA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906442; c=relaxed/simple;
	bh=ZZuZ/ADCCk++4AfPvYHL67g3ti1/7Ik1nFReG2CeRkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UHOqpMJSXhnCUqMBqEz7Nb+10a03vyEvqM494Sj3Zj9sOronN3cd/1RuiMr5jrXDwSxgecICUBUuhQAo5bu46WImmutMzHGSLWEYMCyzD2i2RcDa7BwX8uHSAmPgTmoWxpQ6Ao5L3w11HvKtnmBJlHVA6ItVDU+2R1Uw3H3JsUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OPQUIxgA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OPQUIxgA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC6FC4CEE4;
	Tue, 25 Mar 2025 12:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906442;
	bh=ZZuZ/ADCCk++4AfPvYHL67g3ti1/7Ik1nFReG2CeRkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OPQUIxgAkMl/qVO603dq+CDV7b4qZsDvi62r/331PaLS5Ay2lASty4Y5jTV85U16C
	 jhwPthb+OkedLb/5UTNZVP7O6wEniKu6MQmro8vCGONEwfF2LXbDnoaLMKhM6qOGrA
	 iZba+Fhaf0P2sJGDUgNyfW1nHT1OqXfpQoxrQFgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Leite Ladessa <igor-ladessa@hotmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 102/116] ksmbd: fix incorrect validation for num_aces field of smb_acl
Date: Tue, 25 Mar 2025 08:23:09 -0400
Message-ID: <20250325122151.812091059@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


