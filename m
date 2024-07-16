Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5D1CA40;
	Tue, 16 Jul 2024 15:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144334; cv=none; b=lfXmAGFdpdLsot+zXqBzMwrtlkipgZNwFRwNTMy49lsQxsoqT1xdf9KoUGDOEpQiEMQknHmMMzx5aIpUYyRdF721HLmOD5DkawMPDFkR/MehqCMez3Q3hMVwAnPRrcGbG9FbslqIcv09NDBsvBkANOlNuQxl6iQAjoKSB+vlpHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144334; c=relaxed/simple;
	bh=qMptx+6qkrahFzaH6aoiD3gCEThxVchg9+m8uGHCr+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ywe9NY/S1yzvm44WZ3SOINvuelBxFvgWSTneCjHkGPvItsaAAbHnaOtRhvGOmG+PfIIn+bK11rAp1QI5/YH6uY0f8vRkQjaEPijGW+Ve1PWQvEuquDrnjYIAP7Ttx2k+0/miSC+cXQ+Aaf0f26BwSDowt8slr7tg8cU8oeVFwTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NDJ9jRCl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NDJ9jRCl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66203C116B1;
	Tue, 16 Jul 2024 15:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144333;
	bh=qMptx+6qkrahFzaH6aoiD3gCEThxVchg9+m8uGHCr+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NDJ9jRCldj3+hGsT6HdOqtHumfbc5fAHrq0dBc3TSvsKgeL7P+FkgIQ0/QTgfj/gY
	 lMWuZPj/kT6zSSOaLV0G5Vb7dVgDA+4CMAMdHNAgz9W+dgNXHG9gvoYWnHhw5FOSJl
	 /EYxZU5vkQD52YCYMxhaSk3OnpYHFy90usPB1LOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Zach OKeefe <zokeefe@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.4 37/78] Revert "mm/writeback: fix possible divide-by-zero in wb_dirty_limits(), again"
Date: Tue, 16 Jul 2024 17:31:09 +0200
Message-ID: <20240716152742.073597362@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152740.626160410@linuxfoundation.org>
References: <20240716152740.626160410@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1530,7 +1530,7 @@ static inline void wb_dirty_limits(struc
 	 */
 	dtc->wb_thresh = __wb_calc_thresh(dtc);
 	dtc->wb_bg_thresh = dtc->thresh ?
-		div64_u64(dtc->wb_thresh * dtc->bg_thresh, dtc->thresh) : 0;
+		div_u64((u64)dtc->wb_thresh * dtc->bg_thresh, dtc->thresh) : 0;
 
 	/*
 	 * In order to avoid the stacked BDI deadlock we need


