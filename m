Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34DCB38654F;
	Sat, 17 Oct 2026 16:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253774; cv=none; b=d/jD3pJmpoeDYPgncJyDfB7E0/AERimkRr3Z223KC/4nzwuF2A3Flxpct26mWP0lONsTapXI2QAEEolLGy1Cwvqxi38+xs+tHedWZ30O22Vg3jv5GPkDEKG+FqyHzXfygagQh4y29Z1/7/1sgcWh8E0ssRRgrtevJOccoumbbe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253774; c=relaxed/simple;
	bh=BxMRqQVFIFdYZqrbSz1Uxy5ZxF1kKGmDXoDRdxfRj0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FOGRn8E/+Wb3Ig4Yg+Mzi9hp0JgOjnqbuKHrrV8qxitkJALrT1I9NKp+2ynAQUcYmawlve/YTP8UpGtfuxEZqYc3jhdqfE6XlKP1ExFDbwqB0FNh0lt3ipkcOovM4cxyafxGZ8PNKlsKWn/qhSoSoAlN/biupcW1xSGQxxkiRAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eMyjqONG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eMyjqONG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 898081F000C4;
	Sat, 17 Oct 2026 16:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253773;
	bh=3vmwpArgEEH/g8Ymv5kOJHbOaqWJLd1ZNMVFy09BRCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eMyjqONGbaA3SUuxFitQz75lK9dNWit4NsAmdXAhfyuUZjJ86hXa7Ya//cfL0sFYR
	 LR/e8+9cDZpqJWbOMr8y9kX4A3L3AtXaxuvAFzGLvQ9MlZm/fr1xzthsEnlzLCo4FU
	 BPDiHzWRmpku0u3YunpHZ1mdIs84WRmRcbXLU10k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Chen <chenl311@chinatelecom.cn>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 228/869] HID: rate-limit hid_warn to prevent log flooding
Date: Sat, 17 Oct 2026 17:51:09 +0200
Message-ID: <20261017160042.895250192@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
index ba6d42a3e634e..bf9cd8c7e4c5c 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -672,9 +672,9 @@ static int hid_parser_main(struct hid_parser *parser, struct hid_item *item)
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
index 89529c58da0a4..2edaa8cbdd4a9 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -1262,6 +1262,8 @@ void hid_quirks_exit(__u16 bus);
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



