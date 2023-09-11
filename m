Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F0111710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:18:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD93C433C7;
	Mon, 11 Sep 2023 15:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445511;
	bh=HhBd57wcKY2OqcdKiPd34J1MjAt9YYrER6oiHuEIQFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y52sBq5lUYtbg8bEU+pO4M69LY/xRwsSo6ykHR3DfIPo3OpgxmujVVmDZ4f6b/oCY
	 EjjEzkhDG1zd/vhNO/ITfCvdTK9Ly3xzPQUX84mmYSJMIF0EAtNSP5LmYOgovi8mNo
	 fDC/u9Ke4NVPEb/9nQAXoq/Lirwtt63CDKw1vIk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 374/600] NFSv4.2: Fix up READ_PLUS alignment
Date: Mon, 11 Sep 2023 15:46:47 +0200
Message-ID: <20230911134644.718535351@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

From: Anna Schumaker <Anna.Schumaker@Netapp.com>

[ Upstream commit f8527028a7e52da884055c401abc04e0b0c84285 ]

Assume that the first segment will be a DATA segment, and place the data
directly into the xdr pages so it doesn't need to be shifted.

Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Stable-dep-of: 8d18f6c5bb86 ("NFSv4.2: Fix READ_PLUS size calculations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs42xdr.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/nfs42xdr.c b/fs/nfs/nfs42xdr.c
index ae034a1c53efd..ef3b150970ff6 100644
--- a/fs/nfs/nfs42xdr.c
+++ b/fs/nfs/nfs42xdr.c
@@ -47,13 +47,14 @@
 #define decode_deallocate_maxsz		(op_decode_hdr_maxsz)
 #define encode_read_plus_maxsz		(op_encode_hdr_maxsz + \
 					 encode_stateid_maxsz + 3)
-#define NFS42_READ_PLUS_SEGMENT_SIZE	(1 /* data_content4 */ + \
+#define NFS42_READ_PLUS_DATA_SEGMENT_SIZE \
+					(1 /* data_content4 */ + \
 					 2 /* data_info4.di_offset */ + \
-					 2 /* data_info4.di_length */)
+					 1 /* data_info4.di_length */)
 #define decode_read_plus_maxsz		(op_decode_hdr_maxsz + \
 					 1 /* rpr_eof */ + \
 					 1 /* rpr_contents count */ + \
-					 2 * NFS42_READ_PLUS_SEGMENT_SIZE)
+					 NFS42_READ_PLUS_DATA_SEGMENT_SIZE)
 #define encode_seek_maxsz		(op_encode_hdr_maxsz + \
 					 encode_stateid_maxsz + \
 					 2 /* offset */ + \
-- 
2.40.1



