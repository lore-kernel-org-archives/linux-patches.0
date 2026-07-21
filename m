Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C3740097F;
	Tue, 21 Jul 2026 21:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667974; cv=none; b=aemd/YuDizkT5KbbRlJRVoE51lW217mnoGiJJAj9FOuFx1A4aukX2Mdu6Xt2wuoheVIojptj4hJUF+W+aHGQVQJifU29ew53nsLOEUw1CBMt6ctUwtQZpST1BpPsJDuymkx5strUeehDwZSq0slFpKKy/n9dJxX4Pzn0syc8qpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667974; c=relaxed/simple;
	bh=wDc+s4XxAKg0UB4EPvpcQTZYAG9Qpfu8XErjGAUdpx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tLF5RG2GxF0BMz61fUzdjbITCsU7uG1SnALtIhkOKOditO9MpBSQiYyOXnkFYHXhQKUv1QtEkvoQ21KFzp6NHwVePqsp8p79byeae6NMzLE4c0BVUsfy9OdPJrCY4ur5M6tCK1H9SWEwMm2wXNBEs+4yK2M3jMK954I9AoUm3Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jki+MGfs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jki+MGfs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 140291F000E9;
	Tue, 21 Jul 2026 21:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667972;
	bh=tdT+ve2HxB9+PUHfNTFZIyNk8hR3YsWMkqfWrYEcR58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jki+MGfslfwGq08jbV1ATO9G45oR1tosZ6hyDVf57cvqgwl+v66H1SDTIMrMgq+rN
	 VswXfUaMwgV1aDD/SeGKFrpcyCeWjUEYhFqwOrgHUk9hmcX84jjKC9ROifgwCvbIAF
	 CU54ax5Gy5IfA47fjxNaARTIc24ps34m/M9KHtyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Easwar Hariharan <eahariha@linux.microsoft.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 1263/1266] jiffies: Define secs_to_jiffies()
Date: Tue, 21 Jul 2026 17:28:20 +0200
Message-ID: <20260721152510.087062826@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Easwar Hariharan <eahariha@linux.microsoft.com>

commit b35108a51cf7bab58d7eace1267d7965978bcdb8 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/jiffies.h   |   13 +++++++++++++
 net/bluetooth/hci_event.c |    2 --
 2 files changed, 13 insertions(+), 2 deletions(-)

--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -523,6 +523,19 @@ static __always_inline unsigned long mse
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
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -43,8 +43,6 @@
 #define ZERO_KEY "\x00\x00\x00\x00\x00\x00\x00\x00" \
 		 "\x00\x00\x00\x00\x00\x00\x00\x00"
 
-#define secs_to_jiffies(_secs) msecs_to_jiffies((_secs) * 1000)
-
 /* Handle HCI Event packets */
 
 static void *hci_ev_skb_pull(struct hci_dev *hdev, struct sk_buff *skb,


