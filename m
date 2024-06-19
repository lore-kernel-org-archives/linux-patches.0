Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F72313F426;
	Wed, 19 Jun 2024 13:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802131; cv=none; b=eyyILqrZ4veU/1JwGucmKwEtoZ6vZPQxV+C+h1/x2v5hUjRmFqNwVB3NtDEQY+TqJx9VzaAYDIoabzZBS3OWxc17NZDNqzrjE9UauoEBqMoaUFBJWhQzD1xa7oY+ijUzq9GdBLm3SN74vSA+xxtB0ha3i6ZCd9tck+xvAcWamLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802131; c=relaxed/simple;
	bh=G0QOgA/FNzHC/VkjkTuHg/T7nTM1BOvqQVDkCwXGOhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z0xIKVzAT94gm1eCBPrQ4rgftLqHQ0opqCBn9Yrx8hkVvRbj4JNaIAOp+Paw/aoDovi0loB0a7O3eA/l5tbC7FrNgd1TnItLjndUH/Ea4P9BO6nK7PP9BEEkLbSNbssOrvgAuMiCROhVEFR6UnBKWMm3e9eBXVzGNwPMCtuSK4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZcORBYJQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZcORBYJQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8B16C2BBFC;
	Wed, 19 Jun 2024 13:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802131;
	bh=G0QOgA/FNzHC/VkjkTuHg/T7nTM1BOvqQVDkCwXGOhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZcORBYJQz764ZM69z5xcat2oOkq9dUDfN01k1LijfihnRfLYiD5nREiCvvTSYe7qx
	 WUtU2wKF/5hpb96LZPqXSk0OJ2W11Tl5d3+xbjyzPnK+5xkldlSCrsxlX+Y6277T9n
	 cMp0EOueaA3FaEwqZtdPGW6ni8yjZ39Yp2A3cb0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aapo Vienamo <aapo.vienamo@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.6 093/267] thunderbolt: debugfs: Fix margin debugfs node creation condition
Date: Wed, 19 Jun 2024 14:54:04 +0200
Message-ID: <20240619125609.921582931@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Aapo Vienamo <aapo.vienamo@linux.intel.com>

commit 985cfe501b74f214905ab4817acee0df24627268 upstream.

The margin debugfs node controls the "Enable Margin Test" field of the
lane margining operations. This field selects between either low or high
voltage margin values for voltage margin test or left or right timing
margin values for timing margin test.

According to the USB4 specification, whether or not the "Enable Margin
Test" control applies, depends on the values of the "Independent
High/Low Voltage Margin" or "Independent Left/Right Timing Margin"
capability fields for voltage and timing margin tests respectively. The
pre-existing condition enabled the debugfs node also in the case where
both low/high or left/right margins are returned, which is incorrect.
This change only enables the debugfs node in question, if the specific
required capability values are met.

Signed-off-by: Aapo Vienamo <aapo.vienamo@linux.intel.com>
Fixes: d0f1e0c2a699 ("thunderbolt: Add support for receiver lane margining")
Cc: stable@vger.kernel.org
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/debugfs.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/thunderbolt/debugfs.c
+++ b/drivers/thunderbolt/debugfs.c
@@ -943,8 +943,9 @@ static void margining_port_init(struct t
 	debugfs_create_file("run", 0600, dir, port, &margining_run_fops);
 	debugfs_create_file("results", 0600, dir, port, &margining_results_fops);
 	debugfs_create_file("test", 0600, dir, port, &margining_test_fops);
-	if (independent_voltage_margins(usb4) ||
-	    (supports_time(usb4) && independent_time_margins(usb4)))
+	if (independent_voltage_margins(usb4) == USB4_MARGIN_CAP_0_VOLTAGE_HL ||
+	    (supports_time(usb4) &&
+	     independent_time_margins(usb4) == USB4_MARGIN_CAP_1_TIME_LR))
 		debugfs_create_file("margin", 0600, dir, port, &margining_margin_fops);
 }
 


