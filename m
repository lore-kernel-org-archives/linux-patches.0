Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 130DF423761;
	Tue, 25 Aug 2026 13:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666081; cv=none; b=UTpR9R9skUL4eIJnlm1Nhmuq0GOz9nN1Ko8dWPbNnvIJeKYNFd7DoKtl2LGgOyoVpdGB9U4D+swJh1ixcUEwXKoV8CtUiCJJOxl8dwshHDHT79MfrywRVUmL99YnnsEPEvR5bai3QvnGMUjy1hQScV1glvjn5p2iUiXcynCUsEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666081; c=relaxed/simple;
	bh=l5RLfyJlVfTZFWsLprZHjQsdW65zyHpErTgXjvBYoYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oJkUXEcGJ05w7U+uwqCeo6Ls6KmbNoGWQYgI+4TPsRdGFcLVKEoPKXuU9+KPGmHg80AmNc5gk/ouWIV+D0kxz8IZQt+6INj3WTyxY+Wdz/ZTbtl/s1TwNismM9RIaX/et3O/RrYNnXzhb4dMVMTqvANFdp16ZhRm3BfJNCefVxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W6HpKjxF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W6HpKjxF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 662E01F000E9;
	Tue, 25 Aug 2026 13:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666080;
	bh=IzLdqzK9ZeZlEd9tjAZwSRDWqPP1vVcchqYzCsnSLqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W6HpKjxFsKRKmNz6aUIPat/p2VaZuEs9BNa87nBiaOCQxlW8GXy19QQr/ecbOt3qD
	 reqlo2lcChqujiF9A4rGwexgK9w89lMKDFS2goqHt4f0J2U69ZFdvjBlXeSbolFjUd
	 HNnvlfjJUGq4m+kibgHLpmsa9yH1eU01CK+i5fc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.1 76/79] HID: core: fix number/pointer type confusion on long items
Date: Tue, 25 Aug 2026 15:26:56 +0200
Message-ID: <20260825132544.658404646@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.677185791@linuxfoundation.org>
References: <20260825132541.677185791@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit 28abce951343fcec26e397610868efa4e1395c3f upstream.

When fetch_item() is called by hid_scan_report() on an item with
HID_ITEM_TAG_LONG, it stores a pointer to the item data in
item->data.longdata instead of storing a value directly in
item->data.{u8/u16/u32}.

When item_udata() or item_sdata() encounters such an item, it incorrectly
assumes that the item is in short format, and therefore returns the lower
part of a kernel pointer reinterpreted as a number.

When a HID device is connected whose descriptor contains a
HID_GLOBAL_ITEM_TAG_REPORT_SIZE encoded in long format with size=4, this
causes the lower half of a kernel pointer to be printed into dmesg as a
number, like this:

    hid (null): invalid report_size 107953555

To fix it, let item_udata() and item_sdata() verify that the item is in
short format.

Note that this bug only affects hid_scan_report(), while the main parsing
pass hid_parse_collections() will always bail out when encountering a long
item.

Sidenote: There are currently no users of data.longdata; maybe we should
just remove any parsing of long-format descriptors as a follow-up.

Fixes: 3dc8fc083dbf ("HID: Use hid_parser for pre-scanning the report descriptors")
Cc: stable@vger.kernel.org
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-core.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -349,6 +349,9 @@ static int hid_add_field(struct hid_pars
 
 static u32 item_udata(struct hid_item *item)
 {
+	if (item->format != HID_ITEM_FORMAT_SHORT)
+		return 0;
+
 	switch (item->size) {
 	case 1: return item->data.u8;
 	case 2: return item->data.u16;
@@ -359,6 +362,9 @@ static u32 item_udata(struct hid_item *i
 
 static s32 item_sdata(struct hid_item *item)
 {
+	if (item->format != HID_ITEM_FORMAT_SHORT)
+		return 0;
+
 	switch (item->size) {
 	case 1: return item->data.s8;
 	case 2: return item->data.s16;


