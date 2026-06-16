Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B7C36A36C;
	Tue, 16 Jun 2026 18:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633892; cv=none; b=p9V68GDoLLLXqDaA9o3m0B2MMZhkkyf6a5k4hG6Cz+/n4AoLjZUBdstqDc0adkc7XoJZMnNQzmqT1rIVTnRPzduBFpSM7elCuz37Hktf54Oudakh6uLWczxlVNynDA4/wcle4ZSqzS1wO59ZTkOqd9lTxvtJlWJtCASL1oQYdPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633892; c=relaxed/simple;
	bh=z4k332f8CnXqzgpRh22v7/cY3DaL+4t6ka/AzyDd3Vo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eFwygv6eJhvzGeHKF6iHgFI/ak9cEjXLX5U74Ydehm3A+1afIOTFYo9BnYuyY8WLgHjyZIOWiNAuqvRUJpCZ+omq4sJhjbYHYxGVL1M5zg48z9eW8Svs7PjtXMg5jWWZbEQO51Z7NgAWDPmRLhHv72/iincSJObuwOZJYuImIr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QVAq2kVR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QVAq2kVR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5BF01F000E9;
	Tue, 16 Jun 2026 18:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633891;
	bh=pdMvtyGkmnzpKUmbKDYfardvosdm/b6A+6/LHF03G8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QVAq2kVRsoqc9yV6ukKtnbyFWn19rX4TTu+1RtonKq/OaTk+oKcMoGFTiIPSKZuhK
	 5LE1xdoobYUiEiW+IH/B2W+/kB5zKIB8aDECRSyv5mPGM4aKuTnoZCTihxHIH94vjg
	 dRD+REc/8U7ZfTz2eYbGbgBg4LN3JhAF4GRgPVTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: [PATCH 5.15 130/411] serial: zs: Fix swapped RI/DSR modem line transition counting
Date: Tue, 16 Jun 2026 20:26:08 +0530
Message-ID: <20260616145107.255596438@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit d15cd40cb1858f75846eaafa9a6bca841b790a92 upstream.

Fix a thinko in the status interrupt handler that has caused counters
for the RI and DSR modem line transitions to be used for the other line
each.

Fixes: 8b4a40809e53 ("zs: move to the serial subsystem")
Cc: stable <stable@kernel.org>
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Link: https://patch.msgid.link/alpine.DEB.2.21.2604101747110.29980@angie.orcam.me.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/zs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/zs.c
+++ b/drivers/tty/serial/zs.c
@@ -679,9 +679,9 @@ static void zs_status_handle(struct zs_p
 			uart_handle_dcd_change(uport,
 					       zport->mctrl & TIOCM_CAR);
 		if (delta & TIOCM_RNG)
-			uport->icount.dsr++;
-		if (delta & TIOCM_DSR)
 			uport->icount.rng++;
+		if (delta & TIOCM_DSR)
+			uport->icount.dsr++;
 
 		if (delta)
 			wake_up_interruptible(&uport->state->port.delta_msr_wait);


