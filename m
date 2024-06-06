Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D168A1991B4;
	Thu,  6 Jun 2024 14:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683151; cv=none; b=l4a3FJ072WKD7MGE4D1w3GkUcfuKtEfjQCpHiZQOXC1K/Ohpt39M0xIr2pxPvPaI0Zuf6oOeC7Uf848PO/k+WFaOz7E1mrJiuzjiyRz9TJlsusiv8Wr3jKwQ4s4X1T9tEyInXd2yAqokAO/pRb+HpQwjzXJi+Mu4302qTVnZkJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683151; c=relaxed/simple;
	bh=alB1SL6kf9fshQZF9oonZdS29NTlwinVbTzSodTNwWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NGOEbmeeT2FlZdBJ3UYIius9Itf0oj6MGZAEDESq1AyLM5q/+p/AG/SnYGqP/d6QO1e1Xe84rSQr+FWbiHl+cyZfhf07FXu0jyRjTxE85Rlg4Yn8PRTFOqzeXwqqR9pTBgmkQiw2HF7d9PaTrYp9Xi8WL4IULCEhhAIbQayu7as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gAbXuAVC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gAbXuAVC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D5FC2BD10;
	Thu,  6 Jun 2024 14:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683151;
	bh=alB1SL6kf9fshQZF9oonZdS29NTlwinVbTzSodTNwWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gAbXuAVCc472TROx4SSnB9cXkbumWFouSEgrhXZhdo7OFLXzRowgy+qXJ8J9bB+0B
	 hEEOKnMS2MA0LsYMlSfGD/w58oyI8SWR1KshMU+SHuxhy+3s8B5Frjt0DTU4VPqcWF
	 viTe9DE0uc/aNAHBwpipnBIxVqzyVrrvt/xFmBcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: [PATCH 6.1 005/473] speakup: Fix sizeof() vs ARRAY_SIZE() bug
Date: Thu,  6 Jun 2024 15:58:54 +0200
Message-ID: <20240606131659.989419584@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -573,7 +573,7 @@ static u_long get_word(struct vc_data *v
 	}
 	attr_ch = get_char(vc, (u_short *)tmp_pos, &spk_attr);
 	buf[cnt++] = attr_ch;
-	while (tmpx < vc->vc_cols - 1 && cnt < sizeof(buf) - 1) {
+	while (tmpx < vc->vc_cols - 1 && cnt < ARRAY_SIZE(buf) - 1) {
 		tmp_pos += 2;
 		tmpx++;
 		ch = get_char(vc, (u_short *)tmp_pos, &temp);


