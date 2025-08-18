Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E183D8BEC;
	Mon, 18 Aug 2025 13:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524103; cv=none; b=lX+cL0aWduTemAgrAsqQkd8Jf2vp7I974i3ptuQ5AZFuArmku/M23ch9iVAtBdSOJXBDb0vtdhvOmmJF3J+6LgY2tc3Q1dzIrVS1VPtb4Hig3ALIPqpBCjKuz6x7nCuVJ5ot3/+5TrVMDT7tDEglfwseX2+nwhCQQnp8wY/JD7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524103; c=relaxed/simple;
	bh=kZ31hKJr7WIrkvpvbD1v7wbjS9/3FDu9uQKCuhfG2K0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GOF6bkqAZsmjk09mowQvvTlFic/zqzVqxnaz6l0CgJhYkZ6SkYviySjXKOX6t2nu9Ze+sRhR8KOcs0BaCV8M1MtFzJ1ACq3uwpPEcoMOJv1XlT3I2Um4Oi/DB3/RMS2HlRtkf4/qYcZUPmJrZcpbDFN9OMmgT3VV8IR9Z7B3M/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oXfQK5z+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oXfQK5z+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF41C4CEEB;
	Mon, 18 Aug 2025 13:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524102;
	bh=kZ31hKJr7WIrkvpvbD1v7wbjS9/3FDu9uQKCuhfG2K0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oXfQK5z+66VguyK31saTwmjVhi/eMNBcBCf3uIvbZOf62PuE+IexfeturkqvpYzwE
	 x3d++gU18cZj11GOuLsk5/7KORg8IQHK14R1sQmzuGqCUTn2sWnya/ElhHwd2LC01z
	 uD29n6SYOr1XgQMtEezuqrBN6svlbgofjEULUqo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Chen <chenl311@chinatelecom.cn>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 369/515] HID: rate-limit hid_warn to prevent log flooding
Date: Mon, 18 Aug 2025 14:45:55 +0200
Message-ID: <20250818124512.611542110@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-core.c | 4 ++--
 include/linux/hid.h    | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 9ebbaf8cc131..bd4b4cc785f7 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -663,9 +663,9 @@ static int hid_parser_main(struct hid_parser *parser, struct hid_item *item)
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
index daae1d6d11a7..ada27535a195 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -1233,6 +1233,8 @@ void hid_quirks_exit(__u16 bus);
 	dev_notice(&(hid)->dev, fmt, ##__VA_ARGS__)
 #define hid_warn(hid, fmt, ...)				\
 	dev_warn(&(hid)->dev, fmt, ##__VA_ARGS__)
+#define hid_warn_ratelimited(hid, fmt, ...)				\
+	dev_warn_ratelimited(&(hid)->dev, fmt, ##__VA_ARGS__)
 #define hid_info(hid, fmt, ...)				\
 	dev_info(&(hid)->dev, fmt, ##__VA_ARGS__)
 #define hid_dbg(hid, fmt, ...)				\
-- 
2.39.5



