Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0B03074AC;
	Sat, 25 Oct 2025 16:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409412; cv=none; b=l1p6Jm9rob1yRrg2rqO2JLqJxOwMJMbHLHy1WXX9JfzWgQeKVXCCNB7bPe2by4u1G+5Fj9vDBAuCtegS8+M0i/0JpD2KXuo3Ks6Tl1HvUYBKjg2vKHIRtUn8pCeTFzjTibMl4HrKwLNcLk37T/jvnEcZg+eIkrAUfa+aV/KxVAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409412; c=relaxed/simple;
	bh=PbvwM6aceSw5zFu5uftWr9Xa6NC0E94O/w5JSauUwY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GTQVby5lKpJtNcSntYe3fckLrs7J6EXsYykSFwxipwUJ8nIcvwjfXIeS++nKMYAVHzpLZLoiJwBFnpwnykhdJ4tSVRIwIXdxWu8M02jasj/75g4FFkJUFdZlN0cfT/e58rqw3nVS40idN1SgBy5p4riBrF3ShOHGOVS5+nkf5HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mAYu0vC2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mAYu0vC2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B353AC4CEF5;
	Sat, 25 Oct 2025 16:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409412;
	bh=PbvwM6aceSw5zFu5uftWr9Xa6NC0E94O/w5JSauUwY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mAYu0vC2+5pOZxBLJB6SCJAL/NQdJ7jF0H1h34fuiH1C8A4W2PIwp1xODeTgvv0C5
	 wwiwoV22Vde48kF2fRBX55C7Q4yt3sXL466Gz2x3NVPIl8sWeUGMaFzptyUMIGG1MG
	 DAz5Ag8UV6SusJhdRZuc0boP5V1sbR7yGE2O9Ne9RjuYQbJ5aYhIs+vLIPleD3g35W
	 26kU2mHDPpun0DWeJcefzqymyK4FNjz/P9PrczWOoIBToZkbxdcPYgXdKvQn7+aDol
	 YrUdj3956QoFcJgJInKPnZZ1muNB/XeW3JiOBlR9oYM6HLyiqFujzBfnxtSEkfu0YL
	 nzifoSq9TeoFA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Owen Gu <guhuinan@xiaomi.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	brauner@kernel.org,
	ingo.rohloff@lauterbach.com,
	nichen@iscas.ac.cn,
	alexander.deucher@amd.com,
	akash.m5@samsung.com,
	alexandre.f.demers@gmail.com,
	peterz@infradead.org,
	viro@zeniv.linux.org.uk,
	snovitoll@gmail.com
Subject: [PATCH AUTOSEL 6.17-5.4] usb: gadget: f_fs: Fix epfile null pointer access after ep enable.
Date: Sat, 25 Oct 2025 11:59:02 -0400
Message-ID: <20251025160905.3857885-311-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Owen Gu <guhuinan@xiaomi.com>

[ Upstream commit cfd6f1a7b42f62523c96d9703ef32b0dbc495ba4 ]

A race condition occurs when ffs_func_eps_enable() runs concurrently
with ffs_data_reset(). The ffs_data_clear() called in ffs_data_reset()
sets ffs->epfiles to NULL before resetting ffs->eps_count to 0, leading
to a NULL pointer dereference when accessing epfile->ep in
ffs_func_eps_enable() after successful usb_ep_enable().

The ffs->epfiles pointer is set to NULL in both ffs_data_clear() and
ffs_data_close() functions, and its modification is protected by the
spinlock ffs->eps_lock. And the whole ffs_func_eps_enable() function
is also protected by ffs->eps_lock.

Thus, add NULL pointer handling for ffs->epfiles in the
ffs_func_eps_enable() function to fix issues

Signed-off-by: Owen Gu <guhuinan@xiaomi.com>
Link: https://lore.kernel.org/r/20250915092907.17802-1-guhuinan@xiaomi.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES Prevents a real NULL-dereference crash in FunctionFS caused by a
race between endpoint reset and re-enable.

- Root cause: `ffs_data_clear()` drops `ffs->epfiles` under `eps_lock`
  while leaving `ffs->eps_count` untouched until later in
  `ffs_data_reset()` (`drivers/usb/gadget/function/f_fs.c:2209-2259`).
  If `ffs_func_eps_enable()` runs in that window, it sees a stale non-
  zero `count` but `epfile == NULL`, leading to `epfile->ep` dereference
  and a kernel oops after `usb_ep_enable()` succeeds
  (`drivers/usb/gadget/function/f_fs.c:2415-2429`).
- Fix: the commit adds an early null-check on `ffs->epfiles` and aborts
  with `-ENOMEM` before touching the per-endpoint bookkeeping
  (`drivers/usb/gadget/function/f_fs.c:2410-2413,2438-2440`), which
  keeps the crash from happening while still unwinding cleanly through
  the existing error paths (`ffs_func_set_alt()` simply propagates the
  failure, `drivers/usb/gadget/function/f_fs.c:3730-3759`).
- Impact if unfixed: FunctionFS functions can hit this race during
  disconnects/resets, taking the whole gadget stack down with a NULL-
  pointer exception—serious for production devices relying on FunctionFS
  (we confirmed the same vulnerable logic is present in v6.6).
- Risk assessment: the guard executes only when the race actually
  occurs; normal enable sequences (where `ffs->epfiles` is valid) are
  untouched. Returning `-ENOMEM` matches existing allocation-failure
  handling in this code, and skipping `wake_up_interruptible()` in the
  no-epfile case is safe because there are no endpoint waiters left once
  the epfile array is gone.
- Backport fit: single-file change, no new APIs, no dependencies on
  later infrastructure, and it directly fixes a crash-worthy
  regression—all lining up with stable tree criteria.

Natural next step: run the gadget/functionfs tests (or a simple
mount/enable cycle) on the target stable branch after applying the patch
to verify there’s no unexpected alt-setting fallout.

 drivers/usb/gadget/function/f_fs.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 08a251df20c43..04058261cdd03 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -2407,7 +2407,12 @@ static int ffs_func_eps_enable(struct ffs_function *func)
 	ep = func->eps;
 	epfile = ffs->epfiles;
 	count = ffs->eps_count;
-	while(count--) {
+	if (!epfile) {
+		ret = -ENOMEM;
+		goto done;
+	}
+
+	while (count--) {
 		ep->ep->driver_data = ep;
 
 		ret = config_ep_by_speed(func->gadget, &func->function, ep->ep);
@@ -2431,6 +2436,7 @@ static int ffs_func_eps_enable(struct ffs_function *func)
 	}
 
 	wake_up_interruptible(&ffs->wait);
+done:
 	spin_unlock_irqrestore(&func->ffs->eps_lock, flags);
 
 	return ret;
-- 
2.51.0

