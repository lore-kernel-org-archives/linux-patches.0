Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53AEE4189DA;
	Tue, 21 Jul 2026 21:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670758; cv=none; b=ZNzJyjVRluTFZqgAN9B0eOPlyoTUUfNnIgAIJoeURg365XCcjrmoPO4I/RLueG6+lsuN2d/m+/C61mS4Y7vNj+ybkOh7ssUJA6qlDkMgtG8zZpW+m8gnEjbCgb+nVj/VtIvkzhtPvq6zgtzxJjrwiccaX1vW9FMf+/RzVahEA28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670758; c=relaxed/simple;
	bh=KFFYaOieOS8ywtQErzteE0pJfQV2T7QxNJ+LiNe9Nm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G1LoJdEpfwXYMIUhwVwnRy66kh2FBjxtMB5gXxTUZ+hU1lDcmcs6vEm4EZgJkwyAqDe6kQduF6GUa/s0QouSpc/jI8Ej3OzAvfffVF1VrB/e5ODxMWMSmpraSaBcUkwxZAKLDTQM4TbDOY854nSM5GKUGlviHYTXNSKO3iUA8PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c+bvDAEs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c+bvDAEs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C201F000E9;
	Tue, 21 Jul 2026 21:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670757;
	bh=CHVP1ULu5ytK1fRXczARbwSMZ//4RMpDhghcQUpOl9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c+bvDAEslJY73Kl4aBWtAkKzdWL/8I/7k6mk6YUtgwud2ymAzl1x+LVo5wozfguaP
	 /oTmf8ynF9vnTQXL2fC9NlZYu2zJ7v+ZJ2wFC3V9J7HbsQhtzisE+4c32+PESiL/V7
	 ZwiVB+2ENHmPD/PyW9/4/hj/kAbxV2i9CLlQNVGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Easwar Hariharan <eahariha@linux.microsoft.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 1052/1067] jiffies: Define secs_to_jiffies()
Date: Tue, 21 Jul 2026 17:27:33 +0200
Message-ID: <20260721152448.121108616@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
@@ -371,6 +371,19 @@ static __always_inline unsigned long mse
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
@@ -42,8 +42,6 @@
 #define ZERO_KEY "\x00\x00\x00\x00\x00\x00\x00\x00" \
 		 "\x00\x00\x00\x00\x00\x00\x00\x00"
 
-#define secs_to_jiffies(_secs) msecs_to_jiffies((_secs) * 1000)
-
 /* Handle HCI Event packets */
 
 static void *hci_ev_skb_pull(struct hci_dev *hdev, struct sk_buff *skb,


