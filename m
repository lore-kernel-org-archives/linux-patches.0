Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E40154BF
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:03:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2793C433C9;
	Wed, 20 Sep 2023 12:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211385;
	bh=/gn0yBNdmAwzIPkv317Rf/2KiFuA1YcLuiYqR705etc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H8sEyfqzdBgDKHtl2ELPgn6WBOt7tQVvW49sX4ePjWOUBHdMPcBXIPa92kXrwJDZ3
	 hjcRg5jfw8C8l+A2on7EZ6QACavTfVMyAUDDM2yqvsCd7skpgyniNLc8SEsQ0PkTOw
	 aMl0AkrUc6T4dvDUHlKF22mzn/a+bO42QqeKDkCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Norris <briannorris@chromium.org>,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 047/186] wifi: mwifiex: fix memory leak in mwifiex_histogram_read()
Date: Wed, 20 Sep 2023 13:29:10 +0200
Message-ID: <20230920112838.628420910@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112836.799946261@linuxfoundation.org>
References: <20230920112836.799946261@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

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
index 49ca84ef1a992..b843be87112c0 100644
--- a/drivers/net/wireless/marvell/mwifiex/debugfs.c
+++ b/drivers/net/wireless/marvell/mwifiex/debugfs.c
@@ -288,8 +288,11 @@ mwifiex_histogram_read(struct file *file, char __user *ubuf,
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
@@ -344,6 +347,8 @@ mwifiex_histogram_read(struct file *file, char __user *ubuf,
 	ret = simple_read_from_buffer(ubuf, count, ppos, (char *)page,
 				      (unsigned long)p - page);
 
+free_and_exit:
+	free_page(page);
 	return ret;
 }
 
-- 
2.40.1



