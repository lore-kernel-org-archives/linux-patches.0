Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD31286D64;
	Fri, 12 Dec 2025 02:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765505356; cv=none; b=pfF4twE89Gp57AJgVERKYkXGMi67QVAcmhS7B+hmo99TH9/+lCWnmevm7FTBmXB6vMSNpzAIlvunSWjcEg2DwfK14lkNi1rj8eORZh8MS5K53eVMcUwu5pzxJ8GsTWDcNX0dRg/U2XGKuzuW2uEmxD6uuiBQjjL3/Q35hFz0ZDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765505356; c=relaxed/simple;
	bh=z4MspZqRvGzpBRzvUPz4xOgqwSvyivGgFgRcTxqDEGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QDPFKaqutXLnr5qS7ysJsXYxa2hDmo6il4TZJrsweyRNYTOGViudA3FP4NivkjwdahnI8XISZ+YdBkyz4pkHOr7Nk3MSvyp3ZO0r6U+9COUnDbzXXstoKWf6cFvd0mgzI6mo7MTWMyt6FOCUUI1ylgRcToQnACHTyc0wjbEYbPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RLJM5eD2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RLJM5eD2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6884FC113D0;
	Fri, 12 Dec 2025 02:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765505356;
	bh=z4MspZqRvGzpBRzvUPz4xOgqwSvyivGgFgRcTxqDEGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RLJM5eD2DHGyJ/EfzeuotB6JK0GwweZC6Z2HDC15g/SD85gRQXbNbPYJMtcHlp7/A
	 Qj7PmnElfTSxuL/bYTwPS9p7vNGA93VInF+aJrinRLkTRpk49YYmqRuQISzlIqSfhv
	 UD3a7+j/6JTvaQbktTLJXbMUnLNmk9auVskUohhZ0K9Z+2/oUONHnTew8Ta2cZta9R
	 /ZqRJMmuGZBRhcGOX5n4Lxhh2M4fI3pkW6wfej2pgPENBXAM+xGtpUSP3TXtmV6ynz
	 M53NGaBvbS3jW93/zsWBa7+PyqVs7mAZrsrh/TsGb0JhhuiZdo883Hu+qCuFI3GMPM
	 meGbfn2rXa3gg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pei Xiao <xiaopei01@kylinos.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>,
	linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.17] hwmon: (emc2305) fix device node refcount leak in error path
Date: Thu, 11 Dec 2025 21:08:57 -0500
Message-ID: <20251212020903.4153935-5-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251212020903.4153935-1-sashal@kernel.org>
References: <20251212020903.4153935-1-sashal@kernel.org>
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

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit 4910da6b36b122db50a27fabf6ab7f8611b60bf8 ]

The for_each_child_of_node() macro automatically manages device node
reference counts during normal iteration. However, when breaking out
of the loop early with return, the current iteration's node is not
automatically released, leading to a reference count leak.

Fix this by adding of_node_put(child) before returning from the loop
when emc2305_set_single_tz() fails.

This issue could lead to memory leaks over multiple probe cycles.

Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Link: https://lore.kernel.org/r/tencent_5CDC08544C901D5ECA270573D5AEE3117108@qq.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of Commit: hwmon: (emc2305) fix device node refcount leak in
error path

### 1. COMMIT MESSAGE ANALYSIS

**Subject:** Clear "fix" language indicates a bug fix targeting a
"refcount leak" in an "error path"

**Body explanation:**
- The `for_each_child_of_node()` macro manages device node reference
  counts internally
- When breaking out of the loop early with `return`, the current node's
  reference is NOT automatically released
- This causes a reference count leak leading to memory leaks over
  multiple probe cycles

**Tags present:**
- `Signed-off-by` from author and maintainer (Guenter Roeck)
- `Link:` to mailing list discussion

**Tags missing:**
- No `Cc: stable@vger.kernel.org`
- No `Fixes:` tag

### 2. CODE CHANGE ANALYSIS

The fix is extremely small and surgical:

```c
for_each_child_of_node(dev->of_node, child) {
    ret = emc2305_set_single_tz(dev, child, i);
- if (ret != 0)
+   if (ret != 0) {
+       of_node_put(child);
        return ret;
+   }
    i++;
}
```

**Technical mechanism:**
- `for_each_child_of_node()` calls `of_node_get()` on each child
  internally
- On normal loop completion, the macro decrements the refcount
- On early exit (return/break), the caller must manually call
  `of_node_put()` to release the reference
- Without this, each failed probe leaves an unreleased reference →
  memory leak

**Root cause:** Missing required cleanup call when breaking out of
device tree iterator macro

**Why fix is correct:** This is the standard, well-documented pattern in
the Linux kernel for handling early exits from
`for_each_child_of_node()`. Adding `of_node_put(child)` before return is
textbook correct.

### 3. CLASSIFICATION

- **Bug type:** Resource leak (reference count / memory leak)
- **Category:** Standard bug fix
- **Security:** Not a security issue
- **New features:** None

### 4. SCOPE AND RISK ASSESSMENT

| Metric | Value |
|--------|-------|
| Lines changed | 3 (effectively +1 functional line) |
| Files touched | 1 |
| Complexity | Very low |
| Risk | Near zero |

**Risk analysis:**
- The fix only adds a cleanup call in an error path that already returns
  immediately
- Cannot possibly affect normal operation
- The `of_node_put()` function is well-tested core kernel infrastructure
- Adding required cleanup where it was missing cannot cause regression

### 5. USER IMPACT

**Affected users:** Those with EMC2305 fan controller hardware using
device tree

**Trigger conditions:**
1. Device must have child nodes in device tree
2. `emc2305_set_single_tz()` must fail
3. Must happen repeatedly over time

**Severity:** Low to medium - memory leak that accumulates over multiple
failed probe cycles. Not a crash or security issue, but can eventually
exhaust memory on long-running systems.

### 6. STABILITY INDICATORS

- Accepted by hwmon subsystem maintainer (Guenter Roeck)
- Simple, well-understood fix pattern
- No complex interactions possible

### 7. DEPENDENCY CHECK

- No dependencies on other commits
- `for_each_child_of_node()` and `of_node_put()` are long-standing
  kernel APIs
- The emc2305 driver must exist in the target stable tree

---

## Summary

**What the commit fixes:** A device node reference count leak in the
emc2305 hwmon driver that occurs when `emc2305_set_single_tz()` fails
during probe. This can lead to memory leaks over multiple probe cycles.

**Stable kernel rules assessment:**
1. ✅ **Obviously correct:** Standard kernel pattern, textbook fix
2. ✅ **Fixes real bug:** Yes, reference count leak causing memory leak
3. ⚠️ **Important issue:** Moderate severity - memory leak in error path
4. ✅ **Small and contained:** 3 lines changed in 1 file
5. ✅ **No new features:** Pure bug fix
6. ✅ **Clean application:** Should apply cleanly

**Risk vs Benefit:**
- **Risk:** Essentially zero - adds required cleanup in error path
- **Benefit:** Prevents memory leak on systems using this hardware

**Concerns:**
- No explicit `Cc: stable` tag from maintainer
- Bug requires specific error condition to trigger
- Affects only specific hardware

**Verdict:** Despite the lack of explicit stable tagging, this fix is a
textbook example of a safe backport candidate. The fix is trivially
correct, follows a well-established kernel pattern, has zero risk of
regression, and fixes a real (if low-severity) resource leak. Similar
`for_each_child_of_node()` refcount leak fixes are regularly backported
to stable trees.

**YES**

 drivers/hwmon/emc2305.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/emc2305.c b/drivers/hwmon/emc2305.c
index 60809289f8169..84cb9b72cb6c2 100644
--- a/drivers/hwmon/emc2305.c
+++ b/drivers/hwmon/emc2305.c
@@ -685,8 +685,10 @@ static int emc2305_probe(struct i2c_client *client)
 			i = 0;
 			for_each_child_of_node(dev->of_node, child) {
 				ret = emc2305_set_single_tz(dev, child, i);
-				if (ret != 0)
+				if (ret != 0) {
+					of_node_put(child);
 					return ret;
+				}
 				i++;
 			}
 		} else {
-- 
2.51.0

