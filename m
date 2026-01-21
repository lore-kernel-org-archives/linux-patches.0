Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103C53A1D10;
	Wed, 21 Jan 2026 18:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019724; cv=none; b=sz3pazIarcb63FFC+pfyBtuuBaOqG3mI10iTOTi8BC6aJlKznk6yEcScf0SILvC4/E4yYfAqEfOmORmzQdk0Bh3Ka+1X66GLhwy+34EFJTOzYAIT18491Sq2gjIF70fzcA0D9hALo/aK9NpDs2WmN6056/8lmvaA3BSZxP3sc0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019724; c=relaxed/simple;
	bh=hbJW6k+8ae4bNPIBh9Z7qX9pjzz7xRuBCuLgnI2Udus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C/7TA6clvvwce11ozN+D75eBjn3anImVxMq63YbOj3P40poVGxrqIqOyGWEKEt9hERrKCAs4rSgDQyfLq/uxM5eRvBztPXIslAFX0rLvdOxuZSwrSM2KNreZcVhPHcE3r+18dyjQtRWG9bsrVVED6tS33gR842MUsEd+neRkzhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JLK+FQnb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JLK+FQnb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BB01C16AAE;
	Wed, 21 Jan 2026 18:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019723;
	bh=hbJW6k+8ae4bNPIBh9Z7qX9pjzz7xRuBCuLgnI2Udus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JLK+FQnbOWOmBrWkejPkm+yGycU0r2INAw9LAOIY/QnZgptDaTcOvf/ZxqLWCH19d
	 EISHMDX/+rebGLSEHM7UwXcLVaIq1haj3JjUuMYK7BJuXslliTS7HYQrRItbDBhk4z
	 H5zmXV3H1j0GW8cYeHkC9ITFzcH8k+g124Yr1MBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.12 088/139] EDAC/i3200: Fix a resource leak in i3200_probe1()
Date: Wed, 21 Jan 2026 19:15:36 +0100
Message-ID: <20260121181414.623554342@linuxfoundation.org>
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
@@ -358,10 +358,11 @@ static int i3200_probe1(struct pci_dev *
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
 
@@ -421,9 +422,9 @@ static int i3200_probe1(struct pci_dev *
 	return 0;
 
 fail:
+	edac_mc_free(mci);
+unmap:
 	iounmap(window);
-	if (mci)
-		edac_mc_free(mci);
 
 	return rc;
 }


