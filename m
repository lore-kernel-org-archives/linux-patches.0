Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585480;
	b=q2O20DM1jtcwkbcnKBFJoe//nhrgLCkzvt1sYRbcGf379Jn/eS+TGsi5TAzEaZfxoBKQ
	 SE9nZcssfDV14l8H1Icq0WR0ijFoPRTEf0zR//rizDrwUv2zLE4sv84ZEsbnAb/QglBvJ
	 jD3YhahYgHhSBP9Mqs5uAAJYnifG56k+X52QQgssjrME/Rpt6VYDULJuthrTWN31kDywN
	 WLA/YbR3ilytwJfU4MiCI5qN5+EcrvBc8Q2EpfDvRcW4Qibt8kJfTSy4OEVSRyHW0lx5P
	 fVdSMO5uLN1LldkzZ8YdjzKF8LwCd421dpu8C5NrpBJtbneR0cruv7RUNTAiuaOyzgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585480;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hPYBnPUZbBXRBZvUW9Oehat/WPKtRlPrfOzvyVdYV0s=;
	b=ZO15ueqjydZNpiNCylxB6CbkgiWjXw7FGLKBgbYamWl67wv8/7Mk3AxS9qBK+2DY3YXs
	 31GvmHiSEhnwCCj1fPnj+UqjyYlRyK29ztzFPr8PDvmDj1mENjNN92j/hS8CH+YM11P6Q
	 mMfDB8a6UwJp/eE1WI6x2IE0uYHVTS8pbe3hYD/MLLSIQ1CA0lfzDQtroQcodD93CQpcP
	 Lik88+zsjgiz/4AQSof1n+mf9qokag/cCV27MRvJfE1NJQCu4mEcpOnQpD3xxufTouvX5
	 v7MR8IRk0hyJwN1L2MLWqRim9Ld2XudEbzI7VIt/1OrUEcDSwUou7lHJ1GctVKAW/CQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=boeTQ+ne;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4801A606A330;
	Fri, 13 Nov 2026 15:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=boeTQ+ne
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6BAB1F000C9;
	Fri, 13 Nov 2026 15:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585480;
	bh=hPYBnPUZbBXRBZvUW9Oehat/WPKtRlPrfOzvyVdYV0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=boeTQ+ne9qM17wWEzjV+xQASIV/hx3DZCsHD3eQhT/ry42tLTAkh/9SOYkJPRwTQ7
	 VEei3c2IWDITTnSAlN1mZiiu0/iHAVGdBPGqhTzBI5wiKxgA/8U9xRyrKfT26NcG8K
	 scOclhDvuMjxyDHB46VC75u3omtn4JJwExnUbjkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ian Bridges <icb@fastmail.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 131/507] ksmbd: grant a POSIX ACL group entry only to the groups members
Date: Fri, 13 Nov 2026 10:47:15 -0500
Message-ID: <20261113153758.888171840@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Bridges <icb@fastmail.org>

[ Upstream commit c00ec7ad449b68c291a4986e481941302ed399c5 ]

When no ACE of the DACL matches the caller, Everyone or Authenticated
Users, smb_check_perm_dacl() falls back to the file's POSIX ACL. It
takes the first ACL_USER or ACL_GROUP entry whose id equals the
caller's uid. For ACL_GROUP, this compares a gid with the caller's uid.
A numerical match grants the group's permissions even when the caller
is not a member.

Match a group entry only when the caller is also in the group.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Reported-by: Namjae Jeon <linkinjeon@kernel.org>
Closes: https://lore.kernel.org/linux-cifs/CAKYAXd93czbFD=znZUq_pJLXzDR5N3zc_auvAGWT7pzKR1f9Ag@mail.gmail.com/
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smbacl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index b95f8c2d6f3e6..c9e4429a19638 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1618,7 +1618,10 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 				else
 					continue;
 
-				if (id == uid) {
+				/* A group entry grants only to the group's members */
+				if (id == uid &&
+				    (pa_entry->e_tag == ACL_USER ||
+				     in_group_p(make_kgid(&init_user_ns, id)))) {
 					mode_to_access_flags(pa_entry->e_perm,
 							     0777,
 							     &access_bits);
-- 
2.53.0



