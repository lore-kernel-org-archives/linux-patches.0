Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FAA913CA81;
	Thu, 12 Dec 2024 17:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025297; cv=none; b=b9HnzM79+vjgqSfRRdFiYrP6htQLoBjbbo5H9jpV8UzPfd1O5QW8KL/tbvVEPhq8R/CfILYKS3zPqMvmFzK70ljd5bOQZ6hj/QQd/TDfHqCWYjnOnd29AkLCryOh3YqzdMw8uF3WLmoWw3/ZdxoVWC2U48jY8DnWaapGN6Qj7PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025297; c=relaxed/simple;
	bh=5K5lxpcui7L8JC+Tni81wG8azZrEX2w0Rr9LrcTmL2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yf49DftmhA+PRGx0nAEzzxQQOHUkChTIqTlD2c9Aw2gvKqRsdZdBLyCXRYkScAfhUJgEieyDtLCfePWNOeLw53HmucJN1NtJqSbH0YlrGRHmHv2Ny4YASeGZVDBX+n7feO5V2w3AiYLsOvjVXlqXI1IiP6/L7s9eM37EW3qkAT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1cexMjhx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1cexMjhx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 767BAC4CECE;
	Thu, 12 Dec 2024 17:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025296;
	bh=5K5lxpcui7L8JC+Tni81wG8azZrEX2w0Rr9LrcTmL2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1cexMjhxMEEsiWHnSJLEHL9iIMwrgcOp9Eeh4yJgS6PzD5il0H/zVEwKFwhKVdUpr
	 9kNaNoRgg0Nz89EdChgsvKqUaiuyyr0s7hhN0qAYDnau50uD8lvCwY6wkQ1kC9PkYG
	 ZyikSwplyMtso1IG5wM1QTOHdi2EFXg+sQE+Ihos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 123/321] NFSD: Cap the number of bytes copied by nfs4_reset_recoverydir()
Date: Thu, 12 Dec 2024 16:00:41 +0100
Message-ID: <20241212144234.836544216@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 1abddad2b7ae7..594db9085b24a 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -666,7 +666,8 @@ nfs4_reset_recoverydir(char *recdir)
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



