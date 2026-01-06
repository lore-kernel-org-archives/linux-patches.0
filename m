Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F8C355035;
	Tue,  6 Jan 2026 17:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720191; cv=none; b=YfLNiZEoIjMpCaXVZPNUEAI30iGMbf/x++mI0dW9kZWbvLkCjQDCcVqDkl0hH/zBGpZDeFEsrCno+MA0OjhhTG8iAx676BkaqghTIWKiW2OZDqNRDjlpHWh5v04vm8qWda1vDOTYjlzqD9Hp3Bev6KiYY4yXFY1VEsa3QqBJrAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720191; c=relaxed/simple;
	bh=J7q45wHS6K90fpvuQQr/HlXrLg7wF520VWRHxpb/38I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bhn0F62BP9WPhk8nGXXI932IJSUnPDR8Bmovga1LRHex5cmK6Ix/TeB8bTx6VRzp2+tViLFjlsTQiXY867afH62uCSqOJpHLW1kPQ4pRLK+PdFcyGceooBAeNFfaeslFN3E9AK1g9hTEOWEvTpc+oV3O76HswWZIHo/QRlhCbD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Js86vPa7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Js86vPa7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D55E9C116C6;
	Tue,  6 Jan 2026 17:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720191;
	bh=J7q45wHS6K90fpvuQQr/HlXrLg7wF520VWRHxpb/38I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Js86vPa7dy6h47jM80FzyOY2saJg9WAj2MFVcPF5rTeHxt9i7cWprtVNEZb7tbIaT
	 iL/7h5dbtV+qzP6ex0SZhm9veUPBzrAMKulK8wT7yI9kbBp6r/Rpuc5PtiHYFfaqhC
	 aqGqDwb9t7rh6GAXfVda0EKGxHF68im2UsDZmwco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Chen <chenl311@chinatelecom.cn>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 161/567] block: rate-limit capacity change info log
Date: Tue,  6 Jan 2026 17:59:03 +0100
Message-ID: <20260106170457.285066047@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Chen <chenl311@chinatelecom.cn>

commit 3179a5f7f86bcc3acd5d6fb2a29f891ef5615852 upstream.

loop devices under heavy stress-ng loop streessor can trigger many
capacity change events in a short time. Each event prints an info
message from set_capacity_and_notify(), flooding the console and
contributing to soft lockups on slow consoles.

Switch the printk in set_capacity_and_notify() to
pr_info_ratelimited() so frequent capacity changes do not spam
the log while still reporting occasional changes.

Cc: stable@vger.kernel.org
Signed-off-by: Li Chen <chenl311@chinatelecom.cn>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/genhd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/genhd.c
+++ b/block/genhd.c
@@ -83,7 +83,7 @@ bool set_capacity_and_notify(struct gend
 	    (disk->flags & GENHD_FL_HIDDEN))
 		return false;
 
-	pr_info("%s: detected capacity change from %lld to %lld\n",
+	pr_info_ratelimited("%s: detected capacity change from %lld to %lld\n",
 		disk->disk_name, capacity, size);
 
 	/*


