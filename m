Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B7A3DB30C;
	Wed, 20 May 2026 11:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779276003; cv=none; b=WH+OL1TeQStfBHxhkbEgswXXPnPnj1Za2OnFAdhnRRjw7NmXyvbcPG5EtSLkKIfZ6m5XIYdjuFMs8yuOOUwIlsg9zNLkqxH6BYTttRqqAE1hiwd0wHQwmM3VRE6Wh6FBbGbqwFU0AwmMXcgPn4AUHjjCxhIod1MsdsoQp7rPnd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779276003; c=relaxed/simple;
	bh=FGukKdgFPhHzSAS8RwJibFc+fvdUkJPLV+tnRWEFNCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ga7i3st0j97WPCHvcKSzdUKSIRZcLEHDfZ/AJOs0FJH0WtVGKRraeg5/nEMPnNPkjB8ruJlsPwmckzzsrvG3+Z1IkteeT1v2Wo77oNrKaH8Od+PdaGEhsgxFDa3FRrSMgXo4Trlytkd+/IPjd296BcQja7/msXsTypJ+8KjB9RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ctVQp/BI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ctVQp/BI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C931F00893;
	Wed, 20 May 2026 11:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779276000;
	bh=XdeT9YGV4NlOVm6Fnc29e0/uchwsmKB8HLwH6visN2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ctVQp/BIyIWup29+OInxO+nTzrin8GXNFAg6PONhuLHJnIPWfL3/JFzPDb647jNmt
	 ifDE+h7tAEibIcZ7ihhHvVLdrm5uHcuLJTOSwcj5d95ZxEaMl0om9x2JYgEoptSKFO
	 ye8qiWtnTJ+KTFdm/JpillBiif/5IQK9Cm/4A0Fsn4a2nMlnVePZ8rgNvVSb4cX+y4
	 yCittWGez49ujR+xyhUrLMzHFrUqI+4dAy7ywKXXlS3O8XZWAJp97RkAPzHbeYyRrD
	 5Peh2cD3uDEd23HeQHMZoU9bZMIX6bydZCfSFp9XKvJhMdVuKy0/ftmZrlaP3LaxKv
	 M5bisLPzXswpg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	amarkuze@redhat.com,
	slava@dubeyko.com,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] libceph: Fix unnecessarily high ceph_decode_need() for uniform bucket
Date: Wed, 20 May 2026 07:18:43 -0400
Message-ID: <20260520111944.3424570-11-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260520111944.3424570-1-sashal@kernel.org>
References: <20260520111944.3424570-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>

[ Upstream commit 596f91294b351866956808b1ecb8dfae15382a6d ]

In crush_decode_uniform_bucket(), the item_weight field of the bucket
is set. This is a single field of type u32 since the uniform bucket uses
the same weight for all items. The value in ceph_decode_need() is set to
(1+b->h.size) * sizeof(u32), which is higher than actually needed.

This patch removes the call to ceph_decode_need() with the unnecessarily
high value and switches the subsequent operation from ceph_decode_32()
to ceph_decode_32_safe(), which already includes the correct bounds
check.

Signed-off-by: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics
Record 1.1: Subsystem `libceph`/`net/ceph`; action verb `Fix`; intent:
correct an overlarge bounds check in `crush_decode_uniform_bucket()`.

Record 1.2: Tags: `Signed-off-by: Raphael Zimmer`, `Reviewed-by: Ilya
Dryomov`, `Signed-off-by: Ilya Dryomov`. No `Fixes:`, `Reported-by:`,
`Tested-by:`, `Link:`, or `Cc: stable` tag in this commit.

Record 1.3: The body says uniform buckets have one `u32 item_weight`,
but the old check required `(1 + b->h.size) * sizeof(u32)`. Symptom
implied by code is false `-EINVAL` during CRUSH map decode when only the
real uniform payload is present. No version info or reporter in the
message.

Record 1.4: Hidden bug fix: yes. It is not cleanup only; it changes a
bounds check from a size-dependent false requirement to the actual
single-field requirement.

## Phase 2: Diff Analysis
Record 2.1: One file, `net/ceph/osdmap.c`, 1 insertion and 2 deletions.
Modified function: `crush_decode_uniform_bucket()`. Scope: single-
function surgical fix.

Record 2.2: Before: checked for `1 + b->h.size` `u32`s, then consumed
one `u32`. After: `ceph_decode_32_safe()` checks and consumes exactly
one `u32`. This affects CRUSH uniform-bucket decode.

Record 2.3: Bug category: logic/correctness and bounds-check bug.
Mechanism: an over-strict buffer check can reject a CRUSH map even
though the following decode only needs `sizeof(u32)`.

Record 2.4: Fix quality: obviously correct from `struct
crush_bucket_uniform`, which contains only `item_weight` after the
common bucket header. Regression risk is very low because the
replacement macro performs the same safe bounds check for the one value
actually read.

## Phase 3: Git History
Record 3.1: `git blame` shows the overlarge check dates to
`f24e9980eb860d` (`ceph: OSD client`), first contained in `v2.6.34`. The
assignment line was later touched by `c89136ea4253c7`, but the wrong
size expression was already present.

Record 3.2: No `Fixes:` tag, so there was no tagged introducing commit
to follow.

Record 3.3: Recent related file history shows adjacent CRUSH decode
hardening, especially `6a782b546337a` (`libceph: Fix potential out-of-
bounds access in crush_decode()`), followed by this patch. This patch’s
hunk is standalone.

Record 3.4: Author Raphael Zimmer has several recent libceph hardening
fixes. Ilya Dryomov is listed in `MAINTAINERS` as a libceph maintainer
and reviewed/committed this patch.

Record 3.5: No functional dependency found for this exact hunk. `git
apply --check` succeeds on the current checkout.

## Phase 4: Mailing List And External Research
Record 4.1: `b4 dig -c 29e2da9499784` found the original submission:
`https://patch.msgid.link/20260424133737.921463-1-raphael.zimmer@tu-
ilmenau.de`. `b4 dig -a` found only v1. The saved mbox shows Ilya
replied “Applied.” No objections or NAKs found.

Record 4.2: `b4 dig -w` shows Raphael Zimmer, Ilya Dryomov, Alex
Markuze, Viacheslav Dubeyko, and `ceph-devel@vger.kernel.org` were
included. `MAINTAINERS` confirms these are the libceph maintainers/list.

Record 4.3: No `Reported-by` or `Link` in this commit. I found Ceph
tracker bug #75829 for adjacent CRUSH decode out-of-bounds work, but it
directly matches `6a782b...`, not this exact overlarge-check patch, so I
did not use it as primary evidence.

Record 4.4: Related patch context is the adjacent `6a782b...` CRUSH
decode safety fix. This patch is not part of a multi-patch series
according to `b4 dig -a`.

Record 4.5: Web lore fetching was blocked by Anubis, but `b4` retrieved
the thread. Web search did not find stable-specific discussion for this
exact subject/hash.

## Phase 5: Code Semantic Analysis
Record 5.1: Modified function: `crush_decode_uniform_bucket()`.

Record 5.2: Caller path verified: `mon_dispatch()` handles
`CEPH_MSG_OSD_MAP` -> `ceph_osdc_handle_map()` -> `handle_one_map()` ->
`ceph_osdmap_decode()` or incremental decode -> `crush_decode()` ->
`crush_decode_uniform_bucket()`.

Record 5.3: Key callees: `ceph_decode_32_safe()` expands to
`ceph_decode_need(..., sizeof(u32), ...)` plus `ceph_decode_32()`.
Failure returns `-EINVAL`, then `crush_decode()` destroys the partial
map and returns `ERR_PTR(err)`.

Record 5.4: Reachability: this is reached from received Ceph monitor OSD
map messages, not a local syscall path. Affected users are Ceph clients
receiving CRUSH maps with uniform buckets.

Record 5.5: Similar patterns: list/straw/straw2 bucket decoders
correctly check size-dependent arrays because they actually decode
arrays. Uniform bucket is the outlier because its bucket-specific data
is one scalar.

## Phase 6: Stable Tree Analysis
Record 6.1: Checked `v5.10`, `v5.15`, `v6.1`, `v6.6`, `v6.12`, `v6.18`,
`v6.19`, and `v7.0`; all contain the old overlarge check.

Record 6.2: Backport difficulty: expected clean or trivial. The exact
target lines are present across checked stable tags/pending branches,
and `git apply --check` succeeds on the current checkout.

Record 6.3: No different fix for this exact uniform-bucket overcheck
found in the checked history before `29e2da9499784`.

## Phase 7: Subsystem Context
Record 7.1: Subsystem: libceph common code, CRUSH/OSD map decoding.
Criticality: important for Ceph users, not universal to all Linux users.

Record 7.2: Subsystem activity: active, with recent libceph decode and
message-processing hardening commits from Raphael Zimmer and Ilya
Dryomov.

## Phase 8: Impact And Risk
Record 8.1: Affected population: Ceph kernel clients using CRUSH maps
with uniform buckets.

Record 8.2: Trigger: receiving a CRUSH map where a uniform bucket’s
`b->h.size` makes the old false requirement exceed the remaining buffer
even though the one actual `item_weight` field is available. Not
verified as unprivileged-user-triggerable.

Record 8.3: Failure mode: false `-EINVAL` in CRUSH/OSD map decode,
leading `ceph_osdc_handle_map()` to report a corrupt map message and
skip the update. Severity: high for affected Ceph clients because OSD
map decode failure can disrupt storage access.

Record 8.4: Benefit: medium-high for Ceph client reliability. Risk: very
low, because the patch narrows a bounds check to the exact field
consumed and introduces no API or behavioral feature.

## Phase 9: Final Synthesis
Record 9.1: Evidence for backporting: real decode correctness bug;
ancient code present in all checked stable trees; affects storage client
map updates; one-line surgical fix; maintainer reviewed; clean apply.
Evidence against: no reporter, no test tag, no direct crash/data-
corruption proof for this exact patch. Unresolved: no external stable-
list discussion found due lore web blocking; no live Ceph reproducer
run.

Record 9.2: Stable rules: obviously correct: yes; fixes a real bug: yes,
over-strict valid-buffer rejection; important: yes for affected Ceph
clients because OSD map updates are core storage functionality;
small/contained: yes, 1-line functional change; no new APIs/features:
yes; applies to stable: yes/trivial based on checked code.

Record 9.3: Exception category: none. This is a normal bug fix, not a
device ID, quirk, DT, build, or documentation exception.

Record 9.4: Decision: backport. The benefit outweighs the tiny risk.

## Verification
- Phase 1: Parsed `git show --format=fuller 29e2da9499784`; confirmed
  subject, tags, author, reviewer, committer, and absence of
  reporter/link/fixes tags.
- Phase 2: Inspected the full diff; confirmed only
  `crush_decode_uniform_bucket()` changes from overlarge
  `ceph_decode_need()` plus raw decode to `ceph_decode_32_safe()`.
- Phase 3: Ran `git blame` on the affected lines; found
  `f24e9980eb860d`, first in `v2.6.34`. Checked related history and
  author history.
- Phase 4: Ran `b4 dig -c`, `-a`, `-w`, and saved/read the mbox; found
  v1 submission and maintainer “Applied” reply.
- Phase 5: Traced callers with source searches and file reads through
  monitor OSD map handling to CRUSH decode.
- Phase 6: Checked stable tags/pending branches for the exact old code
  and ran `git apply --check`.
- Phase 7: Checked `MAINTAINERS`; confirmed libceph maintainers and
  supported status.
- Phase 8: Verified failure path returns `-EINVAL`, destroys partial
  CRUSH map, and causes `ceph_osdc_handle_map()` to log corrupt message
  handling.
- UNVERIFIED: No runtime reproducer was executed; no direct user report
  was found for this exact patch.

**YES**

 net/ceph/osdmap.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
index c89e66d4fcb7f..753a2ed31e5bf 100644
--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -72,8 +72,7 @@ static int crush_decode_uniform_bucket(void **p, void *end,
 				       struct crush_bucket_uniform *b)
 {
 	dout("crush_decode_uniform_bucket %p to %p\n", *p, end);
-	ceph_decode_need(p, end, (1+b->h.size) * sizeof(u32), bad);
-	b->item_weight = ceph_decode_32(p);
+	ceph_decode_32_safe(p, end, b->item_weight, bad);
 	return 0;
 bad:
 	return -EINVAL;
-- 
2.53.0

