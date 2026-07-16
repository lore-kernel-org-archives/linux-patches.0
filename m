Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C98A425899;
	Thu, 16 Jul 2026 14:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211887; cv=none; b=mQQtXV8AUt26I3DewgWU9Fty0D4IC6Vofff1OrzkgNpVhwzDYXbHh/oBI1FqYsRNaAZRAZb8SHd97n7BSrfZPjnkUJtuFH5Xe+goH0GDy0EQh5Wqi9q4PS+/H6ALkdrcJNDrWaRD9TSgoz5yLeiLUlBy9AkwqBnlLGxnSOX2uDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211887; c=relaxed/simple;
	bh=1c+QUEZIQFxBtnZ8YFYItp8PGNq3rINXmQ9aMtyOWZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dtChTjej+0rlhigt6sPAMoicMVZYRKMbdxzKhX0CvPIYWHVthVsf6ARpTUPxRIkwhYpKcedjpAn6QmV6HiknQWR6KxYrdxiMHSQ8aRRpn/AhmYETn+wRZ4tNZDyop+1gW2Xmkl3vb7kUaNytzycwKApOrJel7xzEIjJFYeQ21IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XKpLwKRy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XKpLwKRy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F6A21F00A3F;
	Thu, 16 Jul 2026 14:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211884;
	bh=u1wbgqoq8ER5HyGaW0WV86xU40+5aud+ydlms/Yn9y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XKpLwKRy+NNniVwMSUSNHxYfAu1ZQiZ6fvICujXIX9KvTDxyYNPC+laJZM3UjDodj
	 RgUs62PKXLxQyFozwC4vt2j32E8sM6MUsRFEATNncSl8jOLV4TS15RrrhAO3H9PmH+
	 RnDi9mWPipGm+G92lMM05QPvyIrLZn2CN/k7mECA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Martyn Welch <martyn@welchs.me.uk>,
	Hao-Qun Huang <alvinhuang0603@gmail.com>
Subject: [PATCH 6.12 117/349] staging: vme_user: fix location monitor leak in tsi148 bridge
Date: Thu, 16 Jul 2026 15:30:51 +0200
Message-ID: <20260716133035.978615171@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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
@@ -2537,6 +2537,7 @@ static void tsi148_remove(struct pci_dev
 {
 	struct list_head *pos = NULL;
 	struct list_head *tmplist;
+	struct vme_lm_resource *lm;
 	struct vme_master_resource *master_image;
 	struct vme_slave_resource *slave_image;
 	struct vme_dma_resource *dma_ctrlr;
@@ -2594,6 +2595,13 @@ static void tsi148_remove(struct pci_dev
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


