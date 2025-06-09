Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C158F5B;
	Mon,  9 Jun 2025 13:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749476762; cv=none; b=suknPcYYuii+edj9FCBt+D74I/SsC53hbcUvlv8Zv1YbS7Q5qEtw8Qm/FfszJiHSIREagEXJ5+ylEZw4wscGC6LpT4oaicQot2Hy7JXKsvH1S8t5Qa5FLIZRo/RKlIGkSaiu+KEOzLBn5Tj9JQGYit83V2rd60HY6bfm6pHX4Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749476762; c=relaxed/simple;
	bh=9uj5fqE9tylNERsX/rBTOCw9EOsZwUz2zxDSfGw0s2Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=orj2Om3sl0KCiYTKDf3O6H5HQQYqg+5ziB8Ucp0aPV0H7joVSiJokLUVTAwYJkEB2Eo503k41qQyUpD31mDUXxVwb9YpjfZDWCBthdP6wKLLx7Yqi3yMrUdbGDNomubE/S0fRnDJvCXMbohNKFTshqMT7/QoiLolk/SHxS1wGdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qLNqQHAp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qLNqQHAp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D6CC4CEED;
	Mon,  9 Jun 2025 13:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749476762;
	bh=9uj5fqE9tylNERsX/rBTOCw9EOsZwUz2zxDSfGw0s2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qLNqQHApxzuHu21k5jEl3LR79jVDSCm2Fhnm7ZbOMhSaxdTdPtPapoxQIQhEv0D0z
	 6iqjFHaKTKov3pfEUKeIfIfc6BwV0sISkctuHbB9BTqPyGJEhzV8nKTcXa9wsafInc
	 Es8IQihu7+0N5JIse8ULWV2NqFdU25uXEpKxaNbK5vshpdt71TLm8rognvxr5b99jK
	 tGYRmMHXdgyom5A70qm5sfsP2FzxtY5YG9b7u9O1/t3fhsk0cvUlWN8YcqpkCk9Euy
	 GuXA2c7CXciMeLnX21P88pbzsk/NWpsoVW1xmoYXrH99uZBWm1vQoK0kv7uAiF9+CF
	 Pyex5ZprmeASA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jos Wang <joswang@lenovo.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 26/29] usb: typec: displayport: Receive DP Status Update NAK request exit dp altmode
Date: Mon,  9 Jun 2025 09:45:07 -0400
Message-Id: <20250609134511.1342999-26-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250609134511.1342999-1-sashal@kernel.org>
References: <20250609134511.1342999-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.10
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
index ac84a6d64c2fb..b09b58d7311de 100644
--- a/drivers/usb/typec/altmodes/displayport.c
+++ b/drivers/usb/typec/altmodes/displayport.c
@@ -393,6 +393,10 @@ static int dp_altmode_vdm(struct typec_altmode *alt,
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

