Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172A0400DE1;
	Tue, 21 Jul 2026 20:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665009; cv=none; b=fAPosvko6xIYUbDtkbIMWN4vxuBXgA/ftxVmHUuGQ88hhr+AB5Fb5bt9MPdNQT0Cl4RhO3bU6asRZbNcrWhCpwb76Zs+K55fQ5CTRndtnUzyZWRn4SAQBUL6mI0IGSv5ZoTOuoSEZW/JUCLnKTZg3/0/CBoa2lxZ5ffWuDrFI0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665009; c=relaxed/simple;
	bh=IdKo2Li4IW5LLm4QHxEcZLy8lgeFaywMiB9+DYgcYlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f235olFpzTdlXBzaao/lQy+01Ggp5Uuf1CEpuh2hhab49hWsdxojJiA8qMzeIhgIHTyZY+LEn97EbKbbGbDCRXs56jN/N3ZETVc71uZXrSb3CnUDxAqS9G/5nAK3ADEYug9roKdmDA9AkaMQx/FyX9TDGI5s+YYhB4R9IBbw6qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zhGwsqV7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zhGwsqV7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD671F000E9;
	Tue, 21 Jul 2026 20:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665008;
	bh=bT0X3NLJ3iHcfxdGOfmgJw9RqZKJfWKugZk3ktyLa3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zhGwsqV7yPrWiQ8Nq8gsgnSMKWDdWyXrWFyC1jTdQGzHCotz0rufmEY4M0go3ywX1
	 2/vgDdGpNdJdf4j1V4snJ2SFifwxYCUVeut18oJSqs8Glha8Q/whKooLwi953Dcr4E
	 /hXKdHp7VtJcvbd8kR2NwtQ9VpGBaYEhFrJKw9Lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Martyn Welch <martyn@welchs.me.uk>,
	Hao-Qun Huang <alvinhuang0603@gmail.com>
Subject: [PATCH 6.6 0143/1266] staging: vme_user: fix location monitor leak in tsi148 bridge
Date: Tue, 21 Jul 2026 17:09:40 +0200
Message-ID: <20260721152445.007435906@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Hao-Qun Huang <alvinhuang0603@gmail.com>

commit 151edde741f8bc7f2931c5f44ab376d32b0c8beb upstream.

tsi148_probe() allocates a location monitor resource and links it into
tsi148_bridge->lm_resources. The probe error path frees this list, but
tsi148_remove() only frees the dma, slave and master resource lists, so
the location monitor resource is leaked on device unbind or module
unload.

Free the lm_resources list in tsi148_remove() as well, before
tsi148_bridge is freed.

Fixes: d22b8ed9a3b0 ("Staging: vme: add Tundra TSI148 VME-PCI Bridge driver")
Cc: stable <stable@kernel.org>
Cc: Martyn Welch <martyn@welchs.me.uk>
Assisted-by: Claude:claude-fable-5
Signed-off-by: Hao-Qun Huang <alvinhuang0603@gmail.com>
Link: https://patch.msgid.link/20260704065817.403111-2-alvinhuang0603@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/vme_user/vme_tsi148.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/staging/vme_user/vme_tsi148.c
+++ b/drivers/staging/vme_user/vme_tsi148.c
@@ -2538,6 +2538,7 @@ static void tsi148_remove(struct pci_dev
 {
 	struct list_head *pos = NULL;
 	struct list_head *tmplist;
+	struct vme_lm_resource *lm;
 	struct vme_master_resource *master_image;
 	struct vme_slave_resource *slave_image;
 	struct vme_dma_resource *dma_ctrlr;
@@ -2595,6 +2596,13 @@ static void tsi148_remove(struct pci_dev
 	tsi148_crcsr_exit(tsi148_bridge, pdev);
 
 	/* resources are stored in link list */
+	list_for_each_safe(pos, tmplist, &tsi148_bridge->lm_resources) {
+		lm = list_entry(pos, struct vme_lm_resource, list);
+		list_del(pos);
+		kfree(lm);
+	}
+
+	/* resources are stored in link list */
 	list_for_each_safe(pos, tmplist, &tsi148_bridge->dma_resources) {
 		dma_ctrlr = list_entry(pos, struct vme_dma_resource, list);
 		list_del(pos);


