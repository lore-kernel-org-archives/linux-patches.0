Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E101170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 13:58:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D2E8C433C7;
	Mon, 11 Sep 2023 13:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440710;
	bh=uCkuAZ1VMNwBoQX/0f9u01s5A6VQ4IIvb47phhiZJPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k9NVRZMZi+EFHfQCxCaJIdZGmV4WPB/dXzc/EOE30vRP8+N4MXfr7dqE9zH8cVmJl
	 rh8q01iLTf/92E3DIkelUU4rWGXLEFtBInbSd2qz0jAPgfA5kZFeII8X33imTly29k
	 TxjGNM52MDB5mYW3YTK5JM9D5qKqpfAgQrIyen4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Norris <briannorris@chromium.org>,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 157/739] wifi: mwifiex: fix memory leak in mwifiex_histogram_read()
Date: Mon, 11 Sep 2023 15:39:16 +0200
Message-ID: <20230911134655.536125511@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit 9c8fd72a5c2a031cbc680a2990107ecd958ffcdb ]

Always free the zeroed page on return from 'mwifiex_histogram_read()'.

Fixes: cbf6e05527a7 ("mwifiex: add rx histogram statistics support")

Acked-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230802160726.85545-1-dmantipov@yandex.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/debugfs.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/debugfs.c b/drivers/net/wireless/marvell/mwifiex/debugfs.c
index 52b18f4a774b7..0cdd6c50c1c08 100644
--- a/drivers/net/wireless/marvell/mwifiex/debugfs.c
+++ b/drivers/net/wireless/marvell/mwifiex/debugfs.c
@@ -253,8 +253,11 @@ mwifiex_histogram_read(struct file *file, char __user *ubuf,
 	if (!p)
 		return -ENOMEM;
 
-	if (!priv || !priv->hist_data)
-		return -EFAULT;
+	if (!priv || !priv->hist_data) {
+		ret = -EFAULT;
+		goto free_and_exit;
+	}
+
 	phist_data = priv->hist_data;
 
 	p += sprintf(p, "\n"
@@ -309,6 +312,8 @@ mwifiex_histogram_read(struct file *file, char __user *ubuf,
 	ret = simple_read_from_buffer(ubuf, count, ppos, (char *)page,
 				      (unsigned long)p - page);
 
+free_and_exit:
+	free_page(page);
 	return ret;
 }
 
-- 
2.40.1



