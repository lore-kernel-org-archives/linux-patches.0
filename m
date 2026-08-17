Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD48426D03;
	Mon, 17 Aug 2026 14:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978325; cv=none; b=is5nhduRZ5O3L3SMqeR5DaTCcp5EwVrZeXnF+YFNTCIZxm+XoFdI0lmrwhBdHknnwZpYs2fePLafIOAr/RwIHo0O32o6w0EJlwaZutoLJ7WbLyqjhTP11fAxI+TkA7yToHzURMozLbnPDyt3VzDhbliXfoOOy8e5UqtsHg0oz1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978325; c=relaxed/simple;
	bh=NSjXLg4Vm4KyxTo958HAB/8ebVldaTqzD36HBNGMhao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ceC+iL/DoIM6rMMrbZSa4BLw2iTAuTXzuQIqWp4TVJ9d5JIM5CjR4TtvMONVJ1JMkWZK0s+Mr7gxOkr/aKOJTeku7ccjj+x1ORC8TRnmWjcqJORf0N5QzewnCo2UE6Uk+U8W82wuYo87xc4zF4wnFiksFGiu98lLoSRmKy0fNtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MJW/wmDy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MJW/wmDy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F111F000E9;
	Mon, 17 Aug 2026 14:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978324;
	bh=+QlhKZU0/hpuwnXOKUU2gkWdLNg48UrvOB4o2FaxI+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MJW/wmDyBhFzDouJAvRVIqxDAZGcJKUkpsOhMtH0uKfZD8YxgokFAp4xjWpBi3JMn
	 RK5pb8atpTt/vWIYwJzR968WXA8C05YUvNg67s/hW6ATAQa6xP98+qJ4fB+TzybxEx
	 VHetCa5/DzpUrTBTg6Vi9MuVqUwsrG0hFK/oDka4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.12 180/181] thunderbolt: Fix bandwidth group reservation indexing
Date: Mon, 17 Aug 2026 15:34:34 +0200
Message-ID: <20260817132542.786160672@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Rao <raoxu@uniontech.com>

commit d2ee4d47aacbd2ba456092eeec670dba35fde291 upstream.

Valid bandwidth group IDs range from 1 through MAX_GROUPS, while Group
ID 0 is reserved. tb_consumed_dp_bandwidth() uses the Group ID directly
to index its local group_reserved[] array.

The array currently has MAX_GROUPS entries, so its valid indices are 0
through MAX_GROUPS - 1. Group ID MAX_GROUPS therefore accesses one
element past the end, and the final group's reserved bandwidth is not
included when the array is summed.

Give group_reserved[] MAX_GROUPS + 1 entries so direct Group ID
indexing covers the reserved ID 0 and valid IDs 1 through MAX_GROUPS.

Fixes: 52a4490e89d7 ("thunderbolt: Reserve released DisplayPort bandwidth for a group for 10 seconds")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/tb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -597,7 +597,7 @@ static int tb_consumed_dp_bandwidth(stru
 				    int *consumed_up,
 				    int *consumed_down)
 {
-	int group_reserved[MAX_GROUPS] = {};
+	int group_reserved[MAX_GROUPS + 1] = {};
 	struct tb_cm *tcm = tb_priv(tb);
 	struct tb_tunnel *tunnel;
 	bool downstream;


