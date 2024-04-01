Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92FF11C0DE7;
	Mon,  1 Apr 2024 16:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989360; cv=none; b=KjNEpyMZGtxxZMdm9/9LISXt6x3sdyb9wfCLGqETtnsqv5aAWvbkwM5PPrWfl1rBy+XViYYBautUaxnSqmuZ67d5tkF08Gx2V5z+yO6GqjYRzpwC6mQFHLh/MJZAIde23T6btIufwbHewImIf6+4w93/u8N3kc2xls3jXm3DeZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989360; c=relaxed/simple;
	bh=ZF6E5sK5aVMf0mi44BMzh3G0lql/PyzuyPm3wasT6AQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OW7GGTGhhEPInBV5VFIzdxfGOoWts4zIUhI8DoCX/83hvMHmkdJYGpw8I3DnfgSrsCrYsbGgmWUIDJPGzevp1XnjpaDnYGJ9VPYL448lXH/sUdif/+7mGV/NZueArUfjJR4oJpEN5AE1whX45InGE9HdegFUv7tZX8a5jCtwkUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iarxjUbx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iarxjUbx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04091C433F1;
	Mon,  1 Apr 2024 16:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989360;
	bh=ZF6E5sK5aVMf0mi44BMzh3G0lql/PyzuyPm3wasT6AQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iarxjUbxu/JXvP6fUGJpEQaMJXeT9fyaCNuBWZ10qBsQldCac3odrH/1aD2v+8khl
	 w1kUBbDj+2o5jDmOfDOv+zbiWOuGYOA8sEY5DxIjtf6BfrqNhVnQE/9u0bTBRWuzcA
	 hQEC1pVgTXQ/RxYvn3/bv1Muvx9sX5zGxeO37H2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 005/396] wifi: brcmfmac: avoid invalid list operation when vendor attach fails
Date: Mon,  1 Apr 2024 17:40:54 +0200
Message-ID: <20240401152548.039196414@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Arend van Spriel <arend.vanspriel@broadcom.com>

[ Upstream commit b822015a1f57268f5b2ff656736dc4004e7097da ]

When the brcmf_fwvid_attach() fails the driver instance is not added
to the vendor list. Hence we should not try to delete it from that
list when the brcmf_fwvid_detach() function is called in cleanup path.

Cc: stable@vger.kernel.org # 6.2.x
Fixes: d6a5c562214f ("wifi: brcmfmac: add support for vendor-specific firmware api")
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://msgid.link/20240106103835.269149-3-arend.vanspriel@broadcom.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwvid.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwvid.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwvid.c
index 86eafdb405419..f610818c2b059 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwvid.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwvid.c
@@ -187,9 +187,10 @@ void brcmf_fwvid_detach_ops(struct brcmf_pub *drvr)
 
 	mutex_lock(&fwvid_list_lock);
 
-	drvr->vops = NULL;
-	list_del(&drvr->bus_if->list);
-
+	if (drvr->vops) {
+		drvr->vops = NULL;
+		list_del(&drvr->bus_if->list);
+	}
 	mutex_unlock(&fwvid_list_lock);
 }
 
-- 
2.43.0



