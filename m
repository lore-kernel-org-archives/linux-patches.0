Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28BA855E4C;
	Tue,  9 Jul 2024 11:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524706; cv=none; b=Wr6JnX3iEDrZFG1dccynJAi/OlanpREZp5St+AGZji5ZddFJKprH7HUVbdMNviWW2pmY35+F6MmVDK7moDgfPHT+rrkmeJHHthnndWNrP1Wz7Vrp6I8HUJh9IFkMPUPtETy3P/MPTEQ4FQWy110yauIgyhcl52Z+NJnV7Wm2nig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524706; c=relaxed/simple;
	bh=o9moS7+D+SJuJ/thl5lA1u1Yn9uw5f3//DiQR+B7Mjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MB5qVhhS0X+C6aMOehbeJtCnwWxq/o4j26k0SsfF4UO/251CuaeQoJKhm1bPzE/vCEEJpKVTFs92JMCISW9Lt2HnxquK6gtoOREySasN+92+6MOhAuiv/z2JnYsEFzv6oIIvTPVaZYQxYW/zQdQGSDxswNQopRDRu/30Q8mNCFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fwSB6oMd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fwSB6oMd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96866C32786;
	Tue,  9 Jul 2024 11:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524706;
	bh=o9moS7+D+SJuJ/thl5lA1u1Yn9uw5f3//DiQR+B7Mjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fwSB6oMdTs82T++UZ1qu+JYQ9tVK5Crj6DOlgI77WjiunIpDjWJVU++EDtcRen0Xz
	 /Ca6+pwTg+LY9UarwUJuIWFfAd/p2oIzfQdG5B50TGGDDNrp2Lg2PB/zYbY2sTnRVY
	 g8vC030gT7Oj1MpivGkomOB+Qkf0CWiKifaK/FkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Zach OKeefe <zokeefe@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 073/102] Revert "mm/writeback: fix possible divide-by-zero in wb_dirty_limits(), again"
Date: Tue,  9 Jul 2024 13:10:36 +0200
Message-ID: <20240709110654.217540740@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1548,7 +1548,7 @@ static inline void wb_dirty_limits(struc
 	 */
 	dtc->wb_thresh = __wb_calc_thresh(dtc);
 	dtc->wb_bg_thresh = dtc->thresh ?
-		div64_u64(dtc->wb_thresh * dtc->bg_thresh, dtc->thresh) : 0;
+		div_u64((u64)dtc->wb_thresh * dtc->bg_thresh, dtc->thresh) : 0;
 
 	/*
 	 * In order to avoid the stacked BDI deadlock we need


