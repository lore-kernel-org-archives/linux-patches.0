Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12A825B0AA;
	Sat, 12 Sep 2026 09:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206735; cv=none; b=FrVG7EvfHSXHs+L7Kl2v8dKrowmjstPvx2R/ev6z/KAXQ7BaXhKwef/Oc7o56CAs94Z81wEl/yYp3sVmiPXNF2Y1tMJ3nOlHCBAV8/HV2U2HnTgR96VfPQ8Y6bpYRfWzqb5rFhcEg9NdaR9A28lhzNF+8pPuYlVCUiICpGuyWs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206735; c=relaxed/simple;
	bh=9nnWK3AtQuOsGF6bx0+eyq07PWdM8+lVdBvsAOVvxaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MrQtYHC+DRU9kQVZJq7QhUHaYqilourQ0h5LNETDtGHZ24JE3s1M5nlTM3TsVZ/BbgN3uSpAKEFBoUHlmzHsKM1RMDKIzeFIW/Lv0D4q1pqmfR6OzvRGZHU7GFRBVJ9W0Nz8nixMcWA2O9xY6oa11Fcu1OqeuCZ9YL5hkahF1og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=irDPfG7h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="irDPfG7h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B001F000FF;
	Sat, 12 Sep 2026 09:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206734;
	bh=eTcgARK03aK82hzrNRkcMuqGs8IGKD9XkoB1DPUWFqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=irDPfG7hSDBC7eJ7oGQWF6MOrG6ScyAM1J5uJfLtRdmsJZYWXmLVsg61NAqJrxERK
	 IsXP4nEEfaWCjdFOuyNSLtdKwP5/5SFdB8IU5XjGq0SnDGffnxPZ1mLVqLc9+B/HZr
	 XR2AYylO3/obhwsFkl48+BdDuD8EEl0lUtJ5q4mY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidhu Sarwal <vidhu.linux@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0267/1518] staging: media: ipu7: fix pm_runtime refcount leak in ipu7_resume()
Date: Sat, 12 Sep 2026 08:40:36 +0200
Message-ID: <20260912065629.526918697@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vidhu Sarwal <vidhu.linux@gmail.com>

[ Upstream commit b298b80814dd0fc3cb1c8c0e0082fc14fdb5fecf ]

ipu7_resume() calls pm_runtime_get_sync() before resuming the device.
If the runtime PM resume fails, the usage count remains incremented, but
the error path returns without dropping the reference.

Use pm_runtime_resume_and_get() instead, which balances the usage count
on failure and avoids the leak. Keep returning 0 on error, as resume
callbacks should not propagate failures to the PM core, matching the
behaviour of the ipu6 driver.

Fixes: b7fe4c0019b1 ("media: staging/ipu7: add Intel IPU7 PCI device driver")
Signed-off-by: Vidhu Sarwal <vidhu.linux@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/ipu7/ipu7.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/ipu7/ipu7.c b/drivers/staging/media/ipu7/ipu7.c
index 83e73fac3a7e0..34fe95145c826 100644
--- a/drivers/staging/media/ipu7/ipu7.c
+++ b/drivers/staging/media/ipu7/ipu7.c
@@ -2702,7 +2702,7 @@ static int ipu7_resume(struct device *dev)
 	if (ret)
 		dev_err(dev, "IPC reset protocol failed!\n");
 
-	ret = pm_runtime_get_sync(&isp->psys->auxdev.dev);
+	ret = pm_runtime_resume_and_get(&isp->psys->auxdev.dev);
 	if (ret < 0) {
 		dev_err(dev, "Failed to get runtime PM\n");
 		return 0;
-- 
2.53.0



