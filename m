Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F4519A29C;
	Thu, 25 Jul 2024 14:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918634; cv=none; b=FGddEDPkjB04fkHKoKwlgDIFH7XZuXtQpKxdE+8MeBV70nyND8AcYfx1LRccHcC/K8FPZtLTd6D061FCdpz0FTY44NdAp14BO7ZmFhQeTtQA87M2LsXvfR9hAduWw0VMc68jerKFru+AIprFCAOVuJ91Q16UGNeYrkhRuxWbE/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918634; c=relaxed/simple;
	bh=WjvFOJAXtSnG7iBN3cjyR8sufReDkGkV/Q5vwmYAl7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PGSHjJPNHG8qeDoGFWjJss/po57vHiKq1DDqJ5B4CGsFzpRZHw0geS1CzQUE53+XsJmaV7ZkexKgWDEs5wTCqPy+3r7Da1ip+yoMvBL1um9GT3HteovIIKr7mPts6E/79q88YpFlqEHfHYUFrrXyo+tVWLj97Dqr2dTzN+wyeOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eqDmTNCL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eqDmTNCL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B888CC116B1;
	Thu, 25 Jul 2024 14:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918634;
	bh=WjvFOJAXtSnG7iBN3cjyR8sufReDkGkV/Q5vwmYAl7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eqDmTNCLogMm5GafUt+X0ay8fKGOxDlfjowBiV4T5FTMijtsOvDhVhkeKn5gqoE79
	 4OvWafq9ib7JBJd05U6z4PScUeNGF3ZWe/6Vnuzc/JcEwHU+HUQFCS0eB+5uP6Mw6h
	 wdC8ojrC5c0rkW+aRScyABN9H9kToVJUCifJAdcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 13/43] mei: demote client disconnect warning on suspend to debug
Date: Thu, 25 Jul 2024 16:36:36 +0200
Message-ID: <20240725142730.974970740@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142730.471190017@linuxfoundation.org>
References: <20240725142730.471190017@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 7310b476323c2..5cd29deb79858 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -268,7 +268,7 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 	}
 
 	if (!mei_cl_is_connected(cl)) {
-		cl_err(dev, cl, "is not connected");
+		cl_dbg(dev, cl, "is not connected");
 		rets = -ENODEV;
 		goto out;
 	}
-- 
2.43.0



