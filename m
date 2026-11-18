Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037552;
	b=mwRFGh74aHWvjb0ErN2RyPGZu/n63fzgBy1GherRXHk/3oAfWjD8GkUcz/xhLa9D85Zq
	 9WnA2ow2h7f62zFV8UClIJYjCaSOJD25NM0cFOJSOn0ueLVCAmhTLW5yX11QDhJfARtEQ
	 32s7K+D2qEY1Cc8IfPUaEfczIAAyhjpFApsS++72O2U5q6+ZS/zBgnL2eh00en5sDsP+2
	 +VdXH/mJNV1Nhad+ZnGY72wiFW2FGUEXa/XCvpawWeDRBJyeDSz2C9D5PaFrNFheXcvNz
	 LeMf2Juo2YDXVAWS5CVmfYCn/DlqMIRoKuZ8/0ACZzeTmXKTjf/FEvON5NV6EYB1QfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037552;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QmqIXDM1tdOM0X98XEONQ7SF68lW+bSJur336NyNjDo=;
	b=daS/Rn+zra+xs1FT2u1d6G9QrvQjkcdkLjcG1i8YxHyAY60ha+PbICf9BwW9V8O/aEBX
	 QT6GOVko4hSAx998AfySEyoIYeLUal8h37iqPVzF5Cblvmg1iq7z4s86ml/IOzf/MlC1A
	 +z4LLOGp55+wAwhBJFw6BlIXCmeVZdrF+TniBJUx4Il80kEULQNmmMVs10UpHxo6epRev
	 kH24lBW/1w9FvcxFJ5PuMgDBo0FpI1U2mQD5fQZur0nLiH8Pu/WQWHX9DoGnUJoWdVEoR
	 v5HVEenCt7yiZkgyIP/29MHIervsA2diYoO5XOr/eD3XmbEBpUjlo3zJ+3cgJpqWFzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Minnr/+H";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72878606A325;
	Wed, 18 Nov 2026 21:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Minnr/+H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C27A81F000C4;
	Wed, 18 Nov 2026 21:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037552;
	bh=QmqIXDM1tdOM0X98XEONQ7SF68lW+bSJur336NyNjDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Minnr/+Hl6WuCYMIoV2YfEr8TPbzRtgqBL4e/jaC9bx8HOAtX3f0HCcEYF/I7qjCb
	 EriottbE1nQLw0788wIwIIgo2D2VgDz5wk0WQ9nJD0aLeF8Vcwf+70INbEcqR4gT2A
	 4SGd11keOUFzn84tZwruRLi2KuifQ+0v5TpZlUaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ian Bridges <icb@fastmail.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1438/3318] ksmbd: grant a POSIX ACL group entry only to the groups members
Date: Wed, 18 Nov 2026 15:34:20 +0100
Message-ID: <20261118150403.948253444@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d14408480f50e..40b2e6b499457 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1596,7 +1596,10 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
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



