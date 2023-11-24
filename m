Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E0A339BE;
	Fri, 24 Nov 2023 19:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rFAy74C+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE070C433C8;
	Fri, 24 Nov 2023 19:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853646;
	bh=zJa9qB1a7G2wP4JeKtP57e3PPe8V9rt/wnh4BSgl1Cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rFAy74C+9ZHS/UrZQT6XZl1YYShmZ92pc+fQmRdvpIx+H+M9mVLFlEaGYKA3bNWus
	 Y0qF+Wl9gefxorH+QdEYEKE0Y4yaoRYyaxBsqvZTL7Y5rJKma18bwRsBV5jcqaMxn5
	 SmhdROyEjVfA6f12WRynTjEmnqvDBEMJc7Eet1BU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 5.15 264/297] media: lirc: drop trailing space from scancode transmit
Date: Fri, 24 Nov 2023 17:55:06 +0000
Message-ID: <20231124172009.389149972@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -287,7 +287,11 @@ static ssize_t lirc_transmit(struct file
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


