Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A8F1F890E;
	Tue,  3 Dec 2024 16:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241813; cv=none; b=ibmG5nofc2Eq4b8hq78sust/JUGn/MZSLOWSsl9O4LloKcxwv5P4h8POsx4VhhouRdoFG4A5H/A66DtYdhdPafKa3+YM46cPHG7ltOogHJbDRouGfFsUNMpvasCRhRskZIgo6ZmOD1L2Wd+18AIz07FIVgemwF8Tw/77b+AR6u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241813; c=relaxed/simple;
	bh=coMXvWLp4Bgs3dvTmM+D02UfGOj/4pFCZDMgQ4D8idA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iS2BAbT0A/RmtKNRFIEIy2jZhnn70dFBiYf6PFDnEGY9ido/5YXPTv5P73lcyjVDamd90CfrHVrcMG6rRja5ohhUtMqK2V5Fc0vQi6UcR6KzRUljYLLWgTxI9OF6oWC7SnaMFBqHo1An7Wt14OsHmtCv8Ktsr/wlQ3xgrnk/80Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M1ddxZ65; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M1ddxZ65"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC52CC4CED6;
	Tue,  3 Dec 2024 16:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241813;
	bh=coMXvWLp4Bgs3dvTmM+D02UfGOj/4pFCZDMgQ4D8idA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M1ddxZ65YYw5Ad5Th2/ncYzSbA9cUYx9q3R1YnFggh9UppLtc3lZZGKEMcdhdJiCb
	 V3TuGRYdPUU9H6JZuxTpF74vud8uxDhag+3pMtN2T2enZLQ4FSK6g4WMD8MgvRhEBA
	 xUH8sj4sFs/I1133twxjdEcj6JbhwZLDndMyaRys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 525/826] NFSD: Prevent NULL dereference in nfsd4_process_cb_update()
Date: Tue,  3 Dec 2024 15:44:12 +0100
Message-ID: <20241203144804.237068960@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 1e02c641c3a43c88cecc08402000418e15578d38 ]

@ses is initialized to NULL. If __nfsd4_find_backchannel() finds no
available backchannel session, setup_callback_client() will try to
dereference @ses and segfault.

Fixes: dcbeaa68dbbd ("nfsd4: allow backchannel recovery")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4callback.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
index b5b3ab9d719a7..72764f73cf19a 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -1461,6 +1461,8 @@ static void nfsd4_process_cb_update(struct nfsd4_callback *cb)
 		ses = c->cn_session;
 	}
 	spin_unlock(&clp->cl_lock);
+	if (!c)
+		return;
 
 	err = setup_callback_client(clp, &conn, ses);
 	if (err) {
-- 
2.43.0



