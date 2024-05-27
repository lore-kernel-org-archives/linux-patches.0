Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D64E15DBD8;
	Mon, 27 May 2024 19:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837309; cv=none; b=M/1ppWMcmEaWMZDIb3SuG1jJLD+ct3J9AvQazeSG83t6fQLbmKNnxENBdZL4+EbPVML4vy3z7OPInIiOFTMZHMQTUBl9ycrGmgbsOOcaoPU4MCI0Gr0zlVkWmoss96cSTOo/Jos+iCyFhHS4wrupVriK0Si1haTrGloXFPKutLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837309; c=relaxed/simple;
	bh=h6XulrfaPscbKiqmCkC0CkQyvFqD/4PoXUqJ/68FPNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cf+eu5+1FcH0qxpJgPDC7vxQUhNXkeJZSrEgO86OCdar6oS2PQ5rzNKRhYBcOMSYhuxF9wBVHkFglXi+1dpxz0bhBZKpUagsx551DdpnYCz40z549zxt7PRvcm5ApjIvzV/47M51hWnC6paQLmtZZBk/8RkTBqa1UuoWMwvrYFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nbh26Ph3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nbh26Ph3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E581DC2BBFC;
	Mon, 27 May 2024 19:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837309;
	bh=h6XulrfaPscbKiqmCkC0CkQyvFqD/4PoXUqJ/68FPNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nbh26Ph3hJA/43ATrzudlIYn2g7InYm6L7yuSOWi+6nFXYBR61YY6Znw+Ef8qx6vy
	 JUMWakr2IJ/Ldgv3qhNb/s1WqqBNddzKxszi5RlGwIt48ycbtDry7q6seDIlXIZTQE
	 ZGCn7pQbnGldQHfDcTvAEo2j6gLSorQ8Kxufs/ug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Aprelkov <aaprelkov@usergate.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 390/427] sunrpc: removed redundant procp check
Date: Mon, 27 May 2024 20:57:17 +0200
Message-ID: <20240527185634.792243486@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Aprelkov <aaprelkov@usergate.com>

[ Upstream commit a576f36971ab4097b6aa76433532aa1fb5ee2d3b ]

since vs_proc pointer is dereferenced before getting it's address there's
no need to check for NULL.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 8e5b67731d08 ("SUNRPC: Add a callback to initialise server requests")
Signed-off-by: Aleksandr Aprelkov <aaprelkov@usergate.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/svc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index b33e429336fb7..2b4b1276d4e86 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -1265,8 +1265,6 @@ svc_generic_init_request(struct svc_rqst *rqstp,
 	if (rqstp->rq_proc >= versp->vs_nproc)
 		goto err_bad_proc;
 	rqstp->rq_procinfo = procp = &versp->vs_proc[rqstp->rq_proc];
-	if (!procp)
-		goto err_bad_proc;
 
 	/* Initialize storage for argp and resp */
 	memset(rqstp->rq_argp, 0, procp->pc_argzero);
-- 
2.43.0



