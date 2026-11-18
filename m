Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055619;
	b=RWN9r7Z6iVCTEMzAiUMITsawDVg1hVP7+mInBrxmfFMJBi5cF4DfjAygXY0EHGk2BuPa
	 w6t41mFsTNFRp1I3TRfiFae/1yEuM79XocJt/of1MVEFAPsdQkGHq/daYkKl6lP1AD9Yb
	 VdbJc5gvjjpJiJbhU69Lq9sO1Ew0NI4yDhvFGL68BHBMjFPj404miyOEzByAmluA2EADw
	 XuC6cfm0Wso4dgSJYrrXXgciDQ2E8e2Wv08CXyEtaJYP4NY72BGCEosuL/u02/ocV/SE8
	 PcUI0ps0eSNBpSu36ki5EQ1f3xQQuRRVaW+bGSICG1Xc5U+pq9V0B8GFi5DJgcR7kmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055619;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xFt1vmY4K26O+OFxQMxVBdnWV2M9Xjcw+9qpQrRvE3k=;
	b=bjsUDYTEYV4RrJz6QrNUrMvPn9UDRD3jq8N46Q5igPK6TSvoVGwwKGIs8Egv1ZIqV6wu
	 sY/79JkxrvNA/m0taI2YdezwOFrtEDp6hEcU3OQukCbn+FFm+jssQdW5B6hXinB0GBI1f
	 XZrYzmOXSPfKJ+Kw/3Gz6zjsk+u6krS1jbto/IAOVYhnzXWCIwLM20BG9Imp/rT1EcFal
	 99y2KtW9K2wNOGWsNqiKgLueN4vvFArG9Yuu0kLPoFJd0OOfkffi6fqZ75W+PeE/WxtEp
	 hy5qjFTWxkTOThKrFL29hRZY+6R8rIx6TAoLtg2WD1seNsJEL08g2FgyEtRn7PBwPjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zv0HrQrK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A8060A2604;
	Thu, 19 Nov 2026 02:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zv0HrQrK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 254011F000C4;
	Thu, 19 Nov 2026 02:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055619;
	bh=xFt1vmY4K26O+OFxQMxVBdnWV2M9Xjcw+9qpQrRvE3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zv0HrQrKVm62MieHif02WoSrMI9qV/Un5wArWYsVn7vbb8TAlQ43vlFuPes/l85PY
	 G1kXkG/VjbXXTFG8eI4InJah6/R6oRkuQ9HshhFf550uaLwcEF3VNCHNdrhnXBYx4k
	 x+ynBtaUXmoA5TTmUnxElm5VhRqE/ofJgt8pK9v4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1697/2214] misc: enclosure: fix UAF on device_register() failure
Date: Wed, 18 Nov 2026 15:56:13 +0100
Message-ID: <20261118150119.693856521@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linkai Gong <gonglinkai@kylinos.cn>

[ Upstream commit 0f3b12bab74e13a2b8686a49c5b83099da61e032 ]

After device_register() fails, the embedded struct device has already been
initialized and must be released with put_device() so that
enclosure_release() can drop the parent reference and free edev.

The error path currently does put_device(parent) + kfree(edev), which
skips the device lifetime rules and can free the object while the device
core still owns a reference (use-after-free).

Fixes: d569d5bb3fd9 ("[SCSI] enclosure: add support for enclosure services")
Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
Link: https://patch.msgid.link/20260806070358.1599627-1-gonglinkai@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/enclosure.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index f950d0155876a..6ac14c2e614b5 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -147,8 +147,7 @@ enclosure_register(struct device *dev, const char *name, int components,
 	return edev;
 
  err:
-	put_device(edev->edev.parent);
-	kfree(edev);
+	put_device(&edev->edev);
 	return ERR_PTR(err);
 }
 EXPORT_SYMBOL_GPL(enclosure_register);
-- 
2.53.0



