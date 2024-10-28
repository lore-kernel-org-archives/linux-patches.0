Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE20A2AF07;
	Mon, 28 Oct 2024 06:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098451; cv=none; b=V8iAQ4fg1lN5b3xYcPGh/fRfpu+tkYOLdGL6w/0erppf2/qSaDdyI2wXVPmmhzB9H+PhSNvZ2SWDY36OoqsVTBK6FENeiPg4V5M5CDrIQHSWDuoFgPzE45UIH/Z9CqkbxxG8+XMn50f5SoUhRiL5jH5OtRY3fXXpB0vthcoj8rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098451; c=relaxed/simple;
	bh=AzYby7oLct5q6iyS3pEQ9cLbkiHbl85xX2xQUmfZTCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PL7BW3faBIRd1Pqen00PtVRuBdpMYI96uDOh1b3dfASsfch1WziCviB9qtc6N+Jw8YI1I2YMqpmq6dBuoXB68Kh/Ej/SC9VxNr/pvNV4LjrToCTZ0XZsaqIjCybfibi26FC4Qp37UIOsOGcpWwx32JNHz9SacZSdSf+zPE+9bSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wugi5fyT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wugi5fyT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F0B4C4CECD;
	Mon, 28 Oct 2024 06:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098450;
	bh=AzYby7oLct5q6iyS3pEQ9cLbkiHbl85xX2xQUmfZTCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wugi5fyTz8GNQt+XsQpTOis4qjXbw3tyZ7DarVyaU70V+461aKGO59H0cMcstHIZF
	 2DEo75/wXVkAdbq0Aoxd7zzcI/3LpQeIrPaBVjwUjSsrvA+QeVjlR7lBN4/M3qwpM3
	 JGUSn/r1DcN3cTM+VXYe6ukO99PlCwSAelblMdRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Song Liu <song@kernel.org>,
	ValdikSS <iam@valdikss.org.ru>
Subject: [PATCH 6.11 232/261] md/raid10: fix null ptr dereference in raid10_size()
Date: Mon, 28 Oct 2024 07:26:14 +0100
Message-ID: <20241028062317.930439281@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

commit 825711e00117fc686ab89ac36a9a7b252dc349c6 upstream.

In raid10_run() if raid10_set_queue_limits() succeed, the return value
is set to zero, and if following procedures failed raid10_run() will
return zero while mddev->private is still NULL, causing null ptr
dereference in raid10_size().

Fix the problem by only overwrite the return value if
raid10_set_queue_limits() failed.

Fixes: 3d8466ba68d4 ("md/raid10: use the atomic queue limit update APIs")
Cc: stable@vger.kernel.org
Reported-and-tested-by: ValdikSS <iam@valdikss.org.ru>
Closes: https://lore.kernel.org/all/0dd96820-fe52-4841-bc58-dbf14d6bfcc8@valdikss.org.ru/
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20241009014914.1682037-1-yukuai1@huaweicloud.com
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid10.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4055,9 +4055,12 @@ static int raid10_run(struct mddev *mdde
 	}
 
 	if (!mddev_is_dm(conf->mddev)) {
-		ret = raid10_set_queue_limits(mddev);
-		if (ret)
+		int err = raid10_set_queue_limits(mddev);
+
+		if (err) {
+			ret = err;
 			goto out_free_conf;
+		}
 	}
 
 	/* need to check that every block has at least one working mirror */


