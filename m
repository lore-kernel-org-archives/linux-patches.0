Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701D23815F8;
	Sat, 12 Sep 2026 19:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242917; cv=none; b=PPeA82ElItoulIHBJYfsWL5qrvCwojfOkAHOdK2ZF7WdAIbnsgMfsqiJeeq+P4JIivtPuPz8ewieA+jNf2S4NIS7o08ep1g1xrbk1PoEZSgPamyDiQ5OzVtvxXmcjcQqXi0321+FRP4Mwmyin6wp2mQdQ/CLN/F9PpzHv/kCAzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242917; c=relaxed/simple;
	bh=/As3pf1B7zxJsfBZtcfrGCxhcK/2l6PeS1FtoYuUJzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y6BKgfnU8t36OiWYHJN0HLTNx2JQwPlC8O6AFTBkoPmuHqe2OwOQ8FHOrc9LXNcMlbmC5DI3XWzw9sQxN2qFN40ZC4adZe/ZgpC2G5jRUBnIT+jmRrpFSzb3rFNCohvvs4LqT1rg6he45quj/bAT1xprCG0f4uSpDBKxt4oBbIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pZw/RVXh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pZw/RVXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD921F000FF;
	Sat, 12 Sep 2026 19:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242916;
	bh=/7k+EPQEKVLm6wrBZ44Va7KJdamh+VMoqhfI3KmtIQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pZw/RVXh+N2BNZERqEFnn8RWLl7q0WUh5iufj4pryoojXUQy+7ujSZPf9s3N9vke7
	 CvYWVqADe4P5sw9fVXtaSd0JkR6MAK8Ce/jYFSd6k5gciBAjpBRLdtp5t6DB2N9gl/
	 mmUWQkxM0ixLmHXtAsShG4EclTNbvKyrKF1NBjlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Jack Rosenthal <jrosenth@chromium.org>,
	Guenter Roeck <groeck@chromium.org>,
	Julius Werner <jwerner@chromium.org>,
	Brian Norris <briannorris@chromium.org>,
	Stephen Boyd <swboyd@chromium.org>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 573/798] firmware: coreboot: Check size of table entry and use flex-array
Date: Sat, 12 Sep 2026 09:03:21 +0200
Message-ID: <20260912065530.262887253@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 3b293487b8752cc42c1cbf8a0447bc6076c075fa ]

The memcpy() of the data following a coreboot_table_entry couldn't
be evaluated by the compiler under CONFIG_FORTIFY_SOURCE. To make it
easier to reason about, add an explicit flexible array member to struct
coreboot_device so the entire entry can be copied at once. Additionally,
validate the sizes before copying. Avoids this run-time false positive
warning:

  memcpy: detected field-spanning write (size 168) of single field "&device->entry" at drivers/firmware/google/coreboot_table.c:103 (size 8)

Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Link: https://lore.kernel.org/all/03ae2704-8c30-f9f0-215b-7cdf4ad35a9a@molgen.mpg.de/
Cc: Jack Rosenthal <jrosenth@chromium.org>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Julius Werner <jwerner@chromium.org>
Cc: Brian Norris <briannorris@chromium.org>
Cc: Stephen Boyd <swboyd@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Julius Werner <jwerner@chromium.org>
Reviewed-by: Guenter Roeck <groeck@chromium.org>
Link: https://lore.kernel.org/r/20230107031406.gonna.761-kees@kernel.org
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Jack Rosenthal <jrosenth@chromium.org>
Link: https://lore.kernel.org/r/20230112230312.give.446-kees@kernel.org
Stable-dep-of: a58a57a1076f ("firmware: coreboot: Validate table bounds")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/google/coreboot_table.c | 9 +++++++--
 drivers/firmware/google/coreboot_table.h | 1 +
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/google/coreboot_table.c b/drivers/firmware/google/coreboot_table.c
index 568074148f62b..1f52d8b82ef8d 100644
--- a/drivers/firmware/google/coreboot_table.c
+++ b/drivers/firmware/google/coreboot_table.c
@@ -96,7 +96,12 @@ static int coreboot_table_populate(struct device *dev, void *ptr)
 	for (i = 0; i < header->table_entries; i++) {
 		entry = ptr_entry;
 
-		device = kzalloc(sizeof(struct device) + entry->size, GFP_KERNEL);
+		if (entry->size < sizeof(*entry)) {
+			dev_warn(dev, "coreboot table entry too small!\n");
+			return -EINVAL;
+		}
+
+		device = kzalloc(sizeof(device->dev) + entry->size, GFP_KERNEL);
 		if (!device)
 			return -ENOMEM;
 
@@ -104,7 +109,7 @@ static int coreboot_table_populate(struct device *dev, void *ptr)
 		device->dev.parent = dev;
 		device->dev.bus = &coreboot_bus_type;
 		device->dev.release = coreboot_device_release;
-		memcpy(&device->entry, ptr_entry, entry->size);
+		memcpy(device->raw, ptr_entry, entry->size);
 
 		ret = device_register(&device->dev);
 		if (ret) {
diff --git a/drivers/firmware/google/coreboot_table.h b/drivers/firmware/google/coreboot_table.h
index 7b7b4a6eeddae..89fbf18468947 100644
--- a/drivers/firmware/google/coreboot_table.h
+++ b/drivers/firmware/google/coreboot_table.h
@@ -66,6 +66,7 @@ struct coreboot_device {
 		struct coreboot_table_entry entry;
 		struct lb_cbmem_ref cbmem_ref;
 		struct lb_framebuffer framebuffer;
+		DECLARE_FLEX_ARRAY(u8, raw);
 	};
 };
 
-- 
2.53.0



