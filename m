Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B597E
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:08:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F05FC433D2;
	Sun, 22 Jan 2023 15:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400102;
	bh=gkdDlIqVtB+arxvu2drDuPw+bpSMsUuv8uQgDM5h/fY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cNGSXpkQciwR8m6XmpBRHIiAu2BDzrZ6wXPs+VkQ9gG0M7r65Bqq0E0PvnQ6nc947
	 XmC6li4LEzDptBIFukBHzH+kvAmwbUrCZs4oOHB3bzO9WkGJbGfNPBmSasiKHYfJzT
	 BthmNXqztyO0XH0GtCwq14N+jrqMbvGIpZbQnM78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <kolga@netapp.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 01/37] pNFS/filelayout: Fix coalescing test for single DS
Date: Sun, 22 Jan 2023 16:03:58 +0100
Message-Id: <20230122150219.618306203@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150219.557984692@linuxfoundation.org>
References: <20230122150219.557984692@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Olga Kornievskaia <olga.kornievskaia@gmail.com>

[ Upstream commit a6b9d2fa0024e7e399c26facd0fb466b7396e2b9 ]

When there is a single DS no striping constraints need to be placed on
the IO. When such constraint is applied then buffered reads don't
coalesce to the DS's rsize.

Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/filelayout/filelayout.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/nfs/filelayout/filelayout.c b/fs/nfs/filelayout/filelayout.c
index e8e825497cbd..015d39ac2c8f 100644
--- a/fs/nfs/filelayout/filelayout.c
+++ b/fs/nfs/filelayout/filelayout.c
@@ -837,6 +837,12 @@ filelayout_alloc_lseg(struct pnfs_layout_hdr *layoutid,
 	return &fl->generic_hdr;
 }
 
+static bool
+filelayout_lseg_is_striped(const struct nfs4_filelayout_segment *flseg)
+{
+	return flseg->num_fh > 1;
+}
+
 /*
  * filelayout_pg_test(). Called by nfs_can_coalesce_requests()
  *
@@ -857,6 +863,8 @@ filelayout_pg_test(struct nfs_pageio_descriptor *pgio, struct nfs_page *prev,
 	size = pnfs_generic_pg_test(pgio, prev, req);
 	if (!size)
 		return 0;
+	else if (!filelayout_lseg_is_striped(FILELAYOUT_LSEG(pgio->pg_lseg)))
+		return size;
 
 	/* see if req and prev are in the same stripe */
 	if (prev) {
-- 
2.35.1



