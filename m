Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3999443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:30:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B0BC433CB;
	Sun, 13 Aug 2023 21:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962236;
	bh=Q/9huDZQtCDnqCu3n8Lxkqn/nicz6guvEabofKVyExM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I+eJBcIJ+1Me1M8ISIn7iLsVE4bdF00MIGq74lZC7wEMAWe2BeJR2EbE8ytdJpjbo
	 vjvumYI6GRnWMhroi4WrF0JzwFkVpZ5OZ6K8HvXaDRo5Pta+ekj+C404gQ/QXcAv7l
	 u5df9PUz1Imfgq4iydtFzzeE2vgzDJP7GC8Kyjdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Chen <chenhao418@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.4 163/206] net: hns3: fix strscpy causing content truncation issue
Date: Sun, 13 Aug 2023 23:18:53 +0200
Message-ID: <20230813211729.692342034@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hao Chen <chenhao418@huawei.com>

commit 5e3d20617b055e725e785e0058426368269949f3 upstream.

hns3_dbg_fill_content()/hclge_dbg_fill_content() is aim to integrate some
items to a string for content, and we add '\n' and '\0' in the last
two bytes of content.

strscpy() will add '\0' in the last byte of destination buffer(one of
items), it result in finishing content print ahead of schedule and some
dump content truncation.

One Error log shows as below:
cat mac_list/uc
UC MAC_LIST:

Expected:
UC MAC_LIST:
FUNC_ID  MAC_ADDR            STATE
pf       00:2b:19:05:03:00   ACTIVE

The destination buffer is length-bounded and not required to be
NUL-terminated, so just change strscpy() to memcpy() to fix it.

Fixes: 1cf3d5567f27 ("net: hns3: fix strncpy() not using dest-buf length as length issue")
Signed-off-by: Hao Chen <chenhao418@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Link: https://lore.kernel.org/r/20230809020902.1941471-1-shaojijie@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c         |    4 ++--
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -461,9 +461,9 @@ static void hns3_dbg_fill_content(char *
 		if (result) {
 			if (item_len < strlen(result[i]))
 				break;
-			strscpy(pos, result[i], strlen(result[i]));
+			memcpy(pos, result[i], strlen(result[i]));
 		} else {
-			strscpy(pos, items[i].name, strlen(items[i].name));
+			memcpy(pos, items[i].name, strlen(items[i].name));
 		}
 		pos += item_len;
 		len -= item_len;
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -111,9 +111,9 @@ static void hclge_dbg_fill_content(char
 		if (result) {
 			if (item_len < strlen(result[i]))
 				break;
-			strscpy(pos, result[i], strlen(result[i]));
+			memcpy(pos, result[i], strlen(result[i]));
 		} else {
-			strscpy(pos, items[i].name, strlen(items[i].name));
+			memcpy(pos, items[i].name, strlen(items[i].name));
 		}
 		pos += item_len;
 		len -= item_len;


