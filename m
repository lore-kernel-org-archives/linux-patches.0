Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021C58BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 15:00:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E3C7C433D2;
	Tue, 28 Mar 2023 15:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015637;
	bh=nY5wMEAjf17Cj3Bkpkgam5vh8mcfisWNVi/j51Izv0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iZ+J2vSbbgg2ArRoFnexuXrvicpmZZ/r3TFOfRaxtoebVYak/AmTYvrg6F5GCbpGc
	 /NIoES+S70LncIEudPwe0ZeKceHFBJZUEubLYNSaVGrHWvA+VUnabulOB9h9wvVocs
	 wxIS46XpJ1WMc3Uq/SEAR2KexGrKopPK0Ztbf9V4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong2@huawei.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 079/224] ksmbd: fix possible refcount leak in smb2_open()
Date: Tue, 28 Mar 2023 16:41:15 +0200
Message-Id: <20230328142620.612271657@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: ChenXiaoSong <chenxiaosong2@huawei.com>

[ Upstream commit 2624b445544ffc1472ccabfb6ec867c199d4c95c ]

Reference count of acls will leak when memory allocation fails. Fix this
by adding the missing posix_acl_release().

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: ChenXiaoSong <chenxiaosong2@huawei.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 61d12eab0be15..e8c051a3329ec 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -2994,8 +2994,11 @@ int smb2_open(struct ksmbd_work *work)
 							sizeof(struct smb_acl) +
 							sizeof(struct smb_ace) * ace_num * 2,
 							GFP_KERNEL);
-					if (!pntsd)
+					if (!pntsd) {
+						posix_acl_release(fattr.cf_acls);
+						posix_acl_release(fattr.cf_dacls);
 						goto err_out;
+					}
 
 					rc = build_sec_desc(user_ns,
 							    pntsd, NULL, 0,
-- 
2.39.2



