Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C940155736;
	Tue, 18 Jun 2024 13:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715888; cv=none; b=ZSTz2wKXKmDoB2Prv4n+DkmtdDf3/0ZB80aktDGmgLYhCFe/QrmtgFla0HbN3FEs4WeB2m+RgDFUrkhM8IHGTBmWzaggCYM+TltPbRmXJDJoirN06lH58fhzP+gEuKR85BPlq2+DK1HtjbEEGz/AL9ZznlDUQQ+TGdvy8jc67Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715888; c=relaxed/simple;
	bh=tPvgaPpWUcjWb3kDApHfzfioZJE9J6jT/gsugWNMhsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cvWK2l+K2jcRaoVfS481YnIO+y39iyEIRG1QapRJC4OhpjBg2O5WbOZ9SrVCumOPe6iK7Bu28mA0+dxnPYomVq+OcycBYHi5CV/VcsQusISQBacklfjEwrE5FOy9OTodSw70yRhj2afLpmw+JiCbKXIZBZK507RBA3OlcgZmYG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wEfaG04a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wEfaG04a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 121A5C3277B;
	Tue, 18 Jun 2024 13:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715888;
	bh=tPvgaPpWUcjWb3kDApHfzfioZJE9J6jT/gsugWNMhsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wEfaG04aXIH+NjPtQMux85KWUNHm2YJ4uBJhWPvlqaBr4bKGzCY1mxXeXIBzlYeQi
	 1sKqBg3NvzJ/2NFbdw4M6tAaBQvaHaPmdGEBee7FQ4hJkXFL9E+5W58TirE954KaCp
	 hmnLC+4qLHn1+jHOSLHv3f572glOTP9YFj7IhaoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	rtm@csail.mit.edu,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Olga Kornievskaia <kolga@netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 461/770] nfsd: fix crash on COPY_NOTIFY with special stateid
Date: Tue, 18 Jun 2024 14:35:14 +0200
Message-ID: <20240618123425.106880854@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit 074b07d94e0bb6ddce5690a9b7e2373088e8b33a ]

RTM says "If the special ONE stateid is passed to
nfs4_preprocess_stateid_op(), it returns status=0 but does not set
*cstid. nfsd4_copy_notify() depends on stid being set if status=0, and
thus can crash if the client sends the right COPY_NOTIFY RPC."

RFC 7862 says "The cna_src_stateid MUST refer to either open or locking
states provided earlier by the server.  If it is invalid, then the
operation MUST fail."

The RFC doesn't specify an error, and the choice doesn't matter much as
this is clearly illegal client behavior, but bad_stateid seems
reasonable.

Simplest is just to guarantee that nfs4_preprocess_stateid_op, called
with non-NULL cstid, errors out if it can't return a stateid.

Reported-by: rtm@csail.mit.edu
Fixes: 624322f1adc5 ("NFSD add COPY_NOTIFY operation")
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Olga Kornievskaia <kolga@netapp.com>
Tested-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 4161a4854c430..60d5d1cb2cc65 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6097,7 +6097,11 @@ nfs4_preprocess_stateid_op(struct svc_rqst *rqstp,
 		return nfserr_grace;
 
 	if (ZERO_STATEID(stateid) || ONE_STATEID(stateid)) {
-		status = check_special_stateids(net, fhp, stateid, flags);
+		if (cstid)
+			status = nfserr_bad_stateid;
+		else
+			status = check_special_stateids(net, fhp, stateid,
+									flags);
 		goto done;
 	}
 
-- 
2.43.0



