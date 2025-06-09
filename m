Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33FF625B1F4;
	Mon,  9 Jun 2025 13:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749476750; cv=none; b=drUMFa6Nl/ggaaJoij+vYkFBIgUnnor79DPAozvvWkyRksbjgJJ7etSsJd1LGebnUaxg+grYbMd3M36UCUm1PuJOrVprRqhH1ui4Jljlc3K0MIcjkGoWQLX3E/zEYtryaSnGHhnF8XY49PzUlXVS2SW58vbAzC6uehlbLDTbbr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749476750; c=relaxed/simple;
	bh=HjridAooayUFqN9fuzoMMCf1Aa8GkQiQtC9/KaMxQQY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jd8KFhG1xFkqiAlV9tBZztIzE8sw2Xu2yby5Xa8NVsqCYq8DCNKJtWdPUS8hKhDUIx91udk/uxlnZOz/AewQ11whPw+Yytljec/pv9w6IVpuhV+3QNpp8Jyj69J7UdY9Tgvi+1Uim88tVHuDIrAvz92EwBcuzkTefMeTsjYBrbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TSe0Ts1i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TSe0Ts1i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53748C4CEED;
	Mon,  9 Jun 2025 13:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749476750;
	bh=HjridAooayUFqN9fuzoMMCf1Aa8GkQiQtC9/KaMxQQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TSe0Ts1iVxcQzioWS/CEajfu2AuVD8ZVkXVgF5OLvfXnu8+elbk2xfZG0KRBRkvDr
	 ZpL+kDQZZmddnb34Z7CWUqbiuaG/dN4Ght35iT+TKZxP5u683jcaaQDacIZEuNY9Mz
	 5SijxH7gkzv91tmETjsy0F2XMawwin0HaHyDwRTQhdPxB1LgybSQSXGeuJaa5hj/hJ
	 YocHvQ6dB3Jivt5sHJpWy9FZjWShvLQizdIWGuh/01iMjIURgt5HFSEf5T25E8yRdD
	 yoP6DV39tKjXmNIM/VeGI3FIdf6WOJmhzdnkG9zcgQcZx+XbK1+ZXt3fNzSIqTDj6E
	 DwuK0EMEyeUhg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chen Yufeng <chenyufeng@iie.ac.cn>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Thinh.Nguyen@synopsys.com
Subject: [PATCH AUTOSEL 6.14 20/29] usb: potential integer overflow in usbg_make_tpg()
Date: Mon,  9 Jun 2025 09:45:01 -0400
Message-Id: <20250609134511.1342999-20-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250609134511.1342999-1-sashal@kernel.org>
References: <20250609134511.1342999-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.10
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chen Yufeng <chenyufeng@iie.ac.cn>

[ Upstream commit 153874010354d050f62f8ae25cbb960c17633dc5 ]

The variable tpgt in usbg_make_tpg() is defined as unsigned long and is
assigned to tpgt->tport_tpgt, which is defined as u16. This may cause an
integer overflow when tpgt is greater than USHRT_MAX (65535). I
haven't tried to trigger it myself, but it is possible to trigger it
by calling usbg_make_tpg() with a large value for tpgt.

I modified the type of tpgt to match tpgt->tport_tpgt and adjusted the
relevant code accordingly.

This patch is similar to commit 59c816c1f24d ("vhost/scsi: potential
memory corruption").

Signed-off-by: Chen Yufeng <chenyufeng@iie.ac.cn>
Link: https://lore.kernel.org/r/20250415065857.1619-1-chenyufeng@iie.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Based on my comprehensive analysis, here's my decision:

**YES**

This commit should be backported to stable kernel trees for the
following reasons:

## Analysis of the Integer Overflow Bug

**1. Clear Security/Correctness Issue:**
The bug is a classic integer overflow vulnerability where a user-
controlled value (`tpgt`) parsed from a string via `kstrtoul()` as an
`unsigned long` gets truncated when assigned to a `u16` field
(`tpg->tport_tpgt`).

In the original code at line 1690:
```c
unsigned long tpgt;  // Can hold values up to ULONG_MAX
// ... kstrtoul(name + 5, 0, &tpgt) ...
tpg->tport_tpgt = tpgt;  // u16 field - truncation occurs!
```

If a user provides a value like `tpgt_70000`, the parsing succeeds
(70000 < UINT_MAX), but when assigned to the 16-bit field, it becomes
`70000 & 0xFFFF = 4464`, completely changing the intended value.

**2. Matches Stable Backport Criteria:**
- **Important Bug Fix**: Yes - prevents integer overflow and data
  corruption
- **Small, Contained Change**: Yes - only changes variable type and
  validation function
- **No Architectural Changes**: Correct - simply fixes data type
  mismatch
- **Minimal Regression Risk**: Very low risk - more restrictive
  validation
- **Confined to Subsystem**: Yes - only affects USB gadget target mode

**3. Historical Precedent:**
The fix directly references commit `59c816c1f24d` which was a nearly
identical fix in `drivers/vhost/scsi.c` that was backported to stable
trees. That commit fixed the exact same pattern:
- `unsigned long tpgt` → `u16 tpgt`
- `kstrtoul() || tpgt > UINT_MAX` → `kstrtou16()`
- Assignment to `u16 tport_tpgt` field

**4. Real Impact:**
While this requires privileged access to trigger (configfs
manipulation), the integer overflow could lead to:
- Unexpected behavior in target portal group handling
- Potential confusion in multi-target setups
- Data integrity issues in storage target configuration

**5. Code Quality:**
The fix properly aligns the variable type with its intended use and
makes the validation more precise by using `kstrtou16()` instead of the
broader `kstrtoul()` check.

This fix exemplifies the type of integer overflow prevention that stable
trees actively accept - targeted, low-risk corrections that prevent
subtle but potentially serious bugs from affecting users.

 drivers/usb/gadget/function/f_tcm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 5a2e1237f85c3..6e8804f04baa7 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1641,14 +1641,14 @@ static struct se_portal_group *usbg_make_tpg(struct se_wwn *wwn,
 	struct usbg_tport *tport = container_of(wwn, struct usbg_tport,
 			tport_wwn);
 	struct usbg_tpg *tpg;
-	unsigned long tpgt;
+	u16 tpgt;
 	int ret;
 	struct f_tcm_opts *opts;
 	unsigned i;
 
 	if (strstr(name, "tpgt_") != name)
 		return ERR_PTR(-EINVAL);
-	if (kstrtoul(name + 5, 0, &tpgt) || tpgt > UINT_MAX)
+	if (kstrtou16(name + 5, 0, &tpgt))
 		return ERR_PTR(-EINVAL);
 	ret = -ENODEV;
 	mutex_lock(&tpg_instances_lock);
-- 
2.39.5

