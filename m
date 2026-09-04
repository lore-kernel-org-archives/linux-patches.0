Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2DC43C73C1;
	Fri,  4 Sep 2026 05:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500618; cv=none; b=sSkh+KlxACw/rHnKSEmXEQNplv84wmF87RhdSbgebOwxJUlY1BvnfWZkfIJbmqaVeQwxWhanVTV+ecOBTTgeTde9AsSAq/uWd753YdX7r7+uYceVt1X45wb7cNRN91XLjd9kKNf1VtEiIUXI7g46sKzfDP93162FA5K/ED7757U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500618; c=relaxed/simple;
	bh=tI4DfR8mXsFJNEeeMZuPc5fayru+nSVoY67R2Xj4r/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r1W/IGCW2sKJ4gNJDAYbpE2BOSXRWw0nmbgT+3KU9WHuMw73E+f/x4iAkrV6iL9a5OzycPl3Nocc5dQa9IOwULbdGukxoKVbyaEnYgOz76ettk091Rru7wsErD8vlNCjOc12okzVtzIDrHHbnhGehRL00AL/JqY/orh4c8/qpHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J/RyB1Ia; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J/RyB1Ia"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A5F61F00A3D;
	Fri,  4 Sep 2026 05:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500617;
	bh=YBqIsiXZjzx1ygxr90fzVxu1yt6VK/s5ov2BHgf6iBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J/RyB1Ia38Ngk7aQ0w6C/Q+SWVYV/yvQjA4ltNwq1EWSL3NWQx7HxJvNrTnaNljMk
	 mTtInIw/EJ3HZ4fVwbJDljRXgw2XoTYR0fZEXH7S8OVgNKm4+JFWSMAC7XIzMG5KcU
	 pzy4nff0aT5ROFUyZyKgj/xJl8qm1zRntXPv04yI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huang Wei <huangwei@kylinos.cn>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Fedor Pchelkin <boddah8794@gmail.com>
Subject: [PATCH 6.18 077/552] usb: typec: ucsi: use UCSI_TIMEOUT_MS for sync command completion
Date: Fri,  4 Sep 2026 06:53:54 +0200
Message-ID: <20260904045749.602832064@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Huang Wei <huangwei@kylinos.cn>

commit eb4573cf2fd860b20adfae050c3f6ec6ddc3abdb upstream.

The synchronous command completion path in ucsi_sync_control_common()
hardcodes a 5 second (5 * HZ) timeout when waiting for the PPM to signal
command completion via ACPI notification. This value matched
UCSI_TIMEOUT_MS when it was still 5000 ms, but it was not updated when
that macro was later raised to 10000 ms to fix PPM reset timeouts.

As a result, the two PPM communication paths are now inconsistent: the
polling path in ucsi_reset_ppm() respects the 10 second timeout, while
the event-driven completion path still uses 5 seconds. On machines where
the firmware is slow to respond during boot (e.g. some Lenovo ThinkPad
models such as the E14 Gen 7), commands sent after the PPM reset, such
as SET_NOTIFICATION_ENABLE and GET_CAPABILITY, can exceed 5 seconds and
cause UCSI initialization to fail with:

    ucsi_acpi USBC000:00: error -ETIMEDOUT: PPM init failed

Once UCSI init aborts, USB-C PD negotiation never completes, which in
turn blocks USB-C dock enumeration since the dock depends on a successful
PD contract.

Replace the hardcoded 5 * HZ with msecs_to_jiffies(UCSI_TIMEOUT_MS) so
that both communication paths share a single, consistent timeout value,
and future adjustments to UCSI_TIMEOUT_MS are picked up automatically.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221740
Link: https://bugzilla.kernel.org/show_bug.cgi?id=2183790
Fixes: bf4f9ae1cb08c ("usb: typec: ucsi: increase timeout for PPM reset operations")
Cc: stable@vger.kernel.org
Signed-off-by: Huang Wei <huangwei@kylinos.cn>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Fedor Pchelkin <boddah8794@gmail.com>
Link: https://patch.msgid.link/20260805085725.389761-1-huangwei@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -78,7 +78,8 @@ int ucsi_sync_control_common(struct ucsi
 	if (ret)
 		goto out_clear_bit;
 
-	if (!wait_for_completion_timeout(&ucsi->complete, 5 * HZ))
+	if (!wait_for_completion_timeout(&ucsi->complete,
+					 msecs_to_jiffies(UCSI_TIMEOUT_MS)))
 		ret = -ETIMEDOUT;
 
 out_clear_bit:


