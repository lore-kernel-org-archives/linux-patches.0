Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7221C208C7
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X1NC+Izf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0EF7C433C7;
	Tue, 31 Oct 2023 17:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698774627;
	bh=4H1KD4EIJqyj4jWsfqDh//7hBjCmlLfxS6FDIihUkio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X1NC+Izfmra6GPjr7mt3drKQ3ws+BRULq+YopPK0fK/UuLyVVSOY06z0XuK+duzo/
	 IVvryb59bvMNQTHpORS575HadQSEmzPn+QVn+60v6+aDIeeWZMBGetxxmGj3+Boeg9
	 KDkvlmBXvo4eNzn8lVO9jgm0wa0X3e95CME79vlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.5 111/112] mm/damon/sysfs: check DAMOS regions update progress from before_terminate()
Date: Tue, 31 Oct 2023 18:01:52 +0100
Message-ID: <20231031165904.762790861@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165901.318222981@linuxfoundation.org>
References: <20231031165901.318222981@linuxfoundation.org>
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

commit 76b7069bcc89dec33f03eb08abee165d0306b754 upstream.

DAMON_SYSFS can receive DAMOS tried regions update request while kdamond
is already out of the main loop and before_terminate callback
(damon_sysfs_before_terminate() in this case) is not yet called.  And
damon_sysfs_handle_cmd() can further be finished before the callback is
invoked.  Then, damon_sysfs_before_terminate() unlocks damon_sysfs_lock,
which is not locked by anyone.  This happens because the callback function
assumes damon_sysfs_cmd_request_callback() should be called before it.
Check if the assumption was true before doing the unlock, to avoid this
problem.

Link: https://lkml.kernel.org/r/20231007200432.3110-1-sj@kernel.org
Fixes: f1d13cacabe1 ("mm/damon/sysfs: implement DAMOS tried regions update command")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.2.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1202,6 +1202,8 @@ static int damon_sysfs_set_targets(struc
 	return 0;
 }
 
+static bool damon_sysfs_schemes_regions_updating;
+
 static void damon_sysfs_before_terminate(struct damon_ctx *ctx)
 {
 	struct damon_target *t, *next;
@@ -1209,10 +1211,12 @@ static void damon_sysfs_before_terminate
 
 	/* damon_sysfs_schemes_update_regions_stop() might not yet called */
 	kdamond = damon_sysfs_cmd_request.kdamond;
-	if (kdamond && damon_sysfs_cmd_request.cmd ==
+	if (kdamond && (damon_sysfs_cmd_request.cmd ==
 			DAMON_SYSFS_CMD_UPDATE_SCHEMES_TRIED_REGIONS &&
+			damon_sysfs_schemes_regions_updating) &&
 			ctx == kdamond->damon_ctx) {
 		damon_sysfs_schemes_update_regions_stop(ctx);
+		damon_sysfs_schemes_regions_updating = false;
 		mutex_unlock(&damon_sysfs_lock);
 	}
 
@@ -1331,7 +1335,6 @@ static int damon_sysfs_commit_input(stru
 static int damon_sysfs_cmd_request_callback(struct damon_ctx *c)
 {
 	struct damon_sysfs_kdamond *kdamond;
-	static bool damon_sysfs_schemes_regions_updating;
 	int err = 0;
 
 	/* avoid deadlock due to concurrent state_store('off') */


