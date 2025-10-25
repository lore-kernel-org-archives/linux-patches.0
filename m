Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2975030BBA5;
	Sat, 25 Oct 2025 16:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409064; cv=none; b=g/OGOZcvM8LcDuAwcOh9rLfHWKHxgXAtP/1t0ujdJyTmftUicsBML2suFP4+JE6lP+05kDbycX0TZdnsBXecdyqC4LkmHQjUPRiAgg9OiE6sRdnQVBPd65VnaeaX0bWqUBduFhVnn4cR5BJPIV8NUFIoQwjpp/xWymnIsr4U4ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409064; c=relaxed/simple;
	bh=f18otFE9sXRaB1/a73mzywcxvmNlV74lHEbEVIw6MZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hrIXRnWXuIz2eKoiYDBN8eySqLetwRPPX4QqqT+l8S3+xbyHPSDG90BLMEvq5+fkZC9IidRhpvr4ekZj9lA5SO8xduqYUJHUwh8/RTWrvEQIoYaRjWzm+Q7VRXLgTHK8xhc3RdIk3XRObjpLvoFMXN4BCUgbPAcmtj2/28YXZ4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sBrNVfAi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sBrNVfAi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F2BC4CEFB;
	Sat, 25 Oct 2025 16:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409064;
	bh=f18otFE9sXRaB1/a73mzywcxvmNlV74lHEbEVIw6MZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sBrNVfAi9WNpED6/HLE7mA/fXygXnMYjtRnOCtgwYvTQAQWb2EBwBEPfki9X4dJ2E
	 04V2F84ps8tOfWhEwQVL7zD1R0NHX45ivB+TAKKXIgH6M/ZuwUYtCWL548SVa0jLNw
	 aOPNNjH//WUwD0DY3+bNIVUXloo+5jhS0nLNfplMbFdDmsnfxaGZqWkuijFzwCPm6L
	 Ozaaxy44snHwUtxqfFGQqLDcSmpmBSRpsO6ZgpLHGPa3OrGzsTbs4zjJfKbigxLMaG
	 Ursn3AvZMRU/M98MHaa6tI0eKNGRMaytb6mQ+pQ6KeDODCtrdk8TRfpSfPas1p+pXN
	 krtXPl/HMomHg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Stanislav Fomichev <sdf@fomichev.me>,
	Mina Almasry <almasrymina@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	joe@dama.to
Subject: [PATCH AUTOSEL 6.17] selftests: ncdevmem: don't retry EFAULT
Date: Sat, 25 Oct 2025 11:56:59 -0400
Message-ID: <20251025160905.3857885-188-sashal@kernel.org>
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

From: Stanislav Fomichev <sdf@fomichev.me>

[ Upstream commit 8c0b9ed2401b9b3f164c8c94221899a1ace6e9ab ]

devmem test fails on NIPA. Most likely we get skb(s) with readable
frags (why?) but the failure manifests as an OOM. The OOM happens
because ncdevmem spams the following message:

  recvmsg ret=-1
  recvmsg: Bad address

As of today, ncdevmem can't deal with various reasons of EFAULT:
- falling back to regular recvmsg for non-devmem skbs
- increasing ctrl_data size (can't happen with ncdevmem's large buffer)

Exit (cleanly) with error when recvmsg returns EFAULT. This should at
least cause the test to cleanup its state.

Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Link: https://patch.msgid.link/20250904182710.1586473-1-sdf@fomichev.me
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Explanation

- What changed
  - Adds a specific EFAULT handling path in the server receive loop: on
    recvmsg() returning -1 with errno == EFAULT, the test logs and exits
    the connection, instead of retrying indefinitely.
    - recvmsg call:
      tools/testing/selftests/drivers/net/hw/ncdevmem.c:940
    - Error branch:
      tools/testing/selftests/drivers/net/hw/ncdevmem.c:944
    - New EFAULT handling:
      tools/testing/selftests/drivers/net/hw/ncdevmem.c:946–949
    - Other errors still “continue” (retry):
      tools/testing/selftests/drivers/net/hw/ncdevmem.c:950
  - The new fatal path drops into the existing cleanup cascade via goto
    err_close_client, ensuring full resource cleanup:
    - err_close_client label and cleanup:
      tools/testing/selftests/drivers/net/hw/ncdevmem.c:1039–1055

- Why it matters (bug fixed)
  - The test currently spams “recvmsg: Bad address” (EFAULT) in a tight
    loop and can OOM the test host, as described in the commit message.
    With the new branch, the test fails fast and performs cleanup
    instead of repeatedly retrying a non-recoverable condition.
  - The commit notes likely causes of EFAULT (e.g., fallback to regular
    recvmsg for non-devmem skbs), which ncdevmem cannot meaningfully
    handle at present. Continuing to retry is not productive and causes
    resource exhaustion.
  - The control buffer is intentionally very large
    (tools/testing/selftests/drivers/net/hw/ncdevmem.c:830), so the
    “control buffer too small” EFAULT scenario is not applicable here,
    aligning with the commit message.

- Scope and risk
  - Extremely contained: changes only the ncdevmem selftest, not kernel
    code, UAPI, or any production subsystem behavior.
  - Minimal behavior change: only EFAULT is treated as fatal; other
    transient errors continue to be retried
    (tools/testing/selftests/drivers/net/hw/ncdevmem.c:950).
  - Cleanup is comprehensive: closes fds, frees memory, unbinds, and
    restores NIC state (flow steering, RSS, ring config), preventing
    test pollution:
    - close(client_fd):
      tools/testing/selftests/drivers/net/hw/ncdevmem.c:1040
    - close(socket_fd):
      tools/testing/selftests/drivers/net/hw/ncdevmem.c:1042
    - free(tmp_mem):
      tools/testing/selftests/drivers/net/hw/ncdevmem.c:1044
    - ynl_sock_destroy(ys):
      tools/testing/selftests/drivers/net/hw/ncdevmem.c:1046
    - reset_flow_steering/reset_rss/restore_ring_config/free
      ring_config:
      tools/testing/selftests/drivers/net/hw/ncdevmem.c:1048–1054

- Fit for stable
  - Fixes a real, practical problem in selftests (runaway logging
    leading to OOM), improving reliability of stable selftest runs and
    CI.
  - Small and surgical change in a test; no architectural changes; no
    user-visible kernel behavior change; very low regression risk.
  - Aligns with stable policy for backporting important selftest fixes
    that prevent hangs/OOM and ensure tests can complete and clean up.

Given it prevents a test-induced OOM, improves determinism, and is
tightly scoped to selftests, this is a good candidate for stable
backport.

 tools/testing/selftests/drivers/net/hw/ncdevmem.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/hw/ncdevmem.c b/tools/testing/selftests/drivers/net/hw/ncdevmem.c
index 72f828021f832..147976e55dac2 100644
--- a/tools/testing/selftests/drivers/net/hw/ncdevmem.c
+++ b/tools/testing/selftests/drivers/net/hw/ncdevmem.c
@@ -631,6 +631,10 @@ static int do_server(struct memory_buffer *mem)
 			continue;
 		if (ret < 0) {
 			perror("recvmsg");
+			if (errno == EFAULT) {
+				pr_err("received EFAULT, won't recover");
+				goto err_close_client;
+			}
 			continue;
 		}
 		if (ret == 0) {
-- 
2.51.0

