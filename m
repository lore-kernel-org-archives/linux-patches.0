Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E695A2E6D0E;
	Tue, 15 Jul 2025 13:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587437; cv=none; b=te/wTEwmioGZqf/a55Ze6q3Hi5+sgj9aQnYJuQ+8xUCEZSfKmL/TOGwEEHXy2PoOmcJhk66Ij9ogsPqJWwOCi1KuoUKqa+3aYdGfsp8yGE5lxSKAxepMY8UoOB4GtA1w8YNQ1jRbgRArYinMY/S/6GExCLj6BSmb3y2rnjq5zbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587437; c=relaxed/simple;
	bh=/3xYRYxUsWSuOB2mExp4+9adu48Pe1P/pPkcUy6ZKP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m/EC+3GT/sppQTavctzuFpbbqXkpRJ5yuwmWfjobPBDBz3Kmb6EOWaCfKwxy/L5wnH3ceuo9lG4H968uxph8PUYO5hgr9lsWiVkarzudJio5S5HWBW1Y+lo7ViTxqDteyQrURh242/W1UT9IvIDLfntQJ2ma8HRhmetizEL1iFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xwsek+6m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xwsek+6m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B8B8C4CEE3;
	Tue, 15 Jul 2025 13:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587436;
	bh=/3xYRYxUsWSuOB2mExp4+9adu48Pe1P/pPkcUy6ZKP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xwsek+6mipOcuq94mWmlD463rsJCTwaN+U6J1t7xUPUTz4iMh8RRoU3hGCgS2YJpv
	 f4h9vH82fKQv0ov3uZP7k3Rbq7qLvNFwEr6viqUkF0SLGm9doODswO81DL4r9ZVPEV
	 pMfYN9ss/1YovAfA9u1FttecHJNCedKLdsgFC3GQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Yufeng <chenyufeng@iie.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 012/208] usb: potential integer overflow in usbg_make_tpg()
Date: Tue, 15 Jul 2025 15:12:01 +0200
Message-ID: <20250715130811.328882493@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7f825c961fb88..30c3a44abb183 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1325,14 +1325,14 @@ static struct se_portal_group *usbg_make_tpg(struct se_wwn *wwn,
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



