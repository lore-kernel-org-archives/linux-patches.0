Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62AF92571A5;
	Mon, 23 Jun 2025 13:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685890; cv=none; b=gSYgyhg+xvsG+XtKHBTx7Vg54y4o5HUyZOUl/iggkVbqRBDgGowJaUjN5TJcyOouF1LmMDt0vBdymhFI/dLgWFpPCF6vSDgqSc7d6v8EtdyNCIEXfQejxM5PW6VpxQe9niSWY8FKWCv8htsvuMCFXfq1ntX6xCTYCBgr9cSEBCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685890; c=relaxed/simple;
	bh=FhJ69nZENyPhky/ZMxXLWQoRzL3SA/KTZFXrUyXUbEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pR3OwvoRmwypR8kzN22Tk0vRwTOXrSfotymY1ryd4HuJRrWXCOuBvD7SNqK/p97aLkXki229wehWUh2v/60xp7uZoR+Tcke65leOaIr/TPnfbjQ32/T3x+RejHBrK1K7yZNFzLSkcnDcxcXAP6jtvxhVXvzH49K0HWaYhfbECFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zIApeS9j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zIApeS9j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDECDC4CEEA;
	Mon, 23 Jun 2025 13:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685890;
	bh=FhJ69nZENyPhky/ZMxXLWQoRzL3SA/KTZFXrUyXUbEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zIApeS9jblHSUiUEiD0HegYyT2H5zXw9xNjJbAFA2e9pc3utnIVPI2OYeRZH4Syr7
	 4pwigU08IPI6sPVSyIRB2yvfHcSV2Si+rVL021vHiD5A3C58M3+QD1etFtR2NOt8Ef
	 VFog9jhrtPmYkesbp6gNb9WdHS16l1UXMCs+Ka3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 012/414] io_uring: account drain memory to cgroup
Date: Mon, 23 Jun 2025 15:02:29 +0200
Message-ID: <20250623130642.332488652@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Pavel Begunkov <asml.silence@gmail.com>

commit f979c20547e72568e3c793bc92c7522bc3166246 upstream.

Account drain allocations against memcg. It's not a big problem as each
such allocation is paired with a request, which is accounted, but it's
nicer to follow the limits more closely.

Cc: stable@vger.kernel.org # 6.1
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/f8dfdbd755c41fd9c75d12b858af07dfba5bbb68.1746788718.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1681,7 +1681,7 @@ queue:
 	spin_unlock(&ctx->completion_lock);
 
 	io_prep_async_link(req);
-	de = kmalloc(sizeof(*de), GFP_KERNEL);
+	de = kmalloc(sizeof(*de), GFP_KERNEL_ACCOUNT);
 	if (!de) {
 		ret = -ENOMEM;
 		io_req_defer_failed(req, ret);


