Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E08315B316;
	Mon, 29 Jan 2024 17:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548265; cv=none; b=VYObktVxSIpWat8sm2iWdPYiYc01FP0471grBTxp/FpF5+tLTN8wiVBW8QweIGBQ5lhWyyvQZ9W3z1qWdZPGim0GpH2A2ppuxbJJ6MD0mac9jqqD4BqTLHorR0h2MbgsTld9v6N9VUgOlXNgdR53ze1K2WaYVc7PhGtvCJI65Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548265; c=relaxed/simple;
	bh=GsGo1I9QbVwsOZms9QFgyefKstJdGFT1JVU3ZBJAaxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gk4R34Auqbwz+X6MzdBOySmz29Iefb9eX+z7oel4Rzy7ucIetRGWwV7V18OvLCwFTVPo7wM56eqMxUvbfgSCmLOpkwlhZq3Z8AzD6hj05LOG8SYDiF5l1YhOWh5GvZQxKvhe7fo2nuVRWsDrgtuLr40uKCjZK8jE8SyZ90Z9Vqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SzNdeo96; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SzNdeo96"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC65C43394;
	Mon, 29 Jan 2024 17:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548264;
	bh=GsGo1I9QbVwsOZms9QFgyefKstJdGFT1JVU3ZBJAaxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SzNdeo968ZwuduoSR4WwbkHEk71yVhnRrsyRD4MTO0hBCG91qbphRRabZk/zVI+oB
	 eHGc4CXrljNRzzuzhZ6hkSki8AoiyZ2Eqlybxn+myOFwO2U1AYHvgn1Uqn0QM/bW7C
	 XaLiXdjNVtqT+94R1oWlT9RC1t4S0Zm+EW5A985w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 055/185] mm/rmap: fix misplaced parenthesis of a likely()
Date: Mon, 29 Jan 2024 09:04:15 -0800
Message-ID: <20240129170000.364828537@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit f67f8d4a8c1e1ebc85a6cbdb9a7266f14863461c upstream.

Running my yearly branch profiler to see where likely/unlikely annotation
may be added or removed, I discovered this:

correct incorrect  %        Function                  File              Line
 ------- ---------  -        --------                  ----              ----
       0   457918 100 page_try_dup_anon_rmap         rmap.h               264
[..]
  458021        0   0 page_try_dup_anon_rmap         rmap.h               265

I thought it was interesting that line 264 of rmap.h had a 100% incorrect
annotation, but the line directly below it was 100% correct. Looking at the
code:

	if (likely(!is_device_private_page(page) &&
	    unlikely(page_needs_cow_for_dma(vma, page))))

It didn't make sense. The "likely()" was around the entire if statement
(not just the "!is_device_private_page(page)"), which also included the
"unlikely()" portion of that if condition.

If the unlikely portion is unlikely to be true, that would make the entire
if condition unlikely to be true, so it made no sense at all to say the
entire if condition is true.

What is more likely to be likely is just the first part of the if statement
before the && operation. It's likely to be a misplaced parenthesis. And
after making the if condition broken into a likely() && unlikely(), both
now appear to be correct!

Link: https://lkml.kernel.org/r/20231201145936.5ddfdb50@gandalf.local.home
Fixes:fb3d824d1a46c ("mm/rmap: split page_dup_rmap() into page_dup_file_rmap() and page_try_dup_anon_rmap()")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/rmap.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -250,8 +250,8 @@ static inline int page_try_dup_anon_rmap
 	 * guarantee the pinned page won't be randomly replaced in the
 	 * future on write faults.
 	 */
-	if (likely(!is_device_private_page(page) &&
-	    unlikely(page_needs_cow_for_dma(vma, page))))
+	if (likely(!is_device_private_page(page)) &&
+	    unlikely(page_needs_cow_for_dma(vma, page)))
 		return -EBUSY;
 
 	ClearPageAnonExclusive(page);


