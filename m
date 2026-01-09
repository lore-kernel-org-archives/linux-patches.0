Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46AFD33C53A;
	Fri,  9 Jan 2026 12:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962313; cv=none; b=IQWMotQXn4Ra333Oy0GlrF9bJYz1cJvwgAQhZBeOXcfANo258EroeHHGxilpTKnfq4zlluJcCvXBWfEi/kHA3XyWipsOtzFwQgNub5BYOr/esH2cst4caHHMGoVCfvC3Mjmpmcvohec4BmkD5aP9tCIMvMUQqx4pPuLRLCD1Gew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962313; c=relaxed/simple;
	bh=1v8alsF/CCGSs9sbj14ep4cP3d+1KTXGCVliGEKysj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i61fa9JL1GEQRmNPlJC1pNvGpwEY4vaFGJVj/QG9RVcFzbkRuST3UpaQ3O+8/uYs6FKqsJQW76p+tSEpyq+KBEC2wlcriXxUUmSgkgFfexwHJoI2bd8PrYhkllUAlTnec5n920H86ZUp/UvcJZ4d6JgpzA+CaeeV4jFE9z+OAco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eyLpMvu8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eyLpMvu8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C58BCC4CEF1;
	Fri,  9 Jan 2026 12:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962313;
	bh=1v8alsF/CCGSs9sbj14ep4cP3d+1KTXGCVliGEKysj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eyLpMvu8s0398zmcz9cvVLqOtJ9YeIm+Eh61bFwOJ7zpLUgmb70ILq1rKkIabmSLO
	 /GOit2FdDu9rBxa7KNVVcvkDppiHh2jSwGDOpw+71vY/hTe49UcaqOsk0I93Duqh8u
	 Aiysurt3Ex4El6LBTT7ysUIJdj5yo/uC+TGQyFVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Chen <chenl311@chinatelecom.cn>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 322/634] block: rate-limit capacity change info log
Date: Fri,  9 Jan 2026 12:40:00 +0100
Message-ID: <20260109112129.647321920@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -88,7 +88,7 @@ bool set_capacity_and_notify(struct gend
 	    (disk->flags & GENHD_FL_HIDDEN))
 		return false;
 
-	pr_info("%s: detected capacity change from %lld to %lld\n",
+	pr_info_ratelimited("%s: detected capacity change from %lld to %lld\n",
 		disk->disk_name, capacity, size);
 
 	/*


