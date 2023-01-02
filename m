Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DDDC28EE
	for <patches@lists.linux.dev>; Mon,  2 Jan 2023 11:26:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC032C433EF;
	Mon,  2 Jan 2023 11:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672658818;
	bh=jhGHPPiCg8PuuPbx27YsQpFMkeaCpoT/eez0u9GB/Jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oxfm26sKJjVIzqdGXFGBT/NbWIm+90JOmbRyBYReKncvrYjFVQC+X8KA/rdbHM0D9
	 2FDBkWXVOHU4pXD3AJzru8b5MJ7SRd9nhduWruxZVWaYYuntQ1Kt42DQdRdIOtSTp/
	 ybgF1cUXJ8hrg2PzB58v6DRNiGDc+ubB0vU1BJYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 11/74] cifs: dont leak -ENOMEM in smb2_open_file()
Date: Mon,  2 Jan 2023 12:21:44 +0100
Message-Id: <20230102110552.525903229@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
References: <20230102110552.061937047@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paulo Alcantara <pc@cjr.nz>

[ Upstream commit f60ffa662d1427cfd31fe9d895c3566ac50bfe52 ]

A NULL error response might be a valid case where smb2_reconnect()
failed to reconnect the session and tcon due to a disconnected server
prior to issuing the I/O operation, so don't leak -ENOMEM to userspace
on such occasions.

Fixes: 76894f3e2f71 ("cifs: improve symlink handling for smb2+")
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index ffbd9a99fc12..ba6cc50af390 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -122,8 +122,8 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms, __u32
 		struct smb2_hdr *hdr = err_iov.iov_base;
 
 		if (unlikely(!err_iov.iov_base || err_buftype == CIFS_NO_BUFFER))
-			rc = -ENOMEM;
-		else if (hdr->Status == STATUS_STOPPED_ON_SYMLINK) {
+			goto out;
+		if (hdr->Status == STATUS_STOPPED_ON_SYMLINK) {
 			rc = smb2_parse_symlink_response(oparms->cifs_sb, &err_iov,
 							 &data->symlink_target);
 			if (!rc) {
-- 
2.35.1



