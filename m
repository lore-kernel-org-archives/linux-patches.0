Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34E42FD1C2;
	Tue, 12 Aug 2025 18:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024830; cv=none; b=JMpKab7UCAjHCfBnwH8lnQ4cQh5scS1+uI9d3ipNYQj5fv6vccpIGSTeFfosI5HUu61rbszc4uDglAToD9+RmMvf0Sn/BmZbX3qOY7JLz8xBPIYkucY/TIxl2qt13BR2IyWmXqWGasmf69rUicu2fpk2hzKp9xTYVW1dzIziYhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024830; c=relaxed/simple;
	bh=+ctIGOz8Sx3lVHUXNQ0Jo7UTaARWe2N20e0p0gu3d74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cc1cldAqGuAeDH+hkR3YwqA/alQXZaYXt9ncfvz/Qf7L678zW3Q6vDtP76xBOGyJMwBeFmqbc0mPzGHv8+SXU+INfCb1beSqOc4B4D+esk8o2+y0LS6OxLYvzXQM1SHQkZNbxc3n7dEQJ8dZX8H7NQjBcfNr/Y53AA+dOqNxVZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VM8/5OKV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VM8/5OKV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07118C4CEF0;
	Tue, 12 Aug 2025 18:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024829;
	bh=+ctIGOz8Sx3lVHUXNQ0Jo7UTaARWe2N20e0p0gu3d74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VM8/5OKVZtg98m9PHC1FNXYzqzVCDYMi2uUKLw6jlps5x7k+yiH6UCKzBVtWXLWlU
	 AoTWH6psvbl4aUgNbRssy1AC6ePdo/fJk3R9TTWqnlEprJqDkZhGmb9qMWZ03C0v/l
	 g+s+sqcSuciE9zWiNHMLr8LAwYO4gpD4MSGyh8/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 456/627] uprobes: revert ref_ctr_offset in uprobe_unregister error path
Date: Tue, 12 Aug 2025 19:32:31 +0200
Message-ID: <20250812173438.250944031@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <olsajiri@gmail.com>

[ Upstream commit aa644c405291a419e92b112e2279c01c410e9a26 ]

There's error path that could lead to inactive uprobe:

  1) uprobe_register succeeds - updates instruction to int3 and
     changes ref_ctr from 0 to 1
  2) uprobe_unregister fails  - int3 stays in place, but ref_ctr
     is changed to 0 (it's not restored to 1 in the fail path)
     uprobe is leaked
  3) another uprobe_register comes and re-uses the leaked uprobe
     and succeds - but int3 is already in place, so ref_ctr update
     is skipped and it stays 0 - uprobe CAN NOT be triggered now
  4) uprobe_unregister fails because ref_ctr value is unexpected

Fix this by reverting the updated ref_ctr value back to 1 in step 2),
which is the case when uprobe_unregister fails (int3 stays in place), but
we have already updated refctr.

The new scenario will go as follows:

  1) uprobe_register succeeds - updates instruction to int3 and
     changes ref_ctr from 0 to 1
  2) uprobe_unregister fails  - int3 stays in place and ref_ctr
     is reverted to 1..  uprobe is leaked
  3) another uprobe_register comes and re-uses the leaked uprobe
     and succeds - but int3 is already in place, so ref_ctr update
     is skipped and it stays 1 - uprobe CAN be triggered now
  4) uprobe_unregister succeeds

Link: https://lkml.kernel.org/r/20250514101809.2010193-1-jolsa@kernel.org
Fixes: 1cc33161a83d ("uprobes: Support SDT markers having reference count (semaphore)")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Suggested-by: Oleg Nesterov <oleg@redhat.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/uprobes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 4c965ba77f9f..84ee7b590861 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -581,8 +581,8 @@ int uprobe_write_opcode(struct arch_uprobe *auprobe, struct vm_area_struct *vma,
 
 out:
 	/* Revert back reference counter if instruction update failed. */
-	if (ret < 0 && is_register && ref_ctr_updated)
-		update_ref_ctr(uprobe, mm, -1);
+	if (ret < 0 && ref_ctr_updated)
+		update_ref_ctr(uprobe, mm, is_register ? -1 : 1);
 
 	/* try collapse pmd for compound page */
 	if (ret > 0)
-- 
2.39.5



