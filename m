Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CBA62566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:28:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0F1C433D2;
	Tue, 18 Apr 2023 12:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681820907;
	bh=TiMi9raqU+dwzmPfgrSQ0df/D9qckQeKfr42TFsg+oI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vtjes6J22+IH659zTNlgkNQCczXI3RImlJdErEUTmWOJGKV7tAsW5UBgATTmgKui4
	 l8cJEXc1d81Wjt5uHAN256v+Z9em7Or+4SoQGcf5qx+wAUd9D7ZBE5A8Tkb69XuxgB
	 4Cp/gto8reRDA+gbQ+8y2pSNP3mA4QYBM92TGc8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 19/92] NFSD: callback request does not use correct credential for AUTH_SYS
Date: Tue, 18 Apr 2023 14:20:54 +0200
Message-Id: <20230418120305.473729344@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
References: <20230418120304.658273364@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit 7de82c2f36fb26aa78440bbf0efcf360b691d98b ]

Currently callback request does not use the credential specified in
CREATE_SESSION if the security flavor for the back channel is AUTH_SYS.

Problem was discovered by pynfs 4.1 DELEG5 and DELEG7 test with error:
DELEG5   st_delegation.testCBSecParms     : FAILURE
           expected callback with uid, gid == 17, 19, got 0, 0

Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Fixes: 8276c902bbe9 ("SUNRPC: remove uid and gid from struct auth_cred")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4callback.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
index ffc2b838b123c..771733396eab2 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -840,8 +840,8 @@ static const struct cred *get_backchannel_cred(struct nfs4_client *clp, struct r
 		if (!kcred)
 			return NULL;
 
-		kcred->uid = ses->se_cb_sec.uid;
-		kcred->gid = ses->se_cb_sec.gid;
+		kcred->fsuid = ses->se_cb_sec.uid;
+		kcred->fsgid = ses->se_cb_sec.gid;
 		return kcred;
 	}
 }
-- 
2.39.2



