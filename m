Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591061;
	b=S/kntzDQDwWb7byYnkajpUehHXNQ0iYQKWLzTP0K2Nl7bSF5AiOmth45f/5klQaYDsTC
	 vCV4NaeQS0/qjEI2jSNTHVP6U09m3SQimWcyXQBfV/zde4WfFWFsDTpbgvo+FH4nVPu2y
	 HorTZonxXzrLgiCism7liuLBEYT30LS2PQVDLBNz9w0AcdVdOCEC7/DTmxMId+mesLvBf
	 7AhGfFL2RW2WuRtVb+7noCXjXR4k57zYjy3o3cEDlQ6P72kF22c5sUJX8Ob7rJn7D6G+L
	 9tTodv2qV4EC8efz/aXWdbTreoP3ytxrYtWThbOi7yZu0W6hCfkiYhquoadCZwe1nqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591061;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JeEgAOxyGlB5EYojL7pyyoH7fE58/gFW5a/TotggxOI=;
	b=vxZNG3+o4auEFmTXUsUNu8lXFOi6QMcT4cWtYXakdZjqSEr7WeK1k5sDPfj5oz/Y7xO4
	 zf6wpWBRci9m2/QkwdHtKVO9wwt7IHGKNjglKmK976n8itUNG7cPR2LOfMVQ+uH4MZSvQ
	 xjEGCKFF2wxRMI/yJ0VWznSAwnodgR0Voyo0VcG4kgAEFvWZcj5b1IiaAmJshrxoBLIZ/
	 ojsf/hDZtJw2Y0N02UlrOjGhdF9sc3zX4LqJfgX04si2HwByuTya0tSK0iRpthsXHt1oF
	 coKuIrugWM/cDNprd8XYIhrjzkIqnrYnBET7WDlpxJRiCgH3gCvPE0b+WbA1I9fNfaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EvDT07qS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C6D606B83B;
	Fri, 13 Nov 2026 17:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EvDT07qS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF771F000C5;
	Fri, 13 Nov 2026 17:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591061;
	bh=JeEgAOxyGlB5EYojL7pyyoH7fE58/gFW5a/TotggxOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EvDT07qSbBC9Sx70NGKnOXEE2QIxJAr6DgYc9xGulO5kNSOYg/7iE2i0J7pXYn3hK
	 QRGOL7/hmd5NsKwc6jhiReBJRBu+kHAlyDqZ99mfbCEmHMELaS4bA1VBdIh5JQqr+N
	 sSQSY0PGqQfv9gd1Q5GRucv+vBmYUcgwMm2kBJ7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ian Bridges <icb@fastmail.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 221/670] ksmbd: grant a POSIX ACL group entry only to the groups members
Date: Fri, 13 Nov 2026 10:46:25 -0500
Message-ID: <20261113153819.381110694@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



