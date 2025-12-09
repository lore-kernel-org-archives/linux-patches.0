Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1B4220F3E;
	Tue,  9 Dec 2025 00:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765239409; cv=none; b=QHWPgkqeGimxDi5DdhZFZ9zLpuv0zkpx0Ohh6snbFyn+lNeKslEiWAr4kvQ10M73IR0EQb/RL7WFHqxL/vQLBu7qYkBl7yc4961K7IxQATzz68vFvOMU6uY9SIbfNSk+PDmLwaY1fnztHQReN1WI2vcs+yEoMSGgoGWdol/ZC30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765239409; c=relaxed/simple;
	bh=+fEtpiAU5F4qN2nqblGeJLbNnNnrXklntIsEeaDT3ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bAbaj/Upd9XWlHgXOEN9ty2CAG0U0jQLgLziAjdKLPn3I6HMuEgrLJOARuz250F7Sc9QM+UKqF1wYzkB1fjS1TpdRf/ioQwNYbVOOfL8cnn4nURMrUkaXMZEAXBgwsJJmikaa9F5SfzHg61nuz09uoQ0P/Ul9EYw4fqTEq6D3xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i5yLId5x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i5yLId5x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE272C19421;
	Tue,  9 Dec 2025 00:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765239408;
	bh=+fEtpiAU5F4qN2nqblGeJLbNnNnrXklntIsEeaDT3ns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i5yLId5x6TQTUTJcUxf13z4bmstvfc3r0y+ceWeYnx8kZimGGqLb+d+5E497N0WrZ
	 ONJqyQ3+MLTw1EI1Jz4n/TZFzjaI9ces1wSeKCePOtUS4suK7hdzaVxBibr9A35rgI
	 wp6e68ZP2U8HMA+QWvP5uUCb4dIf4K88r2bBWf3+FQmXbE8iS6eh4iF0NCCJ0YMMOn
	 WrY/ju29LumH6p81ctEcqnLPUP+LD1ubBQcP/dJfPOHw3AvRx8O9oa6e5UHM94/9NW
	 IggIgBnEfCSezUNeCR4ngWNmW4E91xP8NW9MRuWyXidaRin7hpPGnfRIh/X19xPUGo
	 VpundUZGWWqRg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	Stephen Zhang <starzhangzsd@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	gfs2@lists.linux.dev
Subject: [PATCH AUTOSEL 6.18-6.1] gfs2: Fix use of bio_chain
Date: Mon,  8 Dec 2025 19:15:00 -0500
Message-ID: <20251209001610.611575-8-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251209001610.611575-1-sashal@kernel.org>
References: <20251209001610.611575-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 8a157e0a0aa5143b5d94201508c0ca1bb8cfb941 ]

In gfs2_chain_bio(), the call to bio_chain() has its arguments swapped.
The result is leaked bios and incorrect synchronization (only the last
bio will actually be waited for).  This code is only used during mount
and filesystem thaw, so the bug normally won't be noticeable.

Reported-by: Stephen Zhang <starzhangzsd@gmail.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I understand the bug clearly. The `bio_chain()` signature is:
```c
void bio_chain(struct bio *bio, struct bio *parent)
```

Where:
- `bio` - the target bio being submitted
- `parent` - the bio whose completion will be delayed until both
  complete

**The Bug:**
In `gfs2_chain_bio()`:
```c
new->bi_iter.bi_sector = bio_end_sector(prev);
bio_chain(new, prev);  // WRONG: arguments swapped
submit_bio(prev);
return new;
```

The function allocates `new`, chains with `prev`, submits `prev`, and
returns `new`. The intention is that `new` accumulates all completions -
callers wait on `new`.

With the **wrong order** `bio_chain(new, prev)`:
- `new`'s completion increments `prev`'s remaining count
- But `prev` is submitted immediately and freed after completion
- Result: **leaked bios** (new never freed properly) and **incorrect
  synchronization** (waiting on `new` doesn't work correctly)

With the **correct order** `bio_chain(prev, new)`:
- `prev`'s completion increments `new`'s remaining count
- Waiting on `new` correctly waits for all chained bios

## 3. CLASSIFICATION

- **Type:** Bug fix - logic error (swapped arguments)
- **Impact:** Memory leaks and incorrect I/O synchronization in GFS2
- **Not:** Feature addition, refactoring, or cleanup

## 4. SCOPE AND RISK ASSESSMENT

- **Lines changed:** 1 line
- **Files touched:** 1 file
- **Complexity:** Trivial - argument swap
- **Risk:** Extremely low - this is the obviously correct fix

The fix is minimal, self-contained, and the correct argument order is
unambiguous from the API documentation.

## 5. USER IMPACT

- **Affected users:** GFS2 users (enterprise/cluster environments)
- **Trigger conditions:** Mount and filesystem thaw operations
- **Severity:**
  - Bio leaks (memory exhaustion over time)
  - Incorrect synchronization could lead to data consistency issues
    during mount/thaw

While the maintainer notes "normally won't be noticeable," in production
cluster environments, bio leaks during repeated mount/umount cycles
could be problematic, and synchronization bugs in filesystem code are
inherently risky.

## 6. STABILITY INDICATORS

- Reported-by tag (issue was identified)
- Signed by GFS2 maintainer (Andreas Gruenbacher)
- Trivially correct fix - no ambiguity about the right solution

## 7. DEPENDENCY CHECK

This is a standalone fix with no dependencies. The `bio_chain()` API is
stable and has existed for years.

## CONCLUSION

**Meets stable criteria:**
- ✅ Obviously correct - clear API misuse with documented correct usage
- ✅ Fixes real bug - bio leaks and incorrect synchronization
- ✅ Small and contained - single one-line change
- ✅ No new features
- ✅ Risk is minimal

**Minor concerns:**
- No explicit `Cc: stable@vger.kernel.org` tag (maintainer didn't
  request backport)
- No `Fixes:` tag identifying affected versions
- Impact described as "normally won't be noticeable"

Despite the lack of explicit stable tags, this is a clear bug fix to
filesystem code. Bio leaks and synchronization issues in filesystem
operations are exactly the type of bugs stable trees should fix. The
change is trivial, obviously correct, and carries essentially zero risk
of regression.

**YES**

 fs/gfs2/lops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 9c8c305a75c46..914d03f6c4e82 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -487,7 +487,7 @@ static struct bio *gfs2_chain_bio(struct bio *prev, unsigned int nr_iovecs)
 	new = bio_alloc(prev->bi_bdev, nr_iovecs, prev->bi_opf, GFP_NOIO);
 	bio_clone_blkg_association(new, prev);
 	new->bi_iter.bi_sector = bio_end_sector(prev);
-	bio_chain(new, prev);
+	bio_chain(prev, new);
 	submit_bio(prev);
 	return new;
 }
-- 
2.51.0

