Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5455746F
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:38:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43DAAC433C7;
	Sun, 17 Sep 2023 20:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694983119;
	bh=jA4DAkjQfIPuZ5CXZknTC+5hGbPVpEtQ1npU7FRJrRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qYdhGQ/QGhvv3dn1fkCUxHYRuKSwDvaC+xJv4Q68tsdXG8Yp6JUYAnhwnVMuoRiJ0
	 SNhG3jZG3rjiVr3fsEaUHYpIm2Zhd39m16QDwQmeJ75I4qdPFruMwfUOkMQBOs3tzC
	 hEYPfLJAd7EqT9jJTYIi399+0cQ6+lsXrGx2Dwgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 449/511] s390/zcrypt: dont leak memory if dev_set_name() fails
Date: Sun, 17 Sep 2023 21:14:36 +0200
Message-ID: <20230917191124.591704460@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 6252f47b78031979ad919f971dc8468b893488bd ]

When dev_set_name() fails, zcdn_create() doesn't free the newly
allocated resources. Do it.

Fixes: 00fab2350e6b ("s390/zcrypt: multiple zcrypt device nodes support")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20230831110000.24279-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/zcrypt_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/s390/crypto/zcrypt_api.c b/drivers/s390/crypto/zcrypt_api.c
index 356318746dd16..17b3f1ea3a5c2 100644
--- a/drivers/s390/crypto/zcrypt_api.c
+++ b/drivers/s390/crypto/zcrypt_api.c
@@ -398,6 +398,7 @@ static int zcdn_create(const char *name)
 			 ZCRYPT_NAME "_%d", (int) MINOR(devt));
 	nodename[sizeof(nodename)-1] = '\0';
 	if (dev_set_name(&zcdndev->device, nodename)) {
+		kfree(zcdndev);
 		rc = -EINVAL;
 		goto unlockout;
 	}
-- 
2.40.1



