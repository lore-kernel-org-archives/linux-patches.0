Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679362D8DA8;
	Wed,  4 Feb 2026 15:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217688; cv=none; b=UPgDY5+BuSlWzOHvBe7Ier+ebPPPY7Xc7CHVUzAZM2foHne4UYpUIYEFfBhTss4eSoFuI5qWHboStZOYmSms+Oo1tgLiU/YfOB3bZgzUl8yiNVGEwueM35w+yvjhWsFVH4ekRDghbz1x8fm8bARRrL/BleuIyij2M3+yiCpiLXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217688; c=relaxed/simple;
	bh=uPBlSBBnacISHW7bd258C7AuZrRKIcJrvK9JXm+Axlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iqPs5lp6+V87nZJGd9zgjjp7oJ73Zrce6MJOe8rxtaceEWCvszUqxZg7Olb+1J3cNAeo9q6ljYSOG4GUKcJ0zRZKkHl1o8cI+4+zgRmFHv3aDhBgvW0qoxUQBSf1x1U2TSaX9xvjL4blYeBsQ8i4SGaDwf1NZ6v6dtimrjKypA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J0wcsCmX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J0wcsCmX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D29BC4CEF7;
	Wed,  4 Feb 2026 15:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217688;
	bh=uPBlSBBnacISHW7bd258C7AuZrRKIcJrvK9JXm+Axlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J0wcsCmXk5Z7Dh3fbLXibuM8Higy6irq8RA7GEO/oBOMNTimx5OPaKQdnbna+DxIu
	 3Tm1kUE5kVz+HUMw11Rw3yL5FhF5t6HpsqKUj3rKV7L7O5BR9NpMIiV+h0IuxgAj51
	 jDkrNanC+BGkypmm32uDygvhftnADc1IpDKzezrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.1 055/280] EDAC/x38: Fix a resource leak in x38_probe1()
Date: Wed,  4 Feb 2026 15:37:09 +0100
Message-ID: <20260204143911.630687340@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


