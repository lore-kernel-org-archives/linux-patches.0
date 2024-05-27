Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77CFE168C4;
	Mon, 27 May 2024 19:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837428; cv=none; b=n4YlzDDXSymg83Ei2uSlzfM8ErGyLh7PMmLSbJMp3BKwZSF9ufoKtpCp1bNAEGwkj+5NlIgPe5noHhPysIrDyocHZHjgegF5SLNLA5LUC+GeaFvMUhIyVyJ5w3e1gO4nAgavd0X/C99LxUy8f0qrWINDxBU1GORjc59imAPF2wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837428; c=relaxed/simple;
	bh=ieSJsbfNB8NDQ4ZBxMu625DpH1C7hZqJ4Fv1qjkIr3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iRCc54aAjz7yOBp3zVSKhQ1A9EUgz7woR7U9FcRFjHVjjRDYMRtDneiFKgoFoK/9iKyUin1xdKCom/fuXXtCZ7p4aTrXNmjXDN9DHxnR2euHAzoJc13PhXFeJxf/Fy6EKY46b3SJtX+i4qymVwcRCuCaS4pyaMrNb3MYc2GAIiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KbMIoQrB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KbMIoQrB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D0A7C2BBFC;
	Mon, 27 May 2024 19:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837428;
	bh=ieSJsbfNB8NDQ4ZBxMu625DpH1C7hZqJ4Fv1qjkIr3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KbMIoQrBXsgrC7HvMqqpj9g+7Wf2VU/Y7HS2/+k6q+8fwDsHZ4fetXDpzpH3KxCqP
	 Dp7H7/c+0P+OIF1tAVPY2ojNPNLXQuuOCw2dCGzj5i7bcr+htDexgK72kDn/KRwfTw
	 QgeEjxmgZUZWgB4Elwqc7VPrdEk8ATuQtZ4jcFak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: [PATCH 6.8 010/493] speakup: Fix sizeof() vs ARRAY_SIZE() bug
Date: Mon, 27 May 2024 20:50:12 +0200
Message-ID: <20240527185627.536011975@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 008ab3c53bc4f0b2f20013c8f6c204a3203d0b8b upstream.

The "buf" pointer is an array of u16 values.  This code should be
using ARRAY_SIZE() (which is 256) instead of sizeof() (which is 512),
otherwise it can the still got out of bounds.

Fixes: c8d2f34ea96e ("speakup: Avoid crash on very long word")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Link: https://lore.kernel.org/r/d16f67d2-fd0a-4d45-adac-75ddd11001aa@moroto.mountain
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
-	while (tmpx < vc->vc_cols - 1 && cnt < sizeof(buf) - 1) {
+	while (tmpx < vc->vc_cols - 1 && cnt < ARRAY_SIZE(buf) - 1) {
 		tmp_pos += 2;
 		tmpx++;
 		ch = get_char(vc, (u_short *)tmp_pos, &temp);


