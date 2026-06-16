Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110353CC324;
	Tue, 16 Jun 2026 18:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633662; cv=none; b=n6A32m/tJ6zfxdKyX94rl4xTkhYNAb06bOt2gA9L6krA2hr9b1zvPTDawS+fjfZCB7HyA5RmIPwembBMRFj4d4nd/3Vzq0Fxwo4ij+MuYWEDgo6gLrvOaDgd/Unz8zoHEGFILDBd62G1j6fXy3c9pWjgPwlXsdlf3SUwr3/jr48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633662; c=relaxed/simple;
	bh=yuJhuOrQbyfIgkOE3mwdft3qEhO4wNAjGWvm5SmyTsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dac19yK83wIHQFnKU2ulokUziB3hV70FdNX734tn+ylGwP0FzHmtrvxqhfYXeKWOz3BQpDDJHZfVOw4yqoretO5j1/917s1c5hZxFswItvr19UAH9ayILtaTZb7lhuGnhFylak9j8296fY/3N7d8X+P9fTByfi7RKUxO+h47VSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NDcuYa6O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NDcuYa6O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B23C31F000E9;
	Tue, 16 Jun 2026 18:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633661;
	bh=mY5qgfNaxtwPyj3XfKq/ULKqU0Jel+KRcXOnIrXC9oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NDcuYa6OHp9ArVeSmIbL6rXIY7W0DW3mx8CC+/iteALxPbhdePQ0dl7eifSIjn4Zf
	 crvKBr0rWyuYyuGryW9XEWDmK6eDHaMD4W3yxtMlS9pNetj3dWSAfUdl0m2lZ1g02q
	 DCF8WPVn5X/aWrla5VzWRyvGhNZ8Gl7fES8OM7Hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 120/411] USB: serial: mct_u232: fix missing interrupt-in transfer sanity check
Date: Tue, 16 Jun 2026 20:25:58 +0530
Message-ID: <20260616145106.698312621@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 245aba83e3c288e176ed037a1f6b618b09e92ed8 upstream.

Add the missing sanity check on the size of interrupt-in transfers to
avoid parsing stale or uninitialised slab data (and leaking it to user
space).

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/mct_u232.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/serial/mct_u232.c
+++ b/drivers/usb/serial/mct_u232.c
@@ -543,6 +543,11 @@ static void mct_u232_read_int_callback(s
 		goto exit;
 	}
 
+	if (urb->actual_length < 2) {
+		dev_warn_ratelimited(&port->dev, "short interrupt-in packet\n");
+		goto exit;
+	}
+
 	/*
 	 * The interrupt-in pipe signals exceptional conditions (modem line
 	 * signal changes and errors). data[0] holds MSR, data[1] holds LSR.


