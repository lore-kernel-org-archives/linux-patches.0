Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63355481DD;
	Mon,  4 Aug 2025 00:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267047; cv=none; b=gvKLKHFuTe427dg3izUkZqdA+EAMSkc3/3knH9N2DxS6BdWDqJAu1s/i400GEnUtikO9PMAv1tTP2p6ZpVDwFroBrsSp40nLQZG426wWREkhePudypVzo+R1FNt65gq4jph1JhBMUqwdEXJ6uVM4JNQ4dlbA7o/ty4bqMHtcNHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267047; c=relaxed/simple;
	bh=9yl34AuDo5VJmNgu8Ln9VKmiPKC9lrTDnVLtokXKakM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZwhvRQ5Jpa16L5kisXgCaInwlgx62tp1NytsweoYx8KKQsS7wzhsTX4IbQdX+mT4dbOeg3hfd3oa7Xhoe44A2mXHEWBSQDMJwZRQIfSvD6l/DGAHFvvhBGkIIWlGquK/K740sK9w0WCyTzfJkWE5U7wCJZf4qgyDg0nXgBHcO5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e8wsIRTQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e8wsIRTQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B2EAC4CEEB;
	Mon,  4 Aug 2025 00:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267047;
	bh=9yl34AuDo5VJmNgu8Ln9VKmiPKC9lrTDnVLtokXKakM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e8wsIRTQZDn0bUhMkWv89Nw/RJ2B2OWyei24zzi0rralJhmDEAmXAUdsHxGiT2UyF
	 13lmlsQEcYODnavHQHfP65/DZs/B/uRXdY8rBV9g4g8i0NvcjKGGg4NdLbBQ7cbZA5
	 FGYt3Gg+Y1kwW2fOm67bPobxsuYDq6VZqnaZ8NUoBSdVXKC1aTS919bz2RQvMn9fdr
	 //Av1UYOzsEjpB1+t1n1obAVziSFCWfrSRQejt9XhbPSXg+UDNmO6WYMlJXyDExWj6
	 jmXJGmUqm+7J2QHNbp0Cc5A08Cyq/k9PeemeyUGN7kPfsbogCWwNWTm1dvn61yxz9O
	 SCtU8QrsmpqkA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>,
	Jameson Thies <jthies@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	hansg@kernel.org,
	dmitry.baryshkov@oss.qualcomm.com,
	madhu.m@intel.com
Subject: [PATCH AUTOSEL 6.16 07/85] usb: typec: ucsi: psy: Set current max to 100mA for BC 1.2 and Default
Date: Sun,  3 Aug 2025 20:22:16 -0400
Message-Id: <20250804002335.3613254-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804002335.3613254-1-sashal@kernel.org>
References: <20250804002335.3613254-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Benson Leung <bleung@chromium.org>

[ Upstream commit af833e7f7db3cf4c82f063668e1b52297a30ec18 ]

ucsi_psy_get_current_max would return 0mA as the maximum current if
UCSI detected a BC or a Default USB Power sporce.

The comment in this function is true that we can't tell the difference
between DCP/CDP or SDP chargers, but we can guarantee that at least 1-unit
of USB 1.1/2.0 power is available, which is 100mA, which is a better
fallback value than 0, which causes some userspaces, including the ChromeOS
power manager, to regard this as a power source that is not providing
any power.

In reality, 100mA is guaranteed from all sources in these classes.

Signed-off-by: Benson Leung <bleung@chromium.org>
Reviewed-by: Jameson Thies <jthies@google.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Link: https://lore.kernel.org/r/20250717200805.3710473-1-bleung@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Let me analyze the code changes more carefully. The commit introduces a
new constant `UCSI_TYPEC_DEFAULT_CURRENT` set to 100mA and changes the
behavior for BC 1.2 and Default USB power sources from returning 0mA to
returning 100mA.

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Bug Fix for User-Facing Issue**: The commit fixes a clear bug where
   the UCSI driver was reporting 0mA as the maximum current for BC 1.2
   and Default USB power sources. This incorrect value causes userspace
   power managers (specifically mentioned: ChromeOS power manager) to
   incorrectly interpret these power sources as not providing any power.
   This is a functionality bug that affects end users.

2. **Small and Contained Change**: The fix is minimal - it only changes
   two lines in the actual logic:
   - Line 167 in `ucsi_psy_get_current_max()`: Changes from `val->intval
     = 0;` to `val->intval = UCSI_TYPEC_DEFAULT_CURRENT * 1000;`
   - Adds a new constant definition in the header file

3. **Minimal Risk of Regression**: The change is very conservative:
   - It only affects the BC (Battery Charging) and DEFAULT power
     operation modes
   - The 100mA value is the guaranteed minimum from USB 1.1/2.0
     specification (1 unit load)
   - It doesn't change behavior for any other power modes (PD, TypeC
     1.5A, TypeC 3.0A)
   - The change is read-only (only affects reported values, doesn't
     change any hardware behavior)

4. **Clear Technical Justification**: The commit message correctly
   explains that while UCSI cannot distinguish between DCP/CDP or SDP
   chargers, all USB sources in these classes guarantee at least 100mA
   (1 unit load per USB specification). This is technically accurate and
   represents the minimum guaranteed current.

5. **No Architectural Changes**: This is a simple value correction that
   doesn't introduce new features or change any interfaces. It maintains
   the existing API while providing more accurate information.

6. **Fixes Real-World Issues**: The commit explicitly mentions that
   returning 0mA causes problems with userspace power management
   software, which would treat the power source as non-functional. This
   could lead to incorrect battery status reporting or power management
   decisions.

The change follows stable kernel rules by being a targeted fix for a
specific bug that affects users, with minimal code changes and low
regression risk.

 drivers/usb/typec/ucsi/psy.c  | 2 +-
 drivers/usb/typec/ucsi/ucsi.h | 7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/typec/ucsi/psy.c b/drivers/usb/typec/ucsi/psy.c
index 62ac69730405..62a9d68bb66d 100644
--- a/drivers/usb/typec/ucsi/psy.c
+++ b/drivers/usb/typec/ucsi/psy.c
@@ -164,7 +164,7 @@ static int ucsi_psy_get_current_max(struct ucsi_connector *con,
 	case UCSI_CONSTAT_PWR_OPMODE_DEFAULT:
 	/* UCSI can't tell b/w DCP/CDP or USB2/3x1/3x2 SDP chargers */
 	default:
-		val->intval = 0;
+		val->intval = UCSI_TYPEC_DEFAULT_CURRENT * 1000;
 		break;
 	}
 	return 0;
diff --git a/drivers/usb/typec/ucsi/ucsi.h b/drivers/usb/typec/ucsi/ucsi.h
index 5a8f947fcece..f644bc251863 100644
--- a/drivers/usb/typec/ucsi/ucsi.h
+++ b/drivers/usb/typec/ucsi/ucsi.h
@@ -481,9 +481,10 @@ struct ucsi {
 #define UCSI_MAX_SVID		5
 #define UCSI_MAX_ALTMODES	(UCSI_MAX_SVID * 6)
 
-#define UCSI_TYPEC_VSAFE5V	5000
-#define UCSI_TYPEC_1_5_CURRENT	1500
-#define UCSI_TYPEC_3_0_CURRENT	3000
+#define UCSI_TYPEC_VSAFE5V		5000
+#define UCSI_TYPEC_DEFAULT_CURRENT	 100
+#define UCSI_TYPEC_1_5_CURRENT		1500
+#define UCSI_TYPEC_3_0_CURRENT		3000
 
 struct ucsi_connector {
 	int num;
-- 
2.39.5

