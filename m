Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B916335F61E;
	Sat, 12 Sep 2026 07:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196968; cv=none; b=cywZnUB8KcQ6BwRlC3QbVPLdY/UyjFeaN+XarhvhJWpF6Q5eJugy2OY69r3W5Nc57MYv3jpPtI4m8UB352ILNOORJ/MtssLH6OpDvj8JoNKuFJytbHWTCNJXC40dcJcOBGC65kfuojTof7jHNPoscCHsCOGlu+DA/F2XaBp6QgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196968; c=relaxed/simple;
	bh=HP9YRo5wSYK10FzZ9r6biH72Si0/wbm1NK2Fdlc1TUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W7u2LwtZ15/YojNHMITEPKmOFmPH2sfmnJLrnawwKwMwEi6xzhYJEWrKfOs1UI6B0ILWkFTGJqWcSKgZJWbqc8OkQBYXW6FggFQyyFRInC6hMeMFexn/Ni2WRWK1t7UUPcYf47geWY4Wp25C137C4RlHIL0VDAuaMpOh5xpkZ3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2SqclQjX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2SqclQjX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEEB11F000FF;
	Sat, 12 Sep 2026 07:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196967;
	bh=ekAoGbPEHN8/IWCXqCoy/E6Eaa00d4LvBR0IwtIIpDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2SqclQjX89E8HJ5Fva5OU8karTmOV7txmpEhZaJwrkq0EwSq7tOJeG0qmRedd2qRR
	 HMjn1u7U+eBfedTEZ3mx/o2V/yllLDu1SvX6+iowbW4bIaAtZIVBzB0NRVwmPywOb3
	 Q7iRM73kz1MkLukIfexUclWGL3JrykvspQkamq7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai-Heng Feng <kaihengf@nvidia.com>,
	Koba Ko <kobak@nvidia.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Richard Cheng <icheng@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0073/1815] cxl/mbox: Clamp mailbox output allocation to the payload size
Date: Sat, 12 Sep 2026 08:30:23 +0200
Message-ID: <20260912065650.727342937@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Richard Cheng <icheng@nvidia.com>

[ Upstream commit 8a13db9f899d149c3aab24abcb668121cfda5a4f ]

CXL_MEM_SEND_COMMAND bounds the user's in.size to the mailbox payload
size but leaves out.size unbounded, then cxl_mbox_cmd_ctor() calls
kvzalloc(out.size). A large out.size drives a huge allocation, above
INT_MAX it WARNs and taints, and with panic_on_warn=1 it panics.

The transport __cxl_pci_mbox_send_cmd() already clamps the response copy
to min(out.size, payload_size, device len), so the output buffer is
never written beyond payload_size. Clamp the allocation to payload_size
too, matching the RAW path.

Fixes: 583fa5e71cae ("cxl/mem: Add basic IOCTL interface")
Reviewed-by: Kai-Heng Feng <kaihengf@nvidia.com>
Reviewed-by: Koba Ko <kobak@nvidia.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Richard Cheng <icheng@nvidia.com>
Link: https://patch.msgid.link/20260624144147.53997-1-icheng@nvidia.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/mbox.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 1fa1f78565e31..94b1f71675882 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -379,11 +379,7 @@ static int cxl_mbox_cmd_ctor(struct cxl_mbox_cmd *mbox_cmd,
 		}
 	}
 
-	/* Prepare to handle a full payload for variable sized output */
-	if (out_size == CXL_VARIABLE_PAYLOAD)
-		mbox_cmd->size_out = cxl_mbox->payload_size;
-	else
-		mbox_cmd->size_out = out_size;
+	mbox_cmd->size_out = min_t(size_t, out_size, cxl_mbox->payload_size);
 
 	if (mbox_cmd->size_out) {
 		mbox_cmd->payload_out = kvzalloc(mbox_cmd->size_out, GFP_KERNEL);
-- 
2.53.0



