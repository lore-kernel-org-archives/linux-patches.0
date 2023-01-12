Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FCDA749A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:08:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69AC0C433D2;
	Thu, 12 Jan 2023 14:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532506;
	bh=f74FlJa5li0/L0Fp8ZqCCRb640nEvTPCqUDgnhKtCG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PhWz60mK8CCnwW65PmZueEsLqqrYBsdTuq9eof8lmEBZ9WYm5Ftwx3aeTIegioaHB
	 THE5hBWbgiKe8wmTfwEfrVWfba4lyLv432yLMhtrNcvFpj3KskSVqE21//lM1RQwxa
	 T5fs5pFuL4rsECvOgTWemkcR5y3YDHN2G9yP2FGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 185/783] NFSv4.2: Fix a memory stomp in decode_attr_security_label
Date: Thu, 12 Jan 2023 14:48:21 +0100
Message-Id: <20230112135532.905633458@linuxfoundation.org>
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

[ Upstream commit 43c1031f7110967c240cb6e922adcfc4b8899183 ]

We must not change the value of label->len if it is zero, since that
indicates we stored a label.

Fixes: b4487b935452 ("nfs: Fix getxattr kernel panic and memory overflow")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4xdr.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index f8c89f9f4d52..f1e599553f2b 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -4168,12 +4168,10 @@ static int decode_attr_security_label(struct xdr_stream *xdr, uint32_t *bitmap,
 			return -EIO;
 		bitmap[2] &= ~FATTR4_WORD2_SECURITY_LABEL;
 		if (len < NFS4_MAXLABELLEN) {
-			if (label) {
-				if (label->len) {
-					if (label->len < len)
-						return -ERANGE;
-					memcpy(label->label, p, len);
-				}
+			if (label && label->len) {
+				if (label->len < len)
+					return -ERANGE;
+				memcpy(label->label, p, len);
 				label->len = len;
 				label->pi = pi;
 				label->lfs = lfs;
-- 
2.35.1



