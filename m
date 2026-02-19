Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F65273D9F;
	Thu, 19 Feb 2026 02:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771466716; cv=none; b=QX+chfzVP1acgBce3N0dWAYVvK+RalcmEBYe2Q49FQevGcJ5byskRy9I0rwuU53Z43bOAN6lJ17b0uq7srAM20ER/VDg8uCjl+6Cj+IGV/ZgKJhu8xoy5b3DuQ7i2jyWXr8+mX6/ENrYMSgF50IG3t4iiSiG2J+i9twF6QNAOdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771466716; c=relaxed/simple;
	bh=lS9ujJfIZo2cy+7lurud5/71Qp0597qRXF+VGDG/iyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lE5jXxohay2mxJWh72KcrX+YLNXrGFOjAnOFCE8yk5MiP0O3TKto95jLte+GO747DwVlC2iFUZh+6DI+/5ZB1PcDiBZifGtmh1MeG9qUwdqpe0+5Jeoq8xjCOXB9bFqAN2pe80qc0hhTgnvWJO0E4PZ0zm+LC90/lAK3pm7f9Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZYfxxsGW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZYfxxsGW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E343C19424;
	Thu, 19 Feb 2026 02:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771466716;
	bh=lS9ujJfIZo2cy+7lurud5/71Qp0597qRXF+VGDG/iyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZYfxxsGWjXDs4nkphDyN3xzRe1wWK5j9IVNwh09Y9X7LTD4JFA3J+f9RscNMU05Bi
	 FDP//kxVEu4rLQiorsvw4hKQv+K1riH2ODpSCZDHyTwcvemMKOByjYHXo88gOOE5pj
	 bzfzjjEW5dBP1umpTSv7O+aHN0xVsHFJPczVl5WLXqc1xpv2pBM/B+l/jXbXWaRjy3
	 zbGeqmp+PrRuA8cFM9QM8S1/BHImFfnSkdO4kVMFEj2VNM7F6Ca4CnulULU21TTX/b
	 KZEV2dGHfdBmSNI1/rL8UzPaXcdOvGifG/lulzw7Fqaad+xo9Wc6ZlySNLetFbU1qq
	 QqJAufHRKaJAQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Felix Gu <gu_0233@qq.com>,
	Romain Gantois <romain.gantois@bootlin.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] misc: ti_fpc202: fix a potential memory leak in probe function
Date: Wed, 18 Feb 2026 21:04:17 -0500
Message-ID: <20260219020422.1539798-41-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260219020422.1539798-1-sashal@kernel.org>
References: <20260219020422.1539798-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.2
Content-Transfer-Encoding: 8bit

From: Felix Gu <gu_0233@qq.com>

[ Upstream commit dad9f13d967b4e53e8eaf5f9c690f8e778ad9802 ]

Use for_each_child_of_node_scoped() to simplify the code and ensure the
device node reference is automatically released when the loop scope
ends.

Signed-off-by: Felix Gu <gu_0233@qq.com>
Reviewed-by: Romain Gantois <romain.gantois@bootlin.com>
Link: https://patch.msgid.link/tencent_FA1AC670F5CF49873F88A44424F866994A08@qq.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Good - `for_each_child_of_node_scoped()` was introduced before v6.15, so
it's available in all stable trees that have this driver.

## Analysis Summary

### What problem the commit solves

The `for_each_child_of_node()` macro takes a reference on each child
device node during iteration. When the loop exits early via `goto
unregister_chans` (which happens on three separate error paths at lines
367, 373, and 379), the reference on `i2c_handle` is never released
because there's no `of_node_put(i2c_handle)` call before the `goto`.
This causes a device_node reference count leak each time probe fails
during child iteration.

The fix is clean and well-established: switching to
`for_each_child_of_node_scoped()` which uses cleanup attributes to
automatically release the reference when the variable goes out of scope,
regardless of how the loop exits.

### Does it meet stable kernel rules?

1. **Obviously correct and tested**: Yes - reviewed by the subsystem
   reviewer (Romain Gantois), well-known pattern, minimal change.
2. **Fixes a real bug**: Yes - reference count leak on device_node
   objects during probe failure.
3. **Important issue**: This is a resource leak. While it only triggers
   on probe errors (not in a hot path), it's a genuine bug that leaks
   kernel memory. It's a minor resource leak rather than a critical
   issue.
4. **Small and contained**: Yes - one line changed plus removal of one
   variable declaration.
5. **No new features**: Correct - purely a bug fix.

### Risk vs Benefit

- **Risk**: Extremely low. The `for_each_child_of_node_scoped()` macro
  is a well-tested, widely-used pattern across the kernel. The change is
  minimal.
- **Benefit**: Fixes a real resource leak, though it only triggers on
  error paths during probe.

### Concerns

- The driver was only introduced in v6.16, so it only applies to very
  recent stable trees.
- The bug only triggers on probe failure, so user impact is relatively
  low - most users with working hardware would never hit this.
- This is a minor resource leak (not a crash, corruption, or security
  issue).

### Verdict

This is a legitimate bug fix - a device_node reference count leak on
probe error paths. The fix is minimal, obviously correct, and uses a
well-established pattern. However, the practical impact is low: it only
affects an obscure driver (TI FPC202 dual port controller) and only
triggers during probe failures. The leak is a few bytes of memory per
failed probe attempt, not in a hot path.

While the fix is technically correct and meets stable criteria for being
small and fixing a real bug, the overall user impact is minimal. The
driver itself is very new (v6.16) and the leak only triggers on error
paths. This is the kind of fix that is nice to have but not critical for
stable users.

Given that it does fix a real (if minor) bug, is reviewed, minimal in
scope, and has essentially zero regression risk, it meets the stable
criteria.

## Verification

- **Read the file**: Confirmed the `for_each_child_of_node()` loop at
  line 360 with three `goto unregister_chans` early exits (lines 367,
  373, 379) none of which call `of_node_put()`.
- **Driver introduction**: `git log --diff-filter=A` confirmed driver
  was added in commit 1e5c9b1efa1c3; `git merge-base --is-ancestor`
  confirmed it's in v6.16 but not v6.15.
- **Scoped macro availability**: `git log -S` found it was introduced in
  commit 34af4554fb0ce; `git merge-base --is-ancestor` confirmed it's
  available since before v6.15, so it's present in all stable trees that
  have this driver.
- **Patch correctness**: The `for_each_child_of_node_scoped()` pattern
  is a well-known and widely used approach for fixing this exact class
  of bug throughout the kernel.

**YES**

 drivers/misc/ti_fpc202.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/misc/ti_fpc202.c b/drivers/misc/ti_fpc202.c
index 7964e46c74482..8eb2b5ac98506 100644
--- a/drivers/misc/ti_fpc202.c
+++ b/drivers/misc/ti_fpc202.c
@@ -309,7 +309,6 @@ static void fpc202_remove_port(struct fpc202_priv *priv, int port_id)
 static int fpc202_probe(struct i2c_client *client)
 {
 	struct device *dev = &client->dev;
-	struct device_node *i2c_handle;
 	struct fpc202_priv *priv;
 	int ret, port_id;
 
@@ -357,7 +356,7 @@ static int fpc202_probe(struct i2c_client *client)
 
 	bitmap_zero(priv->probed_ports, FPC202_NUM_PORTS);
 
-	for_each_child_of_node(dev->of_node, i2c_handle) {
+	for_each_child_of_node_scoped(dev->of_node, i2c_handle) {
 		ret = of_property_read_u32(i2c_handle, "reg", &port_id);
 		if (ret) {
 			if (ret == -EINVAL)
-- 
2.51.0

