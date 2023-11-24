Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26C739FF3;
	Fri, 24 Nov 2023 18:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I2rRzsm4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 439AFC433C7;
	Fri, 24 Nov 2023 18:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849703;
	bh=n5l5ugTpNVR91lW3E17o1cek0jgrgJeK343Hg81hmQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I2rRzsm4s1bAyTTCxGMss2K44ITba3TFEVisC61RysdwtGNqvprijs2dA3zvFOU4f
	 05CiKe9DM3F6t+4IA7KyB6LUniHuQb9X6LzX8Ej1cHzE4lf7GTPj5SIyK8taMsXwc+
	 irSq/1IyWloEfPzuYYtiKPcWOC176TLSye5OCXAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 286/530] mm/damon/sysfs: check error from damon_sysfs_update_target()
Date: Fri, 24 Nov 2023 17:47:32 +0000
Message-ID: <20231124172036.744417006@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1203,8 +1203,10 @@ static int damon_sysfs_set_targets(struc
 
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


