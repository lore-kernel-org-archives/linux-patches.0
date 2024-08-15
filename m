Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CEF91494C5;
	Thu, 15 Aug 2024 13:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729878; cv=none; b=rfB2oBW45bY3fMrGfzI/FWDA0tR4HqaTGTP24EsBZCf4i7rAKqV3eiiZyDWpTJlwr7z8WX4G3vmgtcr6Na074I/hI0t2FfilTTAKdpdsC/HPVZYSadh5qZxQ2Y20s+YZ340vglkKvz8S7B/c6bsq/cviMINVSjd5CUQOVvApPdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729878; c=relaxed/simple;
	bh=uRvd73akubC/blDHcx+IE6SxznjfoW0ITJ3L9w9NPrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ApZ7SS4ANCorDDHQv0OA9gYWC2t6xDOs7Tl4OMunIwaFGgrtxCR+tHn1Xd14RhlesZ5EDT0yHEc5pyXnzJXDyflb9TOHjONjs9M6ec53f2l15ge50mFiRExQ53nsJ1Lwt86h74SG9+ItBgT25yEaLqKOIbSwyNjAZaGoNxGQ/pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RkjmqhaP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RkjmqhaP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7674CC32786;
	Thu, 15 Aug 2024 13:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729877;
	bh=uRvd73akubC/blDHcx+IE6SxznjfoW0ITJ3L9w9NPrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RkjmqhaPxvJIWV6rW+NcdUT4MzorvobT/4jHBqc0dOuDUW+JeJ+h7fiiUZfjC88Fk
	 t6VUa8Uuv7soQRohAe5QAzRKdIa1C9L+FmnODn0cpzxIXXF/coIYwLOCYHKSmzx2rC
	 TnbsumHsjsv9SPv34wK+YqTPFA3pDzYbPFVGfASs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Andrea Parri <parri.andrea@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 5.15 204/484] tools/memory-model: Fix bug in lock.cat
Date: Thu, 15 Aug 2024 15:21:02 +0200
Message-ID: <20240815131949.292717746@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 4c830eef806679dc243e191f962c488dd9d00708 upstream.

Andrea reported that the following innocuous litmus test:

C T

{}

P0(spinlock_t *x)
{
	int r0;

	spin_lock(x);
	spin_unlock(x);
	r0 = spin_is_locked(x);
}

gives rise to a nonsensical empty result with no executions:

$ herd7 -conf linux-kernel.cfg T.litmus
Test T Required
States 0
Ok
Witnesses
Positive: 0 Negative: 0
Condition forall (true)
Observation T Never 0 0
Time T 0.00
Hash=6fa204e139ddddf2cb6fa963bad117c0

The problem is caused by a bug in the lock.cat part of the LKMM.  Its
computation of the rf relation for RU (read-unlocked) events is
faulty; it implicitly assumes that every RU event must read from
either a UL (unlock) event in another thread or from the lock's
initial state.  Neither is true in the litmus test above, so the
computation yields no possible executions.

The lock.cat code tries to make up for this deficiency by allowing RU
events outside of critical sections to read from the last po-previous
UL event.  But it does this incorrectly, trying to keep these rfi links
separate from the rfe links that might also be needed, and passing only
the latter to herd7's cross() macro.

The problem is fixed by merging the two sets of possible rf links for
RU events and using them all in the call to cross().

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Andrea Parri <parri.andrea@gmail.com>
Closes: https://lore.kernel.org/linux-arch/ZlC0IkzpQdeGj+a3@andrea/
Tested-by: Andrea Parri <parri.andrea@gmail.com>
Acked-by: Andrea Parri <parri.andrea@gmail.com>
Fixes: 15553dcbca06 ("tools/memory-model: Add model support for spin_is_locked()")
CC: <stable@vger.kernel.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/memory-model/lock.cat |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/tools/memory-model/lock.cat
+++ b/tools/memory-model/lock.cat
@@ -102,19 +102,19 @@ let rf-lf = rfe-lf | rfi-lf
  * within one of the lock's critical sections returns False.
  *)
 
-(* rfi for RU events: an RU may read from the last po-previous UL *)
-let rfi-ru = ([UL] ; po-loc ; [RU]) \ ([UL] ; po-loc ; [LKW] ; po-loc)
-
-(* rfe for RU events: an RU may read from an external UL or the initial write *)
-let all-possible-rfe-ru =
-	let possible-rfe-ru r =
+(*
+ * rf for RU events: an RU may read from an external UL or the initial write,
+ * or from the last po-previous UL
+ *)
+let all-possible-rf-ru =
+	let possible-rf-ru r =
 		let pair-to-relation p = p ++ 0
-		in map pair-to-relation (((UL | IW) * {r}) & loc & ext)
-	in map possible-rfe-ru RU
+		in map pair-to-relation ((((UL | IW) * {r}) & loc & ext) |
+			(((UL * {r}) & po-loc) \ ([UL] ; po-loc ; [LKW] ; po-loc)))
+	in map possible-rf-ru RU
 
 (* Generate all rf relations for RU events *)
-with rfe-ru from cross(all-possible-rfe-ru)
-let rf-ru = rfe-ru | rfi-ru
+with rf-ru from cross(all-possible-rf-ru)
 
 (* Final rf relation *)
 let rf = rf | rf-lf | rf-ru


