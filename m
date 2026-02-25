Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24D94369A;
	Wed, 25 Feb 2026 01:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982878; cv=none; b=ViC+lksxaTOvHcFZ1Jm3STANGQyp+wBQcrxQSHKafnuP6rQqklmyDnFnjZA+KMdm2FLdBq1fhf9jWbKvOHst9oM57hSZJsVWz7WN3WKlDoqXVavtxVtjzpVwiruNnffhsecTApg1CLKwDp4DDiztuKYgAt9+sFNJKsBDuxgBHM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982878; c=relaxed/simple;
	bh=G2Om4FvrwYtR8nv2HUlNmKprkVF9knW4pvk/aNFSZAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pcb7EwPVdeclNO+xit85lua9joGOb4Y2dwDxV2AdaT5xXSJqLPWOf1TfsO2qlKnCtCoPHaXPO2zrOP1c1pbkH3cPXL8VNQSVBbqNRkl58qfD9v3WS2V/s7jPzdSB2n4RfhQxGDJEfyzc5p/fvZyP5KmigFEIp7sJuw0BZ+eP+cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SLgd1YRF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SLgd1YRF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A4F8C116D0;
	Wed, 25 Feb 2026 01:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982878;
	bh=G2Om4FvrwYtR8nv2HUlNmKprkVF9knW4pvk/aNFSZAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SLgd1YRFwuI82VovP9pEKRLLeFm6gFu2howv3lBLLnEu/IiALxh/XXL40RkX2RqB4
	 MKsP61O1DdRgG7l1Y7wDRUzVoOplOwfal0H8xLcci915I288V25h2vz0gKzlGIZGWK
	 HMEn10gQ1nwd4al4Nd0EmovSQdvb3MQFsUYLuE9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 062/781] block: dont use strcpy to copy blockdev name
Date: Tue, 24 Feb 2026 17:12:51 -0800
Message-ID: <20260225012401.227389563@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit ee4784a83fb21a2d16ebfdf8877fa6f6a1129150 ]

0-day bot flagged the use of strcpy() in blk_trace_setup(), because the
source buffer can theoretically be bigger than the destination buffer.

While none of the current callers pass a string bigger than
BLKTRACE_BDEV_SIZE, use strscpy() to prevent eventual future misuse and
silence the checker warnings.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202602020718.GUEIRyG9-lkp@intel.com/
Fixes: 113cbd62824a ("blktrace: pass blk_user_trace2 to setup functions")
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/blktrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index d031c8d80be4f..c4db5c2e71037 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -793,7 +793,7 @@ int blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 		return PTR_ERR(bt);
 	}
 	blk_trace_setup_finalize(q, name, 1, bt, &buts2);
-	strcpy(buts.name, buts2.name);
+	strscpy(buts.name, buts2.name, BLKTRACE_BDEV_SIZE);
 	mutex_unlock(&q->debugfs_mutex);
 
 	if (copy_to_user(arg, &buts, sizeof(buts))) {
-- 
2.51.0



