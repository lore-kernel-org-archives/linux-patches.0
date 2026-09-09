Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D29566C53;
	Wed,  9 Sep 2026 13:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962253; cv=none; b=T7cQO1EFH0lhWrUoGxySm3ufNtwgM4lgjiT51zYMSKhELzWYx0YYsSL/GG2BtJ5DWHwELO71VL32kFwQR7zw1vZ/puuwnggU1907U5KRk5KEj7OiNfn2+ZB6CZUfuc+Y3cJJBV/5/FZkjWDbkl2brkoutFvoWp4ciykL/beiU+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962253; c=relaxed/simple;
	bh=GvhGiveRqELE8kaCefx5SHOuIA/qudXjjU6Ok6JDmtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WKyRbGdF7sTDK6RWDzQLvuysMhFYU2HmiGZYW3e1y93+BOXiqcM6e4hmENkHyZ3dHrdFD/k3eIXXTHtPvjOXFwjykMXLeG3JuBXXUqD6XNdpDa51NO15KcOw/89VpuW87oNaHJeXtpn2XeF2fXJjUiI9APz97pc33l6Vg8tYSdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m2ZZ061B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m2ZZ061B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432F81F00A3A;
	Wed,  9 Sep 2026 13:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962251;
	bh=6rn4Zkk18NtC9+ZqkP/0Dk04NR/i9T4Q7J6YbYyqqx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m2ZZ061Bn6akhGIPfE+CVJ+JpHaaWhuUXCjWh8gdwbJszTQ7+LPmoheqd1vXjQePO
	 mx2wxJ43+0BbkzGVecMeVffyAjKxxjm7V4feqCEfMAp3BwoMIuBd4wAMoctRlAzFjv
	 5VdVmiUkfypEbD5qO7mdHS9Lvuf5vuKzPshGXMhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 227/556] ASoC: hdac_hda: Fix hlink refcount leak on component registration failure
Date: Wed,  9 Sep 2026 15:38:27 +0200
Message-ID: <20260909134238.395007185@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -642,10 +642,8 @@ static int hdac_hda_dev_probe(struct hda
 						&hdac_hda_codec, hdac_hda_dais,
 						ARRAY_SIZE(hdac_hda_dais));
 
-	if (ret < 0) {
+	if (ret < 0)
 		dev_err(&hdev->dev, "%s: failed to register HDA codec %d\n", __func__, ret);
-		return ret;
-	}
 
 	snd_hdac_ext_bus_link_put(hdev->bus, hlink);
 


