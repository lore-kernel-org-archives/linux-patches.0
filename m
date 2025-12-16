Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CAAF34B438;
	Tue, 16 Dec 2025 11:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885259; cv=none; b=CzPmIXeUFhdCzzQbu3IQ67rZl7LyKDmKiHTfTDObKxInc4MuYVqyq4iqlCO1TwLoHS0AGeRjQ4UksDQEFeIbzrn1a1BjQUDyxR1x7IMLcDF8G+HOKYz3TDKm3LwxlPNqWcXhvjie8m7rUt58exLZyoQ5XZLsKjtiVCebzr6VI2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885259; c=relaxed/simple;
	bh=eLez0LEbBKP+ZZUMy9ttLCwensONxYJ7aCZLWvQg8PE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=McCqQ/NpZq2YepcLYqsLkaGjIGStDWlE/Iodq65FoyfSYyEvob/5vynqAJcQOty+l/wq5fyvkZlGiDlHS7DQS3mQ0b0/ABbLznM/z+pQAFIpzww5pYlmVPvotNRO/YQz0IeYB87e7WiZ7I0IHBjgBCo7WaR36KGSDU8e8+pPOqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WA79mnlz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WA79mnlz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97F43C4CEF1;
	Tue, 16 Dec 2025 11:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885259;
	bh=eLez0LEbBKP+ZZUMy9ttLCwensONxYJ7aCZLWvQg8PE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WA79mnlzpt0vxv6CsiahSC9ydtbWrGSzbACeFmq7SSGIWq6jImL74i1syFBiJlFn9
	 pZK6LsA1Ey88yNEu761cWrgCYJ0+ikqiJIVZ5XmqxHbRbogqkONmxAOzJiwKlWnlYJ
	 sqs7pGdUCfjjFv1dlxksRx48sa8FVshYJUu434AA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harald Freudenberger <freude@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 085/507] s390/ap: Dont leak debug feature files if AP instructions are not available
Date: Tue, 16 Dec 2025 12:08:46 +0100
Message-ID: <20251216111348.618164949@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 65f1a127cc3f6..dfd5d0f61a70d 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -2484,15 +2484,15 @@ static int __init ap_module_init(void)
 {
 	int rc;
 
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



