Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD0F12D761;
	Tue, 30 Apr 2024 11:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476263; cv=none; b=Y37kKJg5Rh/jKLJvUI2ijCE/Kxmm1W4m/aV1PdBdAPwyrMOsGLbMKOyreW3M09AmTr5jcrbDKH7Eb7TZ10KjMuJpVtZqXo1JXvVfNnAJSw7KSikGfM6RLLzgFuaJqXfx6bgGNLg7uaQjnD0EeWGFu2AxaT+JoS+/6l2O/VNLjQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476263; c=relaxed/simple;
	bh=2aisiLx4y+g+DqA6PBP1sQNSqtJzsCD+V6tX3w+vzHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=blILxzZhostkib22TQLSLYF0o0AeH6QXSjh7bxpvtiMoo0YMEjv3SBjGYlZJ64yJ9ofYjaL3kkbnUj41XXyZusmClsaOcccRfkYp4RoX1o68urC1Kbyg8GZdDUsSssJPOZuTLABJxQo3pSZGWdUzWoXEig9TG20SG5b8/w+68LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ow0OdUdf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ow0OdUdf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E01C4AF18;
	Tue, 30 Apr 2024 11:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476263;
	bh=2aisiLx4y+g+DqA6PBP1sQNSqtJzsCD+V6tX3w+vzHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ow0OdUdfe9TXpltO6wzLnfgLJdgZlyfMQecXzmHc1FMcExB3IbJGEqy73sMKeiyHB
	 9Ab5E44oSp1kuP1z7KfYVdNExPFS4hoGaV4MgwZv7zBB5Nb/s9wStbZ3wZhcB9ri1m
	 dhvveu4UeFNMeMmrYOZaaX+sHCB9zynHWt1tFLTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: [PATCH 5.4 047/107] speakup: Avoid crash on very long word
Date: Tue, 30 Apr 2024 12:40:07 +0200
Message-ID: <20240430103046.047556204@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/staging/speakup/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/speakup/main.c
+++ b/drivers/staging/speakup/main.c
@@ -577,7 +577,7 @@ static u_long get_word(struct vc_data *v
 	}
 	attr_ch = get_char(vc, (u_short *)tmp_pos, &spk_attr);
 	buf[cnt++] = attr_ch;
-	while (tmpx < vc->vc_cols - 1) {
+	while (tmpx < vc->vc_cols - 1 && cnt < sizeof(buf) - 1) {
 		tmp_pos += 2;
 		tmpx++;
 		ch = get_char(vc, (u_short *)tmp_pos, &temp);


