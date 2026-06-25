Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1501828640B;
	Thu, 25 Jun 2026 13:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782392963; cv=none; b=m1L4IuZT6auBkrf3kfVVuHHbkNJkqUWL/1COVXVvnUe0OX5B/DOdSgMJeibhEXOQlxZRIr3QXbCB0a4jHfl/54qZXJBaBYiRtXCPmG6QsF5X0loQMLUfN17PbVLp8chSo2z9c9S6u9pUSONT6QbQzxy+llkt1ge9LgHihtW3DCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782392963; c=relaxed/simple;
	bh=CryHx8u/Y6xxKCSes2rxoCWR6yh7YZ6/Bb8o90/cSUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OFwKRN0C4eqvIP7uvU5OZHhn3J565pGQe5qK5/NefqrNNAjhquYwLhw7wJbZTmEOT+MJKcy8cEmRkojvA4pNgTAncHgK4Lu0ZBW/jt31SnMQwTBNWrRtg7Q4PdNoCEYAdXgrYj1CQtOCrnEOrWbNbszYWoLmvu/jtE7SjtteTyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OyOXl+Yu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OyOXl+Yu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5999A1F000E9;
	Thu, 25 Jun 2026 13:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782392962;
	bh=yDYLP30RNi2/UurMk/4jLIgcbGYtf9Ob3gs2PaAZ4so=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OyOXl+YuVU4F4d5mgPV6DVC45hDCiswVEAPQzBNLo/z9btIOjGN+RkWVwd6j2jBrJ
	 Ccg0HZoijrp5JnVGmu/RIXFmyuicTPa7TjRpMmhgJMIgZVE/eVd5IfN508LZvQiQvg
	 utrV57sVyyi03mjnOrGnJ7qpMosZfQ7Ia5Y1K3CI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingyu Wang <25181214217@stu.xidian.edu.cn>,
	Lukas Wunner <lukas@wunner.de>
Subject: [PATCH 7.0 15/49] agp/amd64: Fix broken error propagation in agp_amd64_probe()
Date: Thu, 25 Jun 2026 14:03:27 +0100
Message-ID: <20260625125639.643487047@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125637.527552689@linuxfoundation.org>
References: <20260625125637.527552689@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mingyu Wang <25181214217@stu.xidian.edu.cn>

commit b08472db93b1ccff84a7adec5779d47f0e9d3a30 upstream.

A NULL pointer dereference was observed in the AMD64 AGP driver when
running in a virtualized environment (e.g. qemu/kvm) without a physical
AMD northbridge. The crash occurs in amd64_fetch_size() when attempting
to dereference the pointer returned by node_to_amd_nb(0).

The root cause of this crash is broken error propagation in
agp_amd64_probe(): When no AMD northbridges are found, cache_nbs()
correctly returns -ENODEV. However, the probe function erroneously
checks the return value against exactly -1, rather than < 0.

As a result, the hardware absence error is masked, allowing the driver
to improperly proceed with initialization. It eventually calls
agp_add_bridge(), which invokes amd64_fetch_size(). Since the hardware
does not exist, node_to_amd_nb(0) returns NULL, leading to a General
Protection Fault (GPF) when accessing its ->misc member.

Fix the issue by correcting the error check in agp_amd64_probe() to
abort properly when cache_nbs() returns any negative error code. This
prevents the driver from erroneously proceeding without hardware, thereby
avoiding the subsequent NULL pointer dereference at its source.

Fixes: a32073bffc65 ("[PATCH] x86_64: Clean and enhance up K8 northbridge access code")
Signed-off-by: Mingyu Wang <25181214217@stu.xidian.edu.cn>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org # v2.6.18+
Link: https://patch.msgid.link/20260504074823.99377-1-w15303746062@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/agp/amd64-agp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -546,7 +546,7 @@ static int agp_amd64_probe(struct pci_de
 	/* Fill in the mode register */
 	pci_read_config_dword(pdev, bridge->capndx+PCI_AGP_STATUS, &bridge->mode);
 
-	if (cache_nbs(pdev, cap_ptr) == -1) {
+	if (cache_nbs(pdev, cap_ptr) < 0) {
 		agp_put_bridge(bridge);
 		return -ENODEV;
 	}


