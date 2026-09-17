Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C9C4E0B80;
	Thu, 17 Sep 2026 17:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665355; cv=none; b=N1PM9PZ3endnz+jthAdRoCFW5NkiHO9FkEc6SzNFqwy9kkANec9kNXp89/UEp3WWJd0juaOfUG+/VZZHFhXEFBOyppVLwErtcwWYSL61Jr7FduhTA805oSHLh3LuhYy+G6EYIpzzxUXUOkr3RANHrBZlALCyKHfnvX+JJQtBap8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665355; c=relaxed/simple;
	bh=Q1/6P0sa+yhRjhl4TBfxHCfgKzcHX9wQvYF4USK6L10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c1LZ6R1HW1GC6E3fAFrZWLOQXj5PK81GlDt6OPCouir3mmlXekJ5Z1/nn7o7Q9ykScIn/D8s13zfPqSjgiqeLbJOa5asrqpNH2HhDoA/pqCYB0On0jD5K9N6Bjl17QkTYdP2J3uEwmi9fYR7Z8U3r+CLGZpl0m9/kPdfVDCc8f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TD74NZBU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TD74NZBU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 293DB1F00898;
	Thu, 17 Sep 2026 17:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665353;
	bh=coJ/SI2kH/YgYjqV2MVbWU/ezkTDyFOscH5PwEVdvnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TD74NZBUcKlskX28otl36SojYyLD9vEDgAxizjt8+AtobvCXzHGn5nPEq7vdEJq+l
	 R79Vq2CwhKuATrGx3Fn+mB0T7qoll7gAI8bBdEt5UMWTbYTFRVa2UoYZgGhqgIjOMB
	 KCvRxKlOj10d2I4gsz/gagCB3JvzTKPwoGisnWto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheryl Babcock <cheryl@renat.io>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0650/1250] ksmbd: rate limit unmapped SID errors
Date: Thu, 17 Sep 2026 16:07:25 +0100
Message-ID: <20260917151609.516210543@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



