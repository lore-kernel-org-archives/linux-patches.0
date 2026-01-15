Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1EB54A3C;
	Thu, 15 Jan 2026 17:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498907; cv=none; b=bCMv0HMFWYwMbg9bP/v4ERE5raTRfVSnukWkV7pMtmzQBaEUCZUdeW14KXr4IMEHMR10gcsHl8m/lOxED6dEyv1YZ3B1nZg60DY351OShQWQi1D6FKZf5UGbVhyi8gR8CIsO3v9bP1hdnUPZD1u7fjjsDlP2qih5zkFa7FLrJG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498907; c=relaxed/simple;
	bh=k6LjTWIGkQd0kBBOl0ZcqwVMSfw/DqJdWWz324W5Epw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GDvj22XeHDcSZTYrJXcrkjfiR3GhDgqF3HZ53mfgcdbjqbVFYJdepe+W88WTijWFgKX949vJoM0jgY7d+lRHU1G09yLMGDZnDSzg1vX5bz2VtmE4UrR3HzINh4fT0LSeDRFkfdX2pSpRwCrNrbOvjDDtVIcJXqXezorucssgDW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rWBOQS32; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rWBOQS32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3267FC16AAE;
	Thu, 15 Jan 2026 17:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498907;
	bh=k6LjTWIGkQd0kBBOl0ZcqwVMSfw/DqJdWWz324W5Epw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rWBOQS32GYAqiaQYare+3V3cKlYnE2I8TZ11oO3UgGW6oGtVZRArGi3TRkunknirR
	 r1L13LqBeGmvwE7UOe797UY7UyVzqa2xMOyVcEriLutRv0w2hrBCam0tDhdJJI8Dm8
	 mqQ+ZLqiPNKnYc6ppiK3BILiu7clSxKU9wmPa1lM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Freudenberger <freude@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 040/451] s390/ap: Dont leak debug feature files if AP instructions are not available
Date: Thu, 15 Jan 2026 17:44:01 +0100
Message-ID: <20260115164232.342669919@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 020d5dc57874e58d3ebae398f3fe258f029e3d06 ]

If no AP instructions are available the AP bus module leaks registered
debug feature files. Change function call order to fix this.

Fixes: cccd85bfb7bf ("s390/zcrypt: Rework debug feature invocations.")
Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/ap_bus.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index 13e56a23e41ec..a1903b4a7f00a 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -1648,15 +1648,15 @@ static int __init ap_module_init(void)
 {
 	int rc, i;
 
-	rc = ap_debug_init();
-	if (rc)
-		return rc;
-
 	if (!ap_instructions_available()) {
 		pr_warn("The hardware system does not support AP instructions\n");
 		return -ENODEV;
 	}
 
+	rc = ap_debug_init();
+	if (rc)
+		return rc;
+
 	/* init ap_queue hashtable */
 	hash_init(ap_queues);
 
-- 
2.51.0



