Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026DB1A3029;
	Tue, 21 Oct 2025 20:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077575; cv=none; b=CmNUO+UUBKIPDpuh/6itlVONUlOqpWiKP7efleLCeIdGuIj1AMdhTPD2g4mDgpKR+qdUpqTCWRqIP0qOQiCw7EWI0EB8MJqiYB7tAl50IzjdQ8buPzf8IlCaFlZSF2aS+SRMrO2D7jqltWRMz/LseS3s6g0NchBmhPdfTBPwjIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077575; c=relaxed/simple;
	bh=ZGMN+l766kc9lhv/3zNvSnrqEjrHs1WJSlyGXF7ckD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EHzQESVgvzps0UOi5BVzYwwAOz1XZDmp01hYrmJbVyOWHvVtEzbHp9Z40HzIWA2Xjfz+p6QWENJwM8KgFB2vnhzikbzQYqrcS/qMrF+2phdrFRia2pHb+doOatsnQhHQMudhf/5nbiqjsmMxIIML6OMxl0ShmOxLq0OohN0UW6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n9+IH6hv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n9+IH6hv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 625BFC4CEF7;
	Tue, 21 Oct 2025 20:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077574;
	bh=ZGMN+l766kc9lhv/3zNvSnrqEjrHs1WJSlyGXF7ckD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n9+IH6hvGywFhI7bptgImnPnRwSWvLsF78oTynXfUIBQtlTTzMFjzpxOQuTlcyAA7
	 pACBv6VS2Mlomh1syJr530EKy/cqULgZ6gZksStXWWkL28YQWCW5iaoOiH65CngNJa
	 BptG0wYA3515OjDXN7xbsKmkyBTAWME/JrWfj07Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Morris <rtm@csail.mit.edu>,
	Thomas Haynes <loghyr@hammerspace.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 149/159] NFSD: Define a proc_layoutcommit for the FlexFiles layout type
Date: Tue, 21 Oct 2025 21:52:06 +0200
Message-ID: <20251021195046.756132218@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 4b47a8601b71ad98833b447d465592d847b4dc77 ]

Avoid a crash if a pNFS client should happen to send a LAYOUTCOMMIT
operation on a FlexFiles layout.

Reported-by: Robert Morris <rtm@csail.mit.edu>
Closes: https://lore.kernel.org/linux-nfs/152f99b2-ba35-4dec-93a9-4690e625dccd@oracle.com/T/#t
Cc: Thomas Haynes <loghyr@hammerspace.com>
Cc: stable@vger.kernel.org
Fixes: 9b9960a0ca47 ("nfsd: Add a super simple flex file server")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/flexfilelayout.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/nfsd/flexfilelayout.c
+++ b/fs/nfsd/flexfilelayout.c
@@ -125,6 +125,13 @@ nfsd4_ff_proc_getdeviceinfo(struct super
 	return 0;
 }
 
+static __be32
+nfsd4_ff_proc_layoutcommit(struct inode *inode, struct svc_rqst *rqstp,
+		struct nfsd4_layoutcommit *lcp)
+{
+	return nfs_ok;
+}
+
 const struct nfsd4_layout_ops ff_layout_ops = {
 	.notify_types		=
 			NOTIFY_DEVICEID4_DELETE | NOTIFY_DEVICEID4_CHANGE,
@@ -133,4 +140,5 @@ const struct nfsd4_layout_ops ff_layout_
 	.encode_getdeviceinfo	= nfsd4_ff_encode_getdeviceinfo,
 	.proc_layoutget		= nfsd4_ff_proc_layoutget,
 	.encode_layoutget	= nfsd4_ff_encode_layoutget,
+	.proc_layoutcommit	= nfsd4_ff_proc_layoutcommit,
 };


