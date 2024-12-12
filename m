Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2734D2144C4;
	Thu, 12 Dec 2024 17:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024184; cv=none; b=iGxwVhrr8mmMPUwp+QorQdfHOPUKMjCCj+UD9FsgEK5a3aQNDeDCf1pUgFPLKFW6WoaGQaq15xCVpdJIVUWXyHksl0FjAUIzmnpTMp16TUgIILRwSvHsqeh2Mks2JSATvPyyvaIVEYhhTHDYpkQMS81N0HwZUVxfpELCd47URiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024184; c=relaxed/simple;
	bh=KwDHRH8eIu1y1gj0rFKf7OEI8LICOibgawGnaaNM+iI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CUOoZFB1V4yffBDXLCCvfOkpqFaNeCGb4cZV5d7P0VEZgZ7D6aHeChXy9YPFC85k15bAmxMFIlY493dfG2IoyAGK2CVRpIdx/XzPLtLtIBCPFtcf743yEbxCu+Y4f2DulxPDDP0+zJq4zE8ZbYtZAaDmUjyRAv2vBzq6lRZ6QEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dbo95lGk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dbo95lGk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90656C4CECE;
	Thu, 12 Dec 2024 17:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024184;
	bh=KwDHRH8eIu1y1gj0rFKf7OEI8LICOibgawGnaaNM+iI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dbo95lGk1eVLCf1kaNn7Nq09MHgQDwGQMo3CIBP15uHwytxM6CvsWq3viT7M6AzkC
	 maVU10JjTgKRt3iNrwMqTw7/lfblSsbJFMEozf+zowjjKKKbR1XoYL/Zv7R8HMjOlp
	 umzglSjT/6T7jwRucUDGMETwoJkvrHCijnRXhuIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 212/459] NFSD: Cap the number of bytes copied by nfs4_reset_recoverydir()
Date: Thu, 12 Dec 2024 15:59:10 +0100
Message-ID: <20241212144301.947789541@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2904268c18c9a..eca39b5c12c68 100644
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



