Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5B74C10D0;
	Thu, 17 Sep 2026 18:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668789; cv=none; b=emibMz6UqDRHMLBCrCGW/JNmfPtxIbpfs3Cgb+NPQMkR+AD4sylkGs44Zk2BtHqqCMpsCLSuh19NS3wo24RbU8E0gF/aO4W98mLSIDZMtWsJuu1h1r1yijf9W915/mz9O3KOPaqPsOc8vQPbjw5kPhRykvr6K1LWw47HdZU4tmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668789; c=relaxed/simple;
	bh=pht04uHH8jyhbprZMjzZjpRKxsJKjB06jCpK8y9+HEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ld5vCops1RPB6sBQ9biMdiaCkB8I9kgRBPpb10uu/K+YcyvRa+Hhx6m2CJjAz07PN71GX4xO1hWcG5BlEGxsCviU1/NMcb0yhz63EekEge4kwVyCIYbv/xNCcxKgXZc1mkNHa8tuTf6iGIQaxvipdA3ffS0Z6mSn7AyUGzgrNUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xeaqbtSi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xeaqbtSi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B2151F000FF;
	Thu, 17 Sep 2026 18:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668788;
	bh=G5nK8FxeJIbBWO0VKzuDhEbDSoV6DZEvyvFhj959Nrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xeaqbtSiJbPeSzFUJ3HgPaeJ96p3vKjI7u53fYOUjZJ1+qjKmbSQrC/lEQG9EZwJl
	 Z/HSrJ86lWMIuWIfQqp1u4w3CcxBHrmg80YuYVWQlXQ/NajVsRvhY8nsT/uhYg/r3Q
	 YfFxF0daKOsIaOkzkH8Xl7PQvRzaz3Y4zns/aOv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheryl Babcock <cheryl@renat.io>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0541/1102] ksmbd: rate limit unmapped SID errors
Date: Thu, 17 Sep 2026 16:08:04 +0100
Message-ID: <20260917151553.400501770@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit feca5e70fc963b088377b20879e8cd8237c2fd7d ]

A client can include many structurally valid but unmapped SIDs in a DACL.
Logging every mapping failure lets one request generate hundreds of kernel
error messages.

Rate limit the message to prevent an authenticated client from flooding
the kernel log.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Reported-by: Cheryl Babcock <cheryl@renat.io>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smbacl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 0b35b275eaf65..2a46646b3a0e4 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -525,8 +525,8 @@ static int parse_dacl(struct mnt_idmap *idmap,
 			temp_fattr.cf_uid = INVALID_UID;
 			ret = sid_to_id(idmap, &ppace[i]->sid, SIDOWNER, &temp_fattr);
 			if (ret || uid_eq(temp_fattr.cf_uid, INVALID_UID)) {
-				pr_err("%s: Error %d mapping Owner SID to uid\n",
-				       __func__, ret);
+				pr_err_ratelimited("%s: Error %d mapping Owner SID to uid\n",
+						   __func__, ret);
 				continue;
 			}
 
-- 
2.53.0



