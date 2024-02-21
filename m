Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2572A53816;
	Wed, 21 Feb 2024 13:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521815; cv=none; b=tH0nTejboR8IgK/Q9l8H73YKNjZgd6JgFHJjpM8Q29es72iq7flk6jP+WdclbHQlt4uHAZPtcykdOJL73d7qcK67Qs3bTmc8TcWQcNfjxQcMA55gcdb+d6dDKxM+w7LcV/Yp1ZqSPZFvl+k7s43BF8pL9RG2uE0mZkOb+DvvtD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521815; c=relaxed/simple;
	bh=U1uhNcFwTlh+i5HqXJyrJyNcVY5doKyxxM0OGWB0FhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=heRicwZ6tHZlzPF42L32z0GrI49XTdfDOAfgtcmQX8t+K3P9WZxlqYAIAbD4oB2bJ7GW6PgqiTqSTvNpkkLkDVGyGYRQNOs0DAwp8ooewllFe6g9FVnhTKqSMETsyagz33D3Kuhvj3rmdXNLgpv9O4VApus6hKwgiOfntRBIBT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bv7aVCBc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bv7aVCBc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8676DC433C7;
	Wed, 21 Feb 2024 13:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521815;
	bh=U1uhNcFwTlh+i5HqXJyrJyNcVY5doKyxxM0OGWB0FhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bv7aVCBc8cU44J2g+6HM0nMeBlkSU9T3DxxKyTydKFm9h0TCwu3s+VbResLvxk/+s
	 JAVnntCjhH6qk+slELEiMOZZsvyi33sp10BaZlDZT0csbrxg6zTu3LNB5WI/kf9HkT
	 rJ4I7NX6i8MsAqLhqErZV7a4pu/6Gify34YgZ2W0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 001/476] ksmbd: free ppace array on error in parse_dacl
Date: Wed, 21 Feb 2024 14:00:52 +0100
Message-ID: <20240221130007.878386944@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit 8cf9bedfc3c47d24bb0de386f808f925dc52863e ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smbacl.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/ksmbd/smbacl.c b/fs/ksmbd/smbacl.c
index 9ace5027684d..3a6c0abdb035 100644
--- a/fs/ksmbd/smbacl.c
+++ b/fs/ksmbd/smbacl.c
@@ -399,10 +399,6 @@ static void parse_dacl(struct user_namespace *user_ns,
 	if (num_aces > ULONG_MAX / sizeof(struct smb_ace *))
 		return;
 
-	ppace = kmalloc_array(num_aces, sizeof(struct smb_ace *), GFP_KERNEL);
-	if (!ppace)
-		return;
-
 	ret = init_acl_state(&acl_state, num_aces);
 	if (ret)
 		return;
@@ -412,6 +408,13 @@ static void parse_dacl(struct user_namespace *user_ns,
 		return;
 	}
 
+	ppace = kmalloc_array(num_aces, sizeof(struct smb_ace *), GFP_KERNEL);
+	if (!ppace) {
+		free_acl_state(&default_acl_state);
+		free_acl_state(&acl_state);
+		return;
+	}
+
 	/*
 	 * reset rwx permissions for user/group/other.
 	 * Also, if num_aces is 0 i.e. DACL has no ACEs,
-- 
2.43.0



