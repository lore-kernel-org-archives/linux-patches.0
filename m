Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34303C1986;
	Wed, 30 Sep 2026 19:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794998; cv=none; b=AJS9/qC626G5OBQSKZIT110nDuWYMU51betgYgC2/STzZazHIHeesEuneg4dpkgYaLN+XsE3NYgYIpqhKa5wZ1tMD87omXh6TlXYzIE6EvbDggdOGKCjQp+GwxfKmXfUKQTVOCjT5WSEj1c7F2oKi2Owiiuu7Ahy9YYhc5hU9HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794998; c=relaxed/simple;
	bh=l4YYD+mucxrQyLvajHsrrZpln6IvnBaUQ1+rMuG9tNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c3afK4tUzEGbl3mkzZ/iZQvvVtmDh+SSSLqsssYAOGCNWIvugIpOggNnbq2SrRSUnrED5U2OEr/Dmw7sD/KamDr4XnJRzPxsG1fUbq5qWO+Cy6t8qTOL927+f1o5TGgF3kVCPqVUYEX69P/Y3j03go8NH80lY52p6m7MlEwIWCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SU5XLQba; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SU5XLQba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B50E1F000FF;
	Wed, 30 Sep 2026 19:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794997;
	bh=VmE9anP6nXwjtDSfx0o7pppqblt9Aax2gnEm97Q2k00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SU5XLQbaIFFxlfRV7pyE5OgV+TCaS5fkhi6fVCJZ+CXCoo9vRqp+AezRYi3oVvIbp
	 CxHDtuF00Q6qjUBvunvOhjLaJv1I+4K77l6V0fVyJPBKWEN+cNuqNJl2VRcPWLiY7Y
	 r7HQ8SS/QUlxte3fc4dwZwHUSFe8MLkNNBCnubPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheryl Babcock <cheryl@renat.io>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0406/1193] ksmbd: rate limit unmapped SID errors
Date: Wed, 30 Sep 2026 17:18:10 +0200
Message-ID: <20260930152443.216055184@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index 3056634d0b4b5..b68b63a3195fa 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -521,8 +521,8 @@ static void parse_dacl(struct mnt_idmap *idmap,
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



