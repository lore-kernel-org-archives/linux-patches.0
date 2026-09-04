Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA224195A0;
	Fri,  4 Sep 2026 05:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499257; cv=none; b=cTkdoM6TaK1YMvTgs7n+8jpNoWWFs2xuQeUOMrPSGmnRs46U0kc5Xdk81GAZAe7KdOZ/banAdAJg6SK4FDE346+PMq6Ow/GsbN3UeVWaKGTt9MjLRIFE7zx9UWp0SHJKblnzNRMxhofi/GSBy0n/OTbJWxEEXiavkEzd3hIMb2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499257; c=relaxed/simple;
	bh=f7LY1Ipn1RcwsoP/xTVVfGyODh4zcGFANlkntSLtB68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OHKuytTOJH+6EsT5ffwdFp6K1moFIe6ZrQzhaAaih3Riq7pGupRoC5np3LkuRpc+x/2uWvuIWs+alvxOXx0MMu89QdTfv5tKWlqNnwiIR9DNjd+5+SnwNG9Xi5wfUPTZibz9zfTfbLywFe3h/LEj8T5/aDETdQNZQm4U3MGkN1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FYrSsAU2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FYrSsAU2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97B3E1F00A3D;
	Fri,  4 Sep 2026 05:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499256;
	bh=lgkojPLYxcWEsqPMEpQRFI9of0n5XyRqe5P/ourYm8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FYrSsAU2scRSqWNTBiLCfI5ZM13m6WgSSW+w78wS+eeoAUe7Le52BB71Rocu2l/hS
	 5MmOfeCEqyCW0onBpIj3yfshhcej7FyYU0ai/VEpjBMey3u3sr9rTLvx9wJsb7eBr8
	 tzFd8p3P0iveQHDns55XQcDIsYEo7rMQngBqDKCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 7.2 351/713] jbd2: check need_resched() when skipping busy checkpoint buffers
Date: Fri,  4 Sep 2026 06:55:19 +0200
Message-ID: <20260904045811.699933207@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Kellermann <max.kellermann@ionos.com>

commit f213e12ff5c9590b1034ae8da0e6d09665c772d0 upstream.

journal_shrink_one_cp_list() skips busy checkpoint buffers when called
with JBD2_SHRINK_BUSY_SKIP.  The continue statement on this path also
skips the need_resched() check at the end of the loop body.

Consequently, when a checkpoint list contains mostly busy buffers, the
shrinker can walk the entire list while holding journal->j_list_lock,
even when a reschedule has been requested.  Large checkpoint lists under
memory pressure can therefore cause long lock hold times and leave other
CPUs spinning on j_list_lock, resulting in soft lockups or RCU stalls.

Route the busy-buffer path through the need_resched() check so that the
shrinker can release j_list_lock and reschedule promptly, restoring
parity with the clean-buffer path, which already checks need_resched().
This does not change which checkpoint buffers are eligible for removal.

Fixes: b98dba273a0e ("jbd2: remove journal_clean_one_cp_list()")
Cc: stable@vger.kernel.org
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260713102229.1598812-2-max.kellermann@ionos.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jbd2/checkpoint.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -392,7 +392,7 @@ static unsigned long journal_shrink_one_
 			ret = jbd2_journal_try_remove_checkpoint(jh);
 			if (ret < 0) {
 				if (type == JBD2_SHRINK_BUSY_SKIP)
-					continue;
+					goto next;
 				break;
 			}
 		}
@@ -403,6 +403,7 @@ static unsigned long journal_shrink_one_
 			break;
 		}
 
+next:
 		if (need_resched())
 			break;
 	} while (jh != last_jh && (!nr_to_scan || *nr_to_scan));


