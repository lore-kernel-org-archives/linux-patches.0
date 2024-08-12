Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F46183CC4;
	Mon, 12 Aug 2024 16:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478826; cv=none; b=qJzyEk7j2kxbE09mq2eZdeHO65qqT7tFCVCmJvGoZDlqRfBObEAKQmwX8Qa4Jju2o1pHfa08RE4ChhW5IqbfPTun+eubGnaRRh8ojmJ5Trpw92nCAo1w7+TX1h7CnsVlkYkDr1OJTKDaaQoa5mKdiEKan9FGPSdPJdyeayrPUGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478826; c=relaxed/simple;
	bh=jAF+fcyq2XOwHhJtVBGswXnhz7fcSfhragNAW5vEHFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lcAg2s2EkDNxDrgTkgVfvJohcr+n9crTb/WzDmv16nu/xI7wi/tnYyae0WFAetFm3X0C0JMf6jIudBFXPyWSTUcm947TZUyO1ABbXRDCQmymYi3kcT6xJ7wCVrFpIeGrhXzYASs+uhUSnGD8CoLrLZljEQKz767SQfmqccSunS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=03iQ9TV6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="03iQ9TV6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9847CC32782;
	Mon, 12 Aug 2024 16:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478826;
	bh=jAF+fcyq2XOwHhJtVBGswXnhz7fcSfhragNAW5vEHFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=03iQ9TV6sGaUPusDWahSmmR9Uc42UYcJsx7rSBu81m2CG4ykdg3lMw/yxYCg8Y5Ba
	 xU8kv/TfS2bgBnvpx5/7ac+YLO1Z9gNbx6AjMgZFE5E8b+JW69blfQ9bUf1bSuCcVT
	 ZfbEOmCnw3GsPyy2+YWLlKhxZfV6VTjk8gle+/a0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 048/150] s390/sclp: Prevent release of buffer in I/O
Date: Mon, 12 Aug 2024 18:02:09 +0200
Message-ID: <20240812160127.019035081@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

From: Peter Oberparleiter <oberpar@linux.ibm.com>

[ Upstream commit bf365071ea92b9579d5a272679b74052a5643e35 ]

When a task waiting for completion of a Store Data operation is
interrupted, an attempt is made to halt this operation. If this attempt
fails due to a hardware or firmware problem, there is a chance that the
SCLP facility might store data into buffers referenced by the original
operation at a later time.

Handle this situation by not releasing the referenced data buffers if
the halt attempt fails. For current use cases, this might result in a
leak of few pages of memory in case of a rare hardware/firmware
malfunction.

Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/char/sclp_sd.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/char/sclp_sd.c b/drivers/s390/char/sclp_sd.c
index f9e164be7568f..944e75beb160c 100644
--- a/drivers/s390/char/sclp_sd.c
+++ b/drivers/s390/char/sclp_sd.c
@@ -320,8 +320,14 @@ static int sclp_sd_store_data(struct sclp_sd_data *result, u8 di)
 			  &esize);
 	if (rc) {
 		/* Cancel running request if interrupted */
-		if (rc == -ERESTARTSYS)
-			sclp_sd_sync(page, SD_EQ_HALT, di, 0, 0, NULL, NULL);
+		if (rc == -ERESTARTSYS) {
+			if (sclp_sd_sync(page, SD_EQ_HALT, di, 0, 0, NULL, NULL)) {
+				pr_warn("Could not stop Store Data request - leaking at least %zu bytes\n",
+					(size_t)dsize * PAGE_SIZE);
+				data = NULL;
+				asce = 0;
+			}
+		}
 		vfree(data);
 		goto out;
 	}
-- 
2.43.0



