Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE82A94A;
	Tue,  8 Apr 2025 11:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112867; cv=none; b=NyafuyPBjVE9EZ6iSYQOaW19aHilc3SFqw4Rl4ZmWJhk5vVaCFisRMOE3eAP+jlz1yDkUe6M3/1kbjWqjJFouGgmEHNLQwGbESnRVbN3YQmbpwZeZUeLM4RUVr28mPfFn+4o8HdlsWKQBqFD1rwiWVnKPJjfbHfcnVqpdkWSoEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112867; c=relaxed/simple;
	bh=DOnR4V3H9FHVgxUpWzzJjgf0weGrzgPyjtZWjn8ccLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cqKRlfg0nZA5I3IxnkJNKGB8yL/lkL98ixRTLhDma1LkKOH4/1WWy7Ty+N8oh/8m4mUcAXBO+YAALdHO0HK/PBHD4SZlyOH0kCX1Lx7euQ158cvYeV6HzWMTG5I7OkXL9zuvfrsQhOJiYkZgyLn66NpEsOpVzQdXzFpxV+KI4bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A5btAlxz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A5btAlxz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F37AC4CEE5;
	Tue,  8 Apr 2025 11:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112867;
	bh=DOnR4V3H9FHVgxUpWzzJjgf0weGrzgPyjtZWjn8ccLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A5btAlxzrTypLTb27m9obmkQtM8ogCRF01/vavBKleJp3iNf8wpC4JQK8uB1ox6dq
	 mKUjDIb3GdnFYTOIjwvhCvCpxSN227TLQrnU94+6H+xy2S3yMZSgB4sSKzPHlQynIu
	 1bF5O+nldhARoKTD8sEhJAZiCfAp207jDSQyAlw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Leite Ladessa <igor-ladessa@hotmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 227/279] ksmbd: fix incorrect validation for num_aces field of smb_acl
Date: Tue,  8 Apr 2025 12:50:10 +0200
Message-ID: <20250408104832.500052534@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 1b8b67f3c5e5169535e26efedd3e422172e2db64 ]

parse_dcal() validate num_aces to allocate posix_ace_state_array.

if (num_aces > ULONG_MAX / sizeof(struct smb_ace *))

It is an incorrect validation that we can create an array of size ULONG_MAX.
smb_acl has ->size field to calculate actual number of aces in request buffer
size. Use this to check invalid num_aces.

Reported-by: Igor Leite Ladessa <igor-ladessa@hotmail.com>
Tested-by: Igor Leite Ladessa <igor-ladessa@hotmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smbacl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ksmbd/smbacl.c b/fs/ksmbd/smbacl.c
index 3a6c0abdb0352..ecf9db3d69c38 100644
--- a/fs/ksmbd/smbacl.c
+++ b/fs/ksmbd/smbacl.c
@@ -396,7 +396,9 @@ static void parse_dacl(struct user_namespace *user_ns,
 	if (num_aces <= 0)
 		return;
 
-	if (num_aces > ULONG_MAX / sizeof(struct smb_ace *))
+	if (num_aces > (le16_to_cpu(pdacl->size) - sizeof(struct smb_acl)) /
+			(offsetof(struct smb_ace, sid) +
+			 offsetof(struct smb_sid, sub_auth) + sizeof(__le16)))
 		return;
 
 	ret = init_acl_state(&acl_state, num_aces);
@@ -430,6 +432,7 @@ static void parse_dacl(struct user_namespace *user_ns,
 			offsetof(struct smb_sid, sub_auth);
 
 		if (end_of_acl - acl_base < acl_size ||
+		    ppace[i]->sid.num_subauth == 0 ||
 		    ppace[i]->sid.num_subauth > SID_MAX_SUB_AUTHORITIES ||
 		    (end_of_acl - acl_base <
 		     acl_size + sizeof(__le32) * ppace[i]->sid.num_subauth) ||
-- 
2.39.5



