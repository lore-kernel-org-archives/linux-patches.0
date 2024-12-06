Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8656C20CCE1;
	Fri,  6 Dec 2024 15:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498572; cv=none; b=qHtPyng4QrSzAuLw4r2uIPcNsjvoZkdR6M6VzcK3HPlOAx/yAz6tgYaPUxmDxED9PpatnKN/oO/JfEWYNwJJvogXhpzRAP0Xu5ikVPy78+8ibA+a11XElkg9qYuN1gpLvA235NUr3AgU+NwtB36Pt0cgR5LLSAllSQZco2j6JHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498572; c=relaxed/simple;
	bh=cFbx20p0+9NfjFzHfxNwMtB3LIpXiEnXTWi/J/vuTUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SI6vHQ9g5SLSoeuBX60mZ8+2PMtSCnlEZBzQQCohpiBfTEiB311oWKrsr+OJ/9++zkjJP9OnKHKfmvL74K6JJzJ8Ojlhh9OxVaYqwOd+EzQ2IHbyLktl/tP9ztB6S0uHP9ac/op5iQJFJ+NawF9WR1a2pYu3xuhDXSNYV7YkTcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UJhGKJCe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UJhGKJCe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E32C4CEDC;
	Fri,  6 Dec 2024 15:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498572;
	bh=cFbx20p0+9NfjFzHfxNwMtB3LIpXiEnXTWi/J/vuTUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UJhGKJCepqzn+icxwkAF9Ko2BX8echaWJIckQ0IMmbDO5nFp8Orm68pF5EASvm3MQ
	 Zb6xcpapYzwG4KB1exXQKq6Vl2D/OkHQZVKfPrjQMg9lzqtiXSxdQTPDHRE210HDDb
	 /E0yJ2aQizh8WTjNCAxSCQdx3LZfuNioPQxJDSKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Bharath SM <bharathsm@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 593/676] cifs: unlock on error in smb3_reconfigure()
Date: Fri,  6 Dec 2024 15:36:52 +0100
Message-ID: <20241206143716.533323620@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit cda88d2fef7aa7de80b5697e8009fcbbb436f42d ]

Unlock before returning if smb3_sync_session_ctx_passwords() fails.

Fixes: 7e654ab7da03 ("cifs: during remount, make sure passwords are in sync")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Bharath SM <bharathsm@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/fs_context.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 6ba38bfa645b4..4e77ba191ef87 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -976,8 +976,10 @@ static int smb3_reconfigure(struct fs_context *fc)
 	 * later stage
 	 */
 	rc = smb3_sync_session_ctx_passwords(cifs_sb, ses);
-	if (rc)
+	if (rc) {
+		mutex_unlock(&ses->session_mutex);
 		return rc;
+	}
 
 	/*
 	 * now that allocations for passwords are done, commit them
-- 
2.43.0



