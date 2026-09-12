Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793E92D47F1;
	Sat, 12 Sep 2026 14:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222807; cv=none; b=LLREpwMPypjzfoOfZ5t8j9ZIWDf/A6tAHwPmwoUucns07SF7A8GCCJ9+osVumV7aNPA4pixxr7Vu4zjy13MD0tJhdDXG4cQ9qqGvZOZl3rCSs9VTXTWu6tJ6JLGIBMSjRXvvUg1eMYRY8V7uhrMOwsBWW2tEUpmcOIN6I3SmIpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222807; c=relaxed/simple;
	bh=y8V6QzsrsiMLRqEYzsvRccIoWvJ4MRmup1YpGTJKWc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Trjo1YqDp9PSUihLTfOOG+i4+dLrsHOpT31flq82G+OCi8KF5oaK0T1u3CNwjSKnpfTgTdE++YL0PIl4G2Y617B2QR6F18wCZcpKJ3Dn3IA+AkNNKW1HD+v/JQzWclKpFSCP1UphlWh3NJj31Oh075vI7pnhRR1acO/z9UxE8Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L9Ypa8Qi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L9Ypa8Qi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C8EB1F000FF;
	Sat, 12 Sep 2026 14:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222806;
	bh=obGVRFALEaYnKfxvZRAHNYv2BfjcYtWJh6OIT6rrfnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L9Ypa8QiYAWheEeW4H8Medavx70KQZBJuFguUS+yui+BSQkDYN1aBe+Ri6WmvO/7O
	 pQkqwq9IfpJzu+SFVfESGq0g+FaGb2e2/s0GNOs3Iy6SoS75pz8+gex3xWzNBzTtHF
	 8y/IQBXeK+6pRqZl/+xBSuqYLEHgKV7wE1WvgwdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Ayush Mukkanwar <ayushmukkanwar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0660/1424] staging: octeon: add missing tasklet_kill in cvm_oct_tx_shutdown
Date: Sat, 12 Sep 2026 08:51:32 +0200
Message-ID: <20260912065622.075264875@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ayush Mukkanwar <ayushmukkanwar@gmail.com>

[ Upstream commit b9af44b0d20b2247c4eb0ea5cfca907d643eea50 ]

The TX cleanup tasklet can be scheduled by the watchdog IRQ handler
to execute cvm_oct_tx_do_cleanup. There can be a pending tasklet in
the queue which might run after the cvm_oct_remove() frees net_device
structures, causing a use-after-free in cvm_oct_tx_do_cleanup() as it
iterates cvm_oct_device[] which is an array of netdevice pointers.
Add tasklet_kill() after free_irq() to ensure the tasklet is no longer
scheduled or running before teardown proceeds.

Fixes: 4898c560103f ("Staging: Octeon:  Free transmit SKBs in a timely manner")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260511150931.93382-1-ayushmukkanwar%40gmail.com
Signed-off-by: Ayush Mukkanwar <ayushmukkanwar@gmail.com>
Link: https://patch.msgid.link/20260615172734.42038-1-ayushmukkanwar@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/octeon/ethernet-tx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/octeon/ethernet-tx.c b/drivers/staging/octeon/ethernet-tx.c
index bbf33b88bb7c2..e54b4a413dc40 100644
--- a/drivers/staging/octeon/ethernet-tx.c
+++ b/drivers/staging/octeon/ethernet-tx.c
@@ -711,4 +711,6 @@ void cvm_oct_tx_shutdown(void)
 {
 	/* Free the interrupt handler */
 	free_irq(OCTEON_IRQ_TIMER1, cvm_oct_device);
+
+	tasklet_kill(&cvm_oct_tx_cleanup_tasklet);
 }
-- 
2.53.0



