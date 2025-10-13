Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F0430E85E;
	Mon, 13 Oct 2025 15:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368805; cv=none; b=I7Dxc7VrW4TRjkt9+2LHmuZEEdLO1HhYhqg2BqXa2k8v4TND3XQLSOd6uENaOVBogSieBRxIBLWV+ihWGIq1TzvUeIZJwg/u8W3ZgIMuRbg81OgkRTa5AzexlXRipO7zsF9oGidmmUIsGWbsaiaeHJcqavQIS0vTuo2JcDcJx60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368805; c=relaxed/simple;
	bh=F165bJ/dnjxEp5lQ6/mutWHgsdONEdUQt0VhkXQNqPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KiP+suWzsy4v/wRnbNeCNfNokXqLB6uUavtZjGNkreFyAvbjEKNFoD1PU4Nf/KqMmbLdSH4mhIp2FslmF9WTJUENNJ/aFd4lXM9q9cqHoU33Y0UwcPhj67uzc0LeS1xVYXnB7VE2cb+/ao7LnckciGAH6OlX31cNhOd9wZYfPJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ig1Ss4GI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ig1Ss4GI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46BC4C4CEE7;
	Mon, 13 Oct 2025 15:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368805;
	bh=F165bJ/dnjxEp5lQ6/mutWHgsdONEdUQt0VhkXQNqPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ig1Ss4GI4Mm6L4hz4rtZB3zeoNEJKijT+3HpFAFN3OZq12yYaBPzo01v4g+Wmf52U
	 NwW+fsBjNChRtdd0r6NhRHLwut23s0VV2W23FKFjuQQJ8jEAEDbD94DcAlLe8bGcAz
	 Vn22uxAYPVyAKJOJr8HpCyec46J3EM7SpneEKAGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 026/563] coresight: trbe: Prevent overflow in PERF_IDX2OFF()
Date: Mon, 13 Oct 2025 16:38:07 +0200
Message-ID: <20251013144412.236405834@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit 105f56877f2d5f82d71e20b45eb7be7c24c3d908 ]

Cast nr_pages to unsigned long to avoid overflow when handling large
AUX buffer sizes (>= 2 GiB).

Fixes: 3fbf7f011f24 ("coresight: sink: Add TRBE driver")
Signed-off-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-trbe.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/coresight-trbe.c b/drivers/hwtracing/coresight/coresight-trbe.c
index 8267dd1a2130d..8f426f94e32a1 100644
--- a/drivers/hwtracing/coresight/coresight-trbe.c
+++ b/drivers/hwtracing/coresight/coresight-trbe.c
@@ -23,7 +23,8 @@
 #include "coresight-self-hosted-trace.h"
 #include "coresight-trbe.h"
 
-#define PERF_IDX2OFF(idx, buf) ((idx) % ((buf)->nr_pages << PAGE_SHIFT))
+#define PERF_IDX2OFF(idx, buf) \
+	((idx) % ((unsigned long)(buf)->nr_pages << PAGE_SHIFT))
 
 /*
  * A padding packet that will help the user space tools
-- 
2.51.0



