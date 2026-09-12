Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B861D370AFD;
	Sat, 12 Sep 2026 09:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205015; cv=none; b=Mb2TNpNrgO25HcbeI53h7qU26s3TejNyIRujTt8QP8f6aYuB48fRY6wmqCmt+XwlzfpZJljXf9tlAVwYibGjF1YzaiQLIySeoppYgwU9mMsNiY4KTlWE3JegB6tRh3W8yZP53gc+Fd14cTBOeA/ANXVLvwhKqkOtYWlQ9IHP038=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205015; c=relaxed/simple;
	bh=vIfJgU4Z5hjrW96p6ULFRz7r3dhpUwb8GkwI9HTANN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NkWqcTOGKZtaU7cn1ljD7W/7dneN1BZOjaZktQJ7HS87O7+QLA2eDzQ+tl0wtOxnB85BW2r0xDkJUrn3wofS8Fd7rMQxV/1KKfWB/i/6vCWX75sDQ8bojR5BR5egwxWu5dyDBluVrPUeAnes0H4hYMIp3YP2SnG94lNp9DQuRsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QhHBwaqM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QhHBwaqM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5001F000FF;
	Sat, 12 Sep 2026 09:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205013;
	bh=7WeLMmLj1zozPp12a9uYwteSLEIL6ZqeJjEBtb2+tTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QhHBwaqMw2MVxojEIz3dWzhjVRZdeMA+SxPznh1pXmNQoqYMwWFgdTBFdL7Co5D5D
	 oOs2dVEGa9K6tWhDpV039/cuKKHiL6rJvb7RaFqVNc+5IxS1/kOGxRylyXB1813aJJ
	 wrsu/lCLro94uggVoryavTplkk7kftUTTOiqD1p0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anshumali Gaur <agaur@marvell.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1730/1815] octeontx2-af: fix NULL deref in NIX TM tree debugfs read path
Date: Sat, 12 Sep 2026 08:58:00 +0200
Message-ID: <20260912065729.590613812@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anshumali Gaur <agaur@marvell.com>

[ Upstream commit ec65631bd5ec251cdf67a4919fac7a3149a6e235 ]

rvu_dbg_nix_tm_tree_display() dereferences pfvf->sq_ctx without
checking whether the SQ context has been allocated. Reading
/sys/kernel/debug/octeontx2/nix/tm_tree for a NIX LF whose transmit
queues are not set up triggers a kernel oops.

Guard the read path the same way rvu_dbg_nix_tm_tree_write() already
does and return -EINVAL with a seq_file message when sq_ctx is NULL.

Fixes: b907194a5d5b ("octeontx2-af: Add debugfs support to dump NIX TM topology")
Signed-off-by: Anshumali Gaur <agaur@marvell.com>
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Link: https://patch.msgid.link/20260820050333.2606095-1-rkannoth@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index 3456313d3b3c0..22ee996768796 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -1697,6 +1697,12 @@ static int rvu_dbg_nix_tm_tree_display(struct seq_file *m, void *unused)
 		return -EINVAL;
 
 	pfvf = rvu_get_pfvf(rvu, pcifunc);
+
+	if (!pfvf->sq_ctx) {
+		seq_printf(m, "SQ context is not initialized for pcifunc 0x%x\n", pcifunc);
+		return -EINVAL;
+	}
+
 	max_id = pfvf->sq_ctx->qsize;
 
 	memset(&aq_req, 0, sizeof(struct nix_aq_enq_req));
-- 
2.53.0



