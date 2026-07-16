Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F723FF1B9;
	Thu, 16 Jul 2026 13:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209363; cv=none; b=E9iEhEiKLC5K/oxRzzwFjD3vJ+kLy3hxsKlAWcrgW7P0MvjlwtgXBNrDlOolK6/EsMKlxGfWYPwzpS5eLHLPf2HsS8g0tgcfgFdNNiZTiXZP1NcrhLueMMhIjrPFnMdwCYvl+Z/OstPqyqL/SOqzWWyTCKBVDqo5oQznZfwKOZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209363; c=relaxed/simple;
	bh=OU3OYWxkUsOT6ElGK06JDTjB1iLgB3LSJOG37drDDF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t5BkTiRmh+5iVF4BBJHNnrd5jZAT7zgW6Avi0u/U9NmdyKQgI8Z967uXdFFObk5yogzhdFN+TyjvJAzcYtB5hWM/077yyazFHiu7MYsvjmKaRIjvCqTS2hGHNPaQBf38YVoNWX+kKz/iOx3xYWER2HMQpwmd/eypduNLGps+LS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2aropzPv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2aropzPv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 885871F00A3A;
	Thu, 16 Jul 2026 13:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209361;
	bh=ZB6YTf5kdCoosy8nThbzvAe/iGgzMn5I6F4YdSv2YNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2aropzPvDYhgTtQXEJPtuU2e7QeqQItrXdTm+OM+4psMhL5Q9va7Me7kqj/75bGPQ
	 x1ZSmCaftZSrSQqZQnHJ4M0l99azsc/pFfonRsChLJ2YkX+s4WWT4KTjeVmlxDtdN/
	 NMw7WQETBETG2KudrSJ2QwMGBZ9+CdJfx7Z0nhNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Martyn Welch <martyn@welchs.me.uk>,
	Hao-Qun Huang <alvinhuang0603@gmail.com>
Subject: [PATCH 7.1 155/518] staging: vme_user: fix location monitor leak in tsi148 bridge
Date: Thu, 16 Jul 2026 15:27:03 +0200
Message-ID: <20260716133051.236321331@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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
@@ -2534,6 +2534,7 @@ static void tsi148_remove(struct pci_dev
 {
 	struct list_head *pos = NULL;
 	struct list_head *tmplist;
+	struct vme_lm_resource *lm;
 	struct vme_master_resource *master_image;
 	struct vme_slave_resource *slave_image;
 	struct vme_dma_resource *dma_ctrlr;
@@ -2591,6 +2592,13 @@ static void tsi148_remove(struct pci_dev
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


