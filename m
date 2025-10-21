Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D779F274652;
	Tue, 21 Oct 2025 19:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076622; cv=none; b=exA8OM+w1HU/x+kj9o/WfQc/FOK4Wub6ZVGrlY0OieobxoFZL/wX6lx0GaeLNjeI2TSDMowsEO2/0L+G0tdy+PKw0EaxrSEHRlEyBn8YcXPgNMZC2kUP/y8OQ5WuvG7FPPA/YEmQ5caiSdiXNJzBpzMQF5NvGMVggnBY40gtw9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076622; c=relaxed/simple;
	bh=OIYKf+yAajMjL+X3dBVS1myHhG0aRmyYal1CTCw4CnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VGc7uDpsGfCW7+7peyJaiYOzYtiyZxHmQPwNdzOpOpZiwk+FfPkUwaK/pH+Vo/GUDJYeVToSs79wR1udzbA3M2lWtkV5EIMyE+6GCErWM6SkWAadqmFutB7VGdu1ago5NMcqZayvAjdThRUYx5cmK5GUznJAQAhTwF7fRcVuK/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FMMUMnUF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FMMUMnUF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65162C4CEF1;
	Tue, 21 Oct 2025 19:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076622;
	bh=OIYKf+yAajMjL+X3dBVS1myHhG0aRmyYal1CTCw4CnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FMMUMnUFsgTOhion9JV+ACdNCONVVxKQMWcn5BzMUPiCPoEkTJsyqVXAOzioGoYlB
	 kZI40deIwCXttT2AHMyHayG8f2gqFOdXUYYv5dto9LHErhobr534zziN+aH8ccwcvJ
	 AcqDJgusok1KSugHLVT0KxP6C/s8tamv6tGFlnUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Morris <rtm@csail.mit.edu>,
	Thomas Haynes <loghyr@hammerspace.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 091/105] NFSD: Define a proc_layoutcommit for the FlexFiles layout type
Date: Tue, 21 Oct 2025 21:51:40 +0200
Message-ID: <20251021195023.812249505@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ removed struct svc_rqst parameter from nfsd4_ff_proc_layoutcommit ]
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
+nfsd4_ff_proc_layoutcommit(struct inode *inode,
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


