Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C95749A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:08:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E69C433EF;
	Thu, 12 Jan 2023 14:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532503;
	bh=WCzUZoamPTvD6yyxadxEytmVtfKdZD7Z4bt8uArnGKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZrFy+SPOaGP0izHmccT6SbyXXgguoCLjM+AlqDKfm4zmf8vHOqqaujbETKbFFu4fi
	 1AJr3sCsdsMQMhq130ltjNLQ+CjxqrAJ2yC1P4fW6U236jHIMvZTXyklBgw1rSii+A
	 OCxSHBZ/M3YjzmFTyS+rMEVkuQq+slFGCdClxlTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 184/783] NFSv4.2: Clear FATTR4_WORD2_SECURITY_LABEL when done decoding
Date: Thu, 12 Jan 2023 14:48:20 +0100
Message-Id: <20230112135532.857542609@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit eef7314caf2d73a94b68ba293cd105154d3a664e ]

We need to clear the FATTR4_WORD2_SECURITY_LABEL bitmap flag
irrespective of whether or not the label is too long.

Fixes: aa9c2669626c ("NFS: Client implementation of Labeled-NFS")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4xdr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index e2f0e3446e22..f8c89f9f4d52 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -4166,6 +4166,7 @@ static int decode_attr_security_label(struct xdr_stream *xdr, uint32_t *bitmap,
 		p = xdr_inline_decode(xdr, len);
 		if (unlikely(!p))
 			return -EIO;
+		bitmap[2] &= ~FATTR4_WORD2_SECURITY_LABEL;
 		if (len < NFS4_MAXLABELLEN) {
 			if (label) {
 				if (label->len) {
@@ -4178,7 +4179,6 @@ static int decode_attr_security_label(struct xdr_stream *xdr, uint32_t *bitmap,
 				label->lfs = lfs;
 				status = NFS_ATTR_FATTR_V4_SECURITY_LABEL;
 			}
-			bitmap[2] &= ~FATTR4_WORD2_SECURITY_LABEL;
 		} else
 			printk(KERN_WARNING "%s: label too long (%u)!\n",
 					__func__, len);
-- 
2.35.1



