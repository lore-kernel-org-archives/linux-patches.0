Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046089;
	b=dcgLGwHynmG+nfBVls7cYjKfVC+DWViBbMdHEVl3aLZZl2qZsrUnOLPH2ZsW7PBCViiq
	 4eJ7b10kQZW/XVzTXCJpYTYAjUo+9wgARkbme0cr1Vz4DLoU06f450sepF3SFnUKVJMfP
	 iWPY3jwdwxwghK5fUGfHBuGWjoT4F3sxSpEgxRPHT49Oa/q6qJmHdDADwOOlFcBqJDJU4
	 sf8u14W0iruILLA+ejiIQYYN26cc59sTcI4aJ6HtFBdDHj4roJ3wK2D3VZyKi2Wx1mn75
	 qd/ZZaRh+XDmSO9IEbj0mlpiBV2bKwbiFP/tg3ikq+t+Br/3Pcm5+Wqj5MnNO1QcNLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046089;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Tlm3OPWAyYtNl5IB0ygxbFALAYzMLHMBJOOCUrPb9Kg=;
	b=XQuMjnJECZv8g8EajQC4eJqm3c63F0i8SrojR8IzYbX10joXsv4LWaEIjyWCHN3OEjJ/
	 P48T4Kdx+u35/T6fw3sroc/SfcvwA7lOpMc5RKSpIetkuGT6WST0qkvyfISwmFYA3bO45
	 WbYDESWLi76M9EriW4A9XfK+Uz4em4PNY5L2Txuz0pi9oOSo7uEQ2j6VEB+tRpOU9QrES
	 0ov6tjUN7nCAcTcNQ5vRlyj+YKJFkL+SRErQHwfh6tKShLdGi2TU7N+q6tQO/6tF8OndB
	 J6cNcGo3uYsBGjtjCJkaXU9cEG7/OTWLANjadXXfWEqvzJQeBIQCBHxxK/1XFP5+Lag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zGDkcBGM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297FE606A31C;
	Wed, 18 Nov 2026 23:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zGDkcBGM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45CE91F000C4;
	Wed, 18 Nov 2026 23:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046088;
	bh=Tlm3OPWAyYtNl5IB0ygxbFALAYzMLHMBJOOCUrPb9Kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zGDkcBGMD7bKvwaj7SVqk/9zhy7/v4a9ELCZO5bzIqJTWqiN6IXbymSZabFLiyC4Q
	 9ZyILvXSXciqnBJmub47BDGX5M69+Lg3xlR7gTFTvwK1LturvDBzo3beuKXEqZpUHl
	 NC2HasX5TdSB2WeRltPLDQ5Q+qjZsYn5cBTrPpaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominik Maier <dmnk@google.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1119/2857] smb: client: fix slab-out-of-bounds write in id_mode_to_cifs_acl()
Date: Wed, 18 Nov 2026 15:35:53 +0100
Message-ID: <20261118150241.908481590@linuxfoundation.org>
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

From: Dominik Maier <dmnk@google.com>

[ Upstream commit a377a3645c7d0246af0bc4ef24db94bb2670bdde ]

In id_mode_to_cifs_acl(), while the chown branch reserves
sizeof(struct smb_ntsd) + 2 * sizeof(struct smb_sid) (plus
sizeof(struct smb_acl) and the worst-case ACE space after
commit 0ee150794c75 ("smb: client: fix heap overflow in DACL owner/group
rewrite")), the chmod branch only adds 2 * sizeof(struct smb_ace) or
5 * sizeof(struct smb_ace) to secdesclen (or 1 * sizeof(struct smb_ace)
on posix).

However, the chmod branch also invokes build_sec_desc() ->
copy_sec_desc(), which unconditionally writes the Owner SID at
pnntsd + sidsoffset and the Group SID at
pnntsd + sidsoffset + sizeof(struct smb_sid) (2 * 68 = 136 bytes total),
and set_chmod_dacl() always writes a struct smb_acl header (8 bytes)
even when the source descriptor has dacloffset == 0. When a security
descriptor has compact or overlapping Owner/Group SIDs (or
dacloffset == 0), calling chmod() under-allocates pnntsd and writes past
the end of the slab buffer.

Reserve sizeof(struct smb_acl) + 2 * sizeof(struct smb_sid) (plus
sizeof(struct smb_ntsd) on the posix path) in the chmod branch of
id_mode_to_cifs_acl().

Fixes: 7ee0b4c635c0 ("cifs: fix hardcoded default security descriptor length")
Fixes: f5065508897a ("cifs: Retain old ACEs when converting between mode bits and ACL.")
Assisted-by: ARTIST LLM
Signed-off-by: Dominik Maier <dmnk@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
[ sashal: used += with cifs_* structures because nsecdesclen already includes secdesclen ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsacl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index 7bb35cdbc4d67..4d9481235b0ca 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -1750,6 +1750,8 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 *pnmode,
 	/* Potentially, five new ACEs can be added to the ACL for U,G,O mapping */
 	nsecdesclen = secdesclen;
 	if (pnmode && *pnmode != NO_CHANGE_64) { /* chmod */
+		nsecdesclen += sizeof(struct cifs_acl) +
+			2 * sizeof(struct cifs_sid);
 		if (mode_from_sid)
 			nsecdesclen += 2 * sizeof(struct cifs_ace);
 		else /* cifsacl */
-- 
2.53.0



