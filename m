Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078B432F748;
	Fri,  9 Jan 2026 12:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960477; cv=none; b=MGgylppSSrSGnCPcBKuqS0EAWVsPjA7wVRYUFka3nBTPpdXsaNarK4rAiAHJYwBhdWj+C6r+D0De4iOvyaB/AhczlyS3kyih0V4PawcjYnnAfm+MmFB1dDuHute6Qm3pEBp4P/ykEQ27x9RhrChkCURnacknLXjA5fpqwup5iNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960477; c=relaxed/simple;
	bh=h8GINoNvc5YMtcm8L2okufLpAKQYw16LH56PubBHUoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iFiF43N/6KShpVkTWOSbIQfpDSlrZuLcJ9Lx/dgqbPh+zvGnRrutYTYYMkwyWy71a5lxqgO7CMQSE4WMLaE/DciAhh/aBSI7T7NwtpYV7Fs4RyrOXsx36ozAAioF1HD3/i2kseHA3P3Yv5+G1k9+E3LE1M9TUcLdpnhGiQeUDZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1NRUao39; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1NRUao39"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D2CC4CEF1;
	Fri,  9 Jan 2026 12:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960476;
	bh=h8GINoNvc5YMtcm8L2okufLpAKQYw16LH56PubBHUoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1NRUao39sVpAh5hwgI1aeHF2xSj8gkP4KTdVhEBHI9E85y2vuTJe4/ThaxPgbcjAo
	 8uYH2jG7onCzxnPz8i2XZjZRqSHJ9iujYGx8QR/aUXib3tVNwOyB4of2etEz5p01nX
	 Pro6z/sdEMcu/JITCOcKnlp279THjwyV29V51ODc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Chen <chenl311@chinatelecom.cn>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 417/737] block: rate-limit capacity change info log
Date: Fri,  9 Jan 2026 12:39:16 +0100
Message-ID: <20260109112149.683291761@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


