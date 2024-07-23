Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71818157A4F;
	Tue, 23 Jul 2024 18:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759223; cv=none; b=UvIYDSzE1RsytFK8RX1CMRFabSVh9Yszg/CUExfog85Co1wBn3aKieTeEUrSpq2Z+BJ2m6QVM/79pw89/fwHHl5beBusPaEzky6Hz63dwlqGLpF8azLDw8gCiA3hD5/f1x3oKGp1vdzKAWFgo75SW314zYD/nzxyaWHsgPn2FmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759223; c=relaxed/simple;
	bh=oi5qokBAovkjGOTihvU33+rLVi4LzO21L+/ivPxuV6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nGNT6Sf39xl82wHMXR/Vh0Cy44KPdOYUYGYB94KznlVda0lUMakztMJArFExdzg8EcnGn+HIu6hqYzzEl+7u+BWiHTgzH9jcG2qn4XCjZKVzphfMbysed9rKy72vyv0sdByYoXIZQrzE7CSiqSQNIx8SKJ9d9LaKCMgw5gf54kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c7+hhjEU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c7+hhjEU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99FC0C4AF0A;
	Tue, 23 Jul 2024 18:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759223;
	bh=oi5qokBAovkjGOTihvU33+rLVi4LzO21L+/ivPxuV6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c7+hhjEURyhptoyI38qU3GpToMi/0oBdpaF+AtZrKxgj9jb0JhvIPH7w16wr2KHkT
	 UV1xpPytGQaJvAoXPRppeBqC7SY/+W28Zb5CEGuZACscaHa8u6L/orw3VARZ+FnTqJ
	 4Yy3TCIdRd2F2SBPtrCr7H9dTRHTX38j+Tvm85K4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 044/105] mei: demote client disconnect warning on suspend to debug
Date: Tue, 23 Jul 2024 20:23:21 +0200
Message-ID: <20240723180404.944567678@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 930887e7e38d6..615fafb0366a8 100644
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



