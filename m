Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7187D49659;
	Mon, 14 Oct 2024 15:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918063; cv=none; b=eZQMcdo0qbUvjPuwYkYr8ee9+80JByV28UNBZSICd9Qvv3ONpdmzOn1/NnfxcTveA3e3+7TC+czM0nNQW0O9Hl7wtf971ovNZFU9ER32jZazyiyZWulfEhYPE4XuqBiQuL59vo1Td3ZsF1jWgyqejXdfsgEOUnRNL13K3mZ06V8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918063; c=relaxed/simple;
	bh=VX2VhuL7SllEbcJ9zLIFRZu++vwsgwySkdqOXcUjWck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i1V1Jrcm0E3wiDGRZ/1EQn8gXSWRRy3FdU3G9/B9sNptDuvjiNI8gMSyDVIaj5yein5hVLSROJXGVsElN/NclpPNQ/xXJOv2WDpoFhC4nmRcm3JFmefkP/lWH4Jz42dYjasoyU9dafEe9qjcEwmKwY6XRmAynG+vTaDaI9xJE/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UKaH3+U1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UKaH3+U1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8233C4CEC3;
	Mon, 14 Oct 2024 15:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918063;
	bh=VX2VhuL7SllEbcJ9zLIFRZu++vwsgwySkdqOXcUjWck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UKaH3+U1W6t4wiEipWtEfYTM5e1omLrbqUBlLwYLwIACy/3mvG4yHX5or3wxAIWD6
	 gV1/NvEEhsUSbzsw61qWbyQRuJGi2ixKDGo2f0A6tDvt8dxh+OVTWBaqK+8MRTXt5T
	 gwZGIOYdEse1/xj3ZEF0FcvPt5yfj6j5y/cvkIPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Youzhong Yang <youzhong@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 211/798] nfsd: remove unneeded EEXIST error check in nfsd_do_file_acquire
Date: Mon, 14 Oct 2024 16:12:45 +0200
Message-ID: <20241014141226.222161471@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 81a95c2b1d605743220f28db04b8da13a65c4059 ]

Given that we do the search and insertion while holding the i_lock, I
don't think it's possible for us to get EEXIST here. Remove this case.

Fixes: c6593366c0bf ("nfsd: don't kill nfsd_files because of lease break error")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Tested-by: Youzhong Yang <youzhong@gmail.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index ee9c923192e08..9101ad9175396 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -1041,8 +1041,6 @@ nfsd_file_do_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	if (likely(ret == 0))
 		goto open_file;
 
-	if (ret == -EEXIST)
-		goto retry;
 	trace_nfsd_file_insert_err(rqstp, inode, may_flags, ret);
 	status = nfserr_jukebox;
 	goto construction_err;
-- 
2.43.0



