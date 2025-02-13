Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C70199934;
	Thu, 13 Feb 2025 15:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460616; cv=none; b=NUpQDGotoPrZJclzxVOjVvk27j/lpC1ZdOhMPdJRzb2tNOOMIdFqx8YMX79LWd5ppmjK/scsqRYmGTiOS3kygfjHo1DwKdOUWoY5Dc+uT3Jsr0G5mq2cAqoKPxOqn2zswmoAjXUKWDbFHckr2e8jmou064ufg1JUG0vv5NRzGlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460616; c=relaxed/simple;
	bh=cjhox9k6a0zJveRRwx8KXkxfCnpvgUzB+aRb6Y0pL2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U6esGiK3et2mltLTn2LlY5nOS0EQnWkEcK2AnQlvcvKq5LRqCQQrfXPp/71FmcKDLkhBF4nUaZUPNbkFRBcOLqd+fxjxTm+tTxyQkY6+zUWUu1g+t1kPEfiPhDwwWy54U9V8lOTLOoZqe6kpT7xOy6eQI/nfIXiMD/C9L08TvXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QxG6dqVu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QxG6dqVu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C00CC4CEE9;
	Thu, 13 Feb 2025 15:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460615;
	bh=cjhox9k6a0zJveRRwx8KXkxfCnpvgUzB+aRb6Y0pL2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QxG6dqVuv9cGY4lOT0NxO5mRNIrJMhuTsux7j4vS5wozHR4gbDK8vKOEZTtgAscH7
	 niT5r7bJ4IUSldIfDUinWxH4tjmPMzxVmJfBOaAOsd+fZlhVxfjEDP+fAQwN6c8V2m
	 Q0saFU8RfkrGhTcYnHLO+huk9nkh3hVN/Cu6OVh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Foster Snowhill <forst@pen.gy>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 136/273] usbnet: ipheth: fix possible overflow in DPE length check
Date: Thu, 13 Feb 2025 15:28:28 +0100
Message-ID: <20250213142412.711471938@linuxfoundation.org>
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

commit c219427ed296f94bb4b91d08626776dc7719ee27 upstream.

Originally, it was possible for the DPE length check to overflow if
wDatagramIndex + wDatagramLength > U16_MAX. This could lead to an OoB
read.

Move the wDatagramIndex term to the other side of the inequality.

An existing condition ensures that wDatagramIndex < urb->actual_length.

Fixes: a2d274c62e44 ("usbnet: ipheth: add CDC NCM support")
Cc: stable@vger.kernel.org
Signed-off-by: Foster Snowhill <forst@pen.gy>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/ipheth.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
index 46afb95ffabe..45daae234cb8 100644
--- a/drivers/net/usb/ipheth.c
+++ b/drivers/net/usb/ipheth.c
@@ -243,8 +243,8 @@ static int ipheth_rcvbulk_callback_ncm(struct urb *urb)
 	while (le16_to_cpu(dpe->wDatagramIndex) != 0 &&
 	       le16_to_cpu(dpe->wDatagramLength) != 0) {
 		if (le16_to_cpu(dpe->wDatagramIndex) >= urb->actual_length ||
-		    le16_to_cpu(dpe->wDatagramIndex) +
-		    le16_to_cpu(dpe->wDatagramLength) > urb->actual_length) {
+		    le16_to_cpu(dpe->wDatagramLength) > urb->actual_length -
+		    le16_to_cpu(dpe->wDatagramIndex)) {
 			dev->net->stats.rx_length_errors++;
 			return retval;
 		}
-- 
2.48.1



