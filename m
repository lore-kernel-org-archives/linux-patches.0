Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD864502F;
	Thu, 17 Apr 2025 18:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915604; cv=none; b=Feh44vECJp1NjBpTuVSXbXaoISqjjNBveds6wTqUl/ehgxo9vYUyyEPI1B+YUhoVkWWX4f5sfIOodACcffmhq4EhsQREvD9tS3pR+krKwM76vdbpQhvSbtzW28X9mesxPMLOSdqKIiAPFsulKzedUdY8JB4rMNLMvLwnR7WNo8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915604; c=relaxed/simple;
	bh=0pCwO20UPCgt1FBzgRHOT8bzn+UGS4iESc2dVY+3vD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TxFZ0JwO8P2E3BfP9o4cDX9sX+uw8DLeRHIy6cGMC6pBxw8XC/ZHAVXazUIKiKcATwGD2KhwAIvpzIczBowNcVS/XGv08mY/7jQZtbM+kwHrjcYUlRjvznPjfZ2ET9X8/cYstxhS4pabzT/YpMVT0pgV3DL4Xlc+ZkuUyIVHCxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IV+H2DWu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IV+H2DWu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5CE5C4CEE4;
	Thu, 17 Apr 2025 18:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915604;
	bh=0pCwO20UPCgt1FBzgRHOT8bzn+UGS4iESc2dVY+3vD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IV+H2DWumE42NN/Tn/7yZgzBKJto4MCxTeTuCSrTM7nuUJlfioYneeEKNok5D2IYf
	 F2R2R25GSGkBZHsSJxZVzOwy9gmGNOfttTdbkAk508bFnUirmg7B7T0q1yvCR7JMC3
	 BpWyXG9ZngIduh3cR8IizEELlf6g7+NAvBK4sMls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tomasz=20Paku=C5=82a?= <tomasz.pakula.oficjalny@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 180/393] HID: pidff: Support device error response from PID_BLOCK_LOAD
Date: Thu, 17 Apr 2025 19:49:49 +0200
Message-ID: <20250417175114.837159757@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>

[ Upstream commit 9d4174dc4a234408d91fd83725e1899766cd1731 ]

If an error happens on the device, the driver will no longer fall
into the trap of reading this status 60 times before it decides that
this reply won't change to success/memory full.

Greatly reduces communication overhead during device error situation.

Signed-off-by: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/usbhid/hid-pidff.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/usbhid/hid-pidff.c b/drivers/hid/usbhid/hid-pidff.c
index e2508a4d754d3..d5734cbf745d1 100644
--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -138,7 +138,8 @@ static const u8 pidff_effect_types[] = {
 
 #define PID_BLOCK_LOAD_SUCCESS	0
 #define PID_BLOCK_LOAD_FULL	1
-static const u8 pidff_block_load_status[] = { 0x8c, 0x8d };
+#define PID_BLOCK_LOAD_ERROR	2
+static const u8 pidff_block_load_status[] = { 0x8c, 0x8d, 0x8e};
 
 #define PID_EFFECT_START	0
 #define PID_EFFECT_STOP		1
@@ -666,6 +667,11 @@ static int pidff_request_effect_upload(struct pidff_device *pidff, int efnum)
 				pidff->block_load[PID_RAM_POOL_AVAILABLE].value[0] : -1);
 			return -ENOSPC;
 		}
+		if (pidff->block_load_status->value[0] ==
+		    pidff->status_id[PID_BLOCK_LOAD_ERROR]) {
+			hid_dbg(pidff->hid, "device error during effect creation\n");
+			return -EREMOTEIO;
+		}
 	}
 	hid_err(pidff->hid, "pid_block_load failed 60 times\n");
 	return -EIO;
-- 
2.39.5



