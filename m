Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CF8225A56;
	Thu, 12 Dec 2024 16:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019869; cv=none; b=IVA40UZCPOItyUfDJBWJdURt1n+sAy5SNg/qFNc006zBOP2tsgLF3OYxH9O9pfcC6emVcQendxDn+3sAg0P/86o5nfFejcwgmo0/4GDt3fOJAh0oGPjJOQfFyAsAMNhMHlL0NF6AMAK4CxpI7wZak6JOAOOx8/E44lOf9exSX2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019869; c=relaxed/simple;
	bh=lX2Zdp+8xN+JsAsN5REAw3oEhPoSuc9rya9LMFdTEXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mJSXNrMQmpEjOqdTGeL9ZWnh5Zk1ou1thnu9D2kZCAjFsd8NAoxDj0MvXFkUmkdHgRiGyHpSgyzRIt+2nS8j2z5no4D+/LFGu8YqV3FPCvPYPILHaVUiwkrTr1BatTq5ZMktnJ7KpcSDES++W0BnZvfmgarfRoBRiUbOTvbE+fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j0oAUofz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j0oAUofz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D9CEC4CECE;
	Thu, 12 Dec 2024 16:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019869;
	bh=lX2Zdp+8xN+JsAsN5REAw3oEhPoSuc9rya9LMFdTEXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j0oAUofzVdoJAkOlJGyi3Mu8oW2K642ZUP94CRZy1OyyOA2NpYlAImdu70E4q9OOG
	 0Ancl3IiFEJNnPzmXM6HaU0ZE2FhSz9e2XSc89x+BtoevAr+5XfD6EXjb5Mql9XVwD
	 UxwMAH1YclekZV8dlTEO5qyHc1vt9Koyd0q/cZsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 291/772] NFSD: Cap the number of bytes copied by nfs4_reset_recoverydir()
Date: Thu, 12 Dec 2024 15:53:56 +0100
Message-ID: <20241212144401.923800358@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7d5d794e2e320..6596989718106 100644
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



