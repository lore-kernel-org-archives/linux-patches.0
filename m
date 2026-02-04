Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2D5271A9A;
	Wed,  4 Feb 2026 14:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216359; cv=none; b=lNMFrDBuSoG5JAEhQq/vQYqP50QGlm9mFS9DmuL91q5jbTZgNRoy0YDmYQEADTeYUYwYyjR5iAoBnpR8qDDQfK1YooWsiXoDNLb9hUkI3bKNCz3lJvP+4A7JYSKzZNFtic12fh9VUhwkSvGF4ghyrX5hGuHy4s+e0sGsq1/16z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216359; c=relaxed/simple;
	bh=iLrD3K7qyyAWsqdqqmP6jyT8jW6dNIDIm5yq93tzVN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ic4nWEJrXSlGXdgrMrk8+nDpcbzMDMUmhzPhejYP0GABzncm9IHpcFQ7GAdJi+h0DX/Ru7zgN85MduZV3Lt0bSV6dCx+FvpyZ4GoB6mqMhP5rniWi8uha/1/0HjI3ZVvap/UDjhfZypJ7YQC+XtSASFojlpa+YMgMBLuV1DJBv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KiE3ER3Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KiE3ER3Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81270C4CEF7;
	Wed,  4 Feb 2026 14:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216358;
	bh=iLrD3K7qyyAWsqdqqmP6jyT8jW6dNIDIm5yq93tzVN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KiE3ER3QIfSeZbjzIsyJhdnyhvekpa3t+4LB+/FPXXq14Sk8OfL09nzHwhplOgyz1
	 grZQiVrNGpmPmc9Yp23s6CG/Ts5Brn09i3tJdm5U3+b9Km60hjSHpgSQF98qC+iOBu
	 Ry0nDEEkvPbOIdSIb0JiKWjuabBlU2qJ9urYHRHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 5.10 030/161] EDAC/x38: Fix a resource leak in x38_probe1()
Date: Wed,  4 Feb 2026 15:38:13 +0100
Message-ID: <20260204143852.844965853@linuxfoundation.org>
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
@@ -342,9 +342,12 @@ static int x38_probe1(struct pci_dev *pd
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
 
@@ -404,9 +407,9 @@ static int x38_probe1(struct pci_dev *pd
 	return 0;
 
 fail:
+	edac_mc_free(mci);
+unmap:
 	iounmap(window);
-	if (mci)
-		edac_mc_free(mci);
 
 	return rc;
 }


