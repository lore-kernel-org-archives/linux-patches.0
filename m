Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4AC38494
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:36:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B4B4C433EF;
	Fri, 10 Mar 2023 14:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458986;
	bh=5niFoL15P094P2WgJGlCsCP3P5IB1IMtVXII38xavVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IpVyST2kgwuYKdS/PtA5TS+m/PqWlT77XkWRWl/odiZl/TYlF1Cfx76DrHoHLtIRg
	 qrr8hGyzAHx34k5K9To0HUaXRpujkVqm5gMWq+S56JYgjNT5zbL9pi1ETTo004SG64
	 O9dgcFKf9czWV6AInD1RunD29YBqDGBd5bNBF5mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 210/357] nfsd: zero out pointers after putting nfsd_files on COPY setup error
Date: Fri, 10 Mar 2023 14:38:19 +0100
Message-Id: <20230310133743.982714704@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 1f0001d43d0c0ac2a19a34a914f6595ad97cbc1d ]

At first, I thought this might be a source of nfsd_file overputs, but
the current callers seem to avoid an extra put when nfsd4_verify_copy
returns an error.

Still, it's "bad form" to leave the pointers filled out when we don't
have a reference to them anymore, and that might lead to bugs later.
Zero them out as a defensive coding measure.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 452ed633a2c76..bd7846758947b 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1059,8 +1059,10 @@ nfsd4_verify_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	return status;
 out_put_dst:
 	nfsd_file_put(*dst);
+	*dst = NULL;
 out_put_src:
 	nfsd_file_put(*src);
+	*src = NULL;
 	goto out;
 }
 
-- 
2.39.2



