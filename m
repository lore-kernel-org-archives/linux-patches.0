Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217392;
	b=mJ68ulUvnr2h+4nQB7CdTwWEn4C5cqs9AKJreuG6zgnKO4jU1VVXYxvVwGhXEu61lSos
	 tV4zEIbzrOPIeThuRoSopL0cvnDyE7/ICGqkdqzRjl3YQ+3lC+mRrKXrN8stm2rsOIIlO
	 HpyBYYsCloaeWlxQrd3ATZHg9HOL28xy0BCM1m1bg2nKwdkhamYyk9qc2kWzS9d4Dzxsr
	 2WhMMDoaHHpYcmWl9hQS0J7Ay3+5I2guH7yoxQQQgw3LaPsmcZY0EPOISofDDjnAHsZ1Y
	 kZqXgcCOaYC9ANXq5lavIiHrvj127fuSbva07lumFRWmiTmtKjCz9MOSOAPFx2DKzug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217392;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SMGduP0aRe0184wn7JQkqEiQD93v6yU8dFTp57siAbw=;
	b=zd1negO44hcyHjqJEm8ymrYM2xvEUw02G1qB2CWIzqn8bsAKfLTqquzH+OSC9ALqdJ/A
	 A8pEWza3/GrkhwoldbTEQJ1q4A/v1bO5L+rl81E5Q95T9qpXY6CF+4ar/uvSsqsjU2xKc
	 gHtxGRt83xGAVwLLJATvt6HORajIOOvvh7MUWJI7j9xPxi8r0pj9G0r3CWBYKYQOIGE85
	 gmJYhc4ozZWVHfhUaFD97T70VFTDcfDeeSA3dhRt4zWSzihgnBv0E7eTA6eKhD4ifSQno
	 i7nhu8njHko+z0OWr8r+VgH8NLub5goOlLnsvZbhiuQxKSGZEaiCQbiyIh6n89HV4fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fkoiNmsM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC0E606A31A;
	Wed, 28 Oct 2026 19:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fkoiNmsM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF101F01825;
	Wed, 28 Oct 2026 19:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217391;
	bh=SMGduP0aRe0184wn7JQkqEiQD93v6yU8dFTp57siAbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fkoiNmsMGKUGoC3GJgtHD2OzC8ZgGh8XvwZ2b+R8NVOyRZrpFVuE+TRbh9HRbLvfP
	 TW+FGZXuyj05j3/C78e9z+8A1axFuxFr/tb1yxvlG9mr/5hUjf4RbwtwN/wk5NWair
	 U9eHuTt/SDNvIDTXwOwHnTWlDIGA1WC4rElxmS68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <niklas.cassel@wdc.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1881/1887] scsi: block: Improve ioprio value validity checks
Date: Wed, 28 Oct 2026 18:06:17 +0100
Message-ID: <20261028170542.262157518@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit 01584c1e233740519d0e11aa20daa323d26bf598 ]

The introduction of the macro IOPRIO_PRIO_LEVEL() in commit eca2040972b4
("scsi: block: ioprio: Clean up interface definition") results in an
iopriority level to always be masked using the macro IOPRIO_LEVEL_MASK, and
thus to the kernel always seeing an acceptable value for an I/O priority
level when checked in ioprio_check_cap().  Before this patch, this function
would return an error for some (but not all) invalid values for a level
valid range of [0..7].

Restore and improve the detection of invalid priority levels by introducing
the inline function ioprio_value() to check an ioprio class, level and hint
value before combining these fields into a single value to be used with
ioprio_set() or AIOs. If an invalid value for the class, level or hint of
an ioprio is detected, ioprio_value() returns an ioprio using the class
IOPRIO_CLASS_INVALID, indicating an invalid value and causing
ioprio_check_cap() to return -EINVAL.

Fixes: 6c913257226a ("scsi: block: Introduce ioprio hints")
Fixes: eca2040972b4 ("scsi: block: ioprio: Clean up interface definition")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20230608095556.124001-1-dlemoal@kernel.org
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/ioprio.c              |  1 +
 include/uapi/linux/ioprio.h | 50 ++++++++++++++++++++++++-------------
 2 files changed, 34 insertions(+), 17 deletions(-)

diff --git a/block/ioprio.c b/block/ioprio.c
index f0d9e818abc53..b5a942519a797 100644
--- a/block/ioprio.c
+++ b/block/ioprio.c
@@ -58,6 +58,7 @@ int ioprio_check_cap(int ioprio)
 			if (level)
 				return -EINVAL;
 			break;
+		case IOPRIO_CLASS_INVALID:
 		default:
 			return -EINVAL;
 	}
diff --git a/include/uapi/linux/ioprio.h b/include/uapi/linux/ioprio.h
index 4c4806e8230bc..99440b2e8c352 100644
--- a/include/uapi/linux/ioprio.h
+++ b/include/uapi/linux/ioprio.h
@@ -2,19 +2,20 @@
 #ifndef _UAPI_LINUX_IOPRIO_H
 #define _UAPI_LINUX_IOPRIO_H
 
+#include <linux/stddef.h>
+#include <linux/types.h>
+
 /*
  * Gives us 8 prio classes with 13-bits of data for each class
  */
 #define IOPRIO_CLASS_SHIFT	13
-#define IOPRIO_CLASS_MASK	0x07
+#define IOPRIO_NR_CLASSES	8
+#define IOPRIO_CLASS_MASK	(IOPRIO_NR_CLASSES - 1)
 #define IOPRIO_PRIO_MASK	((1UL << IOPRIO_CLASS_SHIFT) - 1)
 
 #define IOPRIO_PRIO_CLASS(ioprio)	\
 	(((ioprio) >> IOPRIO_CLASS_SHIFT) & IOPRIO_CLASS_MASK)
 #define IOPRIO_PRIO_DATA(ioprio)	((ioprio) & IOPRIO_PRIO_MASK)
-#define IOPRIO_PRIO_VALUE(class, data)	\
-	((((class) & IOPRIO_CLASS_MASK) << IOPRIO_CLASS_SHIFT) | \
-	 ((data) & IOPRIO_PRIO_MASK))
 
 /*
  * These are the io priority classes as implemented by the BFQ and mq-deadline
@@ -25,10 +26,13 @@
  * served when no one else is using the disk.
  */
 enum {
-	IOPRIO_CLASS_NONE,
-	IOPRIO_CLASS_RT,
-	IOPRIO_CLASS_BE,
-	IOPRIO_CLASS_IDLE,
+	IOPRIO_CLASS_NONE	= 0,
+	IOPRIO_CLASS_RT		= 1,
+	IOPRIO_CLASS_BE		= 2,
+	IOPRIO_CLASS_IDLE	= 3,
+
+	/* Special class to indicate an invalid ioprio value */
+	IOPRIO_CLASS_INVALID	= 7,
 };
 
 /*
@@ -73,15 +77,6 @@ enum {
 #define IOPRIO_PRIO_HINT(ioprio)	\
 	(((ioprio) >> IOPRIO_HINT_SHIFT) & IOPRIO_HINT_MASK)
 
-/*
- * Alternate macro for IOPRIO_PRIO_VALUE() to define an I/O priority with
- * a class, level and hint.
- */
-#define IOPRIO_PRIO_VALUE_HINT(class, level, hint)		 \
-	((((class) & IOPRIO_CLASS_MASK) << IOPRIO_CLASS_SHIFT) | \
-	 (((hint) & IOPRIO_HINT_MASK) << IOPRIO_HINT_SHIFT) |	 \
-	 ((level) & IOPRIO_LEVEL_MASK))
-
 /*
  * I/O hints.
  */
@@ -107,4 +102,25 @@ enum {
 	IOPRIO_HINT_DEV_DURATION_LIMIT_7 = 7,
 };
 
+#define IOPRIO_BAD_VALUE(val, max) ((val) < 0 || (val) >= (max))
+
+/*
+ * Return an I/O priority value based on a class, a level and a hint.
+ */
+static __always_inline __u16 ioprio_value(int class, int level, int hint)
+{
+	if (IOPRIO_BAD_VALUE(class, IOPRIO_NR_CLASSES) ||
+	    IOPRIO_BAD_VALUE(level, IOPRIO_NR_LEVELS) ||
+	    IOPRIO_BAD_VALUE(hint, IOPRIO_NR_HINTS))
+		return IOPRIO_CLASS_INVALID << IOPRIO_CLASS_SHIFT;
+
+	return (class << IOPRIO_CLASS_SHIFT) |
+		(hint << IOPRIO_HINT_SHIFT) | level;
+}
+
+#define IOPRIO_PRIO_VALUE(class, level)			\
+	ioprio_value(class, level, IOPRIO_HINT_NONE)
+#define IOPRIO_PRIO_VALUE_HINT(class, level, hint)	\
+	ioprio_value(class, level, hint)
+
 #endif /* _UAPI_LINUX_IOPRIO_H */
-- 
2.53.0



