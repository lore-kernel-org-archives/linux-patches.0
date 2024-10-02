Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3691E1D094A;
	Wed,  2 Oct 2024 14:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878285; cv=none; b=OzsO1gXNQqAuxFX98tYprR8b4kIZ2qooUhQasIyOjde3TzXp/RrDDLmtTt3+Pe7y24TOsPSXRbEQjhiHk83xMYMzfpHC5HSUQ9TMNzRhhAx7N9gawy+zEKIXtPb+KghMbMnOa88NLvxQF2tgr7gB8twIltpOIAI2o2/J+ES1dsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878285; c=relaxed/simple;
	bh=p7jyfENaTaq+Mo7qUwDVStr9RTiDBqGv7Aw2+EIMkyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sc8xbdbh0jyttyjMnGvOwSFU/sSqgx0VHFRFGTJbOMco/TIqvql4iw9S1dixYUNvtJBUnL4V5zBYbwetnrgQn2Q9FbO9DUgP/iCyrTyVsdkj/5vdZosrNpOY6SZGXDSZFDUVkb7an8aTlIe3Ui0hQ9bref34ta8kq1/SPAnjppA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bUsbRUf3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bUsbRUf3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B39C6C4CEC2;
	Wed,  2 Oct 2024 14:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878285;
	bh=p7jyfENaTaq+Mo7qUwDVStr9RTiDBqGv7Aw2+EIMkyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bUsbRUf3Wfluv6/yKKJn4yqSfWGh0KO/2R9XvOSVc2GkAzraaqWtIHYz8RMDk0wI0
	 HoLDCPjziDC/zsYaxk44jAW/E0e1+E3zl1nkPhb3x6vWb7RKnOKVVvHIzbbFNv+PKz
	 WbVRPxSl4PXyXztWlrtKSkkTaH3B875XrRW7svN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Youzhong Yang <youzhong@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 361/634] nfsd: fix refcount leak when file is unhashed after being found
Date: Wed,  2 Oct 2024 14:57:41 +0200
Message-ID: <20241002125825.344831127@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index f09d96ff20652..e2e248032bfd0 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -1049,6 +1049,7 @@ nfsd_file_do_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 			status = nfserr_jukebox;
 			goto construction_err;
 		}
+		nfsd_file_put(nf);
 		open_retry = false;
 		fh_put(fhp);
 		goto retry;
-- 
2.43.0



