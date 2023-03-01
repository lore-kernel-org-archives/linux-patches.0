Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4B9847A
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 18:11:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 437EAC433EF;
	Wed,  1 Mar 2023 18:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677694316;
	bh=31LUiSWRRqRWPJrcSH165zxbffsBpNzPCUysg4JzK1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vhPnF4Z5kGycxcf7aIKEc3y1sidcjZFw68qiKAz/iKWLFub0NOXO6lN47GGG2yOx8
	 xQRVFXSHKP0PBYrJSVGl4x9mC6zRcsSgnSUw3hezh08gFyUDlYlrNKZ1cTaWZIurEJ
	 tCHbfZMHtyk1emxAqeRc3o1H+Pj6Zi3LrjxXrAmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Zhao <xnzhao@google.com>,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 19/42] HID: core: Fix deadloop in hid_apply_multiplier.
Date: Wed,  1 Mar 2023 19:08:40 +0100
Message-Id: <20230301180657.925828018@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180657.003689969@linuxfoundation.org>
References: <20230301180657.003689969@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xin Zhao <xnzhao@google.com>

[ Upstream commit ea427a222d8bdf2bc1a8a6da3ebe247f7dced70c ]

The initial value of hid->collection[].parent_idx if 0. When
Report descriptor doesn't contain "HID Collection", the value
remains as 0.

In the meanwhile, when the Report descriptor fullfill
all following conditions, it will trigger hid_apply_multiplier
function call.
1. Usage page is Generic Desktop Ctrls (0x01)
2. Usage is RESOLUTION_MULTIPLIER (0x48)
3. Contain any FEATURE items

The while loop in hid_apply_multiplier will search the top-most
collection by searching parent_idx == -1. Because all parent_idx
is 0. The loop will run forever.

There is a Report Descriptor triggerring the deadloop
0x05, 0x01,        // Usage Page (Generic Desktop Ctrls)
0x09, 0x48,        // Usage (0x48)
0x95, 0x01,        // Report Count (1)
0x75, 0x08,        // Report Size (8)
0xB1, 0x01,        // Feature

Signed-off-by: Xin Zhao <xnzhao@google.com>
Link: https://lore.kernel.org/r/20230130212947.1315941-1-xnzhao@google.com
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 3e1803592bd4a..5c72aef3d3dd5 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1202,6 +1202,7 @@ int hid_open_report(struct hid_device *device)
 	__u8 *end;
 	__u8 *next;
 	int ret;
+	int i;
 	static int (*dispatch_type[])(struct hid_parser *parser,
 				      struct hid_item *item) = {
 		hid_parser_main,
@@ -1252,6 +1253,8 @@ int hid_open_report(struct hid_device *device)
 		goto err;
 	}
 	device->collection_size = HID_DEFAULT_NUM_COLLECTIONS;
+	for (i = 0; i < HID_DEFAULT_NUM_COLLECTIONS; i++)
+		device->collection[i].parent_idx = -1;
 
 	ret = -EINVAL;
 	while ((next = fetch_item(start, end, &item)) != NULL) {
-- 
2.39.0



