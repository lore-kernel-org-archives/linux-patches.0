Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31581875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:03:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395C1C433D2;
	Wed, 28 Dec 2022 16:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243394;
	bh=3ROR7Pygs5uRnlq+T2ja4v4/0meU851q6weNso+gY1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hSMleAgMiqAkc4UCwVVtv9uHLjN01S5lUjp6ks0LRpQIkF2ES5xTRjxSjU4yTTfUd
	 tmd2ey5Fs1SCSUR6XotZZrpyM5HG/t2GEr+BoPdvUmP34i1E6vTP+6LM1fOGf3aL24
	 V6eOFFkWSW2aAYPuZvUgtCtnYpgXn74dfos/rYRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0488/1146] NFSv4.2: Set the correct size scratch buffer for decoding READ_PLUS
Date: Wed, 28 Dec 2022 15:33:47 +0100
Message-Id: <20221228144343.439949547@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Anna Schumaker <Anna.Schumaker@Netapp.com>

[ Upstream commit 36357fe74ef736524a29fbd3952948768510a8b9 ]

The scratch_buf array is 16 bytes, but I was passing 32 to the
xdr_set_scratch_buffer() function. Fix this by using sizeof(), which is
what I probably should have been doing this whole time.

Fixes: d3b00a802c84 ("NFS: Replace the READ_PLUS decoding code")
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs42xdr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/nfs42xdr.c b/fs/nfs/nfs42xdr.c
index fe1aeb0f048f..2fd465cab631 100644
--- a/fs/nfs/nfs42xdr.c
+++ b/fs/nfs/nfs42xdr.c
@@ -1142,7 +1142,7 @@ static int decode_read_plus(struct xdr_stream *xdr, struct nfs_pgio_res *res)
 	if (!segs)
 		return -ENOMEM;
 
-	xdr_set_scratch_buffer(xdr, &scratch_buf, 32);
+	xdr_set_scratch_buffer(xdr, &scratch_buf, sizeof(scratch_buf));
 	status = -EIO;
 	for (i = 0; i < segments; i++) {
 		status = decode_read_plus_segment(xdr, &segs[i]);
-- 
2.35.1



