Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603AD1C5D77;
	Wed,  4 Feb 2026 14:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216362; cv=none; b=eY7NFTybUoyHzOPakOxW41Zsad0i4ZN6um27AqO2IKriPCEn9ilae6GTGiE6RhqLy7lGZ5C15PK4j3lYYK7cRTpGjdSWRQIRIB/jxHA4+fkhUrdlRLJ+QqoRvtCKIDs4/G7zcw5f+P5nx3RbWyQxAf5C5PosacUnIAA+V92Bd0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216362; c=relaxed/simple;
	bh=sosSK0FlF57JsLeVMkgvlCIv2B3pxlDTFGNmiy7PBVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TYbBf8TjlHcrBWPZXpG9lRnZIsMUvYefMWDKSmZ8BhBibDfaJGliRB3UYkSdsHQAioi3Fn3XOEIkRZA+Mt4fKn732pA9ogTRIUMC+wyU71h3hJwTWGk/JpnfoSyFSwSwjqLgZpJRJw8w1OEqgeLshUtZn4J1+tjhc5TzEkljaWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZLggdc47; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZLggdc47"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C610EC116C6;
	Wed,  4 Feb 2026 14:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216362;
	bh=sosSK0FlF57JsLeVMkgvlCIv2B3pxlDTFGNmiy7PBVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZLggdc47SjlFw0U/TxUhFkxXlEhEeYnz2SUzVojiX3qmgTzjN9vQz60b8yJKi7bBF
	 VfxcA/ClQba5DL5UuF16Ljy87h9IJRDHQIavY8scwPqjwV8je3evpou9kfjs+xlpc4
	 BRR+iboRemOThdZiDPOB/99jnZmYPo99doFmag4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 5.10 031/161] EDAC/i3200: Fix a resource leak in i3200_probe1()
Date: Wed,  4 Feb 2026 15:38:14 +0100
Message-ID: <20260204143852.880616824@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

commit d42d5715dcb559342ff356327b241c53a67584d9 upstream.

If edac_mc_alloc() fails, also unmap the window.

  [ bp: Use separate labels, turning it into the classic unwind pattern. ]

Fixes: dd8ef1db87a4 ("edac: i3200 memory controller driver")
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251223123202.1492038-1-lihaoxiang@isrc.iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/i3200_edac.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/edac/i3200_edac.c
+++ b/drivers/edac/i3200_edac.c
@@ -359,10 +359,11 @@ static int i3200_probe1(struct pci_dev *
 	layers[1].type = EDAC_MC_LAYER_CHANNEL;
 	layers[1].size = nr_channels;
 	layers[1].is_virt_csrow = false;
-	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers,
-			    sizeof(struct i3200_priv));
+
+	rc = -ENOMEM;
+	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers, sizeof(struct i3200_priv));
 	if (!mci)
-		return -ENOMEM;
+		goto unmap;
 
 	edac_dbg(3, "MC: init mci\n");
 
@@ -422,9 +423,9 @@ static int i3200_probe1(struct pci_dev *
 	return 0;
 
 fail:
+	edac_mc_free(mci);
+unmap:
 	iounmap(window);
-	if (mci)
-		edac_mc_free(mci);
 
 	return rc;
 }


