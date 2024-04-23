Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9CC20B3E;
	Tue, 23 Apr 2024 21:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908530; cv=none; b=FWG9RTSLnAvoPuaI8dmPG5UkfgLE5EJ+58vs4xW/2zhy6fF6pjCb6SBIEg0i60LGmhOXjhXTNAVIjCBNl1GHvbTBy5ENII4zygoE/1oJP0CNaPG79MWooCpQ0qTpPrzvpw7d8NdhvQEkr5Gvs52GJINMNBjWGDCOZm9prKLtM14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908530; c=relaxed/simple;
	bh=iQo9gSOU3xXSMPZH3ZPbQwjkDTraCH7/qZgjL9xarWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mMyACtheWeiPfXADoOmAv5XSN+dktXb+v8oj1r9xIGgTo6wOBrdnqUEQwrKvd+Trwo24rD+NKGMUuiUIk88t9/5BKpb91YM34wQwUR11mzQ2vB7TAmBqCptFDC3KZxA/BwFuH/K3xg8INyBqWUEf60S1Rw9Kf4cCgesSdI4sZ0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ebXb2/54; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ebXb2/54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57CA3C116B1;
	Tue, 23 Apr 2024 21:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908530;
	bh=iQo9gSOU3xXSMPZH3ZPbQwjkDTraCH7/qZgjL9xarWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ebXb2/54Yw/widQKpPXHJn81rdlt7COWaaw8/6Vzb5Sv6C8XS1W9CZqbCIg948SmJ
	 np1GxZX+HOUv3IpjPQi+5VQ8Wi63pF9E44QTPd3fCHSNsXgkGhAp80n2Iba84iS/9o
	 D3g6uiQUPd1G2v1FDOJJDGOR7BUz9eOfQO91uJeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: [PATCH 6.8 123/158] speakup: Avoid crash on very long word
Date: Tue, 23 Apr 2024 14:39:05 -0700
Message-ID: <20240423213859.911614744@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

From: Samuel Thibault <samuel.thibault@ens-lyon.org>

commit c8d2f34ea96ea3bce6ba2535f867f0d4ee3b22e1 upstream.

In case a console is set up really large and contains a really long word
(> 256 characters), we have to stop before the length of the word buffer.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Fixes: c6e3fd22cd538 ("Staging: add speakup to the staging directory")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240323164843.1426997-1-samuel.thibault@ens-lyon.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accessibility/speakup/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/accessibility/speakup/main.c
+++ b/drivers/accessibility/speakup/main.c
@@ -574,7 +574,7 @@ static u_long get_word(struct vc_data *v
 	}
 	attr_ch = get_char(vc, (u_short *)tmp_pos, &spk_attr);
 	buf[cnt++] = attr_ch;
-	while (tmpx < vc->vc_cols - 1) {
+	while (tmpx < vc->vc_cols - 1 && cnt < sizeof(buf) - 1) {
 		tmp_pos += 2;
 		tmpx++;
 		ch = get_char(vc, (u_short *)tmp_pos, &temp);


