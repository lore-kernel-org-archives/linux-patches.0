Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04DA23773;
	Thu, 18 Jan 2024 10:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575048; cv=none; b=b5Kv+bTIOYEKZihxswwMN3vsjGA+LWSWhilfcsPwAbZaRT7WLshk3nG/tm1pbY6zihwvLbwTCQV3GCCGl5xUCGL833yoAB7piZamZlJ3KDoLu9r0Z1/IfHKHdOhL9ZHdEphhG/sqmURladyXtKaDMcRTdvOvMh8N3smu5joeXKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575048; c=relaxed/simple;
	bh=socXSL5kwuZNzamP8PEY39QdEIQfEEdYHL5YYpL/FGk=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=Ql3oEOZmUe9fQmWKUCC/m6PDvwFX9pj4Lpaz+1Uvm0kxxj3153luwf3S3W+TKrY5gTpPMEa45vBctSloxy0Bz97kDeGddIH+Zd08i38rhOplmqLqfZAp+ip3QlFyJKjiDVx2x+3wXkT92jRsnrkF2yZto/BZOdHEOkAP7rU3FCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TdOPLAT/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TdOPLAT/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2631DC433C7;
	Thu, 18 Jan 2024 10:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575048;
	bh=socXSL5kwuZNzamP8PEY39QdEIQfEEdYHL5YYpL/FGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TdOPLAT//mUpvHGaSitZDT6Rm1TilYeCsG2SnnqqbcI4fFsBday+Eddny3D0UGTWa
	 gi+KlDf6XbuJ5CPJFwphuWaKP2JASqg8fkWXppq3VQKdJ3imhRoCjjIT/YblQ6GO9p
	 dbaRC5WxqU5UWuZamlRLvEluwt1ZI/V/Ap1c23UY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.7 14/28] ksmbd: free ppace array on error in parse_dacl
Date: Thu, 18 Jan 2024 11:49:04 +0100
Message-ID: <20240118104301.724392561@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104301.249503558@linuxfoundation.org>
References: <20240118104301.249503558@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

commit 8cf9bedfc3c47d24bb0de386f808f925dc52863e upstream.

The ppace array is not freed if one of the init_acl_state() calls inside
parse_dacl() fails. At the moment the function may fail only due to the
memory allocation errors so it's highly unlikely in this case but
nevertheless a fix is needed.

Move ppace allocation after the init_acl_state() calls with proper error
handling.

Found by Linux Verification Center (linuxtesting.org).

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smbacl.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -401,10 +401,6 @@ static void parse_dacl(struct mnt_idmap
 	if (num_aces > ULONG_MAX / sizeof(struct smb_ace *))
 		return;
 
-	ppace = kmalloc_array(num_aces, sizeof(struct smb_ace *), GFP_KERNEL);
-	if (!ppace)
-		return;
-
 	ret = init_acl_state(&acl_state, num_aces);
 	if (ret)
 		return;
@@ -413,6 +409,13 @@ static void parse_dacl(struct mnt_idmap
 		free_acl_state(&acl_state);
 		return;
 	}
+
+	ppace = kmalloc_array(num_aces, sizeof(struct smb_ace *), GFP_KERNEL);
+	if (!ppace) {
+		free_acl_state(&default_acl_state);
+		free_acl_state(&acl_state);
+		return;
+	}
 
 	/*
 	 * reset rwx permissions for user/group/other.


