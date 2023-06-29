Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5B914267
	for <patches@lists.linux.dev>; Thu, 29 Jun 2023 18:46:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487C6C433C0;
	Thu, 29 Jun 2023 18:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688064380;
	bh=Uq2KYAuWAyxUlg7TlPfZj30HrNT6oTM7yl3EGO2qOI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1FVV+GM258JL7LNAir4vBxoXu0Kh2A87TI5gfebXGBngKYR/aKXpshyQXMUYvGnKT
	 HkazoiwsKoqEz/qceyvSsejCiJzoaeD2PwOBPkrJ7IzOwR+ugWUxcVxd23Bg8Gfhns
	 VVA6pDlCSTDhLnJqW5vAzp/XKsQnGNDEvndkSfPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.3 13/29] mm: make the page fault mmap locking killable
Date: Thu, 29 Jun 2023 20:43:43 +0200
Message-ID: <20230629184152.268350026@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230629184151.705870770@linuxfoundation.org>
References: <20230629184151.705870770@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5247,8 +5247,7 @@ static inline bool get_mmap_lock_careful
 			return false;
 	}
 
-	mmap_read_lock(mm);
-	return true;
+	return !mmap_read_lock_killable(mm);
 }
 
 static inline bool mmap_upgrade_trylock(struct mm_struct *mm)
@@ -5272,8 +5271,7 @@ static inline bool upgrade_mmap_lock_car
 		if (!search_exception_tables(ip))
 			return false;
 	}
-	mmap_write_lock(mm);
-	return true;
+	return !mmap_write_lock_killable(mm);
 }
 
 /*


