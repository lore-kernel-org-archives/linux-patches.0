Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8C982495;
	Wed, 19 Jun 2024 13:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803063; cv=none; b=QI41OYoHZaqhtO5mKw2dSX2qGTWehTgO/OE5r3RlG8GKGBBRNyDRa6keskP2VVjFDaj3Ljj5f5SYT0Sm9UPtQsD6ykvdWhYjEz7bRSWP34V9OQ0ZnRcCsz++ld/R/qM97O7wU5PEKZqILlXSrV0Vr59Alu3lVJBLzi0sN+D6iqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803063; c=relaxed/simple;
	bh=WVsIPZOlagzaFMOLAUwFJnxyonU1WqNx2wavicEpJgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HRF10eRjEGWVzt32xmU3+0XxP2lQMyyNRJ340O5HEOrDPsfcgPFttG616JNYm5P1+eK/6DBRgE42BnrgiV9uBwmyhP1q6l8Q8J34Io4DSc1T/FCrLxX3HSCbpTTp16u5gdZK8iufbffcEBrIMMYKfcxjDjBFlvwYhdihMPRmAVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zN8JLSpY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zN8JLSpY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 524F9C2BBFC;
	Wed, 19 Jun 2024 13:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803063;
	bh=WVsIPZOlagzaFMOLAUwFJnxyonU1WqNx2wavicEpJgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zN8JLSpYkuthVLlZGa82NTH3+aiO7AzjKJaiHHWqjNm+JPYdhHPOHA4pXrfivUNDc
	 ffSUWgiZthCrcsVnfNdeIT5xBAxxQjou67OQThgvdn52UkwKORkLT0wW+m81q03cOw
	 aZx0UzSpkjn6IcIO4MGmlIqBYwS24mQqXkEyv1os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 139/281] HID: logitech-dj: Fix memory leak in logi_dj_recv_switch_to_dj_mode()
Date: Wed, 19 Jun 2024 14:54:58 +0200
Message-ID: <20240619125615.190629681@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: José Expósito <jose.exposito89@gmail.com>

[ Upstream commit ce3af2ee95170b7d9e15fff6e500d67deab1e7b3 ]

Fix a memory leak on logi_dj_recv_send_report() error path.

Fixes: 6f20d3261265 ("HID: logitech-dj: Fix error handling in logi_dj_recv_switch_to_dj_mode()")
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-dj.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index 3c3c497b6b911..37958edec55f5 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -1284,8 +1284,10 @@ static int logi_dj_recv_switch_to_dj_mode(struct dj_receiver_dev *djrcv_dev,
 		 */
 		msleep(50);
 
-		if (retval)
+		if (retval) {
+			kfree(dj_report);
 			return retval;
+		}
 	}
 
 	/*
-- 
2.43.0



