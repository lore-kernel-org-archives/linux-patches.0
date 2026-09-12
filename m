Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F6B47CA85;
	Sat, 12 Sep 2026 13:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219123; cv=none; b=Zaoztu4+YtUyeUcMV60CqKb40aYt6wK79vIaeO2NDLi9Mk8HJ8sa/CLw7fBCIII/MZn7C+s1vxdy0XESSU6nOBIRIZGnTCdsud+P/4wGc/nNvQnxYShjVcv0OFrR19QjQZkRWva/qgnSKSV3yF8qi+VhkOuVfl602aP0ovPlMRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219123; c=relaxed/simple;
	bh=5fvaJrgax7fjNgWqQRefHz695LKxxT47aQNqGy+9tTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ETgHXVXjIPXPJ9t3oymGRpUjN/zbTFyW6E6BkAQT1vOKOlAB49zTwkeByVHIIZ+pknZE9FU/WyGpQtPDkqCwqMoSuj27LsBmDyNhb7E3j30k53IsYhonVCjD9IXAkQkiPu0yPq0s9FBPE7WhKkagvADJezCR5+F98rR7s9TF2tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w9Aekq7L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w9Aekq7L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A21FA1F000FF;
	Sat, 12 Sep 2026 13:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219122;
	bh=ZEHoVEf4SPI/IG112JU/0xQuFSsVs4I1np3U8FHcjjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w9Aekq7LeJGBgB88ehTD4rVJSx3md2OXj/Z4CXRjRJKYNVL2v/5G4StRnhneWbvZA
	 qNyGPAIXnrACIXqARpWHDtTrQcDEQ3NfTj2UNMQ5HufbmNaiMOHC5RuTdZopGQsFOa
	 /xeqQ0sMjzRdLwGbgrhM99fKQOMT35kvdDUc7Tgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anshumali Gaur <agaur@marvell.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1285/1376] octeontx2-af: fix NULL deref in NIX TM tree debugfs read path
Date: Sat, 12 Sep 2026 09:01:51 +0200
Message-ID: <20260912065636.177814125@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 53c2a9d6250a7..f4a4fe5f4a79e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -1659,6 +1659,12 @@ static int rvu_dbg_nix_tm_tree_display(struct seq_file *m, void *unused)
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



