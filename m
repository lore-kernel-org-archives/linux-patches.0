Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57728367B63;
	Tue, 21 Jul 2026 22:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673130; cv=none; b=ir4zqbTrZ6wDVKCpArFHgShFjt4CB3rpV9OP2IEOYNA9EScAkCB66po3UqkfpKPNEAkIJRP4RcVlsoba5CHYwL72i/2Uonp6nfTWzn2C4OolQgMxzgT3WyIpWRGL6vlq8SnUg32tKWK32mY0J3iX3c8IXGjlynkEQZ2MK/EmOLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673130; c=relaxed/simple;
	bh=wRBL5V6saEtjEUFlTYQtdpECUPQJLsdVxKsrHPIywjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IowKUVmMZ8UIu1aOZWHGqlQGx7UfX0P3xxf8SRcHhZRc2SnYoInYZ6OXdNSRyOkd6wJksQH9Gb7mM/qv2kmaaY1xaKsCgjzS2v6+M3BYRx5xfRlPi82kyOqGuKlnbERhHe7irbM/rlXqzqkV7q58pxUsC0Lxgg0zkhYXxUHIJIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kHFYEer6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kHFYEer6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2811F000E9;
	Tue, 21 Jul 2026 22:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673129;
	bh=69pt1ZNmE9CEkOfjflamnbJrucGXStXYSYWfJwjoaSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kHFYEer6SUFfgLH7pC6X1fIdh2Wrm/cY4ix6PTVKflileBxoXY4uLfZhE4CzsbvdF
	 IVlgwSa2e3p4ZYKG5wrz9uhisdP+/3DEVmWOS30Dm6+mKgHsSV1e5t5T+CjUh66pHS
	 B0Vz//MskkXWAmgOgatSeUBVgzuSfZoUevsk9pKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 5.10 047/699] iio: light: opt3001: fix missing state reset on timeout
Date: Tue, 21 Jul 2026 17:16:46 +0200
Message-ID: <20260721152356.771556558@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Crofts <joshua.crofts1@gmail.com>

commit c123ca6ee26ad98f70a866ff428b08145c5a24fe upstream.

Currently in the function opt3001_get_processed(), there is a check
that directly returns -ETIMEDOUT if the conversion IRQ times out,
completely bypassing the err label, leaving ok_to_ignore_lock
permanently true, potentially breaking the device's falling threshold
interrupt detection.

Assign -ETIMEDOUT to the return variable and jump to the error label
to ensure ok_to_ignore_lock is properly reset.

Fixes: 26d90b559057 ("iio: light: opt3001: Fixed timeout error when 0 lux")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260525-opt3001-cleanup-v4-0-65b36a174f78%40gmail.com?part=1
Signed-off-by: Joshua Crofts <joshua.crofts1@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/opt3001.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/iio/light/opt3001.c
+++ b/drivers/iio/light/opt3001.c
@@ -280,8 +280,10 @@ static int opt3001_get_lux(struct opt300
 		ret = wait_event_timeout(opt->result_ready_queue,
 				opt->result_ready,
 				msecs_to_jiffies(OPT3001_RESULT_READY_LONG));
-		if (ret == 0)
-			return -ETIMEDOUT;
+		if (ret == 0) {
+			ret = -ETIMEDOUT;
+			goto err;
+		}
 	} else {
 		/* Sleep for result ready time */
 		timeout = (opt->int_time == OPT3001_INT_TIME_SHORT) ?


