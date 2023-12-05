Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160FE8BEC;
	Tue,  5 Dec 2023 03:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NStA24Zq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7E0C433CB;
	Tue,  5 Dec 2023 03:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746966;
	bh=hDxSrlt9hTr7sduOyfkjb4f5+wDjamg6dkSRVSE1l0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NStA24ZqrFTI28IVi4WSEUj9nY6oiKvhAlyCKYfyUNGxuxWmUhPUFKu3FmNdnJXdm
	 6F5hPuNJ89mDK2Mcg3fRdv1IBLs2uJyX2PxERJtPi6LZojA7JQL/iAqn2ebA+oa1Us
	 cQ2FPVl+p7Eudcycoo/KVpvTORZMhZWdTtUK/Obk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 003/107] smb: client: report correct st_size for SMB and NFS symlinks
Date: Tue,  5 Dec 2023 12:15:38 +0900
Message-ID: <20231205031531.687745010@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031531.426872356@linuxfoundation.org>
References: <20231205031531.426872356@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.com>

commit 9d63509547a940225d06d7eba1dc412befae255d upstream.

We can't rely on FILE_STANDARD_INFORMATION::EndOfFile for reparse
points as they will be always zero.  Set it to symlink target's length
as specified by POSIX.

This will make stat() family of syscalls return the correct st_size
for such files.

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/inode.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -772,6 +772,8 @@ static void cifs_open_info_to_fattr(stru
 	}
 
 	if (S_ISLNK(fattr->cf_mode)) {
+		if (likely(data->symlink_target))
+			fattr->cf_eof = strnlen(data->symlink_target, PATH_MAX);
 		fattr->cf_symlink_target = data->symlink_target;
 		data->symlink_target = NULL;
 	}


