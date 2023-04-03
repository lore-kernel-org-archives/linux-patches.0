Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E471E6FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:49:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C897C433D2;
	Mon,  3 Apr 2023 14:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680533341;
	bh=sUKIpC1lspCTLiAyt6y0+uYQoyWOdPIewRENe9rZxgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wBtFgejuu97j9CIY3TRsXsL/f/ZMZ7zLO+nVZXVw7KXMJH/xW00SBZJ8cxcGkGltB
	 XeGq3mANVPEsl0gu6ZFkjk11T+NwT2v7ZtHMU2WMujxKbY7FODcpZ3s6w1KZ1B+2xC
	 hsqJPBL6zYKOLjlUZZ6xKTzawVGZemcPaO6YnpRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Orange Kao <orange@aiven.io>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 6.2 145/187] dm: fix __send_duplicate_bios() to always allow for splitting IO
Date: Mon,  3 Apr 2023 16:09:50 +0200
Message-Id: <20230403140420.779314896@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mike Snitzer <snitzer@kernel.org>

commit 666eed46769d929c3e13636134ecfc67d75ef548 upstream.

Commit 7dd76d1feec70 ("dm: improve bio splitting and associated IO
accounting") only called setup_split_accounting() from
__send_duplicate_bios() if a single bio were being issued. But the case
where duplicate bios are issued must call it too.

Otherwise the bio won't be split and resubmitted (via recursion through
block core back to DM) to submit the later portions of a bio (which may
map to an entirely different target).

For example, when discarding an entire DM striped device with the
following DM table:
 vg-lvol0: 0 159744 striped 2 128 7:0 2048 7:1 2048
 vg-lvol0: 159744 45056 striped 2 128 7:2 2048 7:3 2048

Before (broken, discards the first striped target's devices twice):
 device-mapper: striped: target_stripe=0, bdev=7:0, start=2048 len=79872
 device-mapper: striped: target_stripe=1, bdev=7:1, start=2048 len=79872
 device-mapper: striped: target_stripe=0, bdev=7:0, start=2049 len=22528
 device-mapper: striped: target_stripe=1, bdev=7:1, start=2048 len=22528

After (works as expected):
 device-mapper: striped: target_stripe=0, bdev=7:0, start=2048 len=79872
 device-mapper: striped: target_stripe=1, bdev=7:1, start=2048 len=79872
 device-mapper: striped: target_stripe=0, bdev=7:2, start=2048 len=22528
 device-mapper: striped: target_stripe=1, bdev=7:3, start=2048 len=22528

Fixes: 7dd76d1feec70 ("dm: improve bio splitting and associated IO accounting")
Cc: stable@vger.kernel.org
Reported-by: Orange Kao <orange@aiven.io>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1509,6 +1509,8 @@ static int __send_duplicate_bios(struct
 		ret = 1;
 		break;
 	default:
+		if (len)
+			setup_split_accounting(ci, *len);
 		/* dm_accept_partial_bio() is not supported with shared tio->len_ptr */
 		alloc_multiple_bios(&blist, ci, ti, num_bios);
 		while ((clone = bio_list_pop(&blist))) {


