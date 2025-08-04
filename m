Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622E41FDD;
	Mon,  4 Aug 2025 00:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754268055; cv=none; b=bRh6QcsR8Q6XvD2qqFvucTkF6uuHKlbEZu6sS0E7tejxgeVKqO4x1vntNR+umQYjqVbYaWi2wQkvURKjrvUfHoA8VK9Ad1LPD/ZUUjcx0gznM4kiQml/P5MMDve5YqIPpWY4uniYZ+xA32jY7nTJKOLahuEUHm7JZzmn3uhPMwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754268055; c=relaxed/simple;
	bh=z99a/9KfTHn/54mDh6JyjK2Ksjo1cxZ09UQvVVFg6dE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CgWgdgWcO46IeLY2/FXbQmpvGyzJfkkMZey1QRyxpOdeuyJR1mBoR/dyg52Orm5hExKga9SgXT4N6F6uWaPbw1Arm9nX1Yn1rUbPjm1NdWa6GEKJfx0IBvwgTpHPYgXylz42Aq8g31GsmELr/1JZxg9DPcNSjKpb1IFrrljcJO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YJKmm8o2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YJKmm8o2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 783EFC4CEEB;
	Mon,  4 Aug 2025 00:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754268055;
	bh=z99a/9KfTHn/54mDh6JyjK2Ksjo1cxZ09UQvVVFg6dE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YJKmm8o2il+JALSlsL/wshg413N4cjGBxvDPrdH59Qg2gWFsJX2AN7MRYefwbWsYu
	 tK/rTQ23bQD/B32v5lPFxgs7u+LvGZ1rzQYXbG1hNNUwIkesHhVLegn2/zYJuna67t
	 BlcEK5tpYn6B5LOXuPsYfbcGfTEdB6+OidilNvVQ1ONem1TUbCsu2ijTiXAt41NrHY
	 JkiMHYKWjjc3lvuXO+8Yl5VOPsHgZ7tl+lMb7ls5l0SJvn+hQJulXv2+nmPnrpmayc
	 QEaaMNVhfJdT2LhmYMWSIjEjRUF90UQcmQ5cHSavk18Rjte298SeF85jcpBWhyONXD
	 8t39YEpvNdidw==
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
Subject: [PATCH AUTOSEL 5.10 04/39] usb: typec: ucsi: psy: Set current max to 100mA for BC 1.2 and Default
Date: Sun,  3 Aug 2025 20:40:06 -0400
Message-Id: <20250804004041.3628812-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804004041.3628812-1-sashal@kernel.org>
References: <20250804004041.3628812-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.10.240
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
index 571a51e16234..ba5f797156dc 100644
--- a/drivers/usb/typec/ucsi/psy.c
+++ b/drivers/usb/typec/ucsi/psy.c
@@ -142,7 +142,7 @@ static int ucsi_psy_get_current_max(struct ucsi_connector *con,
 	case UCSI_CONSTAT_PWR_OPMODE_DEFAULT:
 	/* UCSI can't tell b/w DCP/CDP or USB2/3x1/3x2 SDP chargers */
 	default:
-		val->intval = 0;
+		val->intval = UCSI_TYPEC_DEFAULT_CURRENT * 1000;
 		break;
 	}
 	return 0;
diff --git a/drivers/usb/typec/ucsi/ucsi.h b/drivers/usb/typec/ucsi/ucsi.h
index f75b1e2c05fe..ed8fcd7ecf21 100644
--- a/drivers/usb/typec/ucsi/ucsi.h
+++ b/drivers/usb/typec/ucsi/ucsi.h
@@ -305,9 +305,10 @@ struct ucsi {
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

