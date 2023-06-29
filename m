Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E197E14267
	for <patches@lists.linux.dev>; Thu, 29 Jun 2023 18:44:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B451C433C0;
	Thu, 29 Jun 2023 18:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688064293;
	bh=cX3Af1i+c9IHNdRmBFmi7FD/Gm1J/o5DXw2VaQT9qIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u2AZB/IIj9XHf41OH87NUyw77eqkq2zeDUUDptMp0+xTL9tkZ57gvicxdy2AiFxnx
	 i2MMRQ9JY+sinG90RDRklEBunIAT8qqFGe+uhiu5pVxReS3coV3f95VavXp0k6hRUK
	 gQ+d8W7openJEiZ5uQUIUuM7j09Mrlq2EKxRDhiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Samuel Mendoza-Jonas <samjonas@amazon.com>,
	David Woodhouse <dwmw@amazon.co.uk>
Subject: [PATCH 6.1 15/30] mm: make the page fault mmap locking killable
Date: Thu, 29 Jun 2023 20:43:34 +0200
Message-ID: <20230629184152.278785439@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230629184151.651069086@linuxfoundation.org>
References: <20230629184151.651069086@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Linus Torvalds <torvalds@linux-foundation.org>

commit eda0047296a16d65a7f2bc60a408f70d178b2014 upstream.

This is done as a separate patch from introducing the new
lock_mm_and_find_vma() helper, because while it's an obvious change,
it's not what x86 used to do in this area.

We already abort the page fault on fatal signals anyway, so why should
we wait for the mmap lock only to then abort later? With the new helper
function that returns without the lock held on failure anyway, this is
particularly easy and straightforward.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Samuel Mendoza-Jonas <samjonas@amazon.com>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5275,8 +5275,7 @@ static inline bool get_mmap_lock_careful
 			return false;
 	}
 
-	mmap_read_lock(mm);
-	return true;
+	return !mmap_read_lock_killable(mm);
 }
 
 static inline bool mmap_upgrade_trylock(struct mm_struct *mm)
@@ -5300,8 +5299,7 @@ static inline bool upgrade_mmap_lock_car
 		if (!search_exception_tables(ip))
 			return false;
 	}
-	mmap_write_lock(mm);
-	return true;
+	return !mmap_write_lock_killable(mm);
 }
 
 /*


