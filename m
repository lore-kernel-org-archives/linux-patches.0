Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C566E3A9DAF;
	Wed, 21 Jan 2026 18:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019720; cv=none; b=ZA31LgHex13RjvoXRH88ZC04XcI8HbT6sA5Kcg1KfqtW/8cwNTNn80yN7urieWUF59YX0V/2UqFZds7J0CP6lx1xIYYsObungPZHYn7OexlvtTzqm/jZIN9gcxLvs/bHWj00UHVilIBrElpps1uL57YxyvVA0HhpXm4ePvk4YSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019720; c=relaxed/simple;
	bh=/1XK91EmeLM0NmRtl33kVUP2CiMjHr37GfpH4QAW9eM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Afn/foOILZJyX/WdIiYQc21zDjOnMEeFcQETvpmPApJycDq4n0N7IOsFoRDVFVN1TIQ49S1ZXG9qFktw4wcFl6u5tuT5Pr92FmpU3AaL9tic6530kYtVzK0F9N3mgTMblDjRwAzLRudrRxfv3QL5Q/A7GgOiz70Q8ZgfLVXWpvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hfo/0xgP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hfo/0xgP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A960C4CEF1;
	Wed, 21 Jan 2026 18:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019720;
	bh=/1XK91EmeLM0NmRtl33kVUP2CiMjHr37GfpH4QAW9eM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hfo/0xgP8sk01mIUCYuYaGsccwJjHOs3LF9ThsmTRULCwIJnkiuTk3rFBZcO/K7gD
	 Wcr2T1rO5KgM10O8IOemU6REI30p0BhHC9K2pwEsuXe5XxZxdQfoRu94k3X+kZYu9R
	 b/3vnUiz0IJsTf6LzpuhZMxBmGr1Zoxb6thi/Vkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.12 087/139] EDAC/x38: Fix a resource leak in x38_probe1()
Date: Wed, 21 Jan 2026 19:15:35 +0100
Message-ID: <20260121181414.588823740@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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


