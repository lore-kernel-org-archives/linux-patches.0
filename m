Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DFFB13A25F;
	Tue,  9 Jul 2024 11:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523766; cv=none; b=W0INgBlyKSBGl4fpqQlSu7CJlxe1wg0jCyrXs3yoEnHC+63CTRn2zZUHHszlfdXtmStLkSNkUo1ZYV6uPSZbuHqUl1tXdWdmfX9hEQJvL4aiNQ/w6cTFB5wpYU0B7I/6f3RLeSWIIX3tp9iV3KbVgdvQaCdZaUWZnQIEWGQzApU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523766; c=relaxed/simple;
	bh=xxEcZ3dRxwb0NBIRzijQJg5DvgGe/TQQnhFxzRbfRAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N8TdHijVOUXtqsJx372kwQjyo/mPymAHd4Jq4uxloF8NwntnkTyxa6kP11hUvyH29mEqMgoAEcwsvDZDsQzJ9X8DC67upg6YiVi+8izaVddYbAbSd+3F6CbvAwgBrC7TWmsup4ceBK4TtJ6wISBqZwbh5l0M6akH4fpZbcG3Oe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Efyv2zdY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Efyv2zdY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D996DC3277B;
	Tue,  9 Jul 2024 11:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523766;
	bh=xxEcZ3dRxwb0NBIRzijQJg5DvgGe/TQQnhFxzRbfRAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Efyv2zdYQsIjsxhW4/3RfuZGack3wOBC3pje8ArdmZXQ+lg2ESFoR8VdgYiSZAQj4
	 EPqt9/hxN4eTOv3TmJ3aXKlKjjcfl6iDkTmunof5yGdCk4AnP0nQHEmBXF7BDXKowY
	 mzlz21iZARHJJ589iKgQSS6cbvQPS2ku5pk08Vto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Zach OKeefe <zokeefe@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 101/139] Revert "mm/writeback: fix possible divide-by-zero in wb_dirty_limits(), again"
Date: Tue,  9 Jul 2024 13:10:01 +0200
Message-ID: <20240709110702.082219347@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

commit 30139c702048f1097342a31302cbd3d478f50c63 upstream.

Patch series "mm: Avoid possible overflows in dirty throttling".

Dirty throttling logic assumes dirty limits in page units fit into
32-bits.  This patch series makes sure this is true (see patch 2/2 for
more details).


This patch (of 2):

This reverts commit 9319b647902cbd5cc884ac08a8a6d54ce111fc78.

The commit is broken in several ways.  Firstly, the removed (u64) cast
from the multiplication will introduce a multiplication overflow on 32-bit
archs if wb_thresh * bg_thresh >= 1<<32 (which is actually common - the
default settings with 4GB of RAM will trigger this).  Secondly, the
div64_u64() is unnecessarily expensive on 32-bit archs.  We have
div64_ul() in case we want to be safe & cheap.  Thirdly, if dirty
thresholds are larger than 1<<32 pages, then dirty balancing is going to
blow up in many other spectacular ways anyway so trying to fix one
possible overflow is just moot.

Link: https://lkml.kernel.org/r/20240621144017.30993-1-jack@suse.cz
Link: https://lkml.kernel.org/r/20240621144246.11148-1-jack@suse.cz
Fixes: 9319b647902c ("mm/writeback: fix possible divide-by-zero in wb_dirty_limits(), again")
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-By: Zach O'Keefe <zokeefe@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1660,7 +1660,7 @@ static inline void wb_dirty_limits(struc
 	 */
 	dtc->wb_thresh = __wb_calc_thresh(dtc);
 	dtc->wb_bg_thresh = dtc->thresh ?
-		div64_u64(dtc->wb_thresh * dtc->bg_thresh, dtc->thresh) : 0;
+		div_u64((u64)dtc->wb_thresh * dtc->bg_thresh, dtc->thresh) : 0;
 
 	/*
 	 * In order to avoid the stacked BDI deadlock we need


