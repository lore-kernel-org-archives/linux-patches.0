Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF6B3314C2;
	Mon, 29 Dec 2025 16:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025534; cv=none; b=iw7523dykASaOKqjZbXDmyHUIyRbKHCLuT0TAGMDxxjffJANBVP+mXsi5Acm1pcX7zfgM2uzdTZTMG4yeIoUjaB5qU0PJTIQ2RQdtPYBWu7ftiVrzrmPvK3Jj+53qc2ElPCRMEO08kkl0sAQ4L/IOuZCyu4GRPAew400jbynF4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025534; c=relaxed/simple;
	bh=fmZYcip07IyohzcBRk3FHr2N2mPezvnAODiKSoqabMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJC6DDr1SongPnwGgCy0+jllmoGGoriGRL8h6odE7NpP3cPCf2bn/eXf2xUdM+J7RvM+ApB5G+GHoym4mxA5f8AurvHBqxucAHpFaM3jO/JYrs8z6AupQjsqLaj3mjDR0+Hja97m4D1Pr80T3oiz5h5X39bQDxr7AF63my9HHyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JgqsFdKc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JgqsFdKc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E21C16AAE;
	Mon, 29 Dec 2025 16:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025534;
	bh=fmZYcip07IyohzcBRk3FHr2N2mPezvnAODiKSoqabMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JgqsFdKcy4KSvejsejJIma6HE8L2UJwmAosTJEUFjRvV8ghDWlqQORZ2DjG+LsOx6
	 HuICBEAiatI/LuwPFODCHqv8648sM/bMF3fCniAQmghEcloWL275uSIRK/iSu5PDE8
	 Q3FWjtKxbHly2qyOU1ucuejdAu02IiWB2cRIbhFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Chen <chenl311@chinatelecom.cn>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 248/430] block: rate-limit capacity change info log
Date: Mon, 29 Dec 2025 17:10:50 +0100
Message-ID: <20251229160733.483127243@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -90,7 +90,7 @@ bool set_capacity_and_notify(struct gend
 	    (disk->flags & GENHD_FL_HIDDEN))
 		return false;
 
-	pr_info("%s: detected capacity change from %lld to %lld\n",
+	pr_info_ratelimited("%s: detected capacity change from %lld to %lld\n",
 		disk->disk_name, capacity, size);
 
 	/*


