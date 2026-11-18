Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046276;
	b=Hz04+lZSrEQmhWigZIZ7iRUO+c97g2dD26ZyGKza2iO3hYRgCm6hdDI578GfiHsTSLzt
	 qpNUruX1uf6nwKswqP/reEeDIKEpAwjU0PncLG15mWJK05AlgNbsHRehuPin11NuGHfYo
	 cxjcdn+eBu5JmKAKhzmX3N1pijz1LmCeM7zDCxoGdXxLET8WekSX63SZz6nFTl1gZdxAu
	 gstMFSE4I0g+gu1OOpOJJgOQnhLqOHKpq0CPdj1aInkyRn2WEZrVByoXGuTf+cXjdz2CK
	 u1tA7VN2b+vvGtRKR2TU3wb6+tesy6LzwdSddGmf33p/qW+LqZ1Hsu3CT3kZ0hj8bFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046276;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pfqYywEOk9l7nKLJD9GGOSV82Eq1qXHSP6hNdEHa+zo=;
	b=U0joMiDirqcDyK+EIK8UGxF3ie1Kp7lyllTMRuP7IUO/mMF2d2cYJN3QsnNAYFH2ANNT
	 OqQgnoJQvrzSxGuTV586N4vSE9IfJGqG5j7lTPvGnZlByEQ9iECZvrxYg2xiRUit69XJO
	 HC/egDV3PAxKnnspwrjkOB217a9Q3XMbkJ9dNwDs8WUvP1Q1QsqGOk9Vi+3t8SlYpa9dk
	 1NyrE9VY4fWMJTqMNFIh6NS06Rcw3uvuun9k6AyATUhHcq5DS7TtWJWmmwcRYM4QW3Q1T
	 pcdpEzhuf7VI3UMzPFTW0SjbhchGh3+UL5ioolzgkr+jDKEMsPe7S0mZoo9LaKV2RAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZLEVTB5T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9CE606A325;
	Wed, 18 Nov 2026 23:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZLEVTB5T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2861F000C4;
	Wed, 18 Nov 2026 23:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046276;
	bh=pfqYywEOk9l7nKLJD9GGOSV82Eq1qXHSP6hNdEHa+zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZLEVTB5TDRFI0q9tZN3/kFsPJ0KdeDIARr01bW3tDhc5XMeI90O5PNrYodRFmHgWW
	 0Wx/gyNzAT5yBjdP6PVFGPYiVlNozbaNkQ42PquhpB16hKjR3U39F/Q5tl8qEfjsQM
	 Oe6kJxfgubkR3Ww+KQfLwvbROIM2gazb5taQkNxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ian Bridges <icb@fastmail.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1223/2857] ksmbd: grant a POSIX ACL group entry only to the groups members
Date: Wed, 18 Nov 2026 15:37:37 +0100
Message-ID: <20261118150245.604114935@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index bbbcb12aa9d06..f0ec137e4efce 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1582,7 +1582,10 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
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



