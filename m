Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD223C1085;
	Sat, 17 Oct 2026 17:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258501; cv=none; b=WeNxjJGQzDywD5ZHa5t6fLJUQWnC6mRrk8cVc5cQpSDD8fBvpIa3NwmjS9fVTfDzVusrzn/Qp+EbFxfDXxMTumIYwGeghcP+3KEcjjI61Gr6VbWqgK24YkaWLoLqfh+0LagyBRVvCFN90pfoRJLOZFTbd/MLmuxczo+E00KQx8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258501; c=relaxed/simple;
	bh=eSI6Q3EKXmMBm4S/Ug6upNwPXrX91a6NF/Njh9WkS5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/bdzdRzLLKfgAcjwc+QV6mIM0qRRhJ6Bt+RmWfkNwBFREbdBZEEFt9pwsSNaPEjLQkpXk50r+0HkKtk4Kfej/LBl69PFjbjAz8q+Douc+6fa15IvRmPavnJwIi/9alIH/nSs0RCCK3Z5u1JyfXhAvKDRz20bFUDYOQ6KEspgbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1VotWhXh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1VotWhXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62CB31F000C4;
	Sat, 17 Oct 2026 17:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258499;
	bh=3eVkeRv7dQs8Xo5su8IQV7LgnDyTPLOnBecDGNcDHAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1VotWhXhGcC0vR31H/T7ghv0t+Kb9CUwL7P5YveTpKCfTLsi6IFDI9PoYGYpUgFfS
	 87b4zHEJUzAwDlfBmuMz6kiLASWHUgu+6vHXIlH11DocaBE8qqtD+yFyqcC8eDqfq4
	 PFMbJ07kO/LZovkFzrXlRbgILxRO4+Eryne8XQPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Chen <chenl311@chinatelecom.cn>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0905/1674] HID: rate-limit hid_warn to prevent log flooding
Date: Sat, 17 Oct 2026 17:52:57 +0200
Message-ID: <20261017160454.355980531@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Chen <chenl311@chinatelecom.cn>

[ Upstream commit 4051ead99888f101be92c7ce90d2de09aac6fd1c ]

Syzkaller can create many uhid devices that trigger
repeated warnings like:

  "hid-generic xxxx: unknown main item tag 0x0"

These messages can flood the system log, especially if a crash occurs
(e.g., with a slow UART console, leading to soft lockups). To mitigate
this, convert `hid_warn()` to use `dev_warn_ratelimited()`.

This helps reduce log noise and improves system stability under fuzzing
or faulty device scenarios.

Signed-off-by: Li Chen <chenl311@chinatelecom.cn>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Stable-dep-of: 0a3fe972a7cb ("HID: core: Mitigate potential OOB by removing bogus memset()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-core.c | 4 ++--
 include/linux/hid.h    | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 31c8c7fb9c849..a7ad90bce2995 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -637,9 +637,9 @@ static int hid_parser_main(struct hid_parser *parser, struct hid_item *item)
 	default:
 		if (item->tag >= HID_MAIN_ITEM_TAG_RESERVED_MIN &&
 			item->tag <= HID_MAIN_ITEM_TAG_RESERVED_MAX)
-			hid_warn(parser->device, "reserved main item tag 0x%x\n", item->tag);
+			hid_warn_ratelimited(parser->device, "reserved main item tag 0x%x\n", item->tag);
 		else
-			hid_warn(parser->device, "unknown main item tag 0x%x\n", item->tag);
+			hid_warn_ratelimited(parser->device, "unknown main item tag 0x%x\n", item->tag);
 		ret = 0;
 	}
 
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 18a69f6c9d41a..c7f04c9f8ff4a 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -1269,6 +1269,8 @@ int hid_pidff_init_with_quirks(struct hid_device *hid, __u32 initial_quirks);
 	dev_notice(&(hid)->dev, fmt, ##__VA_ARGS__)
 #define hid_warn(hid, fmt, ...)				\
 	dev_warn(&(hid)->dev, fmt, ##__VA_ARGS__)
+#define hid_warn_ratelimited(hid, fmt, ...)				\
+	dev_warn_ratelimited(&(hid)->dev, fmt, ##__VA_ARGS__)
 #define hid_info(hid, fmt, ...)				\
 	dev_info(&(hid)->dev, fmt, ##__VA_ARGS__)
 #define hid_dbg(hid, fmt, ...)				\
-- 
2.53.0



