Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0947E31CA57;
	Mon, 18 Aug 2025 12:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521696; cv=none; b=OrSMdq6yS80rBvSRoJ2S5Q7kOI6U+2qoZL8p5auSyV3/vYcCliK78xNoc0JgutcMd70POewbKN9IvCkxKp2eSqAa/Q9clKceB8PsGcmyybmJtFIhHTqUBLhvZzchYcPFEcTtXg6aemk2LlbkdGmfYzZIkoRoJG5FCHvNiBaidwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521696; c=relaxed/simple;
	bh=od8CRF1+7FzGX2iUhKcYeLtYQgaULIQYXCClkIyH9SY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y66o0T2qVxB2IJHcjAyBwzk1cK6F3ElKxKs3IucEPNTgZkoyit07GYV3gNFbPZykyfM3FMYbdBLeYjqO+w6QoA9/Ay03yUbhI7BMRP4Dl0MvhmxyX9or3RH17SCWohsIk5RqI6dysnGJaTeccB46C0OX8gkUZIPHK6injVRp/28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yIG2kT5e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yIG2kT5e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F36C4CEEB;
	Mon, 18 Aug 2025 12:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521695;
	bh=od8CRF1+7FzGX2iUhKcYeLtYQgaULIQYXCClkIyH9SY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yIG2kT5eVoziWUgLzSk9blE+4bPO3IYO0d782w2PFfXH2H3/rD6lLF8UCUT4akJSL
	 thXYwb7gBs6TkcO75RMUuBn43Y95ByGjpJKWIvkWwJDUZLHUEwHJVrbcTKDhgkdolW
	 jU+8RLYEkonwLT/x0mrts9hiCNUpsjzz5iJdGLDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 095/444] usb: xhci: print xhci->xhc_state when queue_command failed
Date: Mon, 18 Aug 2025 14:42:01 +0200
Message-ID: <20250818124452.508846500@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Su Hui <suhui@nfschina.com>

[ Upstream commit 7919407eca2ef562fa6c98c41cfdf6f6cdd69d92 ]

When encounters some errors like these:
xhci_hcd 0000:4a:00.2: xHCI dying or halted, can't queue_command
xhci_hcd 0000:4a:00.2: FIXME: allocate a command ring segment
usb usb5-port6: couldn't allocate usb_device

It's hard to know whether xhc_state is dying or halted. So it's better
to print xhc_state's value which can help locate the resaon of the bug.

Signed-off-by: Su Hui <suhui@nfschina.com>
Link: https://lore.kernel.org/r/20250725060117.1773770-1-suhui@nfschina.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-ring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 2ff8787f753c..19978f02bb9e 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -4378,7 +4378,8 @@ static int queue_command(struct xhci_hcd *xhci, struct xhci_command *cmd,
 
 	if ((xhci->xhc_state & XHCI_STATE_DYING) ||
 		(xhci->xhc_state & XHCI_STATE_HALTED)) {
-		xhci_dbg(xhci, "xHCI dying or halted, can't queue_command\n");
+		xhci_dbg(xhci, "xHCI dying or halted, can't queue_command. state: 0x%x\n",
+			 xhci->xhc_state);
 		return -ESHUTDOWN;
 	}
 
-- 
2.39.5



