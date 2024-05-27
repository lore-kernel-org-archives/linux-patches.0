Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CC415FA87;
	Mon, 27 May 2024 18:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836324; cv=none; b=GRA2LYg86GJ2TxMbMTjo0YxvOfw1WZ8fCqKw+YKdfWNL4l8EU6xqwZtOasrCuonaEPhAcoE+whQnzrFhE/UPIuqdOtsNF5rDkzNW88DWt9nz23SeqxotqKGIqhUXE/ZCfWc8jIdyZyfil4EfWC0NSHwKACcQp/Zv8Tjs0Kwkr6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836324; c=relaxed/simple;
	bh=e39dQ5JvBZ3J08TKCCsQOEsK8rejlWCWO1FmSkadTq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iSfiVJtW9oe7ZuyMRkf3i1z3cnaQ8rLXHM/xjce/vkKKx065qTky1gX7DAPeWwPDdPu1MU0U6iIhD4eAAH8Y6hFb2IBiD8GMpRbSggItBMrEORV4IqiVG+J3x7k8QDY6JDuOV2guGf/vVjMRZokh73/1fmygBH2OtuATwYnlKfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EwznSGMr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EwznSGMr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAA7AC2BBFC;
	Mon, 27 May 2024 18:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836324;
	bh=e39dQ5JvBZ3J08TKCCsQOEsK8rejlWCWO1FmSkadTq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EwznSGMrgjTyvN3OECJkXA+rJI7zwtOsUZ/5Zr1D5rDtBSNlVzDawTORP8/lm6OvM
	 AvQ2yZAzititBf839hSc0z4alb2prTTMU0NnksqMcM6gOI9KqnIbCNcLXXKUjf5oE+
	 9/YwzAfAjI8/7dvNZZcwrEjBXQPcF7QA4AkKUTYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: [PATCH 6.9 010/427] speakup: Fix sizeof() vs ARRAY_SIZE() bug
Date: Mon, 27 May 2024 20:50:57 +0200
Message-ID: <20240527185602.772648458@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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


