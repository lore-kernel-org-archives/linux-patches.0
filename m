Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186C333CFD;
	Fri, 24 Nov 2023 18:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uG/MnP2U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B790C433C8;
	Fri, 24 Nov 2023 18:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851075;
	bh=lxQNUHHYsuzoE5Py19BmDTnjoZAZmGysec6Sy35woLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uG/MnP2UiTgLGobbP7cl61I2TsVS9iAzkP+cPLo9qB5G4vHkKwAI4011OJaC739l7
	 rnJtkB+mYh633SPKu9fD9u0/CXC6PM3r9hNlWAvyeNFgGtgMT99Cc/4jzQGMvF8N9r
	 4gM+1fYGG8uiUeXiT/TEuldup1OLw2JtutE81j/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.5 269/491] mm/damon/sysfs: check error from damon_sysfs_update_target()
Date: Fri, 24 Nov 2023 17:48:25 +0000
Message-ID: <20231124172032.662975894@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit b4936b544b08ed44949055b92bd25f77759ebafc upstream.

Patch series "mm/damon/sysfs: fix unhandled return values".

Some of DAMON sysfs interface code is not handling return values from some
functions.  As a result, confusing user input handling or NULL-dereference
is possible.  Check those properly.


This patch (of 3):

damon_sysfs_update_target() returns error code for failures, but its
caller, damon_sysfs_set_targets() is ignoring that.  The update function
seems making no critical change in case of such failures, but the behavior
will look like DAMON sysfs is silently ignoring or only partially
accepting the user input.  Fix it.

Link: https://lkml.kernel.org/r/20231106233408.51159-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20231106233408.51159-2-sj@kernel.org
Fixes: 19467a950b49 ("mm/damon/sysfs: remove requested targets when online-commit inputs")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[5.19+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1197,8 +1197,10 @@ static int damon_sysfs_set_targets(struc
 
 	damon_for_each_target_safe(t, next, ctx) {
 		if (i < sysfs_targets->nr) {
-			damon_sysfs_update_target(t, ctx,
+			err = damon_sysfs_update_target(t, ctx,
 					sysfs_targets->targets_arr[i]);
+			if (err)
+				return err;
 		} else {
 			if (damon_target_has_pid(ctx))
 				put_pid(t->pid);


