Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7298F3F1AC6;
	Sat, 12 Sep 2026 09:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206688; cv=none; b=IN2r7VPEr+YBafqiTQztj7AmhtOCHgSUXxwzJCmS/lEnuETFGFf2AT5OxpZwmXSGfTKBBwRojUfj9GfyXtPvEvUp/UkiqYqj+oiGwDE/XjF3bf08gzeLVRHZOhG64hJ+OXPLLQEDgv0NfynNYjJnck1YnFyMaWBEKDRRIJdQv0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206688; c=relaxed/simple;
	bh=br9mWPrGzR5otEb8Y7OnZXyQ3H6kODMiL2dAV96TG/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y37uIw0garP3fnNvG1vpogA6US4p565/VvNhI8OGUgUGYYN+LFHhtL7MTlA8Wd5Nr1Q7qkqwk4cDebq8/cmXcRDoYeo8P7inG+dJGLqk7TAoW1wpdCbE/D7aMNh+nHt9uEocpBXcRYD5C7DeEMigiipVjgsUzWa3A0t6Jc3mgpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j7FIxSzf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j7FIxSzf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9095E1F000FF;
	Sat, 12 Sep 2026 09:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206685;
	bh=kIEjmKjfRWaUoJxXWt/sbu6QZJpRuPbJdW8etIcojj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j7FIxSzf24UB86j2RlxzwzHH9nrnRJ9rOmZOsJAIAO9OFLs2BXR62lJg+nSh5Xjig
	 2zs2eqVj06tEsgHQdtKr84RSwCai1Pw5FrdJuS+nAadslRZaz4wxyexihwuPgTLmHR
	 5DzP2SCb0y01NWxxW6SPHSv22dMcvClAkkg4LK5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuvraj Singh Chauhan <ysinghcin@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0231/1518] staging: octeon: fix free_irq dev_id mismatch in cvm_oct_rx_shutdown
Date: Sat, 12 Sep 2026 08:40:00 +0200
Message-ID: <20260912065628.711782639@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuvraj Singh Chauhan <ysinghcin@gmail.com>

[ Upstream commit 41db5b76eeb4cc11a1097384caba7cfc659f7293 ]

In cvm_oct_rx_initialize(), request_irq() is called with
&oct_rx_group[i].napi as the dev_id:

	request_irq(oct_rx_group[i].irq, cvm_oct_do_interrupt, 0, "Ethernet",
							&oct_rx_group[i].napi);

However, cvm_oct_rx_shutdown() passes cvm_oct_device (an array of
struct net_device pointers) as the dev_id to free_irq():

  free_irq(oct_rx_group[i].irq, cvm_oct_device);

Since __free_irq() matches the action to remove by comparing
dev_id pointers, the mismatched cookie means the IRQ handler is
never found, triggering a WARN and leaving the IRQ line permanently
allocated. This prevents proper driver cleanup on module removal.

Fix the mismatch by passing &oct_rx_group[i].napi as the dev_id
to free_irq(), matching what was used during request_irq().

Signed-off-by: Yuvraj Singh Chauhan <ysinghcin@gmail.com>
Link: https://patch.msgid.link/20260212171903.1417804-1-ysinghcin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: c0a9a8586a63 ("staging: octeon: add missing napi_disable in cvm_oct_rx_shutdown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/octeon/ethernet-rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/octeon/ethernet-rx.c b/drivers/staging/octeon/ethernet-rx.c
index 965330eec80a8..d0b43d50b83ce 100644
--- a/drivers/staging/octeon/ethernet-rx.c
+++ b/drivers/staging/octeon/ethernet-rx.c
@@ -535,7 +535,7 @@ void cvm_oct_rx_shutdown(void)
 			cvmx_write_csr(CVMX_POW_WQ_INT_THRX(i), 0);
 
 		/* Free the interrupt handler */
-		free_irq(oct_rx_group[i].irq, cvm_oct_device);
+		free_irq(oct_rx_group[i].irq, &oct_rx_group[i].napi);
 
 		netif_napi_del(&oct_rx_group[i].napi);
 	}
-- 
2.53.0



