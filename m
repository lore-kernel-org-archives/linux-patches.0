Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75E82E84A;
	Fri, 24 Nov 2023 19:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dBl93cxl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365D8C433C8;
	Fri, 24 Nov 2023 19:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852967;
	bh=UcpPLGcqP224IKBwNsLMvZQBv1WYqtD6vX1V/8AUdJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dBl93cxlR6iM6e1icKWuWHxQIOec9v8Jw5fZ06xBTwQ12du9CjL+oY/apSRESOh61
	 oSN/Z0x5sa0AeufcWkkiogXaLAkjzzOgYuOJitdfMm+0tEPtK2YhMAt1hfopPt7lTL
	 N5rZMa4/XJdzyCPxgQtw7XVZbdCYsJNzgeVkv81A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 5.10 170/193] media: lirc: drop trailing space from scancode transmit
Date: Fri, 24 Nov 2023 17:54:57 +0000
Message-ID: <20231124171953.978463358@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171947.127438872@linuxfoundation.org>
References: <20231124171947.127438872@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

commit c8a489f820179fb12251e262b50303c29de991ac upstream.

When transmitting, infrared drivers expect an odd number of samples; iow
without a trailing space. No problems have been observed so far, so
this is just belt and braces.

Fixes: 9b6192589be7 ("media: lirc: implement scancode sending")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/lirc_dev.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -286,7 +286,11 @@ static ssize_t lirc_transmit(struct file
 		if (ret < 0)
 			goto out_kfree_raw;
 
-		count = ret;
+		/* drop trailing space */
+		if (!(ret % 2))
+			count = ret - 1;
+		else
+			count = ret;
 
 		txbuf = kmalloc_array(count, sizeof(unsigned int), GFP_KERNEL);
 		if (!txbuf) {


