Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38FB46EF8C;
	Tue, 21 Jul 2026 19:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661697; cv=none; b=RTjC478Z6DtT517M1xjPnDGERg6amaNHMlgnpUaAiKMK2siDCmaWVi9BR9DvU9Edm9oXwrm/tpyW9EcaVDzbfcbkfFDgsjkc+s4FuEJj+RPz2Hd7c9BJrs+FVYEG2uFX8FijaHrazLkTjpVt29JZEl3Eq2Z6guQnTEMMsocc/oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661697; c=relaxed/simple;
	bh=ZRHbF32bggv0Dg3d9n2r/MMd6HZQD3kwgLiWaxQfB8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DpDcIax7vfVCrZF6vTNkSBt3+ePgYDDlgQnjlrzDSflFVHsBtow0JmHbrgkzfLKE7NUp4ZRYUQANiPs7NsXUhUt+wZlzDCS4pvWhkM53DY5YsTi/TXwfoU2jwqQwQxzvLGQq4vPMPnPUP1TaMrZzjxCrN6FVVJ7fHpfaY1Rrf7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GUJ3XanI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GUJ3XanI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC8551F000E9;
	Tue, 21 Jul 2026 19:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661696;
	bh=p+ORutEvTDTRxHJGr0/wYRSi6+62S8A0txMqpjW8YEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GUJ3XanItC03FP387J34HGTS8aCjrAOZCpuUuIoXV61slvYf90kBPMn2rQRfFl58c
	 gPDEubab4tbOONCw9FRu2H21BeKAcx/6sKEN56I6aPWDxQHY5XJCRJtp7QD6DnPvLV
	 CN3sRQx/xd0feUr99QuzU0TPUmnc9BNQX46QgLxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Easwar Hariharan <eahariha@linux.microsoft.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0164/1276] jiffies: Define secs_to_jiffies()
Date: Tue, 21 Jul 2026 17:10:07 +0200
Message-ID: <20260721152449.771519770@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Easwar Hariharan <eahariha@linux.microsoft.com>

[ Upstream commit b35108a51cf7bab58d7eace1267d7965978bcdb8 ]

secs_to_jiffies() is defined in hci_event.c and cannot be reused by
other call sites. Hoist it into the core code to allow conversion of the
~1150 usages of msecs_to_jiffies() that either:

 - use a multiplier value of 1000 or equivalently MSEC_PER_SEC, or
 - have timeouts that are denominated in seconds (i.e. end in 000)

It's implemented as a macro to allow usage in static initializers.

This will also allow conversion of yet more sites that use (sec * HZ)
directly, and improve their readability.

Suggested-by: Michael Kelley <mhklinux@outlook.com>
Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Link: https://lore.kernel.org/all/20241030-open-coded-timeouts-v3-1-9ba123facf88@linux.microsoft.com
Stable-dep-of: f9e6da99fe49 ("driver core: Fix missing jiffies conversion in deferred_probe_extend_timeout()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/jiffies.h   | 13 +++++++++++++
 net/bluetooth/hci_event.c |  2 --
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index 8e4a2d4fafe07b..12bead37480d67 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -526,6 +526,19 @@ static __always_inline unsigned long msecs_to_jiffies(const unsigned int m)
 	}
 }
 
+/**
+ * secs_to_jiffies: - convert seconds to jiffies
+ * @_secs: time in seconds
+ *
+ * Conversion is done by simple multiplication with HZ
+ *
+ * secs_to_jiffies() is defined as a macro rather than a static inline
+ * function so it can be used in static initializers.
+ *
+ * Return: jiffies value
+ */
+#define secs_to_jiffies(_secs) ((_secs) * HZ)
+
 extern unsigned long __usecs_to_jiffies(const unsigned int u);
 #if !(USEC_PER_SEC % HZ)
 static inline unsigned long _usecs_to_jiffies(const unsigned int u)
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 92270b99ee0f2a..b3470475f294b7 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -42,8 +42,6 @@
 #define ZERO_KEY "\x00\x00\x00\x00\x00\x00\x00\x00" \
 		 "\x00\x00\x00\x00\x00\x00\x00\x00"
 
-#define secs_to_jiffies(_secs) msecs_to_jiffies((_secs) * 1000)
-
 /* Handle HCI Event packets */
 
 static void *hci_ev_skb_pull(struct hci_dev *hdev, struct sk_buff *skb,
-- 
2.53.0



