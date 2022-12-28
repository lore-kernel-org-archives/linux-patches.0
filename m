Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3333C1C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:45:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C6DC433EF;
	Wed, 28 Dec 2022 16:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245921;
	bh=LjGOw9EVQXL+7ablo/MOtMWvynRlorjXYoMhwnC+Mds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kQmaYc42qpe3ge1/RL5kwWKy7TAaDbKCCPC5EGp85PSMTjVhwZJ5Pbse9fpkL2U/+
	 AhqQI+d3QNbIIMLrPcky6mEjVroAFCLGpOvs+gyd/BpyU6f9RwRDgI/tgD0LBk4hgD
	 p6FuV1JWH4+D8tHaczjP4ixfnS0cRDFaWcKCM6wE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5fc38b2ddbbca7f5c680@syzkaller.appspotmail.com,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Kees Cook <keescook@chromium.org>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0947/1146] jfs: Fix fortify moan in symlink
Date: Wed, 28 Dec 2022 15:41:26 +0100
Message-Id: <20221228144356.040343439@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dr. David Alan Gilbert <linux@treblig.org>

[ Upstream commit ebe060369f8d6e4588b115f252bebf5ba4d64350 ]

JFS has in jfs_incore.h:

      /* _inline may overflow into _inline_ea when needed */
      /* _inline_ea may overlay the last part of
       * file._xtroot if maxentry = XTROOTINITSLOT
       */
      union {
        struct {
          /* 128: inline symlink */
          unchar _inline[128];
          /* 128: inline extended attr */
          unchar _inline_ea[128];
        };
        unchar _inline_all[256];

and currently the symlink code copies into _inline;
if this is larger than 128 bytes it triggers a fortify warning of the
form:

  memcpy: detected field-spanning write (size 132) of single field
     "ip->i_link" at fs/jfs/namei.c:950 (size 18446744073709551615)

when it's actually OK.

Copy it into _inline_all instead.

Reported-by: syzbot+5fc38b2ddbbca7f5c680@syzkaller.appspotmail.com
Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jfs/namei.c b/fs/jfs/namei.c
index 9db4f5789c0e..4fbbf88435e6 100644
--- a/fs/jfs/namei.c
+++ b/fs/jfs/namei.c
@@ -946,7 +946,7 @@ static int jfs_symlink(struct user_namespace *mnt_userns, struct inode *dip,
 	if (ssize <= IDATASIZE) {
 		ip->i_op = &jfs_fast_symlink_inode_operations;
 
-		ip->i_link = JFS_IP(ip)->i_inline;
+		ip->i_link = JFS_IP(ip)->i_inline_all;
 		memcpy(ip->i_link, name, ssize);
 		ip->i_size = ssize - 1;
 
-- 
2.35.1



