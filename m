Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1E9226D16;
	Thu,  9 Oct 2025 15:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025549; cv=none; b=l2CNSruLc6YKBjSdinrBXvlzF8dfDmvza3XeHxGVArkST00vh8fHqiZhzcIn0o4QOaUGETKuy5gac9z9KgUIx4hVHamFoLhlBaismpb4OZcwW02IWpLwC8sYjKAgWF3s84Def+mvoOHhkZwk7ADnDii/gCXwTccyeoCegqXl5PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025549; c=relaxed/simple;
	bh=l7/7eUi2mjzkYxpZeBHXxPnQp1fR3KlCIejpfYTIw7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fT+FF6sA29expbBuD4AKkrqi9WeLtc+o2jrR+CTVcT5pmUlDHUwnKswAxNHPFj4qd3Y4pxENmt2SmX+uBD9pD5n8IVAdrKfjm95cnSwSlprk/bWG4gqEqokubjhaxtRcTCvgPSufNosyR7K0EKrjL2Uuf7wSiHb9cTWs9BZiPNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aFjUssgp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aFjUssgp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00426C4CEF7;
	Thu,  9 Oct 2025 15:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025549;
	bh=l7/7eUi2mjzkYxpZeBHXxPnQp1fR3KlCIejpfYTIw7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aFjUssgpx8MC7ZyMW17AldPm1+991gwWJ04iJQ6khVrFOubz635jgmGclZx7mmLWE
	 HdUcasbN6758DLSf6J1XBHhBS7OSSHVd/KNWEfTtfDWzwl7iJz+DJz9AZbXgN7Y9/N
	 Z7CBIvex3lLr+TJl8bG5NP59RrUrlYYJUqWcTBNlJTVOPw+2RtlntiK5rtMpZMZrTe
	 5umu4e7d56XcDfXDE9NoDsyScMNvtc/YNAKqX8GPcQRXA7i1tZC4PGUhsg3Fvc3OBm
	 KwDQzgh9/+dEG0tyFegmeMLhOSDWeXu3yvzCyFSDAubX2Cn9CvvxEeIt215YcTQZXP
	 35hOHbW8PEOhg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alistair Francis <alistair.francis@wdc.com>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	sagi@grimberg.me,
	linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 6.17-6.1] nvme: Use non zero KATO for persistent discovery connections
Date: Thu,  9 Oct 2025 11:55:07 -0400
Message-ID: <20251009155752.773732-41-sashal@kernel.org>
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

From: Alistair Francis <alistair.francis@wdc.com>

[ Upstream commit 2e482655019ab6fcfe8865b62432c6d03f0b5f80 ]

The NVMe Base Specification 2.1 states that:

"""
A host requests an explicit persistent connection ... by specifying a
non-zero Keep Alive Timer value in the Connect command.
"""

As such if we are starting a persistent connection to a discovery
controller and the KATO is currently 0 we need to update KATO to a non
zero value to avoid continuous timeouts on the target.

Signed-off-by: Alistair Francis <alistair.francis@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - Aligns Linux host behavior with NVMe Base Spec 2.1 requirement that
    a host must specify a non-zero Keep Alive Timer in the Connect
    command to request an explicit persistent discovery connection. The
    previous behavior left `KATO=0` for discovery controllers even when
    the connection became persistent, causing targets to time out and
    drop connections.

- Code change and behavior
  - In `nvme_start_ctrl()` (`drivers/nvme/host/core.c:4998`), on
    reconnect for discovery controllers
    (`test_bit(NVME_CTRL_STARTED_ONCE, &ctrl->flags)` and
    `nvme_discovery_ctrl(ctrl)`), the patch:
    - Checks if `ctrl->kato` is zero.
    - If zero, calls `nvme_stop_keep_alive(ctrl)`, sets `ctrl->kato =
      NVME_DEFAULT_KATO`, then `nvme_start_keep_alive(ctrl)`.
    - Still sends the rediscover uevent: `nvme_change_uevent(ctrl,
      "NVME_EVENT=rediscover")`.
  - This immediately starts keep-alive commands after a persistent
    discovery reconnect and ensures subsequent Connect commands
    advertise non-zero KATO.

- Why this is correct and effective
  - Immediate effect: Even if the just-completed Connect used `kato=0`,
    forcing a non-zero `kato` here starts the host keep-alive work right
    away, avoiding target keep-alive timeouts after a persistent
    reconnect.
  - Future connections: `nvmf_connect_cmd_prep()` sets Connect’s KATO
    from `ctrl->kato` (`drivers/nvme/host/fabrics.c:426`). With this
    change, the next reconnection will send a non-zero KATO in the
    Connect command as the spec requires.
  - Safe sequence: `nvme_stop_keep_alive()` is a no-op when `kato==0`
    (`drivers/nvme/host/core.c:1412`), then `ctrl->kato` is set to
    `NVME_DEFAULT_KATO` (`drivers/nvme/host/nvme.h:31`), and
    `nvme_start_keep_alive()` only schedules work when `kato!=0`
    (`drivers/nvme/host/core.c:1404`).

- Scope and risk
  - Scope-limited: Only affects discovery controllers on reconnect
    (persistent discovery) and only when `kato==0`. No effect on:
    - Non-discovery (I/O) controllers (they already default to non-zero
      KATO).
    - Discovery controllers where userspace explicitly set a non-zero
      KATO.
  - No architectural changes; uses existing helpers and flags; no ABI
    change.
  - Regression risk is low. Prior history already introduced persistent
    discovery semantics and a sysfs `kato` attribute, and transports
    already honor `ctrl->kato` for Connect. This change simply fills a
    corner case where `kato` remained zero in a persistent discovery
    reconnect.

- Historical context and consistency
  - 2018: We explicitly avoided KA to discovery controllers per early
    spec constraints.
  - 2021: The code was adjusted so discovery controllers default to
    `kato=0`, while I/O controllers default to `NVME_DEFAULT_KATO`
    (commit 32feb6de). Persistent discovery connections were intended to
    have a positive KATO (via options), but implicit persistent
    reconnects could still have `kato=0`.
  - 2022: Added rediscover uevent for persistent discovery reconnects
    (f46ef9e87) and `NVME_CTRL_STARTED_ONCE` usage.
  - This patch completes the intent by ensuring persistent discovery
    reconnects run with non-zero KATO automatically, preventing target
    timeouts and complying with spec 2.1.

- Stable backport suitability
  - Fixes a user-visible bug (target timeouts and unstable discovery
    connectivity on persistent reconnects).
  - Small, self-contained change confined to `nvme_start_ctrl()` in
    `drivers/nvme/host/core.c`.
  - No new features or interfaces; minimal risk of regression; behavior
    matches spec and existing design.
  - Dependencies exist in stable trees that already have persistent
    discovery support and the `NVME_CTRL_STARTED_ONCE` mechanism. For
    older branches that still use `test_and_set_bit` in the rediscover
    path, the logic remains valid within that conditional block.

- Side notes for backporters
  - Ensure the tree has `NVME_CTRL_STARTED_ONCE`,
    `nvme_discovery_ctrl()`, and the rediscover uevent path in
    `nvme_start_ctrl()`. If an older stable branch uses
    `test_and_set_bit` instead of `test_bit`, place the new KATO block
    inside that existing conditional.
  - `nvmf_connect_cmd_prep()` must already populate Connect’s `kato`
    from `ctrl->kato` (`drivers/nvme/host/fabrics.c:426`) so that future
    reconnects benefit from the updated `kato`.

 drivers/nvme/host/core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 6b7493934535a..5714d49932822 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4990,8 +4990,14 @@ void nvme_start_ctrl(struct nvme_ctrl *ctrl)
 	 * checking that they started once before, hence are reconnecting back.
 	 */
 	if (test_bit(NVME_CTRL_STARTED_ONCE, &ctrl->flags) &&
-	    nvme_discovery_ctrl(ctrl))
+	    nvme_discovery_ctrl(ctrl)) {
+		if (!ctrl->kato) {
+			nvme_stop_keep_alive(ctrl);
+			ctrl->kato = NVME_DEFAULT_KATO;
+			nvme_start_keep_alive(ctrl);
+		}
 		nvme_change_uevent(ctrl, "NVME_EVENT=rediscover");
+	}
 
 	if (ctrl->queue_count > 1) {
 		nvme_queue_scan(ctrl);
-- 
2.51.0

