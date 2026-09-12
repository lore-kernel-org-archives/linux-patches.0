Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D13479887;
	Sat, 12 Sep 2026 11:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213492; cv=none; b=mQjxgSVPz7Wq1pE1IYRZu+0y2VM+Y3a/jG0N1ZxU+A/t/es9g4Rx4Lh6IPySXisE90+MlSgDJcqYF+KtQl+fREJSXIHMMIxtYdtKisvQVOWs9JqGHRCTXi4eb5aSuX2RR3s/ywZv5of0XYPvAowfZFv6m3jWY/X+4We17eRHbzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213492; c=relaxed/simple;
	bh=8lnkNekRiz7qxqUEu1o5mmaL8++GVzUdxh/D7Es7QZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=doDf9CbbeO5270ybvLcJI830vzdmFJnlJJVj1J+jSULe1aGLJ6gHDHkfwj+/5lP3H3JntV7Cy9s1Bdq1GuVeF+blYj73NmdWQJNXe0pDT8Y83uWnsRjAnW4mbN8b+mu9LlODNyTnl2ByjEO7edtXTPYhsu2NCUX9RCKRSei/u+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w2CAVOYy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w2CAVOYy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FDAD1F00893;
	Sat, 12 Sep 2026 11:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213489;
	bh=fkp3J0Om1fKQ9588gf65E6WYO0n5Xz8kQe/PNqBYC8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w2CAVOYyV+dwI1xC7WsPx8cDCBs4gg+1CTgBMl/lkD2QSQnRlYJY95TAsN/tdSObi
	 pQHYZT+qAWYzR5NxOiOLpa7jShiUisTbdgMeJ10gbBNFhKAWyCS17hevJXZ3xmboPV
	 G48SQmiCIKtbuwhQW26bPZtrU6bIT/zF4563Uhew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 0130/1376] ASoC: hdac_hda: Fix hlink refcount leak on component registration failure
Date: Sat, 12 Sep 2026 08:42:36 +0200
Message-ID: <20260912065610.454182198@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 6ad4892c4f5cb437a928a02f5b7d37d496aa9268 upstream.

hdac_hda_dev_probe() gets the HDA link with snd_hdac_ext_bus_link_get()
before registering the ASoC component. If component registration fails,
the function returns without dropping the link reference.

Always call snd_hdac_ext_bus_link_put() after the registration attempt so
the reference taken during probe is balanced on both success and failure.

Fixes: 6bae5ea94989 ("ASoC: hdac_hda: add asoc extension for legacy HDA codec drivers")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Link: https://patch.msgid.link/20260622145645.1184986-1-haoxiang_li2024@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/hdac_hda.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/sound/soc/codecs/hdac_hda.c
+++ b/sound/soc/codecs/hdac_hda.c
@@ -643,10 +643,8 @@ static int hdac_hda_dev_probe(struct hda
 						&hdac_hda_codec, hdac_hda_dais,
 						ARRAY_SIZE(hdac_hda_dais));
 
-	if (ret < 0) {
+	if (ret < 0)
 		dev_err(&hdev->dev, "%s: failed to register HDA codec %d\n", __func__, ret);
-		return ret;
-	}
 
 	snd_hdac_ext_bus_link_put(hdev->bus, hlink);
 


