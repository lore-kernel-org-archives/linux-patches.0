Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7646AD48
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:23:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D27BC433EF;
	Wed,  4 Jan 2023 16:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672849413;
	bh=WLmQncJgtRzrYWUgeWE3euBzyP5/fCwMN9/eGgUjxps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kkT+LQ3wXiub6tUfnW1wSrhHJ4ktaflH4Bw3R/Peh74uw5ykTmLttG0PMAJ+pQW2n
	 gzEkiuOphbDNmzH6Vs6rctoUGjUk/Z3xMf5OnaVqwb0Y9YPQEO7XGmILrgE7JFeTGj
	 6mr0jEb1mE6TCMcRjuXR1lXZMEZm3P11A7DHnHcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.1 184/207] ext4: dont fail GETFSUUID when the caller provides a long buffer
Date: Wed,  4 Jan 2023 17:07:22 +0100
Message-Id: <20230104160517.720911361@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Darrick J. Wong <djwong@kernel.org>

commit a7e9d977e031fceefe1e7cd69ebd7202d5758b56 upstream.

If userspace provides a longer UUID buffer than is required, we
shouldn't fail the call with EINVAL -- rather, we can fill the caller's
buffer with the bytes we /can/ fill, and update the length field to
reflect what we copied.  This doesn't break the UAPI since we're
enabling a case that currently fails, and so far Ted hasn't released a
version of e2fsprogs that uses the new ext4 ioctl.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
Link: https://lore.kernel.org/r/166811139478.327006.13879198441587445544.stgit@magnolia
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ioctl.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1159,14 +1159,16 @@ static int ext4_ioctl_getuuid(struct ext
 		return -EINVAL;
 	}
 
-	if (fsuuid.fsu_len != UUID_SIZE || fsuuid.fsu_flags != 0)
+	if (fsuuid.fsu_len < UUID_SIZE || fsuuid.fsu_flags != 0)
 		return -EINVAL;
 
 	lock_buffer(sbi->s_sbh);
 	memcpy(uuid, sbi->s_es->s_uuid, UUID_SIZE);
 	unlock_buffer(sbi->s_sbh);
 
-	if (copy_to_user(&ufsuuid->fsu_uuid[0], uuid, UUID_SIZE))
+	fsuuid.fsu_len = UUID_SIZE;
+	if (copy_to_user(ufsuuid, &fsuuid, sizeof(fsuuid)) ||
+	    copy_to_user(&ufsuuid->fsu_uuid[0], uuid, UUID_SIZE))
 		return -EFAULT;
 	return 0;
 }


