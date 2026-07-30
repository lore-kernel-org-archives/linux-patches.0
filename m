Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF04538E5DC;
	Thu, 30 Jul 2026 16:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427961; cv=none; b=IdyeRA9mHYsdYtNbVj2N3SB52otmo6PUoC/fVTuZrednLZeB7+4ZVSBd5KZQqZvU/N2Dv6yIEiSrtx4A58I2a9aOcgy2gqIngbnn5ZaHQTW8qzeTgugYw225Rz+uMlwjTWsVfsC5sv1iOg3qy6CGcpJdKnh0LALMbc0Ry+XTYBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427961; c=relaxed/simple;
	bh=4xYJSoCmiGmfcuWHwkMA97LRa6jOOGSW262T5lManT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qNg5bceDVWV0kcAFQ+LAuf18Zj3jaLoZ2VXS8QIMQXAQCLXCAeysMGa3GTcbdg2aBwLcNZyXBFcR36WnwSQOmSx3UPLQHzDzFKL6ZkkV7Rky77T/hvsHsJ4I0/5bGaNr3iCIEKzZZDa8tAU9ppw20o5luXMmw3q7AGSdlJfH/HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K0QCMPtQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K0QCMPtQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4747E1F000E9;
	Thu, 30 Jul 2026 16:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427959;
	bh=xy7w5C1aMsRhkmPvsQ4Q/agxwxVX1KlzQ9pDFi3TAyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K0QCMPtQHmwtUQMkyXnXUwO2rRVb9Cb7wH0ypnB9dtMNEGG2r2A+Jlur9sF8AprDN
	 1IpQVBMI03p/dZGWMhvzJSGdEhERVCRIU/3ejxtCnHz6vEF3Kho7gUfcGFYmsNbNsj
	 g7yQF4zHbFaG2CL8hYuEafq1lCJ7KB2jFWNsVP00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Guan <guanwentao@uniontech.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 353/484] ksmbd: restore DACL size on check_add_overflow() to avoid malformed ACL
Date: Thu, 30 Jul 2026 16:14:10 +0200
Message-ID: <20260730141431.145872262@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Guan <guanwentao@uniontech.com>

commit bbf0a8e931204ecdab494a88d43b0a24a04285c5 upstream.

check_add_overflow() unconditionally writes the truncated sum into *d
even on overflow, per its contract in include/linux/overflow.h.
The four check_add_overflow() guards in set_posix_acl_entries_dacl()
and set_ntacl_dacl() break out of the ACE-building loops on overflow,
but the truncated *size is then consumed downstream at the end of
set_ntacl_dacl():

    pndacl->size = cpu_to_le16(le16_to_cpu(pndacl->size) + size);

This produces an on-wire NT ACL whose pndacl->size under-reports the
bytes actually written by the preceding fill_ace_for_sid()/memcpy()
calls, yielding a malformed ACL that can trigger out-of-bounds reads
when re-parsed by clients or ksmbd itself.

Restore *size to its pre-addition value on each overflow branch (via
`*size -= ace_sz` / `size -= nt_ace_size`) so that after the break,
*size once again holds the cumulative size of the successfully-written
ACEs. The committed ACL is then truncated-but-self-consistent rather
than malformed.

The ksmbd DACL builders are the only check_add_overflow() sites found
where an overflow path breaks out of a loop and the destination value
is consumed afterward. The other nearby break-style cases either
return -EINVAL on overflow (transport_ipc.c) or break without
consuming the overflowed destination value afterward (buildid.c).

Fixes: 299f962c0b02 ("ksmbd: use check_add_overflow() to prevent u16 DACL size overflow")
Assisted-by: atomcode:glm-5.2
Assisted-by: Codex:gpt-5.5
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smbacl.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index e87f25f4e672fb..3f0f1d9c98d1b7 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -649,6 +649,7 @@ static void set_posix_acl_entries_dacl(struct mnt_idmap *idmap,
 		ace_sz = fill_ace_for_sid(ntace, sid, ACCESS_ALLOWED, flags,
 				pace->e_perm, 0777);
 		if (check_add_overflow(*size, ace_sz, size)) {
+			*size -= ace_sz;
 			kfree(sid);
 			break;
 		}
@@ -663,6 +664,7 @@ static void set_posix_acl_entries_dacl(struct mnt_idmap *idmap,
 			ace_sz = fill_ace_for_sid(ntace, sid, ACCESS_ALLOWED,
 					0x03, pace->e_perm, 0777);
 			if (check_add_overflow(*size, ace_sz, size)) {
+				*size -= ace_sz;
 				kfree(sid);
 				break;
 			}
@@ -708,6 +710,7 @@ static void set_posix_acl_entries_dacl(struct mnt_idmap *idmap,
 		ace_sz = fill_ace_for_sid(ntace, sid, ACCESS_ALLOWED, 0x0b,
 				pace->e_perm, 0777);
 		if (check_add_overflow(*size, ace_sz, size)) {
+			*size -= ace_sz;
 			kfree(sid);
 			break;
 		}
@@ -750,8 +753,10 @@ static void set_ntacl_dacl(struct mnt_idmap *idmap,
 				goto next_ace;
 
 			memcpy((char *)pndace + size, ntace, nt_ace_size);
-			if (check_add_overflow(size, nt_ace_size, &size))
+			if (check_add_overflow(size, nt_ace_size, &size)) {
+				size -= nt_ace_size;
 				break;
+			}
 			num_aces++;
 
 next_ace:
-- 
2.53.0



