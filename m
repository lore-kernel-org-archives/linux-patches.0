Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2BB4E0215;
	Thu, 17 Sep 2026 15:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658893; cv=none; b=WcJG+x5WokVeQqRy0+3AelhUtpHPXiJ2N/nlZrqL0jTuVNB10J++1xBsW7POI2o4iwqq0RdK6H7X2G/XR9Cpv1/5+Z9+cqjHME/4xoKcsXGHnjHkvqHJA6D6iBtX4xoIL4WnAEAvCkZu5gg9KPkv456wm+mCS9CL9YHUaYBjF5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658893; c=relaxed/simple;
	bh=48X8X1BtqCs0S1WN2pCh6de2fmsRPvz3ADnCh/DBTe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fxrL0+ARvcvRE3Q4h64f4MqDPiMw7twP7/QRCzbRkDcQjceZoRnwAbnG8HBfGjKB094h1Ne9Z5ahRJ+who+WZQYqhUi/+VQxDqo+ie/JeoHFbPHTMaq5cTYRz62xJ32CYyAHDQuUy+R0V3visi0p4WUw83XT5LNMN/HLQ5berJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m7kVjflf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m7kVjflf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D6D1F00893;
	Thu, 17 Sep 2026 15:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658886;
	bh=z1+JeLXEHyJyWcSNP8Y3UwHTJR+Nb/Zs9urYBHlDwzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m7kVjflfGmMJV/kS8fOXn9byU6J9gNvoB0RhR5FwQqwuAB5n6zaPEyOrdD+J14koi
	 OgiCS0k3sMCBe02BPPUoCCFS1/FcHDgKaECapyLwVO9VpYUrf49gkkY98jf/0dML/D
	 doJ/OwKmWeAq7savnDsXjHbOCQ7hwFqjksn7CLHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 071/733] smb: client: transport: Fix debug printing in __release_mid()
Date: Thu, 17 Sep 2026 16:06:19 +0100
Message-ID: <20260917151352.632199672@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit d83a21bb26015bfdd79b0440fe816b271b8bbab3 ]

Long time ago during upgrading printk():s to the respective pr_<level>()
calls one misconversion happened and nobody has noticed that. So,
previously printk(KERN_DEBUG) + printk() worked as one long debug print
since the trailing '\n' is only present in the followup printk() format
string. The culprit change missed that and split the message to two on
the different levels. Restore the original behaviour to make users be
less confused in the most likely never happen cases of partially getting
that message.

Fixes: 0b456f04bcdf ("cifs: convert printk(LEVEL...) to pr_<level>")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/transport.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index fdf4e50c27ceb..e266859818a44 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -101,12 +101,11 @@ void __release_mid(struct TCP_Server_Info *server, struct mid_q_entry *midEntry)
 		trace_smb3_slow_rsp(smb_cmd, midEntry->mid, midEntry->pid,
 			       midEntry->when_sent, midEntry->when_received);
 		if (cifsFYI & CIFS_TIMER) {
-			pr_debug("slow rsp: cmd %d mid %llu",
-				 midEntry->command, midEntry->mid);
-			cifs_info("A: 0x%lx S: 0x%lx R: 0x%lx\n",
-				  now - midEntry->when_alloc,
-				  now - midEntry->when_sent,
-				  now - midEntry->when_received);
+			pr_debug("slow rsp: cmd %d mid %llu A: 0x%lx S: 0x%lx R: 0x%lx\n",
+				 midEntry->command, midEntry->mid,
+				 now - midEntry->when_alloc,
+				 now - midEntry->when_sent,
+				 now - midEntry->when_received);
 		}
 	}
 #endif
-- 
2.53.0



