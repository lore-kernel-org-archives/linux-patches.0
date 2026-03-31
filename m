Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DBD8423A63;
	Tue, 31 Mar 2026 16:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975398; cv=none; b=ERew3/fEKDRGtPYhMIYZQ44Kl7X+BLfLUH7dRhykh0KKyKq5nHPzxMZTXr9Fh/+yWpp5dTHjXXn/SSJGrLpanmGSmKJZBRLRY938JK/jAju7TZyKIQekk+esCIsJDa4NC7k3FNSjur7ekqybu8XnFnyuRO8kayZaU5hYtznM/rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975398; c=relaxed/simple;
	bh=/LxLtzZy1LE6T8HqAT6RBqjF5euwby6EY5K9URJMzbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MuS5O4hbaEDmZADSUcqQ9ERfX/Suik01w1ydC+HmZkisACSqv5W31Xr9DVLxy1tt83hYkF36s8IZtILnC53JhRo3tT5lt3R1VH5DgeNHNKV2LmJJXdULQf4/5qGQL3R8LtwBTJHsY+HhWajv0rFX0/CZCEZs0AjmXndULx3H6t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CO/5v17U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CO/5v17U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F04C19423;
	Tue, 31 Mar 2026 16:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975398;
	bh=/LxLtzZy1LE6T8HqAT6RBqjF5euwby6EY5K9URJMzbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CO/5v17U0SSCfZupj8oz8FloFxWFezYYPmikGIaSTdB4GnGrC/u8iZ9IhNZIwOMHd
	 f62aS7SLGvXNuUDqNQ2KwRYma8Ci8UU1qjswIcKhFzF18ts1TdMNUgIHaimU7UkI5H
	 OXQNALT0A4lvNX1/tal3KIHE27GLDn9Ziv5VnKuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Law <objecting@objecting.org>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.19 280/342] mm/damon/sysfs: check contexts->nr before accessing contexts_arr[0]
Date: Tue, 31 Mar 2026 18:21:53 +0200
Message-ID: <20260331161809.241368026@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Law <objecting@objecting.org>

commit 1bfe9fb5ed2667fb075682408b776b5273162615 upstream.

Multiple sysfs command paths dereference contexts_arr[0] without first
verifying that kdamond->contexts->nr == 1.  A user can set nr_contexts to
0 via sysfs while DAMON is running, causing NULL pointer dereferences.

In more detail, the issue can be triggered by privileged users like
below.

First, start DAMON and make contexts directory empty
(kdamond->contexts->nr == 0).

    # damo start
    # cd /sys/kernel/mm/damon/admin/kdamonds/0
    # echo 0 > contexts/nr_contexts

Then, each of below commands will cause the NULL pointer dereference.

    # echo update_schemes_stats > state
    # echo update_schemes_tried_regions > state
    # echo update_schemes_tried_bytes > state
    # echo update_schemes_effective_quotas > state
    # echo update_tuned_intervals > state

Guard all commands (except OFF) at the entry point of
damon_sysfs_handle_cmd().

Link: https://lkml.kernel.org/r/20260321175427.86000-3-sj@kernel.org
Fixes: 0ac32b8affb5 ("mm/damon/sysfs: support DAMOS stats")
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[5.18+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1752,6 +1752,9 @@ static int damon_sysfs_update_schemes_tr
 static int damon_sysfs_handle_cmd(enum damon_sysfs_cmd cmd,
 		struct damon_sysfs_kdamond *kdamond)
 {
+	if (cmd != DAMON_SYSFS_CMD_OFF && kdamond->contexts->nr != 1)
+		return -EINVAL;
+
 	switch (cmd) {
 	case DAMON_SYSFS_CMD_ON:
 		return damon_sysfs_turn_damon_on(kdamond);


