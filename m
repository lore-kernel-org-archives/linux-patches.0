Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3493C1085;
	Sat, 17 Oct 2026 17:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258498; cv=none; b=H/UlXUYfdwZPLopulxC0Rv+wXt/eBvpr9ORVFBnIcycEtAp60EP0Iz9C6NxzxVERJttzK0HpBeEv6a7kL3eL1e6xmlpjGeEggv/F5ydcsn0fnwKqkUITWRPezss5Nzfuybb52EN+VYyrAyjbRNmmp1Rneh3lr5X2b5lrwojJ9to=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258498; c=relaxed/simple;
	bh=Uwb4+nbhhNVdE+sPwXPNB/92YpOkwM4pzWEreBcJzvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oFUBYzBwwrXvp77yrJwoXIvxt18yNuZX5rNWE4W3XqCUpeuuZYJKTK6HIseFLMN765gVQUjB3RJMtAwRoVWDyeFFF2Z0a0OQU2IKH83Bt+KCGdb/OTxKTNO++bHwbMzk1Yr32R9PZEFyjuPZSNVtPbHDDtVHU6gtJe8qUrJ15kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K1CpuuUc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K1CpuuUc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C5D1F000C4;
	Sat, 17 Oct 2026 17:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258497;
	bh=DRPsZXhw4rGafhRaqoGeIp9Rc97zdrhIk+310bEvJZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K1CpuuUcxPNNoI653rMg8G71hxC/rUTLqarPOkr+Cur3bQmPu0Kev/h5UBF3t+66v
	 XX+YuCjypTXC1UrQmHX/XBErnE9ZnHmbsr12Vi5Jjd+9jRhaJoG9qNv/Fv9rr0ADs9
	 iDL+M0XYLwSmMtVGJaUE4tN2+WNAswjcmMmu0D4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tatsuya S <tatsuya.s2862@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0904/1674] HID: core: Add reserved item tag for main items
Date: Sat, 17 Oct 2026 17:52:56 +0200
Message-ID: <20261017160454.330248028@linuxfoundation.org>
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

From: Tatsuya S <tatsuya.s2862@gmail.com>

[ Upstream commit c600a55922640b1c4dcfdc5a694cadd2dd9d1599 ]

For main items, separate warning of reserved item tag from
warning of unknown item tag.
This comes from 6.2.2.4 Main Items of Device Class Definition
for HID 1.11 specification.

Signed-off-by: Tatsuya S <tatsuya.s2862@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Stable-dep-of: 0a3fe972a7cb ("HID: core: Mitigate potential OOB by removing bogus memset()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-core.c | 6 +++++-
 include/linux/hid.h    | 2 ++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 9981346d23aac..31c8c7fb9c849 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -635,7 +635,11 @@ static int hid_parser_main(struct hid_parser *parser, struct hid_item *item)
 		ret = hid_add_field(parser, HID_FEATURE_REPORT, data);
 		break;
 	default:
-		hid_warn(parser->device, "unknown main item tag 0x%x\n", item->tag);
+		if (item->tag >= HID_MAIN_ITEM_TAG_RESERVED_MIN &&
+			item->tag <= HID_MAIN_ITEM_TAG_RESERVED_MAX)
+			hid_warn(parser->device, "reserved main item tag 0x%x\n", item->tag);
+		else
+			hid_warn(parser->device, "unknown main item tag 0x%x\n", item->tag);
 		ret = 0;
 	}
 
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 9ae229a34d7b8..18a69f6c9d41a 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -81,6 +81,8 @@ struct hid_item {
 #define HID_MAIN_ITEM_TAG_FEATURE		11
 #define HID_MAIN_ITEM_TAG_BEGIN_COLLECTION	10
 #define HID_MAIN_ITEM_TAG_END_COLLECTION	12
+#define HID_MAIN_ITEM_TAG_RESERVED_MIN		13
+#define HID_MAIN_ITEM_TAG_RESERVED_MAX		15
 
 /*
  * HID report descriptor main item contents
-- 
2.53.0



