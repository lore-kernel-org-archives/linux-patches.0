Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68E72571B0;
	Tue, 10 Feb 2026 23:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770766303; cv=none; b=UjBx6SNKinmTSJnsQc4XvwVztHHujCMp1KcvinzK4Bvz9cGnvCWQ8+531un+zcdtrMa2DwLwfYyqEs3tKvkWPn5IyL+aKTgc7Tn1bk4gfg736xErWpU28cL5XQmWnRM/cN0DgTbr4NTOf0dVRORZZ7b41HYPtOf48NTgu0f5XVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770766303; c=relaxed/simple;
	bh=y1A6qQyJvwgmdfji+xA9xyMlq+d3I74jPNVsjhZYWqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pwuAOxlwCvOGkuRzwns/FvZJRY8R2CH9HIVxAKg05ur078SkbY6kRjkTAMS5qtpmrTT6moscVO5eVLt55yDj48j9ru8oTZzI/HpyKxqp5DB5R+By0PTfsq7TqM0M9q6NcDJzgWNe6fMysHCRRCAEHelxwBq1xyq0umBaWEBkrGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QmSo6aga; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QmSo6aga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E87C116C6;
	Tue, 10 Feb 2026 23:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770766303;
	bh=y1A6qQyJvwgmdfji+xA9xyMlq+d3I74jPNVsjhZYWqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QmSo6agaIackdqPmXH6xx4prAbJ1wbUmE/OdOgXzjOc1CpWp4fyMo2zg6qNe5SNvj
	 DzZwGZGOfRe+8NRt/7a1O2YxiyBuJjYrFAKd9fd7yN6/+J8L1OsZdN95q2yi2JzJz/
	 1sN499WG634DeElOtcliPTphao/UZQEF/EVfnmiuTGjm+mtkO+ca+IXig1zIkd9VJH
	 15lCmfA1NU8fKuCoVtYL2bLLwxceP5qF2JbIO92rkRQsqFmgXwyrG1R5FF9myUKviU
	 VP9d+2yWwsub3F4a5ykz3mXRMM+OVckYTnGoRXZvmYhPFjPOSXpUEEOCX2Gj8EZhYV
	 bqVd62GqLHRgw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ezrak1e <ezrakiez@gmail.com>,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	gfs2@lists.linux.dev
Subject: [PATCH AUTOSEL 6.19-6.12] dlm: validate length in dlm_search_rsb_tree
Date: Tue, 10 Feb 2026 18:30:57 -0500
Message-ID: <20260210233123.2905307-12-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260210233123.2905307-1-sashal@kernel.org>
References: <20260210233123.2905307-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ezrak1e <ezrakiez@gmail.com>

[ Upstream commit 080e5563f878c64e697b89e7439d730d0daad882 ]

The len parameter in dlm_dump_rsb_name() is not validated and comes
from network messages. When it exceeds DLM_RESNAME_MAXLEN, it can
cause out-of-bounds write in dlm_search_rsb_tree().

Add length validation to prevent potential buffer overflow.

Signed-off-by: Ezrak1e <ezrakiez@gmail.com>
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Indeed, `dlm_copy_master_names` calls `find_rsb_root` with `inlen` that
comes from network data (`receive_rcom_names` →
`dlm_copy_master_names`). `inlen` is derived from
`rc_in->rc_header.h_length - sizeof(struct dlm_rcom)` with no bounds
check. And `find_rsb_root` doesn't validate it before passing to
`dlm_search_rsb_tree`.

So there are **at least two** unvalidated network-
to-`dlm_search_rsb_tree` paths:
1. `receive_rcom_lookup` → `dlm_dump_rsb_name` → `dlm_search_rsb_tree`
   (debug dump path)
2. `receive_rcom_names` → `dlm_copy_master_names` → `find_rsb_root` →
   `dlm_search_rsb_tree`

Both can pass `len > DLM_RESNAME_MAXLEN` (64), causing `memcpy(key,
name, len)` to overflow the stack buffer `key[DLM_RESNAME_MAXLEN]`.

Now let me verify what `DLM_RESNAME_MAXLEN` is:

The value is 64 (from `include/uapi/linux/dlmconstants.h`). The stack
buffer `key` is 64 bytes. If `len` > 64, `memcpy(key, name, len)` writes
beyond the buffer — a classic **stack buffer overflow**.

This is exploitable from a malicious DLM cluster node sending a crafted
network message.

## Detailed Analysis

### 1. COMMIT MESSAGE ANALYSIS

The commit message clearly states:
- The `len` parameter comes from **network messages** (untrusted input)
- When `len` exceeds `DLM_RESNAME_MAXLEN` (64), it causes an **out-of-
  bounds write** in `dlm_search_rsb_tree()`
- The fix adds length validation to prevent the buffer overflow

### 2. CODE CHANGE ANALYSIS

The change is extremely small and surgical — just 2 lines added:

```625:636:fs/dlm/lock.c
int dlm_search_rsb_tree(struct rhashtable *rhash, const void *name, int
len,
                        struct dlm_rsb **r_ret)
{
        char key[DLM_RESNAME_MAXLEN] = {};
        // NEW: if (len > DLM_RESNAME_MAXLEN) return -EINVAL;
        memcpy(key, name, len);
        // ...
}
```

Without the check, `memcpy(key, name, len)` with `len > 64` writes past
the end of the 64-byte stack buffer `key`. This is a **stack buffer
overflow** — one of the most dangerous vulnerability classes in C.

### 3. VULNERABLE CODE PATHS

I traced all 6 callers of `dlm_search_rsb_tree`:

| Caller | Validates `len`? | Network-reachable? |
|--------|------------------|--------------------|
| `find_rsb_dir` | YES (via `find_rsb` at line 1089) | Yes |
| `find_rsb_nodir` | YES (via `find_rsb` at line 1089) | Yes |
| `_dlm_master_lookup` | YES (line 1268) | Yes |
| `receive_remove` | YES (line 4300) | Yes |
| **`dlm_dump_rsb_name`** | **NO** | **Yes** (via `receive_rcom_lookup`)
|
| **`find_rsb_root`** | **NO** | **Yes** (via `receive_rcom_names` →
`dlm_copy_master_names`) |

Two callers do NOT validate `len` before calling `dlm_search_rsb_tree`,
and both are reachable from network messages:

1. **`receive_rcom_lookup`** (rcom.c:379): When `rc_in->rc_id ==
   0xFFFFFFFF`, it calls `dlm_dump_rsb_name(ls, rc_in->rc_buf, len)`
   where `len` is derived from `rc_in->rc_header.h_length` (a network-
   supplied 16-bit field). No bounds check.

2. **`receive_rcom_names`** (rcom.c:336): Calculates `inlen` from
   `rc_in->rc_header.h_length - sizeof(struct dlm_rcom)` and passes it
   directly to `dlm_copy_master_names` → `find_rsb_root` →
   `dlm_search_rsb_tree`. No bounds check.

### 4. BUG SEVERITY

This is a **stack buffer overflow triggered by network input** in the
DLM (Distributed Lock Manager) subsystem:

- **Type**: Out-of-bounds write (stack buffer overflow)
- **Attack vector**: Network (DLM cluster communication protocol)
- **Trigger**: A malicious or buggy DLM cluster node sending a message
  with `h_length` large enough to make the extracted `len` exceed 64
- **Impact**: Stack corruption, potential code execution, kernel
  crash/panic
- **DLM context**: DLM is used in cluster filesystems like GFS2 and
  OCFS2, which are used in production enterprise environments

While the attack surface requires being part of a DLM cluster (not
publicly internet-reachable in most deployments), this is still a
serious security bug. In shared hosting or cloud environments, cluster
node compromise could lead to kernel-level exploitation of other cluster
members.

### 5. FIX QUALITY

The fix is **defense-in-depth at the right layer**:
- Rather than fixing each individual caller, it adds the validation in
  `dlm_search_rsb_tree` itself
- This protects against any future caller that might forget to validate
- The fix returns `-EINVAL`, which all callers handle (they all check
  the return value)
- It's only 2 lines, extremely low risk of regression
- The pattern is identical to the existing checks in
  `_dlm_master_lookup` (line 1268) and `receive_remove` (line 4300)

### 6. SCOPE AND RISK

- **Lines changed**: 2 (added `if` check and return)
- **Files changed**: 1 (`fs/dlm/lock.c`)
- **Risk of regression**: Extremely low — it adds a bounds check that
  was already present in 4 of 6 callers
- **Subsystem**: DLM (mature, production-critical for cluster
  filesystems)

### 7. APPLICABILITY TO STABLE

- The function `dlm_search_rsb_tree` was introduced in commit
  `5be323b0c64db` ("dlm: move dlm_search_rsb_tree() out of lock") from
  August 2024, which was merged in 6.12
- Older kernels may have equivalent vulnerable code but with different
  structure
- For 6.12+ stable trees, the fix should apply cleanly

### 8. STABLE CRITERIA CHECK

- Obviously correct and tested: YES (trivial bounds check, accepted by
  DLM maintainers Alexander Aring and David Teigland)
- Fixes a real bug: YES (stack buffer overflow from network input)
- Fixes an important issue: YES (security vulnerability — buffer
  overflow exploitable from network)
- Small and contained: YES (2 lines in 1 file)
- No new features or APIs: YES (pure bug fix)

**YES**

 fs/dlm/lock.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index c01a291db401b..a393ecaf3442a 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -626,7 +626,8 @@ int dlm_search_rsb_tree(struct rhashtable *rhash, const void *name, int len,
 			struct dlm_rsb **r_ret)
 {
 	char key[DLM_RESNAME_MAXLEN] = {};
-
+	if (len > DLM_RESNAME_MAXLEN)
+		return -EINVAL;
 	memcpy(key, name, len);
 	*r_ret = rhashtable_lookup_fast(rhash, &key, dlm_rhash_rsb_params);
 	if (*r_ret)
-- 
2.51.0

