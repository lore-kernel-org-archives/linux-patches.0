Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7410B54769;
	Wed,  4 Jun 2025 00:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998390; cv=none; b=m5i08gKAdvJmszwKFf6SkPK8QUwuGYV7E7prMqJzfe4U5RUZfn583T0aBLLht2XYfC3DqXWA0C70ZvyWWYzK4kFpIlCVwSAvl2R9jQfa6TZPHscYDcCW1AvkkKZKEK7tuRRjlhCtmPrRMsAonTBAesuMkxIjvceX7tJblZk6SCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998390; c=relaxed/simple;
	bh=h7F1jdITaGLEsj+B6I12y15gRfklp7pblUeohZerrjQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iydVFDdaz16E0NbWPXaMh2ysXdIBZNstJppTLcMmmoP/1OpGWDwGLfD7oP9I7cCDg3TeNyhVWsik/UXi4o8CynqQfBNvitOKuOGbBWrdxotzhMzIK8k4OQvSbncK1Jw1WtxYdfe7zy8DVjaXByNlf6Uti+8SOR8wz7YvjX1ZCro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F82ekK9g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F82ekK9g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37470C4CEED;
	Wed,  4 Jun 2025 00:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998390;
	bh=h7F1jdITaGLEsj+B6I12y15gRfklp7pblUeohZerrjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F82ekK9gI3lYirMOa6Ur5TqkbrmxSKgJTmjSsg2qGkHjI6xvFIJcz2voWvlGpfEdu
	 svlbXtw8HU+jtC2XXDRG54AHSPUMwSaHJEOZbLlbzJQwLBlLi8nfqoHoM5sEKVJ4hL
	 YHDn8+sCbSAWgXI+YHOwPJoewU/koSzaaSegRsvNQkfllFsioS8C9c0xFcjdINw2wQ
	 c1vtwVK7O+GXN4ORZv9JeZ94Vq9z6HCz8MnR2wqaYU8EWTJHTAZM9mK34+nspbYmwA
	 V4TJRLUqF7AcpRjpf0y4VzPNC9cGEoDfw7hiJB0Ra9rfN2CFApaAhdsV8bV7vOkfzm
	 CX5vxafBsUVdw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Salah Triki <salah.triki@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	emmanuel.grumbach@intel.com,
	mingo@kernel.org,
	miriam.rachel.korenblit@intel.com,
	viro@zeniv.linux.org.uk,
	tglx@linutronix.de
Subject: [PATCH AUTOSEL 6.15 058/118] wireless: purelifi: plfxlc: fix memory leak in plfxlc_usb_wreq_asyn()
Date: Tue,  3 Jun 2025 20:49:49 -0400
Message-Id: <20250604005049.4147522-58-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005049.4147522-1-sashal@kernel.org>
References: <20250604005049.4147522-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15
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
index 10d2e2124ff81..c2a1234b59db6 100644
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

