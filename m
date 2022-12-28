Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6681863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:47:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC67C433D2;
	Wed, 28 Dec 2022 15:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242421;
	bh=D3Qpo4WvRoM3MQEmckjJHuzWqUjNIxWOpDs4bzQ4Zc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CX/zL1zkYpcxDZAzkBbdry307VkYS5D0WTclJvDYEXk/Ewrz05Ig7wkrbtVKYbB0w
	 mLf5r2lvgF6nLkOAlOJ2RzKTFZZwpHGGi94mRuvMg5UtF2sETIqZdpkc9G+pHwKWwh
	 Ct8RqIDyswZXmMUA1QcHActt21LxXbGKN7k3n6V8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0408/1073] NFSv4.2: Fix a memory stomp in decode_attr_security_label
Date: Wed, 28 Dec 2022 15:33:16 +0100
Message-Id: <20221228144339.101275273@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index 9103e022376a..deec76cf5afe 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -4236,12 +4236,10 @@ static int decode_attr_security_label(struct xdr_stream *xdr, uint32_t *bitmap,
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



