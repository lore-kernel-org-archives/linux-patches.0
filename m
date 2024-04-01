Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F173C1DDC9;
	Mon,  1 Apr 2024 16:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989023; cv=none; b=lPdMuJDxEMI7J3oia3180ZIgzpLXJre+vmkzC7FAPQ5WenC5ppMDS7VHNpyjB/JI4yyFgdhedOw+kfWitxpaIHg1vFNMDrzW+eARqtFZAL6IDbUZXv1r+GYwYbVGR8ZS6MOPTE8kZt3cbZVPQS8UwXJUqXxVW321KurezWvWTkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989023; c=relaxed/simple;
	bh=XxmOSLsDxWKDG8w0Y+hVsIwwnstMxGZUyn+mNsr2VKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PDjXyaXJ2M/jKomINqUWa8LuZ3cOmfyaoA4PlVTlS9ML+sLHPye62qdTGuXhRu3wVNF3SZqAHsXpTv4TDhKFXdVKXTrKS05slqF5Ibu2dyZnIwzERDImJhv9kMlreKd8F7PpqyYNfD6D01zPzQ3VQ+Ois861aKKVR97fYzuTdKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HsWS6PDP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HsWS6PDP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76DF2C433F1;
	Mon,  1 Apr 2024 16:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989022;
	bh=XxmOSLsDxWKDG8w0Y+hVsIwwnstMxGZUyn+mNsr2VKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HsWS6PDPgTbktZl3VyoMhdtusTv+FxoTyS+r6jPSwal3gD322S1qmmZEkZGmTmd4r
	 S2KkQJyQD2jexj3ryZw5nfOlVjUISYHk/098DCgi0lYtfFW3kGCMB994sxbtpU67X8
	 2PV8oBao1nktsZDAPvxQblybZ1jqy6H8w3SRO9Y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Rapeli <mikko.rapeli@linaro.org>,
	Avri Altman <avri.altman@wdc.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.7 359/432] mmc: core: Avoid negative index with array access
Date: Mon,  1 Apr 2024 17:45:46 +0200
Message-ID: <20240401152603.976462977@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikko Rapeli <mikko.rapeli@linaro.org>

commit cf55a7acd1ed38afe43bba1c8a0935b51d1dc014 upstream.

Commit 4d0c8d0aef63 ("mmc: core: Use mrq.sbc in close-ended ffu") assigns
prev_idata = idatas[i - 1], but doesn't check that the iterator i is
greater than zero. Let's fix this by adding a check.

Fixes: 4d0c8d0aef63 ("mmc: core: Use mrq.sbc in close-ended ffu")
Link: https://lore.kernel.org/all/20231129092535.3278-1-avri.altman@wdc.com/
Cc: stable@vger.kernel.org
Signed-off-by: Mikko Rapeli <mikko.rapeli@linaro.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Link: https://lore.kernel.org/r/20240313133744.2405325-2-mikko.rapeli@linaro.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/block.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -488,7 +488,7 @@ static int __mmc_blk_ioctl_cmd(struct mm
 	if (idata->flags & MMC_BLK_IOC_DROP)
 		return 0;
 
-	if (idata->flags & MMC_BLK_IOC_SBC)
+	if (idata->flags & MMC_BLK_IOC_SBC && i > 0)
 		prev_idata = idatas[i - 1];
 
 	/*


