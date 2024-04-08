Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B355879F0;
	Mon,  8 Apr 2024 13:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584694; cv=none; b=QoTrGUJdIdZqKNJHUMA5GvXV5wnfYwMvlk3sLyf2yUhKKwlsDUHgkqP8/6nLmKRl6sTBzvgNHNOJb6+1NMw1eq29/JbpAUkiQnJ2PvTfRNRfuffDk/jGVO5oAK9Nq2tUJp+7SMmE8GNU0etQgAh8eAOr7WrZIF8q2bXfDKJK5D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584694; c=relaxed/simple;
	bh=vWAoNVs6/I1T8nllvOXuQ17f+GkXAwnh6ajZxtHFt6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P/N+1qfBzzC9+RYPFOrkAiKAbHeBoDvuAZWQ0FgxcF548cHlP9ea1tFWDrdpeP5KSyYmvNS5UZrFyMnRDf3mrEHawowfXfilfFVeYUMeTDEj4hn8Cqdww9LbDJx9rvqeA5O8n1FGXUo5NJ82w7lOnFVHOUSWoRsjdiMK5x5YOf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P/Cv6T0D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P/Cv6T0D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C72BC433C7;
	Mon,  8 Apr 2024 13:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584694;
	bh=vWAoNVs6/I1T8nllvOXuQ17f+GkXAwnh6ajZxtHFt6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P/Cv6T0DiU/JhasutDF0y+vHreRVAMwwRkAZJjsa7VXgt+HTZjyTVRORmCP4U0CaM
	 bMpQkiBIL6TOHWIvMEgX7kfd4NInU2utoQvYBB1TdDExc+EZ0s0fynnlOs6KON1fOa
	 XxvdMWZ0+Zj5DB19Ev5qIHfFrt/eqmrCiuPSkX7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	flole@flole.de,
	Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 526/690] NFSD: Protect against filesystem freezing
Date: Mon,  8 Apr 2024 14:56:32 +0200
Message-ID: <20240408125418.699640953@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit fd9a2e1d513823e840960cb3bc26d8b7749d4ac2 ]

Flole observes this WARNING on occasion:

[1210423.486503] WARNING: CPU: 8 PID: 1524732 at fs/ext4/ext4_jbd2.c:75 ext4_journal_check_start+0x68/0xb0

Reported-by: <flole@flole.de>
Suggested-by: Jan Kara <jack@suse.cz>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217123
Fixes: 73da852e3831 ("nfsd: use vfs_iter_read/write")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/vfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index db7f0119433cf..690191b3d997c 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1101,7 +1101,9 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct nfsd_file *nf,
 	since = READ_ONCE(file->f_wb_err);
 	if (verf)
 		nfsd_copy_write_verifier(verf, nn);
+	file_start_write(file);
 	host_err = vfs_iter_write(file, &iter, &pos, flags);
+	file_end_write(file);
 	if (host_err < 0) {
 		nfsd_reset_write_verifier(nn);
 		trace_nfsd_writeverf_reset(nn, rqstp, host_err);
-- 
2.43.0



