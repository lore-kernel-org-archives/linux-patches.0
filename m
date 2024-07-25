Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E4EFC19;
	Thu, 25 Jul 2024 14:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919253; cv=none; b=nFJ0r4o00C4K6RBEzgpTbhIInRvCyBbgwqKQ/UfbpVxs5YjNn4a3Kg3ee5ebxAIRKcICZKyqr/klIQqI1km2POjx1Td1r7A12P2TkQdqRacLYphkR2Z8XUZZmBGYf5BwyUAslO4CJFrYD224fhT7V6cXzxaQ5qut/z+GZkEQ0MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919253; c=relaxed/simple;
	bh=fkEppUBRuvjphEhkGAZ+S+uRRyuA3sZ9UfIUDN0KARY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dRDcxzfoOh7yS/f81EKqGlxmJsMQQH+kVQuXgW0fYATlHshKnRfdJxexaGRiVstWRY5fFjCLQCjwjKYWjf9iLin7CVeJw1m0lG7oORhxn6uOX+KhOmriPDSwioy8ojt4Hqx66vKDExWt94B277QIvCVC3CoFxwQDPq5zQNHIusQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QyDLhHX8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QyDLhHX8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 498A4C116B1;
	Thu, 25 Jul 2024 14:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919253;
	bh=fkEppUBRuvjphEhkGAZ+S+uRRyuA3sZ9UfIUDN0KARY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QyDLhHX8qnxm4vF6t+QwnuIBXKTPbszcFS1JOkXu3QD5BQPKL+9iiBwe+0L8HvMtJ
	 r/PprF3s7BOm6xJ+UBxmkfyG0AyCdq0IXjBOWOws8XyFJbPUfbc6veyqTzhBdoFLUp
	 6QDydnYdktEa6myLr7owVjtRFr0ZiYDjLX54uej8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 29/87] mei: demote client disconnect warning on suspend to debug
Date: Thu, 25 Jul 2024 16:37:02 +0200
Message-ID: <20240725142739.534985037@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142738.422724252@linuxfoundation.org>
References: <20240725142738.422724252@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Usyskin <alexander.usyskin@intel.com>

[ Upstream commit 1db5322b7e6b58e1b304ce69a50e9dca798ca95b ]

Change level for the "not connected" client message in the write
callback from error to debug.

The MEI driver currently disconnects all clients upon system suspend.
This behavior is by design and user-space applications with
open connections before the suspend are expected to handle errors upon
resume, by reopening their handles, reconnecting,
and retrying their operations.

However, the current driver implementation logs an error message every
time a write operation is attempted on a disconnected client.
Since this is a normal and expected flow after system resume
logging this as an error can be misleading.

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20240530091415.725247-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/mei/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 786f7c8f7f619..71f15fba21ad6 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -327,7 +327,7 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 	}
 
 	if (!mei_cl_is_connected(cl)) {
-		cl_err(dev, cl, "is not connected");
+		cl_dbg(dev, cl, "is not connected");
 		rets = -ENODEV;
 		goto out;
 	}
-- 
2.43.0



