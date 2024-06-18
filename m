Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6FE13E022;
	Tue, 18 Jun 2024 12:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714672; cv=none; b=WTN/sAosNcvaARIGSEQSRJeTQET/JQFU4Dv4jR8glbrrZkRPECUTGnfhkjY+PYqGL7PMp5PLYLskrtDznm8Gz77s9vYz1x/VSvVe72RF5mdhOhW1o/NvFg1bmTfHosCVw/4DBNILwtY1ALN4TC96ZBO4jG/RFM79ovn/8rvUeAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714672; c=relaxed/simple;
	bh=LwY8M2tNi8yX0wXegODJS/hXCeMVvaBSM12jfVl0Bmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YPkfFh1A0r8N9ozR+06547LnJpcPcH/Z/SsCH3euYcniNnUpy8QaN8w6oP419L5sEhwGFzP3RnMid2xARfLPZcG5LPQYwblC5W4HBlT5SJjMow71zYdJGln8FQXuFM6VfDUTfDbo2usL3jUrktuf7mEBWY0+0ebB1MFGfGPUqBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=suSC9ctr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="suSC9ctr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FB3DC3277B;
	Tue, 18 Jun 2024 12:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714669;
	bh=LwY8M2tNi8yX0wXegODJS/hXCeMVvaBSM12jfVl0Bmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=suSC9ctrzwehiqk+hqcjuN11WRWvR/ZqY4ERgxDR7Hfj/ZCfjRBiBQMko0/OXHwBi
	 eWqOv1okBxxMBXJO8OGLwgiZQ3M6CwH7lQKAu2Di34gxuhfqqIDlhjn6KppkKJL8XO
	 TeftsH5n60x4mLVP1N2A8Z9pfppO6lCIPPr5V3Ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 049/770] NFSD: Replace READ* macros in nfsd4_decode_read()
Date: Tue, 18 Jun 2024 14:28:22 +0200
Message-ID: <20240618123409.184430292@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 3909c3bc604688503e31ddceb429dc156c4720c1 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 149948393ccb1..c9652040d748b 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1218,16 +1218,17 @@ nfsd4_decode_putpubfh(struct nfsd4_compoundargs *argp, void *p)
 static __be32
 nfsd4_decode_read(struct nfsd4_compoundargs *argp, struct nfsd4_read *read)
 {
-	DECODE_HEAD;
+	__be32 status;
 
-	status = nfsd4_decode_stateid(argp, &read->rd_stateid);
+	status = nfsd4_decode_stateid4(argp, &read->rd_stateid);
 	if (status)
 		return status;
-	READ_BUF(12);
-	p = xdr_decode_hyper(p, &read->rd_offset);
-	read->rd_length = be32_to_cpup(p++);
+	if (xdr_stream_decode_u64(argp->xdr, &read->rd_offset) < 0)
+		return nfserr_bad_xdr;
+	if (xdr_stream_decode_u32(argp->xdr, &read->rd_length) < 0)
+		return nfserr_bad_xdr;
 
-	DECODE_TAIL;
+	return nfs_ok;
 }
 
 static __be32
-- 
2.43.0



