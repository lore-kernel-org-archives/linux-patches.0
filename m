Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291861D0414;
	Wed,  2 Oct 2024 14:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879993; cv=none; b=ePHdj0w0EgVKpPVkV55vHxDZmrzfH5gWKsFlXY/ZTTlSSpFsm9m96QJToCVD+y7xEPVo/QcvqnzSI8srg9H3N0V9MVbq9eLSoIqvhAY6Hw0yDb/i/WHU4DbOEStQuJaITzGv23TLs0kQRgPynJw1IoXHDVdkRh8S6KUgAoU0dhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879993; c=relaxed/simple;
	bh=qyXF1lDgsoGMA175oJXmg5DFRZPCJjz9cX4wf9OEitM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gKFio7CXcdkvm4O53WUWqMg+rQ8FNcJ4y8qjVitZXo92uapP8ioMNthtUZ91aUTdmStQHKyYXplP/KpkamTXtMhIMgAvis7gZjVLKQUsQCyIT8+5uiKpMqOZ7RRZbabo/7WDExWM9QzTnVKHiGwTIVp673/yuTIbv+rZDiV2cYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DxJsnSI0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DxJsnSI0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66102C4CEC5;
	Wed,  2 Oct 2024 14:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879992;
	bh=qyXF1lDgsoGMA175oJXmg5DFRZPCJjz9cX4wf9OEitM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DxJsnSI0EdNlbT3VOR6v2Lhmn3Lk6tYN46Gb4AWOuUnipkq0MgTeg/FG6UkYC4/lo
	 IEMvNApmhIFAm88IF9VsIhNVBGmvrs4AG82LqrHsB+iFgRuvAbPzzRCtuPyvv3+SwS
	 LtRiTQIimlg1C935beExmL6/hjqx76IY/eIhxm3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Youzhong Yang <youzhong@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 308/538] nfsd: fix refcount leak when file is unhashed after being found
Date: Wed,  2 Oct 2024 14:59:07 +0200
Message-ID: <20241002125804.574865356@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 8a7926176378460e0d91e02b03f0ff20a8709a60 ]

If we wait_for_construction and find that the file is no longer hashed,
and we're going to retry the open, the old nfsd_file reference is
currently leaked. Put the reference before retrying.

Fixes: c6593366c0bf ("nfsd: don't kill nfsd_files because of lease break error")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Tested-by: Youzhong Yang <youzhong@gmail.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 88cefb630e171..5c9f8f8404d5b 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -1054,6 +1054,7 @@ nfsd_file_do_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 			status = nfserr_jukebox;
 			goto construction_err;
 		}
+		nfsd_file_put(nf);
 		open_retry = false;
 		fh_put(fhp);
 		goto retry;
-- 
2.43.0



