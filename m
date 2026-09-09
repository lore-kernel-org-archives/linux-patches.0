Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7F75476C0;
	Wed,  9 Sep 2026 14:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963694; cv=none; b=aqb0T7tC6S7Jy4IFLsOz2GrgaN/+LBvHPSqj457+SGf/5Oyn+WUpvSbW6H8ULErLF76MTOmi6zwtKhzm5tTquDTdIL0di78tjuHE53ng8TzAuu1JbtgPxUllNg7rWcOzjUtGiiXeHjFYAAmIYl93xoW5ei3Az1d7Jvmeryv4BsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963694; c=relaxed/simple;
	bh=iKyp55KAg603S+XfqOr50ccoETlK81AGgX0WHc3cFdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LczGuscJ9zjZsZdGthLiJ87/8d3GY38zMWL+PmhGGNSxUpp135a5JHubWUIeLa63s1ahu+hbo1vS53wXsZBlKzxLdDp7b3fBGbeWQHGbyy5qK0cuas33oaQ98wH7h4vzNCgTrC0LalGpL7BCq+SSTC7k0YDjmhozTTynj9EyaG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XmlscEuu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XmlscEuu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31DAA1F00A3A;
	Wed,  9 Sep 2026 14:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963693;
	bh=YCoqtiroKsnWjPVZ6rcRLOXnJZdWe+znytK1QczLPCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XmlscEuuhEBG/OwjJ6xqxjEQ32BXpTk52WMMzeCwwoHV9cPHRpZ94agyaNR0I8eT9
	 xLIY51tOHF9VxkGn1NAKl42txs3qe3rzQVWjDrlYc4zqQDYk22JQHx9iS1z9xk7Y1v
	 Cj3pTiwnLz8v3tyv91ZHZqrzuIVig3y5hNjZgit0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 165/583] ASoC: hdac_hda: Fix hlink refcount leak on component registration failure
Date: Wed,  9 Sep 2026 15:37:30 +0200
Message-ID: <20260909134243.917111314@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -644,10 +644,8 @@ static int hdac_hda_dev_probe(struct hda
 						&hdac_hda_codec, hdac_hda_dais,
 						ARRAY_SIZE(hdac_hda_dais));
 
-	if (ret < 0) {
+	if (ret < 0)
 		dev_err(&hdev->dev, "%s: failed to register HDA codec %d\n", __func__, ret);
-		return ret;
-	}
 
 	snd_hdac_ext_bus_link_put(hdev->bus, hlink);
 


