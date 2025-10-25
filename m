Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A7F2153D2;
	Sat, 25 Oct 2025 16:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409048; cv=none; b=CkILsUTGD9/6fu5IdcYA6GFASL8VVEs6M6GfAjEvLrfeq18DY46d9s9xJJzhdBamFOqUScUSMlAP3o4NAG4fA4vTr5PzLT9cG5cZt/uTYb2cEFYnps/dJT9BOZfj8p6cgPqgJzo14wN3TSGwc6YcnxEscNDYoLZkeCSkR5kW3RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409048; c=relaxed/simple;
	bh=gNrYfGhr1PB9OFojKEeS0gQsJGs1J0/XerhtBYX4ouQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sCoAMHCUE8tks48qqka5KuT1Ul+bywcP4xnc6Qoegq843NCuLJMIupVCf+9BY/OzUppjEyUHjQb/n0WfXEHobhONGEHgUTCm220fc16Yf2tKq5fi90XB6eFnLloIyPC0rogSf/3VLkqIgHhgJmsFG+E7CG2n4fMnzU5CRZ9mHmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hhoa+GXf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hhoa+GXf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 701AAC4CEF5;
	Sat, 25 Oct 2025 16:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409048;
	bh=gNrYfGhr1PB9OFojKEeS0gQsJGs1J0/XerhtBYX4ouQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hhoa+GXfWyrCG2rjfV4LseHbbTHJpahc1E0fJcjsGfzpwz7Teeo5xcI0coweoWw+D
	 8PGPZRgE3LG/TmSvBUqyKD/7NGtz/U4tDEyytpLN4kjlkdtPJNF1peRDjKxLerdFwY
	 F9rQJiU8fxXoXDtMiY08COFzwC4spNGKYa1L+vqKgPk/G7IsCi/6Omb8blaJxhommi
	 qyzWg7my2UIth4JMf7h9XNSLoG/cbb7aolzx2aJ+s5OnDOahvZ269Q/G5YBlNLi8Nu
	 WdYhAcUySUSZlef741WHoSSx/x1zh4YWRQOFFisG/QsebpgTTewttVnrMCBy1RDj5q
	 lRRskojyhq5OA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: raub camaioni <raubcameo@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	alexander.deucher@amd.com,
	alexandre.f.demers@gmail.com,
	krzysztof.kozlowski@linaro.org,
	namcao@linutronix.de,
	khtsai@google.com
Subject: [PATCH AUTOSEL 6.17-5.4] usb: gadget: f_ncm: Fix MAC assignment NCM ethernet
Date: Sat, 25 Oct 2025 11:56:53 -0400
Message-ID: <20251025160905.3857885-182-sashal@kernel.org>
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

From: raub camaioni <raubcameo@gmail.com>

[ Upstream commit 956606bafb5fc6e5968aadcda86fc0037e1d7548 ]

This fix is already present in f_ecm.c and was never
propagated to f_ncm.c

When creating multiple NCM ethernet devices
on a composite usb gadget device
each MAC address on the HOST side will be identical.
Having the same MAC on different network interfaces is bad.

This fix updates the MAC address inside the
ncm_strings_defs global during the ncm_bind call.
This ensures each device has a unique MAC.
In f_ecm.c ecm_string_defs is updated in the same way.

The defunct MAC assignment in ncm_alloc has been removed.

Signed-off-by: raub camaioni <raubcameo@gmail.com>
Link: https://lore.kernel.org/r/20250815131358.1047525-1-raubcameo@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Explanation

- Problem fixed
  - Multiple NCM functions in a composite gadget end up advertising the
    same host-side MAC address because `f_ncm` writes the global string
    table once during allocation, not per-instance at bind time. In
    current code, `ncm_alloc()` sets the global string entry to the
    instance’s MAC: `drivers/usb/gadget/function/f_ncm.c:1738`. This
    global pointer is then reused for subsequent functions and can be
    overwritten before each function binds, causing duplicate MAC
    strings on the host for multiple NCM interfaces.

- What the patch changes
  - Moves MAC string assignment into bind:
    - Adds `ncm_string_defs[1].s = ncm->ethaddr;` immediately before the
      per-function call to `usb_gstrings_attach()` (i.e., just before
      `drivers/usb/gadget/function/f_ncm.c:1475`). That ensures each
      function instance updates the global strings to its own MAC right
      before string IDs are assigned.
  - Removes the early (and unsafe) assignment from allocation:
    - Deletes `ncm_string_defs[STRING_MAC_IDX].s = ncm->ethaddr;` from
      `ncm_alloc()` (currently at
      `drivers/usb/gadget/function/f_ncm.c:1738`).
  - The string ID is then bound to that instance via
    `ecm_desc.iMACAddress = us[STRING_MAC_IDX].id;`
    (`drivers/usb/gadget/function/f_ncm.c:1484`).

- Why this works (and matches ECM)
  - `usb_gstrings_attach()` assigns IDs for the string table entries at
    bind time and ties them into the composite device’s string tables.
    Updating the MAC string just before that call ensures each NCM
    function’s `iMACAddress` points to a unique string for that
    instance.
  - `f_ecm` has used this pattern since 2018: it assigns the MAC string
    in `ecm_bind()` right before `usb_gstrings_attach()`
    (`drivers/usb/gadget/function/f_ecm.c:715`), avoiding exactly this
    issue. This patch makes `f_ncm` consistent with the proven ECM
    approach.

- Impact and risk assessment
  - Bug fix scope is small and contained to `f_ncm` string handling: one
    added assignment in `ncm_bind()` and removal of the old one in
    `ncm_alloc()`. No API or structural changes.
  - Side effects are minimal: the per-function MAC string is set at the
    correct time; no change to descriptors other than ensuring the
    correct, unique `iMACAddress`.
  - Concurrency/regression risk is low: configfs binds functions
    sequentially; `ncm->ethaddr` is computed during allocation and is
    stable by bind; no timing-sensitive changes.
  - Subsystem is the USB gadget function driver (not a critical core
    subsystem); change mirrors an established, stable pattern in ECM.

- Stable backport criteria
  - Fixes a real user-visible bug (duplicate MAC addresses on host for
    multiple NCM functions), which can break networking and cause ARP/ND
    confusion.
  - Small, surgical change, no new features or architectural shifts.
  - Mirrors an existing fix in `f_ecm`, reducing risk.
  - Signed-off-by from Greg Kroah-Hartman indicates appropriateness for
    stable. The commit message is clear, with rationale and minimal
    scope.

- Backport notes
  - In some trees, the code around `ncm_bind()` may differ slightly
    (e.g., presence/absence of `max_segment_size`/MTU handling), but the
    core fix is independent: set `ncm_string_defs[STRING_MAC_IDX].s =
    ncm->ethaddr;` immediately before `usb_gstrings_attach()`, and
    remove the assignment from `ncm_alloc()`.
  - Index usage (`STRING_MAC_IDX` vs `[1]`) is equivalent in current
    kernels; prefer the macro where available for clarity.

Overall, this is a straightforward, low-risk bug fix that prevents
duplicate MAC addresses across multiple NCM functions and aligns `f_ncm`
with the established `f_ecm` practice. Backporting is advisable.

 drivers/usb/gadget/function/f_ncm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/f_ncm.c b/drivers/usb/gadget/function/f_ncm.c
index 0148d60926dcf..0e38330271d5a 100644
--- a/drivers/usb/gadget/function/f_ncm.c
+++ b/drivers/usb/gadget/function/f_ncm.c
@@ -1465,6 +1465,8 @@ static int ncm_bind(struct usb_configuration *c, struct usb_function *f)
 
 	ncm_opts->bound = true;
 
+	ncm_string_defs[1].s = ncm->ethaddr;
+
 	us = usb_gstrings_attach(cdev, ncm_strings,
 				 ARRAY_SIZE(ncm_string_defs));
 	if (IS_ERR(us))
@@ -1759,7 +1761,6 @@ static struct usb_function *ncm_alloc(struct usb_function_instance *fi)
 		mutex_unlock(&opts->lock);
 		return ERR_PTR(-EINVAL);
 	}
-	ncm_string_defs[STRING_MAC_IDX].s = ncm->ethaddr;
 
 	spin_lock_init(&ncm->lock);
 	ncm_reset_values(ncm);
-- 
2.51.0

