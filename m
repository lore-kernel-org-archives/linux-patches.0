Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F122EE27B;
	Thu,  3 Jul 2025 15:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554847; cv=none; b=lOC32yiqamjv7fWlVTlTEndxAVVUNLh3JGOGHWmL2OxgrWg9+OsItCk2KZeNFjnJQ0ptsMdf5Izsm/nhBhdIYWknK+rjnADaHgV/clGSj7k3ps9LzxnmbvcN0HBNImnJS3EZE2CEXWEjSGAgnEGiLGP0qzedgAZTTTrwRfL2PyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554847; c=relaxed/simple;
	bh=VOSJYV+LH5IN751X9wKhIcoB3XF1/vdDTzdQosBJmeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=boT/fjwoi7ACCS/X5HY68+tMGgxqIJwP5+/gIsw1MqPpWmKVWZk5nP1j5pEdI2Knz1vIG2xkRZ/jCcYMkBNK/BTDEsilRzEzdTiV31cWvR9DryohMibWx/n2qHekA8rsh7QPFSQmmoBaVUt0S0WEfAUvkor+R3U4hrqb0vNfecw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zR3x6e7Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zR3x6e7Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD65C4CEE3;
	Thu,  3 Jul 2025 15:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554847;
	bh=VOSJYV+LH5IN751X9wKhIcoB3XF1/vdDTzdQosBJmeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zR3x6e7ZmpAd12XD7b1EQVNL3GMB928DeDfbUB5moy0M+zyLJVP92MsS6/ZiZSx0M
	 o799k8w7/GROx3fP2S3bFy9rFsdnbqE16j3PK68fuCFesCq36szSzLvjed72jNzF53
	 RGrP5PCoYMekOZR8Etrtjvy4vT/Nfnb2E9y7YgrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Yufeng <chenyufeng@iie.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 057/263] usb: potential integer overflow in usbg_make_tpg()
Date: Thu,  3 Jul 2025 16:39:37 +0200
Message-ID: <20250703144006.598639443@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Yufeng <chenyufeng@iie.ac.cn>

[ Upstream commit 153874010354d050f62f8ae25cbb960c17633dc5 ]

The variable tpgt in usbg_make_tpg() is defined as unsigned long and is
assigned to tpgt->tport_tpgt, which is defined as u16. This may cause an
integer overflow when tpgt is greater than USHRT_MAX (65535). I
haven't tried to trigger it myself, but it is possible to trigger it
by calling usbg_make_tpg() with a large value for tpgt.

I modified the type of tpgt to match tpgt->tport_tpgt and adjusted the
relevant code accordingly.

This patch is similar to commit 59c816c1f24d ("vhost/scsi: potential
memory corruption").

Signed-off-by: Chen Yufeng <chenyufeng@iie.ac.cn>
Link: https://lore.kernel.org/r/20250415065857.1619-1-chenyufeng@iie.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_tcm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 5a2e1237f85c3..6e8804f04baa7 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1641,14 +1641,14 @@ static struct se_portal_group *usbg_make_tpg(struct se_wwn *wwn,
 	struct usbg_tport *tport = container_of(wwn, struct usbg_tport,
 			tport_wwn);
 	struct usbg_tpg *tpg;
-	unsigned long tpgt;
+	u16 tpgt;
 	int ret;
 	struct f_tcm_opts *opts;
 	unsigned i;
 
 	if (strstr(name, "tpgt_") != name)
 		return ERR_PTR(-EINVAL);
-	if (kstrtoul(name + 5, 0, &tpgt) || tpgt > UINT_MAX)
+	if (kstrtou16(name + 5, 0, &tpgt))
 		return ERR_PTR(-EINVAL);
 	ret = -ENODEV;
 	mutex_lock(&tpg_instances_lock);
-- 
2.39.5



