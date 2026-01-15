Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB823EDAA0;
	Thu, 15 Jan 2026 17:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499470; cv=none; b=AW3kYFSabf5fW/wb2VMowLNbDCBO/9JuD2/G+XaGEOiNbu7QUEKU1rZS8I2BxbZ2OcUhJ2u3NsOKt6FmWAy7k41MG4EWku51tpjmT7RLNUKDLYpAUnKcbzowXZIsLqi7WGleMYktfqhFRsd1JyB+Tx5gLB6X7isaylOm63c4MvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499470; c=relaxed/simple;
	bh=A00Bl6qZaKvmkANKp2ymBjBnNmx39I3nrqCP3yp7wig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lfboSSOy7v+JhJHsSUKGwleKGLb5DkNc26XmsdelYE5THagebA08+tAT9Tjg6qMXWf4jlbN3C51Kd7Ylv6FiEsVCFkR2Z8CBtTHHiI1s2dYP0CalAS7CExZZmQwEZtOY1Eo/ThUQRjpOTOGFhOgzv8ytHlc2oih2l8FG4vaYXCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wiPfB3wf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wiPfB3wf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25792C19425;
	Thu, 15 Jan 2026 17:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499470;
	bh=A00Bl6qZaKvmkANKp2ymBjBnNmx39I3nrqCP3yp7wig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wiPfB3wfvZ28E94KakvlATUTpi1fujuKiUfJM0NY0jGhGsTwX9QggaQIkGYS9/hvY
	 vYULv3Kk0pHuDqNID+0uKiep93da4JqQv9CrjqlNUS40mGGODHSLOLgx+x2+kiZDKQ
	 CaVZwPO6u6DUkjllaGzfFDawxZaHF+GIfthwMFIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junjie Cao <junjie.cao@intel.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 195/451] Input: ti_am335x_tsc - fix off-by-one error in wire_order validation
Date: Thu, 15 Jan 2026 17:46:36 +0100
Message-ID: <20260115164237.955524860@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

From: Junjie Cao <junjie.cao@intel.com>

commit 248d3a73a0167dce15ba100477c3e778c4787178 upstream.

The current validation 'wire_order[i] > ARRAY_SIZE(config_pins)' allows
wire_order[i] to equal ARRAY_SIZE(config_pins), which causes out-of-bounds
access when used as index in 'config_pins[wire_order[i]]'.

Since config_pins has 4 elements (indices 0-3), the valid range for
wire_order should be 0-3. Fix the off-by-one error by using >= instead
of > in the validation check.

Signed-off-by: Junjie Cao <junjie.cao@intel.com>
Link: https://patch.msgid.link/20251114062817.852698-1-junjie.cao@intel.com
Fixes: bb76dc09ddfc ("input: ti_am33x_tsc: Order of TSC wires, made configurable")
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/ti_am335x_tsc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/touchscreen/ti_am335x_tsc.c
+++ b/drivers/input/touchscreen/ti_am335x_tsc.c
@@ -86,7 +86,7 @@ static int titsc_config_wires(struct tit
 		wire_order[i] = ts_dev->config_inp[i] & 0x0F;
 		if (WARN_ON(analog_line[i] > 7))
 			return -EINVAL;
-		if (WARN_ON(wire_order[i] > ARRAY_SIZE(config_pins)))
+		if (WARN_ON(wire_order[i] >= ARRAY_SIZE(config_pins)))
 			return -EINVAL;
 	}
 


