Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF52143736;
	Thu, 13 Feb 2025 15:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460649; cv=none; b=A53dW2Dnvws80H4j5eXYPXEQUw7D8c/DiY91XQDZWFB1NvMpfW9AoghtKUBS/kn6JAlTUXj7DktdW5fJIGYU0uA7iHOLlep4YiCRI7dSxIvLf80ji0e2ffmTvHxRUatKF7mmcFx0qr03zNS/hZlwmHvdVtKDgv4JzqNxlcPL9eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460649; c=relaxed/simple;
	bh=/SBr5Yv/4Jq4jT/DzBic1UYYJA6J6J5zyNV4QqP2BeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iSJjJs8rnrkr3b/0NnMYNeT3WV2lasJ4jQmg5QO/qfbiucaF4E5GNcDrmdn8zj6SdhAMQgiw0CNtD3f7rKCBzuPx+VMS6ooDMwatz+7KExERR3PoTENcg4htg5eKnCGyfiihhOsL0lVUHPONPR8/d8hbq+ah38XQ8BW+pgHTAPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yy1Sq46y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yy1Sq46y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8764C4CED1;
	Thu, 13 Feb 2025 15:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460649;
	bh=/SBr5Yv/4Jq4jT/DzBic1UYYJA6J6J5zyNV4QqP2BeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yy1Sq46ynQ6w2C0oiVb5tJoW2G8RrhZbziyCSoeX7WYK1u6QcAk+svPruiwLrH9Eq
	 tWW2LXQ8My6DvLA9Qn0yFpK+4wdhgBTY207nKi9diEDZ1560Z7eacsyIz+wqytPXD/
	 mTrPppwdukvdh4aqlyg9pvy6ZvwHBs8usggLoSgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Foster Snowhill <forst@pen.gy>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 141/273] usbnet: ipheth: fix DPE OoB read
Date: Thu, 13 Feb 2025 15:28:33 +0100
Message-ID: <20250213142412.908075381@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/usb/ipheth.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
index 03249208612e..5347cd7e295b 100644
--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -246,7 +246,7 @@ static int ipheth_rcvbulk_callback_ncm(struct urb *urb)
 		goto rx_error;
 
 	dpe = ncm0->dpe16;
-	while (true) {
+	for (int dpe_i = 0; dpe_i < IPHETH_NDP16_MAX_DPE; ++dpe_i, ++dpe) {
 		dg_idx = le16_to_cpu(dpe->wDatagramIndex);
 		dg_len = le16_to_cpu(dpe->wDatagramLength);
 
@@ -268,8 +268,6 @@ static int ipheth_rcvbulk_callback_ncm(struct urb *urb)
 		retval = ipheth_consume_skb(buf, dg_len, dev);
 		if (retval != 0)
 			return retval;
-
-		dpe++;
 	}
 
 rx_error:
-- 
2.48.1



