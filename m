Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98FE6FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:25:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B47CC433EF;
	Tue, 10 Jan 2023 18:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673375125;
	bh=E+k1Oi8qB3JWMnB0Rv0gwrVg80L4EiYApzwOQySh1Vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t8QdTsxeMsvwdkjJM4BYXFtNpzGslPzUgMBqF17lKi/Ohml9SY3e9WFrehIK8JFzm
	 wMr0Pb/GXm5Kr7w+7vEtfuVpzKDSw3r2WRPF1AbTtYtH5xpkKNWkTxtAUH0yfmdbhM
	 CC1nMMgiHK7WyQZB5TjidEwGJBSiIbIiMhVDppY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Meng <luomeng12@huawei.com>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.15 086/290] dm integrity: Fix UAF in dm_integrity_dtr()
Date: Tue, 10 Jan 2023 19:02:58 +0100
Message-Id: <20230110180034.576429342@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luo Meng <luomeng12@huawei.com>

commit f50cb2cbabd6c4a60add93d72451728f86e4791c upstream.

Dm_integrity also has the same UAF problem when dm_resume()
and dm_destroy() are concurrent.

Therefore, cancelling timer again in dm_integrity_dtr().

Cc: stable@vger.kernel.org
Fixes: 7eada909bfd7a ("dm: add integrity target")
Signed-off-by: Luo Meng <luomeng12@huawei.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-integrity.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -4539,6 +4539,8 @@ static void dm_integrity_dtr(struct dm_t
 	BUG_ON(!RB_EMPTY_ROOT(&ic->in_progress));
 	BUG_ON(!list_empty(&ic->wait_list));
 
+	if (ic->mode == 'B')
+		cancel_delayed_work_sync(&ic->bitmap_flush_work);
 	if (ic->metadata_wq)
 		destroy_workqueue(ic->metadata_wq);
 	if (ic->wait_wq)


