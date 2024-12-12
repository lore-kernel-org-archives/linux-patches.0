Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8F922969E;
	Thu, 12 Dec 2024 16:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022519; cv=none; b=ixwnDaHxEKlSKoUZR1Gc6fTCjYKvt8nFKrBkog/Nhi0iJqrk3uihaFNNvfYciYvoJNxBGrvzQZuWfCKa0blCPQmwNZn+H7STuvB11I1MnhaYSS8FtWZu31B0+SKY8oBIf4ejrJy3tn5bLSgY8TFi9TH0I2Xm9yZgP4QjXgneJNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022519; c=relaxed/simple;
	bh=V+L6EZO2/3hRMJnCFc5zju/KCYRw8eWpF81lcVKKlA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mj77UO1UwDAnQ52xIiEo24AYNE6GA5BuzLDM6RL1T/yegkyqxq3e+DYMt6vJVbIfO/rY0Zo6eiGQt+U+YFTP4uRG8PGnrrjaWwXN6cayLlTcIe4lDNg4cPPxiK8Va3F26aTQoMCELJ5ciDf5SCVI2uAAss13YyVgqECWrd/c3as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ff9UuIUG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ff9UuIUG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B24E2C4CECE;
	Thu, 12 Dec 2024 16:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022519;
	bh=V+L6EZO2/3hRMJnCFc5zju/KCYRw8eWpF81lcVKKlA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ff9UuIUGF9TPLKDA/Z0fznjeDP6/cVjCulyhGP+zWlwDt2KsMWeqVfxetyG4dtafe
	 LSc4AQnkUUUJds9MJe2cQF/M+aEkkL49rNgm8uPV/VrnqZ7zOjuOgzl3I+pO1nSdI5
	 QqIaS7X5aTeuite5zamkhQtnfONrggEdH/gZCWQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 264/565] NFSD: Cap the number of bytes copied by nfs4_reset_recoverydir()
Date: Thu, 12 Dec 2024 15:57:39 +0100
Message-ID: <20241212144321.901944988@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit f64ea4af43161bb86ffc77e6aeb5bcf5c3229df0 ]

It's only current caller already length-checks the string, but let's
be safe.

Fixes: 0964a3d3f1aa ("[PATCH] knfsd: nfsd4 reboot dirname fix")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4recover.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index 2cc543f6c410f..71e7bd23d5c45 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -658,7 +658,8 @@ nfs4_reset_recoverydir(char *recdir)
 		return status;
 	status = -ENOTDIR;
 	if (d_is_dir(path.dentry)) {
-		strcpy(user_recovery_dirname, recdir);
+		strscpy(user_recovery_dirname, recdir,
+			sizeof(user_recovery_dirname));
 		status = 0;
 	}
 	path_put(&path);
-- 
2.43.0



