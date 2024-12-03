Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316521F8921;
	Tue,  3 Dec 2024 16:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242800; cv=none; b=sl9hFBAfhLe9jUZQbXR1eTJHWGdrNKpD8qsAax+eT3yHpzUL8mpB0H7vM/+ZEpiKd+Q13099/MilmYVEC4v+uKHUqwkTO2jRe7ltpFb3r6Y23tvd+njbFYRXEqTjHmC/KE09bRtkgJ6Ol8IUzhgm1nia8b6FHJsT6D5guY+OPlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242800; c=relaxed/simple;
	bh=S2efNBFEwFt2mGlEljz9iADnHNq2jvlwFKZ+/2JSlqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P9f61EAE5AgNP8ftQNC3SavCrcaE8wOv0RM4PczEjXwanwGBcNY06WDpF3yfk8ovKQowWnsMThv0A6rNEoasPbVeTm2sCgsnKk+XqMSD9/7HgiaQz/eke1x5fNh7CH3td+oUlKprnJAA6ADV8PC9jr0BEY5wjpPwXCOppWm+O3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LOtcd/a0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LOtcd/a0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93AE6C4CED8;
	Tue,  3 Dec 2024 16:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242800;
	bh=S2efNBFEwFt2mGlEljz9iADnHNq2jvlwFKZ+/2JSlqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LOtcd/a0jQxe5uloqCyNMCDsEgYo/09UrOi6ypSy66/0iXbh4eBI12zq3TdXj6FBe
	 6KBtOleDlF28AamMX6Ci0QoxbMUj6prHGUuRJxYOcQ57aXKvaxrD9fibIkOfGjPaMF
	 lMliut+nuC3CtrkDyK4WyOYCjG+iLyygYbn8C43I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Bharath SM <bharathsm@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 813/826] cifs: unlock on error in smb3_reconfigure()
Date: Tue,  3 Dec 2024 15:49:00 +0100
Message-ID: <20241203144815.468852530@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1a5842ced489d..48606e2ddffdc 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -978,8 +978,10 @@ static int smb3_reconfigure(struct fs_context *fc)
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



