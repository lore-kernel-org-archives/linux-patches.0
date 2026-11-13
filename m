Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590248;
	b=ft42ILVaplt+4VVEjMn4PIoPHg/NiXDfsxbE3umOrrLVfvpPaBJWodyR0N7X0JDKsho/
	 nPB1WYNUL+y6ZhK3cGXA6gFzAEMAjm2HJ/9Ev4YgWAb7g1cS8AjSfHjoKLOcRNHmdxLZ8
	 zZM6O93jQV9u6hVuWjNNS4KyGmerixnt7w0pNVOisyFcyCZYlD57uBMMxqRW9lhMEecwZ
	 xHKrE1HFttB8QPKjYi/76oB2f2cubrMMjAcz8CMLDQIKHvcwRXv4rQsPkEm/m/Bweww/F
	 6hQs+yvnwJT69U8gePd8e3TUdJh7GJU3Jx6w3er25iHEXotm4PQOz4fw7MghrOaKMJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590248;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pyumZJgacJHFwOVJ0jxeLB5Qm3If35qC92LVdAZrM2Y=;
	b=BbFfusboUQq2zFpigWgF9Q1e+bk34rqZUg/wb55Vf+xIj+Jm1Ut32EDpi/i4JPptjdlX
	 VodX2DivyZ36cG1L1z3rC450EXBDPIz1uY82AtLTowZbroZ+Bwb9Ie9OyU4onsVJJexWI
	 xR1Y2S0bRipz+b/NuawxHDzigRKH+Tr64Pr2/acd+FDbH2wM7YaYdZLgyy6HYa/EMhP6P
	 MDDXYTUkulDp4x2fOxIiqfpXdr3yRBHrNZxSitmnmIc6jPCiBrwsnIxOKNzIz2Bbo6VXO
	 YhXDA108DGuzFlv41VTc4AqdAt8uUGfJsLI6ESGEa/T4DTlZnQDL+ysAJS87rQ6ef8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eif3hrBD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7AC60A2636;
	Fri, 13 Nov 2026 17:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eif3hrBD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD6771F000C6;
	Fri, 13 Nov 2026 17:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590248;
	bh=pyumZJgacJHFwOVJ0jxeLB5Qm3If35qC92LVdAZrM2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eif3hrBDr2Bjspm2P912k2yo2K/2Xqi/wrXdXpsRVfZI1RBuK8/RydbTSEfaSVwfY
	 KF1O1FWsB/2+M4k97fkYXMfM+CxC9Qh8b5gI50gVNMgzoZtExqXQs2oQgUYtHjnFcs
	 P+BsXCzXBXAWLVrUEKBJ+M8j1TC3lETTS0cWwWWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ian Bridges <icb@fastmail.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 245/686] ksmbd: grant a POSIX ACL group entry only to the groups members
Date: Fri, 13 Nov 2026 10:46:18 -0500
Message-ID: <20261113153829.356260335@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 33a607e709f18..63f7bccb4d9af 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1606,7 +1606,10 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
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



