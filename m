Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F51A46420;
	Mon,  1 Apr 2024 15:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986615; cv=none; b=qWjNK2/rS3/s2xIfyIC58BKxWvXutIsaP2QSKXljfd9PZYP7puEJ6W45qXgfTcOCluYNSOfn08BMqnVvZ91nq+cvRbVrgN2LX38KdQd+qrvOvfXHjIPxXSfUSxvMzAtI2PY0B5rnksvacyQ09WJWOSfmkad2pfEjQyXHSYQ3o08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986615; c=relaxed/simple;
	bh=EUx4k95MuGDwof6lqxYH7eRj4hnh7L9ACjVlgAv49Ik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AgLXD/0Cekq1q+WBkSLa05wvzoZitZUck6q/dOW2RLxMZXjE0xW3T0CEDAr5LHuc4w98vAbAEJSiVdm7DwPYfFeMyjCZZcjd5TjhR9OXHGMBbtddkUwFa05Y258J1pVQ9icRt+BslscYyYcgmSIe3+tOIW9BHDEoQ3pdslE6Mtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=czK/NutA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="czK/NutA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866FFC433C7;
	Mon,  1 Apr 2024 15:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986614;
	bh=EUx4k95MuGDwof6lqxYH7eRj4hnh7L9ACjVlgAv49Ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=czK/NutA2FF5/Qq+G0vilDPeMDQutAp+W8oxMTGAZzxFxDFTK/am48mn2paO6BB4+
	 izZP8HKGIsABYsNTiDGz8SjmjqsH/gSLt5tfKF0K5oiEpBk08AjOSJfdF3Wr4ryLdU
	 vwx3Gwd+PjIJ/dwYpkGTcDAb4fk6a5WF0nQMAkkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 003/399] wifi: brcmfmac: avoid invalid list operation when vendor attach fails
Date: Mon,  1 Apr 2024 17:39:29 +0200
Message-ID: <20240401152549.240020131@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



