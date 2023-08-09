Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF82017AA6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:27:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4350AC433C7;
	Wed,  9 Aug 2023 11:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580449;
	bh=r1HfVHaZ0U4+Jo/h/IrSHAbvhnmMaZzfv4L6KBTXHXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MWQF755JE6MlNcGmlwgYq1CrTxi4c0KlSbARIuQ3uMiEcPTK94arVbvKqr976rkAV
	 Uie3Yt3kQOZqHaxT61gcFSiVKube4yARD0JyI/QMOJ/CIPIg+pGXuKwRGN2zQnY+7T
	 /nbgXT3mWEOViakxeb9ISWoEXOS4Jhq03hGG/XAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 029/154] uapi: General notification queue definitions
Date: Wed,  9 Aug 2023 12:41:00 +0200
Message-ID: <20230809103637.955706582@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.887175326@linuxfoundation.org>
References: <20230809103636.887175326@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Howells <dhowells@redhat.com>

[ Upstream commit 0858caa419e6cf9d31e734d09d70b34f64443ef6 ]

Add UAPI definitions for the general notification queue, including the
following pieces:

 (*) struct watch_notification.

     This is the metadata header for notification messages.  It includes a
     type and subtype that indicate the source of the message
     (eg. WATCH_TYPE_MOUNT_NOTIFY) and the kind of the message
     (eg. NOTIFY_MOUNT_NEW_MOUNT).

     The header also contains an information field that conveys the
     following information:

	- WATCH_INFO_LENGTH.  The size of the entry (entries are variable
          length).

	- WATCH_INFO_ID.  The watch ID specified when the watchpoint was
          set.

	- WATCH_INFO_TYPE_INFO.  (Sub)type-specific information.

	- WATCH_INFO_FLAG_*.  Flag bits overlain on the type-specific
          information.  For use by the type.

     All the information in the header can be used in filtering messages at
     the point of writing into the buffer.

 (*) struct watch_notification_removal

     This is an extended watch-removal notification record that includes an
     'id' field that can indicate the identifier of the object being
     removed if available (for instance, a keyring serial number).

Signed-off-by: David Howells <dhowells@redhat.com>
Stable-dep-of: d55901522f96 ("keys: Fix linking a duplicate key to a keyring's assoc_array")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/watch_queue.h | 55 ++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)
 create mode 100644 include/uapi/linux/watch_queue.h

diff --git a/include/uapi/linux/watch_queue.h b/include/uapi/linux/watch_queue.h
new file mode 100644
index 0000000000000..5f3d21e8a34b0
--- /dev/null
+++ b/include/uapi/linux/watch_queue.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI_LINUX_WATCH_QUEUE_H
+#define _UAPI_LINUX_WATCH_QUEUE_H
+
+#include <linux/types.h>
+
+enum watch_notification_type {
+	WATCH_TYPE_META		= 0,	/* Special record */
+	WATCH_TYPE__NR		= 1
+};
+
+enum watch_meta_notification_subtype {
+	WATCH_META_REMOVAL_NOTIFICATION	= 0,	/* Watched object was removed */
+	WATCH_META_LOSS_NOTIFICATION	= 1,	/* Data loss occurred */
+};
+
+/*
+ * Notification record header.  This is aligned to 64-bits so that subclasses
+ * can contain __u64 fields.
+ */
+struct watch_notification {
+	__u32			type:24;	/* enum watch_notification_type */
+	__u32			subtype:8;	/* Type-specific subtype (filterable) */
+	__u32			info;
+#define WATCH_INFO_LENGTH	0x0000007f	/* Length of record */
+#define WATCH_INFO_LENGTH__SHIFT 0
+#define WATCH_INFO_ID		0x0000ff00	/* ID of watchpoint */
+#define WATCH_INFO_ID__SHIFT	8
+#define WATCH_INFO_TYPE_INFO	0xffff0000	/* Type-specific info */
+#define WATCH_INFO_TYPE_INFO__SHIFT 16
+#define WATCH_INFO_FLAG_0	0x00010000	/* Type-specific info, flag bit 0 */
+#define WATCH_INFO_FLAG_1	0x00020000	/* ... */
+#define WATCH_INFO_FLAG_2	0x00040000
+#define WATCH_INFO_FLAG_3	0x00080000
+#define WATCH_INFO_FLAG_4	0x00100000
+#define WATCH_INFO_FLAG_5	0x00200000
+#define WATCH_INFO_FLAG_6	0x00400000
+#define WATCH_INFO_FLAG_7	0x00800000
+};
+
+
+/*
+ * Extended watch removal notification.  This is used optionally if the type
+ * wants to indicate an identifier for the object being watched, if there is
+ * such.  This can be distinguished by the length.
+ *
+ * type -> WATCH_TYPE_META
+ * subtype -> WATCH_META_REMOVAL_NOTIFICATION
+ */
+struct watch_notification_removal {
+	struct watch_notification watch;
+	__u64	id;		/* Type-dependent identifier */
+};
+
+#endif /* _UAPI_LINUX_WATCH_QUEUE_H */
-- 
2.39.2



