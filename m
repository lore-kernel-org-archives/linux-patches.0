Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5DB2375A;
	Thu, 18 Jan 2024 11:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575741; cv=none; b=dzCeCnlO3YAQqyHIW/kOOGLG+MAVCTHX58/FyOh8Q7zjDTgh7w3P90eFAv1xT/URY9yS3q9vvezBWnNFC9zaUgN4/5aTqWdEaPYzw9S2v+XZQ7KRHpZbJX6cp32MYeBlNyjApJJvgnke79GH0F7a/wgNicd5kDw38O6MPVp+EHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575741; c=relaxed/simple;
	bh=j+VhdYOCYoLn0nhJFA84oc3CohOwMaWQTHUqveGr210=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=jhVTpp/GYJUwFWepimcx9jBxHNPB9yAKAt3mpZvIk80IwECNP1wJE5WKEnB02Fow7MKDUOqbaiQHPBFqgojo5N8iz23D/nzXtes5Qm8qM3T7aBp/WhcP44gTptnzTGkfrCMPY4q6sgEx8OTM80pu8DasDBcWJJIlb45kX1+rWuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nyyPwTDq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nyyPwTDq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C886DC433C7;
	Thu, 18 Jan 2024 11:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575741;
	bh=j+VhdYOCYoLn0nhJFA84oc3CohOwMaWQTHUqveGr210=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nyyPwTDq5PTNXJGxFKBJ/lc/n8HoIXfMvoHArDDz3xEilgKzW/wP+gxIZiCOxBYP0
	 JmRxG0hA/8X/AzkwesrRlZ2d1xfwhsZyFdPMOwFoRj/5EjMpxQSTlF3nxmNYBKzud5
	 HfOxBGgMFIOzWFlX67dsAazxBAZBwNw4Wsm6NasY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 088/100] ksmbd: free ppace array on error in parse_dacl
Date: Thu, 18 Jan 2024 11:49:36 +0100
Message-ID: <20240118104314.721842253@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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
@@ -401,10 +401,6 @@ static void parse_dacl(struct user_names
 	if (num_aces > ULONG_MAX / sizeof(struct smb_ace *))
 		return;
 
-	ppace = kmalloc_array(num_aces, sizeof(struct smb_ace *), GFP_KERNEL);
-	if (!ppace)
-		return;
-
 	ret = init_acl_state(&acl_state, num_aces);
 	if (ret)
 		return;
@@ -413,6 +409,13 @@ static void parse_dacl(struct user_names
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


