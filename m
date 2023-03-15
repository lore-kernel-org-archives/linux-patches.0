Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085FA4431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:35:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 791BDC433D2;
	Wed, 15 Mar 2023 12:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883713;
	bh=PP2vOhwYJFy/p40fVDOl/oAx4CphyQWstD6rS+UDdB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DK5yRW9kz4zqSHNhtMJzsXwTPR/8cFjGpTFdQA3Z3rxuUyIS3LLRCd0p7BiayDmtc
	 DxQKGNDuANaOBq1F0OZRrhfh38ysgAPwcFZ/lMQlqNfcue9P0k/I6qcyEylxeuAsvO
	 dvMr5Caq3jLKe58M2D853m4G0GmNdr0fMCV7TNto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	flole@flole.de,
	Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 103/143] NFSD: Protect against filesystem freezing
Date: Wed, 15 Mar 2023 13:13:09 +0100
Message-Id: <20230315115743.635882067@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/vfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 0d49c6bb22eb1..59f9a8cee012a 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1037,7 +1037,9 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct nfsd_file *nf,
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
2.39.2



