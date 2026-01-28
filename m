Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D534A35FF47;
	Wed, 28 Jan 2026 15:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614201; cv=none; b=M4qrI/4yNtnsqbcX0TPqrZoZgYG7HIvJ5LJAp1eOAScm/aXqjW5ceA8/t2Th5fEvhutcHgRYXoIJtuhB01WoZ2dmcQjNQroHGFj8suOe7yXkBasCBbe0thNYdqkbAN+wbXOq1hMbxyy0mXjEzK0ymuvuDCkEUMyhILuIpauSO70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614201; c=relaxed/simple;
	bh=nkTtNSdwe5r/JuHGzf4xFxHlLPDgxcmeImTHTqbES90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ml1UoR5WZUoSUtZRrHMiQFnpVSMnZJDsWGIT59uPUfCiKtMgP7XaJJFBuZ66GzEr/72iE8639NyeE6wPzx4ACtgrMDF+2hK4Ut8lt56qXVUOtsw6vwAsRV26Towzgu22vuw0bmKyGNpKi3n0Eqk6C7h7OdBpSm0Fx3zYTOHSGyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zKcxKu9w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zKcxKu9w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E487C116C6;
	Wed, 28 Jan 2026 15:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614201;
	bh=nkTtNSdwe5r/JuHGzf4xFxHlLPDgxcmeImTHTqbES90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zKcxKu9wSgNDcS13uEGe/Wo4nv4zeqeGunLpxQvDwTfoFdF1D9iBUjhXzn8QgxIMf
	 R9bymtLjOxFOr8OBsFNhcMEXCqES4E+ZS79rBSAuXOAwF+ewEQ+CcPG74+Y1ryuN3g
	 Aai+UyQSvNFo77LWCIQy2g1B1TJYtWx5Y+lIhyBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.6 064/254] EDAC/x38: Fix a resource leak in x38_probe1()
Date: Wed, 28 Jan 2026 16:20:40 +0100
Message-ID: <20260128145347.003099367@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

commit 0ff7c44106b4715fc27a2e455d9f57f1dfcfd54f upstream.

If edac_mc_alloc() fails, also unmap the window.

  [ bp: Use separate labels, turning it into the classic unwind pattern. ]

Fixes: df8bc08c192f ("edac x38: new MC driver module")
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251223124350.1496325-1-lihaoxiang@isrc.iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/x38_edac.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/edac/x38_edac.c
+++ b/drivers/edac/x38_edac.c
@@ -341,9 +341,12 @@ static int x38_probe1(struct pci_dev *pd
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = x38_channel_num;
 	layers[1].is_virt_csrow = false;
+
+
+	rc = -ENOMEM;
 	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, 0);
 	if (!mci)
-		return -ENOMEM;
+		goto unmap;
 
 	edac_dbg(3, "MC: init mci\n");
 
@@ -403,9 +406,9 @@ static int x38_probe1(struct pci_dev *pd
 	return 0;
 
 fail:
+	edac_mc_free(mci);
+unmap:
 	iounmap(window);
-	if (mci)
-		edac_mc_free(mci);
 
 	return rc;
 }


