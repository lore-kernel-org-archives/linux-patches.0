Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFE13D890F;
	Wed,  8 Apr 2026 18:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673976; cv=none; b=ZJxSWH1sHssObQu/lmuvwWY094Hu5fClbg2qQHif5A+Ar5QU+Zp6TX8MX/OKf5MokmxbNt7E0nnEFohM163XcA1Vsv3sqykz+ZoqgoOw8RViKp7zkhxxp2nE7mf3+UYLEpr42/5csidvjhVnqryhGA4cd7ZR8qXuEsVjYhSXahM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673976; c=relaxed/simple;
	bh=NX7js3Y0nFKh+7Vww9cpYPZ7myAcLn95lMAyk4zlXZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MDUCTtRP3s0nqc+KYQFuHRYxDnopJdxMY+6UTFYyXdzZu/yEshLxQt3Uez9ANy0egURQ1eJDZ+QabUAcvpJvjZKmJrBlH6FzGT0dBUV1c+rtH0hh6rGIV+DOVmWfnRw/EaGrbW50VUK4kTbMW9z4ECaKdeTY72Ws+2VWyFjbJp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LKPR0+KQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LKPR0+KQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00629C19425;
	Wed,  8 Apr 2026 18:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673976;
	bh=NX7js3Y0nFKh+7Vww9cpYPZ7myAcLn95lMAyk4zlXZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LKPR0+KQvCt3UAiRc5H3XPTXcTxRRSZ6mYReqFmwQ+AAeIUqCDWKRXaT6iVgurOu2
	 bO/kqqc5REcsjm3hmkwYfZIKwJWrZc3NODZyjN6aABKAdjTXyWXNYVBtRCjoC35+ee
	 QKB79NG/8pDOV8bAyKg1y9cPv6wazQ/Y8Ou091H8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9a3c54f52bd1edbd975f@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Heitor Alves de Siqueira <halves@igalia.com>
Subject: [PATCH 6.12 161/242] usb: usbtmc: Flush anchored URBs in usbtmc_release
Date: Wed,  8 Apr 2026 20:03:21 +0200
Message-ID: <20260408175933.114582484@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Heitor Alves de Siqueira <halves@igalia.com>

commit 8a768552f7a8276fb9e01d49773d2094ace7c8f1 upstream.

When calling usbtmc_release, pending anchored URBs must be flushed or
killed to prevent use-after-free errors (e.g. in the HCD giveback
path). Call usbtmc_draw_down() to allow anchored URBs to be completed.

Fixes: 4f3c8d6eddc2 ("usb: usbtmc: Support Read Status Byte with SRQ per file")
Reported-by: syzbot+9a3c54f52bd1edbd975f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9a3c54f52bd1edbd975f
Cc: stable <stable@kernel.org>
Signed-off-by: Heitor Alves de Siqueira <halves@igalia.com>
Link: https://patch.msgid.link/20260312-usbtmc-flush-release-v1-1-5755e9f4336f@igalia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/usbtmc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -254,6 +254,9 @@ static int usbtmc_release(struct inode *
 	list_del(&file_data->file_elem);
 
 	spin_unlock_irq(&file_data->data->dev_lock);
+
+	/* flush anchored URBs */
+	usbtmc_draw_down(file_data);
 	mutex_unlock(&file_data->data->io_mutex);
 
 	kref_put(&file_data->data->kref, usbtmc_delete);


