Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F5151B188;
	Wed, 30 Sep 2026 16:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784986; cv=none; b=SQcw25P3CejkiSoAWq3qjK8Jd2VkQFeSaeIdoI72vXPLT6PhE9Haie6OVHCM3ytmJooBGLJQ7NWLj/Y6YpxYBS/bZUmvxlpksLea6DRn74llfXlrZww1Vn1K9naniWCctifF3eS9bfFqaXp4Jec4q0GPgdXFWURQDIqUP9rf33c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784986; c=relaxed/simple;
	bh=OffXtHFcTQ420UdORrMEfR//IwNWDjdk20GV85dY4IA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f8g9I3WfI0+UXQliThUcmzXag0mJuf7H3N5ZUHvGPqqvltCh2ihpE0n+O//XjjzSnR3GCneevky412w+/Lj7zX7YYIaNJJ9dJtMbatRFEc75n0gbHhLzUOcsVOsNoAgL4u1q9I8l91Br7R/zyJ81i3Oyzg0ajOtScVfEGrbG0sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aq+gmQih; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aq+gmQih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C15811F000FF;
	Wed, 30 Sep 2026 16:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784980;
	bh=N1aADv/RIAJze6bDqUZEc+BNTzIa0XOOmpge3TjiaBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Aq+gmQihAy0ngTvwcUGhKXnD5JRUyo367TRcPt6FQLgtEJy0r79nXQr/gHjL8z16h
	 svb5qx9K11wEPakcpbgVWsRbAGW9/3yAtDt6+/vTfPfeLjObFCdVFgyNAeqTdz30Lz
	 Il8G1cGG2oL2pyG1S+eE2txjE01VdBzimYDUvqq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheryl Babcock <cheryl@renat.io>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 345/982] ksmbd: rate limit unmapped SID errors
Date: Wed, 30 Sep 2026 17:18:01 +0200
Message-ID: <20260930152424.227119933@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7a0396db6f1d2..5cb020fc01050 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -516,8 +516,8 @@ static void parse_dacl(struct user_namespace *user_ns,
 			temp_fattr.cf_uid = INVALID_UID;
 			ret = sid_to_id(user_ns, &ppace[i]->sid, SIDOWNER, &temp_fattr);
 			if (ret || uid_eq(temp_fattr.cf_uid, INVALID_UID)) {
-				pr_err("%s: Error %d mapping Owner SID to uid\n",
-				       __func__, ret);
+				pr_err_ratelimited("%s: Error %d mapping Owner SID to uid\n",
+						   __func__, ret);
 				continue;
 			}
 
-- 
2.53.0



