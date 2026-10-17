Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED996356A12;
	Sat, 17 Oct 2026 18:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260384; cv=none; b=flgEjLLLFGpSDaojiG8gog1k6Ei2D5dDpaHlaQgkYK3Y4gjreedLWamW4P3032KRL242sbWQLU5ysPeNRBwbI3Jt11aCl7rQVzjO4jnvAJxv5IsTg4/lNphHi4RpSTvc7EuF4tmlQWNtS+vddVRDCRnPzKZD7tWvSR7JfbtdIUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260384; c=relaxed/simple;
	bh=pJe42dr8wBI8imcAuyvuyqaIPjw0cF/suGljYyz3NUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WGlPwlOICywxUItqIz9k7UYBNzx3oE4Dpqf6gGhzzC/JDfm8RBM2C/5zELYqN7hCIkia0bkK+PR+9/53KOPcI7mgkYzehkU7IomVGJafRUyR8ySSJuRsoXcq3fSIJcUVHOsnZIBHij2hDQlFHlfDtHD69si1kdtNt9Jr1ywSRek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jKs6l5Gj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jKs6l5Gj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4634E1F000C4;
	Sat, 17 Oct 2026 18:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260383;
	bh=pkdfX6cX48NxaJ9t0auH8v0zzTw2jykWSKOPCOtQBAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jKs6l5GjtYAWGTupgOAfCspcttHGjHP8GJrt8CTs36MwqFOu6Il8SKGxgLjOQJnRO
	 CKCjf37JOlmH05HxLEQK+SYnFPmLgKF6oA9JEdDu5rV2puHNhUrmG21RpYFZVQwLeh
	 dJRb1g1sSiou104CgC6DWOPpLXGFLpJnm7oi0sWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nikhil P. Rao" <nikhil.rao@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1526/1674] pds_core: quiesce DMA before freeing resources
Date: Sat, 17 Oct 2026 18:03:18 +0200
Message-ID: <20261017160510.289175242@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikhil P. Rao <nikhil.rao@amd.com>

[ Upstream commit 6443f4f20bdae726fe01cf5946fba9742a0ffda6 ]

pdsc_teardown() frees DMA buffers but does not disable bus mastering,
leaving the device able to perform DMA after the buffers are freed.
This can lead to use-after-free if the device writes to freed memory.

Add pci_clear_master() to pdsc_teardown() to disable bus mastering
before freeing resources, ensuring all DMA is quiesced.

Add pci_set_master() to pdsc_setup() to re-enable bus mastering,
which is needed for the firmware recovery path since pdsc_teardown()
now disables it.

Signed-off-by: Nikhil P. Rao <nikhil.rao@amd.com>
Link: https://patch.msgid.link/20260604213637.3844317-1-nikhil.rao@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/amd/pds_core/core.c b/drivers/net/ethernet/amd/pds_core/core.c
index 15884b4c77c3f..07bd5bd92a2ba 100644
--- a/drivers/net/ethernet/amd/pds_core/core.c
+++ b/drivers/net/ethernet/amd/pds_core/core.c
@@ -452,6 +452,8 @@ int pdsc_setup(struct pdsc *pdsc, bool init)
 {
 	int err;
 
+	pci_set_master(pdsc->pdev);
+
 	err = pdsc_dev_init(pdsc);
 	if (err)
 		return err;
@@ -483,6 +485,8 @@ void pdsc_teardown(struct pdsc *pdsc, bool removing)
 	if (!pdsc->pdev->is_virtfn)
 		pdsc_devcmd_reset(pdsc);
 
+	pci_clear_master(pdsc->pdev);
+
 	pdsc_core_uninit(pdsc);
 
 	kfree(pdsc->viftype_status);
-- 
2.53.0



