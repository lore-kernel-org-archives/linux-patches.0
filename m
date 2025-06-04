Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F5C20B804;
	Wed,  4 Jun 2025 01:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998992; cv=none; b=J1a5CGu7bWK8aLj11dQAP2N2FoTFELUbiGp3vTMcm98L6fesTh/SiWHFwawtxtKofeqFyS2GusGKlJ7Wk0YoQs+fpasBw1Qx4JrO57ees6xaqE398MOqnobni5NSHpZsz29Pv849kQAYRyIFVSpy9pfsc+/s+9O6c7A9NMSaOcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998992; c=relaxed/simple;
	bh=EGW8IG26zLd3hXax9meiv8hmZaJnDGeIZcfT+on6QBM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R/CKBYSSdJA3KKDN56L/hjI55DAWUJVPw7HsYknJAAsROeHFI/1Bh5dGVZW0eBUr6khv4FIUdaPTsBZttaoAkOly74CWyTyz23V05QLeefeH6BPnznjvpHTHjDaXA62UMtqVOaA3slDtbApqYoCnVVOyI67l/snBx+GnRJNycqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aQXeN/9x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aQXeN/9x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40C0DC4CEF1;
	Wed,  4 Jun 2025 01:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998992;
	bh=EGW8IG26zLd3hXax9meiv8hmZaJnDGeIZcfT+on6QBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aQXeN/9xkyQmEVbE3CS0l/q6eHU2Qj/XWzwC6wumNvuKOkD532/Tmi867zeyK0+eI
	 2zIi/RR3f8x3zMV3UizqUx0kya1YwLpp6OR/J5oCQIHv2W12DUNNl62oR3bdUAslvi
	 4nWHlFJDJW7w6p9/VlBcTh/TPV7zF8Hliv79WDlb63zt8UE2WLp+1+DDyKYj98aPcB
	 zqQjLR+wMGmtvadV71usWFdFAk43jFRr8j+ndrQBLdzg4bD4PXL9dcSTXYtyLPrFwA
	 bMFXRde6G9/HyZ0TF5UqteX5N5etgPZBpq7KlDyG/HMzM9hMCrgTjA+thoPvYiDR5A
	 pX5PHx5/xp/Sg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Salah Triki <salah.triki@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	emmanuel.grumbach@intel.com,
	miriam.rachel.korenblit@intel.com,
	tglx@linutronix.de,
	viro@zeniv.linux.org.uk
Subject: [PATCH AUTOSEL 6.6 32/62] wireless: purelifi: plfxlc: fix memory leak in plfxlc_usb_wreq_asyn()
Date: Tue,  3 Jun 2025 21:01:43 -0400
Message-Id: <20250604010213.3462-32-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604010213.3462-1-sashal@kernel.org>
References: <20250604010213.3462-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.92
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Salah Triki <salah.triki@gmail.com>

[ Upstream commit 63a9a727d373fa5b8ce509eef50dbc45e0f745b9 ]

Add usb_free_urb() in the error path to prevent memory leak.

Signed-off-by: Salah Triki <salah.triki@gmail.com>
Link: https://patch.msgid.link/aA3_maPlEJzO7wrL@pc
[fix subject]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees. Here's
my extensive analysis: ## Code Analysis The commit fixes a clear memory
leak in the `plfxlc_usb_wreq_async()` function in the pureLiFi wireless
driver. Specifically: **The Bug:** - The function calls
`usb_alloc_urb(0, GFP_ATOMIC)` to allocate a USB URB (USB Request Block)
- If `usb_submit_urb()` fails, the function returns the error code but
never frees the allocated URB - This creates a memory leak every time
USB submission fails **The Fix:** The fix adds a simple but crucial
cleanup path: ```c r = usb_submit_urb(urb, GFP_ATOMIC); -if (r) +if (r)
{ + usb_free_urb(urb); dev_err(&udev->dev, "Async write submit failed
(%d)\n", r); +} ``` ## Timeline and Impact From examining the git
history: 1. **Bug Introduction:** The bug was introduced in commit
`68d57a07bfe5` when the driver was first added 2. **Bug Duration:** This
memory leak has existed since the driver's introduction 3. **Impact:**
Every failed USB submission would leak memory, potentially causing
system instability over time ## Comparison with Similar Commits This
commit matches the pattern of all 5 similar commits marked as "Backport
Status: YES": 1. **Similar Commit #2** - Also fixes missing allocation
failure check in the same function (`plfxlc_usb_wreq_async`) 2.
**Similar Commit #1** - Fixes memory leak in the same driver
(`__lf_x_usb_enable_rx`) 3. **Similar Commits #3-5** - All fix memory
leaks in wireless drivers with small, contained changes ## Backport
Criteria Met ✅ **Fixes important bug:** Memory leaks can cause system
instability ✅ **Small and contained:** Only adds 2 lines of code in
error path ✅ **No architectural changes:** Simple cleanup fix ✅
**Minimal regression risk:** Standard USB cleanup pattern ✅ **Clear
scope:** Limited to specific function in wireless driver ✅ **Follows
stable rules:** Important bugfix with minimal impact ## Additional
Considerations - The fix follows standard kernel patterns for USB URB
cleanup - The same driver has had multiple similar memory leak fixes
(commit `895b3b06efc2`) - The change is identical in nature to Similar
Commit #2, which was also in this exact function and marked YES for
backporting - No side effects beyond fixing the memory leak - The
function is called from transmit path, so failures could be relatively
common under stress This is a textbook example of a stable tree
candidate: a clear, important bug fix with minimal code changes and no
risk of regression.

 drivers/net/wireless/purelifi/plfxlc/usb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/purelifi/plfxlc/usb.c b/drivers/net/wireless/purelifi/plfxlc/usb.c
index 311676c1ece0a..8151bc5e00ccc 100644
--- a/drivers/net/wireless/purelifi/plfxlc/usb.c
+++ b/drivers/net/wireless/purelifi/plfxlc/usb.c
@@ -503,8 +503,10 @@ int plfxlc_usb_wreq_async(struct plfxlc_usb *usb, const u8 *buffer,
 			  (void *)buffer, buffer_len, complete_fn, context);
 
 	r = usb_submit_urb(urb, GFP_ATOMIC);
-	if (r)
+	if (r) {
+		usb_free_urb(urb);
 		dev_err(&udev->dev, "Async write submit failed (%d)\n", r);
+	}
 
 	return r;
 }
-- 
2.39.5

