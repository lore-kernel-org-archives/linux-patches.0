Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E9F21504F;
	Thu, 12 Dec 2024 15:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016316; cv=none; b=FUDDFYqu06Dl9VgO8r3K8eo6r6JS+XayK1KYqll0SBVxDwekZHyPe5ZyilL8odiRpanlY4DSxr/rNF5O2WnGKJV+AUKVCvKTuoHU3wrP/u+hdKZ01MeJ4ft+H0WUbtpC7iHKELI83GRUUGuhPo0BChCnAJkREHH6SRMcN5O9AA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016316; c=relaxed/simple;
	bh=Bw2Jd4Az82V8uRnSer8qatBL79muYHL4BYQqLY3O/Lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MT+h+KrEoepLrlS/Rj300iHmf64EMiCWe+2PjMgF2MPa6rNXs5ArR+DmAi1ELYpXM/FfcT9miKjhlMsICt2cSRC1Qqbs5akuGd1A+iAyx/cL8ufi0eStuMOmwbq3AlIg6yDskhfXrgoohhyTD8Ky8JG0dzQib/yPbrZnQgVFoIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=byyIuWFk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="byyIuWFk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14779C4CECE;
	Thu, 12 Dec 2024 15:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016316;
	bh=Bw2Jd4Az82V8uRnSer8qatBL79muYHL4BYQqLY3O/Lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=byyIuWFkiXrmOjvUFnYs3Qd7hDeLCa83um37tAlO9O2Jkih5xvx+kGOAH86HNftkF
	 ZhLhR6CB5UHvnQZk0DHvKxW5jp4awMSWEUs1VASRNR9ds6vSnyPcTNKhSo8JVYiMfW
	 n772aoO3clySxLtoTar/57g1mIOTkQpH+tAVO/d0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Ralph Boehme <slow@samba.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 156/466] fs/smb/client: avoid querying SMB2_OP_QUERY_WSL_EA for SMB3 POSIX
Date: Thu, 12 Dec 2024 15:55:25 +0100
Message-ID: <20241212144312.959530683@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

From: Ralph Boehme <slow@samba.org>

commit ca4b2c4607433033e9c4f4659f809af4261d8992 upstream.

Avoid extra roundtrip

Cc: stable@vger.kernel.org
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Ralph Boehme <slow@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -943,7 +943,8 @@ int smb2_query_path_info(const unsigned
 		if (rc || !data->reparse_point)
 			goto out;
 
-		cmds[num_cmds++] = SMB2_OP_QUERY_WSL_EA;
+		if (!tcon->posix_extensions)
+			cmds[num_cmds++] = SMB2_OP_QUERY_WSL_EA;
 		/*
 		 * Skip SMB2_OP_GET_REPARSE if symlink already parsed in create
 		 * response.


