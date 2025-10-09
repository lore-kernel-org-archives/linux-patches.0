Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5432F3615;
	Thu,  9 Oct 2025 15:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025568; cv=none; b=Wc9fg3JpBwv1I02It7jzLxwhHNV/5V6UUdFyy5f9gMPz2aE3RD+q43YtFGnTrLe9gx/eifRxmAZb9+T+zKBFvAiWc5BMCyPaAT8R1ZGsUIT5V1x512LAoQ6YGfunhljlrCOnokv5RdEgZPvf+jyN4rYBl/IFe/0j1lWrm3z0usA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025568; c=relaxed/simple;
	bh=HhK2IJFNOuj9oMTXEyfV/LylryGPe9C8fZDPFRwl/Tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hclRcSCHLUvepQD8YPTrpYZiyqZDD9FZnh3qvzq5zvchIxyRLl/b3OFeCNcskgcJwYpZAxHwG8Wevz8wf5NRfHzJKmsZjIdqUQ/SdNFPLm194BNVgAgCE9uEhrpk8Q0swpq2QKHt95vel3evHvhjPvw+jjJ6sDKbIC+VlYlP9dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HZEtJRVP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HZEtJRVP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14794C4CEE7;
	Thu,  9 Oct 2025 15:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025568;
	bh=HhK2IJFNOuj9oMTXEyfV/LylryGPe9C8fZDPFRwl/Tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HZEtJRVPlLe1jkkj97AnsxkRjdffFsAQMRBQKs0MtmUrM1c0mYDHfRqLUphT+Cbmt
	 YTublzkkckObelablNAPctyYkdrxpQhpJJYoQ7Vo6/XmHpRmfknQfbmk/YjhWSEn+T
	 kbfKLxEatKhFlrCEV7gG7fGNimIqFR0h8uaeoe/GK1VZe0q6Rp6W0pZi7l8oVFSZ7l
	 QTQFftycOdJPzeog+rYRGbWJBDB4SqVm0g2e9FxWGyz24i0jSntLcHghOxYBQ7DWAE
	 UpA2GPyPCy6cldv9YJkXFyZ09JMuPiawC9YOBPSjB2rrJFdpG7c4g7fz3JkwXsE1q5
	 q8Nh44ux8FXKg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Bastien Curutchet <bastien.curutchet@bootlin.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.17-6.12] mfd: core: Increment of_node's refcount before linking it to the platform device
Date: Thu,  9 Oct 2025 11:55:17 -0400
Message-ID: <20251009155752.773732-51-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251009155752.773732-1-sashal@kernel.org>
References: <20251009155752.773732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bastien Curutchet <bastien.curutchet@bootlin.com>

[ Upstream commit 5f4bbee069836e51ed0b6d7e565a292f070ababc ]

When an MFD device is added, a platform_device is allocated. If this
device is linked to a DT description, the corresponding OF node is linked
to the new platform device but the OF node's refcount isn't incremented.
As of_node_put() is called during the platform device release, it leads
to a refcount underflow.

Call of_node_get() to increment the OF node's refcount when the node is
linked to the newly created platform device.

Signed-off-by: Bastien Curutchet <bastien.curutchet@bootlin.com>
Link: https://lore.kernel.org/r/20250820-mfd-refcount-v1-1-6dcb5eb41756@bootlin.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

**Why This Is A Bugfix**
- Root cause: `mfd_match_of_node_to_dev()` links a DT node to a new
  `platform_device` using `device_set_node(&pdev->dev,
  of_fwnode_handle(np));` but does not take a reference on the OF node.
  Later, the `platform_device` release path drops a reference
  unconditionally, causing an underflow.
  - Current linking without ref: drivers/mfd/mfd-core.c:134
  - Platform device release drops the ref: drivers/base/platform.c:556
  - `device_set_node()` does not acquire a reference; it only assigns:
    drivers/base/core.c:5274
- Correct pattern elsewhere: OF-based platform devices explicitly
  increment the node ref before linking:
  - Example: `device_set_node(&dev->dev,
    of_fwnode_handle(of_node_get(np)));` in drivers/of/platform.c:129

**What The Commit Changes**
- Adds `of_node_get(np);` immediately before
  `device_set_node(&pdev->dev, of_fwnode_handle(np));` in
  `mfd_match_of_node_to_dev()`, balancing the unconditional
  `of_node_put()` at `platform_device` release.
  - New line added right before the existing call: drivers/mfd/mfd-
    core.c:134
- This matches how other subsystems handle device-tree node linkage and
  ensures the `of_node` refcount is correct when the device is
  unregistered.

**Evidence In Current Code Path**
- During device creation, after a successful match, MFD code drops the
  loop’s reference to `np`:
  - `of_node_put(np);` in drivers/mfd/mfd-core.c:195
- Without an extra `of_node_get()` for the device itself, the platform
  device’s release path performs one more put than gets, leading to a
  refcount underflow (and potentially a UAF if overlays or dynamic DT
  are involved).

**Risk, Scope, and Stable Suitability**
- Small, contained fix: a single additional `of_node_get()` call in a
  narrow path.
- No architectural changes; only balances reference counting.
- Aligns MFD behavior with the broader kernel conventions for DT-backed
  devices.
- Touches a core MFD helper but with minimal regression risk; it only
  affects CONFIG_OF cases.
- Fix addresses a real bug that can manifest at device removal/teardown,
  producing refcount warnings or worse under dynamic DT.

**Backport Considerations**
- APIs used (`of_node_get`, `device_set_node`, `of_fwnode_handle`) exist
  in stable series.
- No dependency on recent reworks; the bug predates switching to
  `device_set_node` (earlier code also omitted the ref get).
- While the commit message does not explicitly carry a “Cc: stable”, it
  is a classic stable-eligible bugfix: important correctness issue,
  minimal change, clear benefit, low risk.

In summary, the patch balances OF node refcounting for MFD-created
platform devices and should be backported to stable trees.

 drivers/mfd/mfd-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index 76bd316a50afc..7d14a1e7631ee 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -131,6 +131,7 @@ static int mfd_match_of_node_to_dev(struct platform_device *pdev,
 	of_entry->np = np;
 	list_add_tail(&of_entry->list, &mfd_of_node_list);
 
+	of_node_get(np);
 	device_set_node(&pdev->dev, of_fwnode_handle(np));
 #endif
 	return 0;
-- 
2.51.0

