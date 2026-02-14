Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE2121CFEF;
	Sat, 14 Feb 2026 01:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031171; cv=none; b=YibQxT8FsXwxrtZTnUrb3K7OrZNs/t+Uzjrb7HSKD1w7cQprkYT+zfXhpxCR5TYmBK5abP0dLU/0Pi557+VMpeTnVaKsDd6mGS8cYBZuNM5YIfew/DBTGur3dUrG1btyF5FGkqY2hIYLOnSKel6G0kwLFWMoy+DxIae9pWsWuRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031171; c=relaxed/simple;
	bh=smfSuVs2WQG0qqAAjLH2JNAXM9pb/6C+MBprENgB1to=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rbRx2/eCR78vx9iKwGKU8tAIKF3jE/+icqEFCxQAVD253xJGhgz5fr+0/CQE7uuMw9iYb9iwCXXTFI6NHpppoM9Dn2g0SGtgssNJwwqE7SXhB+y/4cFE9uAFyTtXhp5+tChQ6Y8PMmVIvWr2eXRC96BIx59KINkq55dqUCnXCNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uFlnFvpm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uFlnFvpm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFAB9C19423;
	Sat, 14 Feb 2026 01:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031171;
	bh=smfSuVs2WQG0qqAAjLH2JNAXM9pb/6C+MBprENgB1to=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uFlnFvpmLgAlSH2B9rvdjIkeJTVkt76I3V3PIA9zHUgIXwBIJ8c76OIZKwi6uJQUS
	 Hf37fpaOh2wypKdIyTFcuokf6ZtXWZ7myBrjO7B/ZReuWeoQaRUV5dDQGn8UO3dV1t
	 fhf98zAAvcuO6eOZhAlcIo/CgtdUk7BOR/WkTh/L1Re2Zdiui/zm9GHl2ubZHoS2li
	 ZtoAUxadksPx8bV/IXOycKaNBzG4KnRGsVlXNGFKNxLUra8fQwgsHJgzjGAui53D5m
	 O7/jlz2MfHYhEyBtLznJw6v4e2TxEVkma4tYR5AYD/NHjL3LJmmNsKpAtwGKS0ZKAD
	 tp5pX/3nUF2ug==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Felix Gu <gu_0233@qq.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>,
	linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] hwmon: (emc2305) Fix a resource leak in emc2305_of_parse_pwm_child
Date: Fri, 13 Feb 2026 19:59:28 -0500
Message-ID: <20260214010245.3671907-88-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
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

From: Felix Gu <gu_0233@qq.com>

[ Upstream commit 2954ce672b7623478c1cfeb69e6a6e4042a3656e ]

When calling of_parse_phandle_with_args(), the caller is responsible
to call of_node_put() to release the reference of device node.
In emc2305_of_parse_pwm_child, it does not release the reference,
causing a resource leak.

Signed-off-by: Felix Gu <gu_0233@qq.com>
Link: https://lore.kernel.org/r/tencent_738BA80BBF28F3440301EEE6F9E470165105@qq.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Looking at the full function:

1. **Line 551**: `of_parse_phandle_with_args()` is called, which sets
   `args.np` to a device node with an incremented refcount.
2. **Line 553-554**: If `ret` is non-zero, we return early - but
   `args.np` is not set in the error case (the function failed), so no
   leak there.
3. **Line 581** (before patch): `return 0;` without calling
   `of_node_put(args.np)` - this is the leak.
4. **Line 581** (after patch): `of_node_put(args.np);` is added before
   `return 0;`.

The fix is correct. There's only one successful return path after
`of_parse_phandle_with_args()`, and that's the `return 0;` at the end.
The error return at line 554 doesn't need `of_node_put()` because
`of_parse_phandle_with_args()` failed and didn't set `args.np`.

### Classification

This is a **resource leak fix** — a missing `of_node_put()` call. This
is one of the most common types of stable backport fixes (reference
counting bugs). The device tree node reference count will never be
decremented, preventing the node from being freed.

### Scope and Risk Assessment

- **Size**: Single line addition — minimal.
- **Risk**: Essentially zero. `of_node_put()` is a standard, well-tested
  kernel API. Calling it on the `args.np` returned by
  `of_parse_phandle_with_args()` is the correct and expected pattern.
  This cannot introduce a regression.
- **Files affected**: 1 file, 1 line.

### User Impact

The emc2305 is a fan controller chip used in embedded systems. This leak
occurs every time the device tree parsing runs for each PWM child node.
While a single leaked reference is small, on systems with hot-plugging
or repeated probe/remove cycles, it accumulates. More importantly, this
is a correctness issue — violating the OF API contract.

### Stability Indicators

- The fix follows a well-established kernel pattern (of_node_put after
  of_parse_phandle_with_args).
- It was reviewed and accepted by the hwmon maintainer Guenter Roeck.
- It's a textbook one-line reference counting fix.

### Dependency Check

No dependencies. The `of_node_put()` API and the emc2305 driver have
been in the kernel for a long time.

### Conclusion

This is a textbook stable backport candidate:
- Fixes a real bug (device tree node reference leak)
- Obviously correct (standard kernel pattern)
- Minimal scope (one line)
- Zero regression risk
- No new features or API changes

**YES**

 drivers/hwmon/emc2305.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/emc2305.c b/drivers/hwmon/emc2305.c
index ceae96c07ac45..67e82021da210 100644
--- a/drivers/hwmon/emc2305.c
+++ b/drivers/hwmon/emc2305.c
@@ -578,6 +578,7 @@ static int emc2305_of_parse_pwm_child(struct device *dev,
 		data->pwm_output_mask |= EMC2305_OPEN_DRAIN << ch;
 	}
 
+	of_node_put(args.np);
 	return 0;
 }
 
-- 
2.51.0

