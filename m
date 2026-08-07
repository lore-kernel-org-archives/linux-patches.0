Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B08472F9A;
	Fri,  7 Aug 2026 15:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117127; cv=none; b=cg6WJXM1Dwtr3tNVb+tBWm4VshEcOZ2vzvqZE5NYLH1WWXLtGJ9w81WegHtEIorCMEeG59F9RTzBeSn3rRNQOQaCj2/9WLAtTQ+NyH7iwqMpfGubp9UYOcQfaA/sFpPcd8amcipRbo+I4V+qY8YLxwKDkTCcc1dWjKFFgSTEtwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117127; c=relaxed/simple;
	bh=UaDdUi0bSn4B5ZPJB8i92ktKqDSO2ZrH7BAFnBCoJG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fzOMMO7T9K1ACqSs5xpEUPrm+6ofINpeohSHsNd60mXyTBaCMuJ9yQCGV2lJJFQ7c4dd1uptb34qxz8vW0eOEVAjiBHDZBroduZDWTSSlXQvjyjjNBNPT/bE85Tl0Pd9rvwPBE85DOFROC9hvscOgNXUPB1VCQc2tqOc/WiOl/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WQ3rXiOE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WQ3rXiOE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 466241F000E9;
	Fri,  7 Aug 2026 15:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117125;
	bh=xbKqF6BoyH65XyriFCvtxVTR/HvWVQJKAiHKLjCVofg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WQ3rXiOElB8Tgw/UC/nIzDhEOgnFU/wABXddeq1DIePt5wdUwWaKtQ0F0RlT4cO+5
	 FrhDEI/sTRqpuNnAgv5HdufEfv/WTriFG+Ozuszf3sHe5RVHgccfd/GdPu7zp8/cDI
	 JZtsi0Xq7LI07nVTfRLAiw4Z/N0WXxeKwjpFI16s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Linus Walleij <linusw@kernel.org>
Subject: [PATCH 7.1 207/438] pinctrl: devicetree: dont free uninitialized dev_name on error path
Date: Fri,  7 Aug 2026 16:36:43 +0200
Message-ID: <20260807143432.430116675@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

commit 015b5bcbcb622b32317642be91a7f79aa5413649 upstream.

dt_remember_or_free_map() duplicates dev_name for each map entry. If
kstrdup_const() fails, dt_free_map() frees dev_name in all num_maps
entries, including entries that have not been initialized.

Some pinctrl drivers, including pinctrl-imx, allocate the map with
kmalloc() and leave dev_name for the core to initialize. The untouched
entries therefore contain uninitialized data which is passed to
kfree_const().

Reproduced on qemu's mcimx6ul-evk (pinctrl-imx) with failslab injection
while binding the pinctrl-consuming device, under KASAN:

  BUG: KASAN: double-free in dt_free_map+0x34/0xa4
  Free of addr c425a900 by task init/1
   kfree from dt_free_map+0x34/0xa4
   dt_free_map from dt_remember_or_free_map+0x184/0x198
   dt_remember_or_free_map from pinctrl_dt_to_map+0x33c/0x4c8
   pinctrl_dt_to_map from create_pinctrl+0x9c/0x5c0

Initialize all dev_name fields to NULL before duplicating the device
name, making the full-map cleanup safe after a partial failure.

Fixes: be4c60b563ed ("pinctrl: devicetree: Avoid taking direct reference to device name string")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-fable-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/devicetree.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/pinctrl/devicetree.c
+++ b/drivers/pinctrl/devicetree.c
@@ -69,6 +69,10 @@ static int dt_remember_or_free_map(struc
 	int i;
 	struct pinctrl_dt_map *dt_map;
 
+	/* Initialize dev_name before any allocation can fail */
+	for (i = 0; i < num_maps; i++)
+		map[i].dev_name = NULL;
+
 	/* Initialize common mapping table entry fields */
 	for (i = 0; i < num_maps; i++) {
 		const char *devname;


