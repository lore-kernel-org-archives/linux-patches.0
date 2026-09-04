Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375392F9DA1;
	Fri,  4 Sep 2026 05:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501083; cv=none; b=uIEhKCdIk+SsEhK3gaI0Zn2LvUb9gxX64iNJDOqawm6iJKCtCS+qkWs/Klzk7n0FN9AnTcSYB1TohDYE/PAh2XbkHfuCSOzWta+lwl+W5aa1szs8s9b3M0T3MJOO4T3/YB3IceN/z0m6gtDTCXrPzQD+vvBAq+cP+oEjlvYxHOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501083; c=relaxed/simple;
	bh=FBqV8nxv8JVgnSLMXISG7dd/pbC2j9QbsAS+ERcPPdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T6qYNh3T98gXxQMQMlWnI0Q5QLeEh+O5m7ZDYKDAkAMCA0Wi/9YPVyavxVl3bih0PsZZDjaflEWdhVU8aN9/YyQSpkjxATCxpLCSDmJ7hmPg61EKkNSO71Lqy0hnKnjKYhPJJpmyUcFgq4f0cvsearC/H9/AGc9+IDCvX8vPjjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T5NQGIOj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T5NQGIOj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB461F00A3D;
	Fri,  4 Sep 2026 05:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501082;
	bh=C+QTCua6V8h8Fv9lt6v44Iksor2/qaKQKeD/Sv2hPnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T5NQGIOjLKO9rGiypxjLGT9lVmBcK+fkeHb+rsmiGgCzl5udWu33EGAFe9iyJG5Ld
	 vh7qISAb8bxB/hwmM1rZ+hD+209uqfaCYORYbygd1xlbek/aMx+81WUpyooQpZuQ+B
	 UBntN3+vX8dmU+3XHER0oI0xEr7uJ303pwi8Zw8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.18 257/552] jbd2: check need_resched() when skipping busy checkpoint buffers
Date: Fri,  4 Sep 2026 06:56:54 +0200
Message-ID: <20260904045755.599505802@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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


