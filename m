Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF79B28EE
	for <patches@lists.linux.dev>; Mon,  2 Jan 2023 11:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A52DC433EF;
	Mon,  2 Jan 2023 11:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672658815;
	bh=N7YlV6o7/KdM+VBaOm62IjA4ZrxjSy/jjYeFF9rcRds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZpFOkHhn/vBNg241R0e3Kv9PX7wLS+ghXpymwW+NNKVcyKBtmH9eIlwjqIrwb43WH
	 7ztS1KKwWyoSHlMGPCLPuIA6hXbG9K6Tw0F70ZndfJEqzMrgPt2EWUaW6XCfOl+kne
	 AULrJkLBrw638o1EphJifGHfSpyx2d2gz6mUeqE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@oracle.com>,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 10/74] cifs: fix static checker warning
Date: Mon,  2 Jan 2023 12:21:43 +0100
Message-Id: <20230102110552.477857252@linuxfoundation.org>
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

[ Upstream commit a9e17d3d74d14e5fd10d54f0a07e0fce4e5f80dd ]

Remove unnecessary NULL check of oparam->cifs_sb when parsing symlink
error response as it's already set by all smb2_open_file() callers and
deferenced earlier.

This fixes below report:

  fs/cifs/smb2file.c:126 smb2_open_file()
  warn: variable dereferenced before check 'oparms->cifs_sb' (see line 112)

Link: https://lore.kernel.org/r/Y0kt42j2tdpYakRu@kili
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: f60ffa662d14 ("cifs: don't leak -ENOMEM in smb2_open_file()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index 4992b43616a7..ffbd9a99fc12 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -123,7 +123,7 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms, __u32
 
 		if (unlikely(!err_iov.iov_base || err_buftype == CIFS_NO_BUFFER))
 			rc = -ENOMEM;
-		else if (hdr->Status == STATUS_STOPPED_ON_SYMLINK && oparms->cifs_sb) {
+		else if (hdr->Status == STATUS_STOPPED_ON_SYMLINK) {
 			rc = smb2_parse_symlink_response(oparms->cifs_sb, &err_iov,
 							 &data->symlink_target);
 			if (!rc) {
-- 
2.35.1



