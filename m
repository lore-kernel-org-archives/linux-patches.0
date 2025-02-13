Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A41281349;
	Thu, 13 Feb 2025 14:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457805; cv=none; b=OayKnSUKn6uc+naCdxsenSF85uykt2og60jEhHSfkDGR8QKCQwuht0LX/N4pSG1/t8sarFaujJFckVIDc/DmddtuSmmt+4KBAJpGmVnDcHcD/PeS2lR+s5JEUN0vf2eiSxVlyNXgMc5CfdyLFr+ra6bPS/TiSKgDb7JHjInLxnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457805; c=relaxed/simple;
	bh=Nh8M1KTEg6FlM9SEbwh+W4Dsr8EsUG5YAhqZXXitk5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lOe+6VIam4V15UeYTalqMDw+KsUYn5ek3CEvKSg0tF+WGNVzfizMfd5L0vJNcUwWwDT80mMV9y+W0dfeSBMKQZhMYMN3jvixEa17GekLoidPaNnIpFuCOxXakTDfy6bOkwIm3a7rHg7yS08SzYVK/PbQEnZ5+n4/5VgDUudnq7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XcQaZFtA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XcQaZFtA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67033C4CED1;
	Thu, 13 Feb 2025 14:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457804;
	bh=Nh8M1KTEg6FlM9SEbwh+W4Dsr8EsUG5YAhqZXXitk5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XcQaZFtAsPa1ewOeNS8JFSWE5aaxrHIXNI8xTckhsLHpqvEifkoL+sLQawIutdjQt
	 hVd7b+FJajosz1RnZu5eDsY0lRwjupyGe4Bw9sCW5kHpp907rFqkU/DhcbpMG4UlXG
	 lUS/xJgHxjemndcUgYkuXQ317bK5Dbgi1gMdu4v0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Foster Snowhill <forst@pen.gy>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 217/422] usbnet: ipheth: fix DPE OoB read
Date: Thu, 13 Feb 2025 15:26:06 +0100
Message-ID: <20250213142444.911737982@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Foster Snowhill <forst@pen.gy>

commit ee591f2b281721171896117f9946fced31441418 upstream.

Fix an out-of-bounds DPE read, limit the number of processed DPEs to
the amount that fits into the fixed-size NDP16 header.

Fixes: a2d274c62e44 ("usbnet: ipheth: add CDC NCM support")
Cc: stable@vger.kernel.org
Signed-off-by: Foster Snowhill <forst@pen.gy>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/ipheth.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -246,7 +246,7 @@ static int ipheth_rcvbulk_callback_ncm(s
 		goto rx_error;
 
 	dpe = ncm0->dpe16;
-	while (true) {
+	for (int dpe_i = 0; dpe_i < IPHETH_NDP16_MAX_DPE; ++dpe_i, ++dpe) {
 		dg_idx = le16_to_cpu(dpe->wDatagramIndex);
 		dg_len = le16_to_cpu(dpe->wDatagramLength);
 
@@ -268,8 +268,6 @@ static int ipheth_rcvbulk_callback_ncm(s
 		retval = ipheth_consume_skb(buf, dg_len, dev);
 		if (retval != 0)
 			return retval;
-
-		dpe++;
 	}
 
 rx_error:


