Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A8217E0;
	Mon,  9 Jun 2025 13:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749476927; cv=none; b=U9cdn6IAEGs8jzxZsvvYbP1Hcb2cADVbtGI1lRg+AcX2XTavb6ozPYyhaQ89574rT8KLw77lDZFEtPDdkLGnz/gFgkPQTMRP25Bcir7ZT+0izJCPAv3fdsyXOK85uf0MEzoRWCGNd92G/wlv6S2s9jgQVNF0egO80PTDTf/dJ0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749476927; c=relaxed/simple;
	bh=JNYaGuJG98fbbsyMztoUVdQ4+6gVRaPRsoYZ7q8V9Jc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r1zzT1z66ubKBtYCzo2HTjUX/VJlEePe/ZWktdqAbAmltV+ujEz0b4VQ1CAam5YVTHZ6xQ3Z++0cOwpGDVbiQqDqZfkuVwcbSIEDrXKfALoHUbL+/5K6depZ4nOxlacINhnRqwJnJsBJMiTo3w1Z7uvpkv90wPLeMtfAHaSbtGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ADaB7yCc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ADaB7yCc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A35BAC4CEEB;
	Mon,  9 Jun 2025 13:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749476927;
	bh=JNYaGuJG98fbbsyMztoUVdQ4+6gVRaPRsoYZ7q8V9Jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ADaB7yCcNLB6RtXAE0K4VpawJ6CgnLaKHVYeqxDFTdXxkDOHfIkyIW7hx+n6fO2R2
	 1Hycinz1KMDbGoRv+DDE4bmPfdKBlu8Qhd49UR/WS81JiwAbUtTCx7RVwC5E031l0e
	 YavdYC2THuy/uk5VfhNDoU8jUD6ESEAG0BroGJU1olt/2BKIQk+OpGIdGXMcWWh7wW
	 l2eQXdtgZoZXrwB8+u85GarkjhIVOEEOYl1IR9gywytqsPmX6vLiU9IyzfUDmsKlI3
	 SL7DKDpZf3PsqmSnc233dz7DPOxOHOWhIIXeElYSNEaJ9lXOr7ZPIyjWSIrUy9drOe
	 WnWsuZ98ERQDg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chen Yufeng <chenyufeng@iie.ac.cn>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Thinh.Nguyen@synopsys.com
Subject: [PATCH AUTOSEL 5.4 3/7] usb: potential integer overflow in usbg_make_tpg()
Date: Mon,  9 Jun 2025 09:48:36 -0400
Message-Id: <20250609134840.1345797-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250609134840.1345797-1-sashal@kernel.org>
References: <20250609134840.1345797-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.294
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
index 90fe33f9e0950..48d02c5ff8491 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1320,14 +1320,14 @@ static struct se_portal_group *usbg_make_tpg(struct se_wwn *wwn,
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

