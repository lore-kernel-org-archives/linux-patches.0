Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C41A3214;
	Mon,  9 Jun 2025 13:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749476844; cv=none; b=W1wgEPTaBggd7E1HmydbX6ZDBmLtqad3AZXEk/c+wIQm6LHlXaUa1B974QHPrQ6tAaEKEZ7s2k6sGkVOU0qtplcXrxQ84F4uxx9KeSYKEtvQYqvO/oeenPgQ7bWoXaXyBp8NypJSxVNrMdWXPsWXq/hXathjc8+WJVqKNqpkgTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749476844; c=relaxed/simple;
	bh=IljqFBmH08jPidiV+MBkOdnswZtFwqSsKu0da2tZNQM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LMQ1dJZJYEqyPLjwAqVg1OLQ2y+ApZeM/fLhF/u6j8ENVApM8uKHNKzkw/+YxXpPoT9t5tlGIsaTEnlvK/z38+yqRXz+e02lmj3r1CpZMoJ+3oFVUUVEAu2DvmwL8nflO1OY8K6/TZe2RCobKeYKIFV45+dfPsjh6pAzVBRRo2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tla+gabG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tla+gabG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF26AC4CEED;
	Mon,  9 Jun 2025 13:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749476843;
	bh=IljqFBmH08jPidiV+MBkOdnswZtFwqSsKu0da2tZNQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tla+gabGNawhgIbTg8A9VIgRUhGw9mj4PZu39EVjTt4JRWgrVj6k9Tzw72YsDXeWo
	 9qVs08AqmHZFbjcuKY0XFwVo5lbtPkht/4L3eQO7nU8VdToM6iQTzm4Q3lUjEGcVFY
	 W9+ZKW8qqxzhOzcSMigg3/8hf2gUGNJ7Ou3L1TV7hRVpwoDW7tceFWVkiC5xrLOnAS
	 +xFkiiJEBYBJ46us/zaXlDticq4pFcaXfVvH5CSG/JuX8chNyMgxUB0lTLxoRI3TQB
	 h6zbcP8w8EpoJIkkjXGd6JvMHXfQwkEUQHZ9NLQsNT5qW5fOEjLw+7CON6g2NEalcH
	 +mQ5c4/OPXsoQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jos Wang <joswang@lenovo.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 17/18] usb: typec: displayport: Receive DP Status Update NAK request exit dp altmode
Date: Mon,  9 Jun 2025 09:46:51 -0400
Message-Id: <20250609134652.1344323-17-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250609134652.1344323-1-sashal@kernel.org>
References: <20250609134652.1344323-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.93
Content-Transfer-Encoding: 8bit

From: Jos Wang <joswang@lenovo.com>

[ Upstream commit b4b38ffb38c91afd4dc387608db26f6fc34ed40b ]

Although some Type-C DRD devices that do not support the DP Sink
function (such as Huawei Mate 40Pro), the Source Port initiates
Enter Mode CMD, but the device responds to Enter Mode ACK, the
Source port then initiates DP Status Update CMD, and the device
responds to DP Status Update NAK.

As PD2.0 spec ("6.4.4.3.4 Enter Mode Command")，A DR_Swap Message
Shall Not be sent during Modal Operation between the Port Partners.
At this time, the source port initiates DR_Swap message through the
"echo device > /sys/class/typec/port0/data_role" command to switch
the data role from host to device. The device will initiate a Hard
Reset for recovery, resulting in the failure of data role swap.

Therefore, when DP Status Update NAK is received, Exit Mode CMD is
initiated to exit the currently entered DP altmode.

Signed-off-by: Jos Wang <joswang@lenovo.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20250209071926.69625-1-joswang1221@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Based on my analysis of the commit and the code, here is my assessment:

**YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Code Analysis

The commit adds a simple but important fix to handle a specific NAK
response scenario in the DisplayPort alternate mode driver.
Specifically, it adds this code block:

```c
case CMDT_RSP_NAK:
    switch (cmd) {
+   case DP_CMD_STATUS_UPDATE:
+       if (typec_altmode_exit(alt))
+           dev_err(&dp->alt->dev, "Exit Mode Failed!\n");
+       break;
    case DP_CMD_CONFIGURE:
        dp->data.conf = 0;
        ret = dp_altmode_configured(dp);
        break;
```

## Why This Should Be Backported

**1. Fixes a Real Hardware Compatibility Issue**
- The commit specifically addresses compatibility with devices like
  "Huawei Mate 40Pro" that don't support DP Sink function
- These devices respond with NAK to DP Status Update commands, creating
  a problematic state

**2. Prevents System Instability**
- According to the commit message, without this fix, attempts to perform
  DR_Swap operations result in Hard Reset from the device
- This causes data role swap failures, which is a significant functional
  regression

**3. Follows USB PD Specification**
- The fix aligns with PD2.0 spec section 6.4.4.3.4 which states "A
  DR_Swap Message Shall Not be sent during Modal Operation"
- By exiting DP altmode when NAK is received, it allows proper DR_Swap
  operation

**4. Small, Contained, Low-Risk Change**
- The change is only 4 lines of code
- It's confined to a specific error handling path (NAK response to
  STATUS_UPDATE)
- Uses existing, well-tested `typec_altmode_exit()` function
- No new functionality or architectural changes

**5. Clear Bug Fix Pattern**
- Similar to commit #4 in the reference examples (which was marked YES
  for backport)
- Both involve adding proper exit handling in response to specific
  conditions
- Both are small, targeted fixes for real-world device compatibility

**6. Stable Tree Criteria Met**
- ✅ Fixes important bugs affecting real hardware
- ✅ Minimal risk of regression
- ✅ Doesn't introduce new features
- ✅ No architectural changes
- ✅ Confined to specific subsystem (USB Type-C DP altmode)

**7. Reference Pattern Alignment**
The commit pattern closely matches Similar Commit #4 which was marked
for backport:
- Both add exit mode handling for specific error conditions
- Both are small, targeted fixes for real device compatibility
- Both prevent system-level issues (Hard Reset in this case)

The change correctly handles an edge case where devices NAK the Status
Update command, ensuring clean exit from DP altmode to prevent
subsequent operational issues. This is exactly the type of hardware
compatibility fix that stable trees are designed to address.

 drivers/usb/typec/altmodes/displayport.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/typec/altmodes/displayport.c b/drivers/usb/typec/altmodes/displayport.c
index ccff838ab89e1..5f6fc5b79212e 100644
--- a/drivers/usb/typec/altmodes/displayport.c
+++ b/drivers/usb/typec/altmodes/displayport.c
@@ -323,6 +323,10 @@ static int dp_altmode_vdm(struct typec_altmode *alt,
 		break;
 	case CMDT_RSP_NAK:
 		switch (cmd) {
+		case DP_CMD_STATUS_UPDATE:
+			if (typec_altmode_exit(alt))
+				dev_err(&dp->alt->dev, "Exit Mode Failed!\n");
+			break;
 		case DP_CMD_CONFIGURE:
 			dp->data.conf = 0;
 			ret = dp_altmode_configured(dp);
-- 
2.39.5

