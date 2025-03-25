Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D489DA2D;
	Tue, 25 Mar 2025 12:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905829; cv=none; b=Jf9lpp7CRTrrp5zCrPvTDEQquf+PoccWpvXTJzfLVn1VTkOvTjMA/M0qiCd/sDg3HWlRAj06jtg6YT71EYbfOiB41K5E4zaby/KX7yLAZGZwyvckvZtNhBk9wMlQodIPcFwAtCtrSjQwP8JNmR1/G5OLGCnI9xb95SRCSAJJ6dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905829; c=relaxed/simple;
	bh=8wkQqXrNZXTQYD6VgEOSpGt4dzNPjoGbSBPUAf3DXmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N8tcm/rSKEH+s9A2RJ3hX4CFchDobdqAt61HIqfJwLghr3G2G5Yh2NSziyjNxCkfD/dNavzkawirXqQveMsGKZpoE6wsHUhiuKnaiSRVhzT6UPDXeqo/bArqOt/R2Hrqqpdy67SJkLNLimlX1F05yukf+WvTZncMv9rErntJHxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ol03aV3v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ol03aV3v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FDF1C4CEED;
	Tue, 25 Mar 2025 12:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905829;
	bh=8wkQqXrNZXTQYD6VgEOSpGt4dzNPjoGbSBPUAf3DXmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ol03aV3vTp2+pjMjKmruPSeG8QQ9yw31KZTHXOiUIEl02ePcLR/vpcQpjAt7ki0Rh
	 fkOToOqMiHKdtVmv6lG6UyvnG/lCVGs+9M+i4PK5mJJH1PPra7jLsgaayxuOKhXpKo
	 rhOmHt4FWL0lLaVrsTbk4lPQa7115YRCj8rSE8F8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Leite Ladessa <igor-ladessa@hotmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 187/198] ksmbd: fix incorrect validation for num_aces field of smb_acl
Date: Tue, 25 Mar 2025 08:22:29 -0400
Message-ID: <20250325122201.554770738@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -398,7 +398,9 @@ static void parse_dacl(struct user_names
 	if (num_aces <= 0)
 		return;
 
-	if (num_aces > ULONG_MAX / sizeof(struct smb_ace *))
+	if (num_aces > (le16_to_cpu(pdacl->size) - sizeof(struct smb_acl)) /
+			(offsetof(struct smb_ace, sid) +
+			 offsetof(struct smb_sid, sub_auth) + sizeof(__le16)))
 		return;
 
 	ret = init_acl_state(&acl_state, num_aces);
@@ -432,6 +434,7 @@ static void parse_dacl(struct user_names
 			offsetof(struct smb_sid, sub_auth);
 
 		if (end_of_acl - acl_base < acl_size ||
+		    ppace[i]->sid.num_subauth == 0 ||
 		    ppace[i]->sid.num_subauth > SID_MAX_SUB_AUTHORITIES ||
 		    (end_of_acl - acl_base <
 		     acl_size + sizeof(__le32) * ppace[i]->sid.num_subauth) ||


