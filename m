Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F65882B
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:14:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6407DC433D2;
	Fri, 10 Mar 2023 15:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678461281;
	bh=vWjZYVCyqOa7QEyu/N9kEW1AAi5cQG0o8QSHeR20/1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NrjlXXybhQHR9LYpXeQN+QdHS5/CP0XnVLFK8nvJKe6h5gGGQ4f1cfUqjcxTpX/HC
	 qqVl0uleeTBqIDipbXpzbo9jAEhIS5ECIYV69q4KJm+4NndPqSB9HYF5Ip8+C2Q/sm
	 f2GdTO+NF+fXi5e4Q5TNK/zapfHDphs8Azk+HuM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Jilin Yuan <yuanjilin@cdjrlc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 085/136] USB: fix memory leak with using debugfs_lookup()
Date: Fri, 10 Mar 2023 14:43:27 +0100
Message-Id: <20230310133709.737987433@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 30374434edab20e25776f8ecb4bc9d1e54309487 ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic at
once.

Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Jilin Yuan <yuanjilin@cdjrlc.com>
Link: https://lore.kernel.org/r/20230106152828.3790902-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/core/usb.c b/drivers/usb/core/usb.c
index 62368c4ed37af..cc36f9f228148 100644
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -1036,7 +1036,7 @@ static void usb_debugfs_init(void)
 
 static void usb_debugfs_cleanup(void)
 {
-	debugfs_remove(debugfs_lookup("devices", usb_debug_root));
+	debugfs_lookup_and_remove("devices", usb_debug_root);
 }
 
 /*
-- 
2.39.2



