Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B60012D74D;
	Tue, 18 Jun 2024 13:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716828; cv=none; b=BTct29NCb2K7ncp3FmujmNenap5mwW61wBUh4flVvt5o+NbDLHEYF/7nGp39lXJnti3mB9Q4E0H5CWJCwos9I9A7y1swIoDMOKBMqTEUrmFLfH7LRgN32/TwSLYWtcfZhVSfsBzR6tk3GrgP6UKXAauMfXhaWHPu7TVNHOjg/aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716828; c=relaxed/simple;
	bh=KRZc3Eeg2g/UKlQAoyA7GguHMOrky6dIouDKP89Q36I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H1K4oRhIE2vxAWfGW2SUMiJxBRAFqps/QT+V7/wWmz0Hf+sZaPXWlC+oU8vTkgCQS3/3jWLZONh+ZSZCBje+SXmJEBx1ujv/v2T6ZQEBzY1u12sUWdBbJTh6mvq9q8HFN5Cc8qiQZXXke94v/v3/t+NG5U2mc3jqKoSkehdmbY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rmSJmYZn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rmSJmYZn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 888C9C3277B;
	Tue, 18 Jun 2024 13:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716827;
	bh=KRZc3Eeg2g/UKlQAoyA7GguHMOrky6dIouDKP89Q36I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rmSJmYZncdDtYNSYsLCVnrjvxJtYq9sGsRz5rneQcOquYD83WVEUDnVVTdsNvjP7j
	 AwwEm7fdtc1TrB/+niPYjbK8ZTx8cW9wvSYIHZsemZ2sQLBsCUKpMc5NIJECCgIJuc
	 BsuQGkmp3QN4TD0UrvcLUOSQU/J5A7z7w4GK0bwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tavian Barnes <tavianator@tavianator.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 759/770] nfsd: Fix creation time serialization order
Date: Tue, 18 Jun 2024 14:40:12 +0200
Message-ID: <20240618123436.568046419@linuxfoundation.org>
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

From: Tavian Barnes <tavianator@tavianator.com>

[ Upstream commit d7dbed457c2ef83709a2a2723a2d58de43623449 ]

In nfsd4_encode_fattr(), TIME_CREATE was being written out after all
other times.  However, they should be written out in an order that
matches the bit flags in bmval1, which in this case are

    #define FATTR4_WORD1_TIME_ACCESS        (1UL << 15)
    #define FATTR4_WORD1_TIME_CREATE        (1UL << 18)
    #define FATTR4_WORD1_TIME_DELTA         (1UL << 19)
    #define FATTR4_WORD1_TIME_METADATA      (1UL << 20)
    #define FATTR4_WORD1_TIME_MODIFY        (1UL << 21)

so TIME_CREATE should come second.

I noticed this on a FreeBSD NFSv4.2 client, which supports creation
times.  On this client, file times were weirdly permuted.  With this
patch applied on the server, times looked normal on the client.

Fixes: e377a3e698fb ("nfsd: Add support for the birth time attribute")
Link: https://unix.stackexchange.com/q/749605/56202
Signed-off-by: Tavian Barnes <tavianator@tavianator.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index a81938c1e3efb..5a68c62864925 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3364,6 +3364,11 @@ nfsd4_encode_fattr(struct xdr_stream *xdr, struct svc_fh *fhp,
 		if (status)
 			goto out;
 	}
+	if (bmval1 & FATTR4_WORD1_TIME_CREATE) {
+		status = nfsd4_encode_nfstime4(xdr, &stat.btime);
+		if (status)
+			goto out;
+	}
 	if (bmval1 & FATTR4_WORD1_TIME_DELTA) {
 		p = xdr_reserve_space(xdr, 12);
 		if (!p)
@@ -3380,11 +3385,6 @@ nfsd4_encode_fattr(struct xdr_stream *xdr, struct svc_fh *fhp,
 		if (status)
 			goto out;
 	}
-	if (bmval1 & FATTR4_WORD1_TIME_CREATE) {
-		status = nfsd4_encode_nfstime4(xdr, &stat.btime);
-		if (status)
-			goto out;
-	}
 	if (bmval1 & FATTR4_WORD1_MOUNTED_ON_FILEID) {
 		u64 ino = stat.ino;
 
-- 
2.43.0



