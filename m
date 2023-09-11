Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7F012B6D
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:28:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2CFC433CD;
	Mon, 11 Sep 2023 15:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694446138;
	bh=gdWuEBppFnj1VvHN2G5dDwTSmLyGQ1r0GbUinLcwlHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m+LRg7MIVJxS8ZQYux6TgwasFXLW5j6ivWT65A2ubr7OtkjO2wWU+qqT37HEypf9o
	 q+324CNqKGCCeGcLB5FXqHSsc/rcePTBBHa9H3iRJFL6mrE+fqgnG5zpNBYbyPoX5U
	 LsNvyKmu7UNI20/OZijMdndVopyJ9zxdUCLS6iKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 6.1 595/600] NFSv4.2: Fix a potential double free with READ_PLUS
Date: Mon, 11 Sep 2023 15:50:28 +0200
Message-ID: <20230911134651.219445619@linuxfoundation.org>
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

commit 43439d858bbae244a510de47f9a55f667ca4ed52 upstream.

kfree()-ing the scratch page isn't enough, we also need to set the pointer
back to NULL to avoid a double-free in the case of a resend.

Fixes: fbd2a05f29a9 (NFSv4.2: Rework scratch handling for READ_PLUS)
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/nfs4proc.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -5444,10 +5444,18 @@ static bool nfs4_read_plus_not_supported
 	return false;
 }
 
-static int nfs4_read_done(struct rpc_task *task, struct nfs_pgio_header *hdr)
+static inline void nfs4_read_plus_scratch_free(struct nfs_pgio_header *hdr)
 {
-	if (hdr->res.scratch)
+	if (hdr->res.scratch) {
 		kfree(hdr->res.scratch);
+		hdr->res.scratch = NULL;
+	}
+}
+
+static int nfs4_read_done(struct rpc_task *task, struct nfs_pgio_header *hdr)
+{
+	nfs4_read_plus_scratch_free(hdr);
+
 	if (!nfs4_sequence_done(task, &hdr->res.seq_res))
 		return -EAGAIN;
 	if (nfs4_read_stateid_changed(task, &hdr->args))


