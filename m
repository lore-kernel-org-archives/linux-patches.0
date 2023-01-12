Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4810379C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:33:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B846AC433EF;
	Thu, 12 Jan 2023 14:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673534026;
	bh=SHBOkh6gYiAYE9krLX7aewZ50j2jMcjc1ogtAwU3EWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fYNTMoPBUFwmFkZpf+CC71hqcgYGGleEspdeTSlH7M1Mn7HQeIXJrcE0/alEU6myz
	 Cf04+NM33M9jm0F/cMu3M34ctvjHue2nlj9A2xQUgmOFfqUW1uD4mcUHhmtAFYTkkR
	 FwXwClAwX8gvGqtPP/3EvjSOAoJuYB1KjY+P6Yh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Meng <luomeng12@huawei.com>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.10 630/783] dm integrity: Fix UAF in dm_integrity_dtr()
Date: Thu, 12 Jan 2023 14:55:46 +0100
Message-Id: <20230112135553.512094281@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
@@ -4388,6 +4388,8 @@ static void dm_integrity_dtr(struct dm_t
 	BUG_ON(!RB_EMPTY_ROOT(&ic->in_progress));
 	BUG_ON(!list_empty(&ic->wait_list));
 
+	if (ic->mode == 'B')
+		cancel_delayed_work_sync(&ic->bitmap_flush_work);
 	if (ic->metadata_wq)
 		destroy_workqueue(ic->metadata_wq);
 	if (ic->wait_wq)


