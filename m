Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B5D23CE;
	Tue,  3 Dec 2024 16:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241816; cv=none; b=HsL1AgweZTUFjlQy8sBdr350uqSTJM5KU//JHcbNDOLtX1W0LSyljP1XJhXeUQQyzZo+m/dJjvbexeuRNhYwZjWnnPjl7r+4fZOM/CmPfolLznpQxzZbU1md7RzWrytbohin0zRZbdfqjfeGbgu5L+gaxdoOqDifyW2lfXyAbdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241816; c=relaxed/simple;
	bh=Fz1ql5BD+R4DAz+3t4T3GMjWcTelKQwv8F7qmUEZyhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GuKHGemEj23jDG2kifAHaCFY8sDNHlmmYY6nBOnnjNX5Q9Xm5nz5HNLzv56g6BdWr/OF77/CkGNuwqpbtemN5nIPb+yADtoLHE57Y+ixsXCKKq10ghDEazPi0+BB7XriW+Db6J/ixS8UN+PXHMubdsZDZ+MeNEauHUZSePBjW9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rsd6OPMI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rsd6OPMI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C66CC4CECF;
	Tue,  3 Dec 2024 16:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241816;
	bh=Fz1ql5BD+R4DAz+3t4T3GMjWcTelKQwv8F7qmUEZyhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rsd6OPMIC/GjfM3caN8UCwYgKTRfpy+S85tuojiK7KGiC+EhZslDsM+2OBhqJ4xBQ
	 hPE5TO9m1utdu0ou5G00MMlu+saq3UG8BNvLVG0xWh4RSHrTDKfCnpwP/bp1+GYQIg
	 1NW87H0x3+bVmcSCf+Bj/zVSKy0hISD4Dsn2110A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 526/826] NFSD: Cap the number of bytes copied by nfs4_reset_recoverydir()
Date: Tue,  3 Dec 2024 15:44:13 +0100
Message-ID: <20241203144804.276555484@linuxfoundation.org>
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
index b7d61eb8afe9e..4a765555bf845 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -659,7 +659,8 @@ nfs4_reset_recoverydir(char *recdir)
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



