Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E043043CA;
	Sat, 25 Oct 2025 16:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408812; cv=none; b=ZYtF/iVSNwo57xpUw6PIuE39zHDF9FyyyfqcfZj7IDtTEITxKyfhrJdwwSoU9UZZTtp7OZIF2ppISJV2d3RJdpgqy8ZmeQOCY1n1uXLOOwF5/3YKCx9uqONjNlnukGNwSh0cOWf/gYIlgTlaIMAk+dby1PDJASeIS2SKjt2NgQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408812; c=relaxed/simple;
	bh=DYOrhNcQ4crAX0MKCWdJSKTYdoZPKS7Hyu4Vvr8Unw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tCEvEpaZflsSlmBroGo8BWeELzp4PAbvwa89UYPFk/YzJ0xpqyvl5DiDWgDEZsGHRsetr1xEIFGScNzpbQ64Hgg1aF63Yd8Vu513/YM+FjPN71rZ5+e7nZrqOS8f3w7JgCeQ3jBAbuAkpA8iNBvLtxkWyOhMWrM9sPhLTQ35tHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y7GTliBw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y7GTliBw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7CC5C4CEF5;
	Sat, 25 Oct 2025 16:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408812;
	bh=DYOrhNcQ4crAX0MKCWdJSKTYdoZPKS7Hyu4Vvr8Unw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y7GTliBwi7ZkXX29boIQZL177eW9RLxoMTxmuVoLJPtORhb4ZWKT/kJTwcXuJC1KL
	 ICHL4vPJNvnwIfmRp2j3GiJGVE2rQCeiunes02LaAsVmyzYLOZet4V37GOboCUf/Uu
	 ZVsK5ps8Mfr2fabqXA3eM1tDjhow/y9SQSwbYPSBtlCfsY5AG9N+qyb+2nblM1R2SM
	 PxIkf7v55IrfWUWv6y8+Xi0z05V5kCaCNd+urfbEmiXqSeO2tVmggAOhd9OOyEAQZi
	 t1NWv2YCjzZhomD7Gd5RxWS0WkYTi3ikpqSq99+AfC9WgLw55hZrTSSM6tW2C1f+dc
	 bOSFTD0MEsSww==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	johan.hedberg@gmail.com,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17] Bluetooth: ISO: Don't initiate CIS connections if there are no buffers
Date: Sat, 25 Oct 2025 11:55:11 -0400
Message-ID: <20251025160905.3857885-80-sashal@kernel.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit d79c7d01f1c8bcf9a48337c8960d618fbe31fc0c ]

If the controller has no buffers left return -ENOBUFF to indicate that
iso_cnt might be out of sync.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- The new guard in `net/bluetooth/iso.c:465` refuses to start a CIS if
  the socket has a TX SDU configured but the controller reports zero ISO
  credits even though there are no active ISO links
  (`hci_iso_count(hdev)` from `include/net/bluetooth/hci_core.h:1093`),
  signalling that the controller/host credit accounting has fallen out
  of sync. Without this check the connection succeeds but
  `hci_sched_iso()` never sends data because `hdev->iso_cnt` stays at
  zero, so user-space observes a “successful” connect that cannot carry
  audio.
- The controller credit bookkeeping is expected to reset to `iso_pkts`
  when the buffer sizes are read (`net/bluetooth/hci_event.c:3770`) and
  to be restored on teardown (`net/bluetooth/hci_conn.c:1195`), so
  hitting this corner case indicates a real bug in the running system;
  returning `-ENOBUFS` makes that failure explicit instead of letting
  the socket hang.
- Change scope is tiny (one extra check and error return in a single
  file) and it relies only on fields and helpers that have existed since
  ISO support shipped, so it backports cleanly and carries minimal
  regression risk.

 net/bluetooth/iso.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 88602f19decac..247f6da31f9f3 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -460,6 +460,13 @@ static int iso_connect_cis(struct sock *sk)
 		goto unlock;
 	}
 
+	/* Check if there are available buffers for output/TX. */
+	if (iso_pi(sk)->qos.ucast.out.sdu && !hci_iso_count(hdev) &&
+	    (hdev->iso_pkts && !hdev->iso_cnt)) {
+		err = -ENOBUFS;
+		goto unlock;
+	}
+
 	/* Just bind if DEFER_SETUP has been set */
 	if (test_bit(BT_SK_DEFER_SETUP, &bt_sk(sk)->flags)) {
 		hcon = hci_bind_cis(hdev, &iso_pi(sk)->dst,
-- 
2.51.0

