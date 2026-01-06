Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D4F224B15;
	Tue,  6 Jan 2026 17:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720672; cv=none; b=AsHs1dvpRrfsLhSwj0ohUhT3ffIvCoP+6o2FuZMGBLKMoKnf0Nw96aHI26ehTVWSAVwatxa+azj57aqz9r5+lqykwt3StyAMC1Qr1VZDST42vgkvts9d2HoyeFB14H3Xj4uYw5uGB/EOk+jisp8kpnB5qK2hv1LbTCLFODIbX2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720672; c=relaxed/simple;
	bh=yTsJbd/SqQf5bi/N1AEhaFTtviQlHVkPIUThdTJiK0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qUpHhblVEPYpaHvoidKYIdN6CKNsERkbKqW3dbzYuHYmUofJJNy2i6IeXtyOjjiWEkKHuGowDxF446MXzxT0Nr2tsuxvQX9Igv+5Zh405dQNF1dQK+nVmLUDbdewXx8xhhTeXZOtdGqRwJKrEPtzQUgeGZO99Z98vqpozeYprZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pOc/CqJw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pOc/CqJw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 364EFC16AAE;
	Tue,  6 Jan 2026 17:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720672;
	bh=yTsJbd/SqQf5bi/N1AEhaFTtviQlHVkPIUThdTJiK0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pOc/CqJwvuRSyFL5ZyZFLnBI+zNBxJxmBqSG1wGWmAOVU1NTQtT9iEZ7glt2Q8AB4
	 HEKwz2lsZlHFsyUWsXeDOvYG6uFs49XVQFDXrjaoDXV8YiBvFKdMmK+1Si5BpAiUYA
	 ggAqH3oX0gZqyB2LWryDgdBo/KFNYwXP6/eTWkv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Sven Peter <sven@kernel.org>
Subject: [PATCH 6.12 280/567] soc: apple: mailbox: fix device leak on lookup
Date: Tue,  6 Jan 2026 18:01:02 +0100
Message-ID: <20260106170501.687994395@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit f401671e90ccc26b3022f177c4156a429c024f6c upstream.

Make sure to drop the reference taken to the mbox platform device when
looking up its driver data.

Note that holding a reference to a device does not prevent its driver
data from going away so there is no point in keeping the reference.

Fixes: 6e1457fcad3f ("soc: apple: mailbox: Add ASC/M3 mailbox driver")
Cc: stable@vger.kernel.org	# 6.8
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Neal Gompa <neal@gompa.dev>
Signed-off-by: Sven Peter <sven@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/apple/mailbox.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/soc/apple/mailbox.c
+++ b/drivers/soc/apple/mailbox.c
@@ -299,11 +299,18 @@ struct apple_mbox *apple_mbox_get(struct
 		return ERR_PTR(-EPROBE_DEFER);
 
 	mbox = platform_get_drvdata(pdev);
-	if (!mbox)
-		return ERR_PTR(-EPROBE_DEFER);
+	if (!mbox) {
+		mbox = ERR_PTR(-EPROBE_DEFER);
+		goto out_put_pdev;
+	}
+
+	if (!device_link_add(dev, &pdev->dev, DL_FLAG_AUTOREMOVE_CONSUMER)) {
+		mbox = ERR_PTR(-ENODEV);
+		goto out_put_pdev;
+	}
 
-	if (!device_link_add(dev, &pdev->dev, DL_FLAG_AUTOREMOVE_CONSUMER))
-		return ERR_PTR(-ENODEV);
+out_put_pdev:
+	put_device(&pdev->dev);
 
 	return mbox;
 }


