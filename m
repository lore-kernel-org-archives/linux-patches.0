Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A403CC324;
	Tue, 16 Jun 2026 18:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633467; cv=none; b=kGZXmM5sFEV97b0V+Vtt7b8teSxeDZzkfuTcLPTLXGhfIRwwM5IvB3J+Rp53G03Twi3lU48fyGLF+ivV2c/w6Q7IGAcFRgydQq1MfNmkz9mghFI2bM0IcULvwBz4WrTyu1REj4LiKpdcPvA4xPzTVeFVX4u+oYYcJ8o646q5Fjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633467; c=relaxed/simple;
	bh=dhImHzkxptijonpEqi54G6HPeuDij8Wvz1mODJ24VKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IyRTXaneQCdZ1JxleFK94kFxK6jrpN5v4SnRaoOTWQidqKhGF3YZ6rOy2ekKyZD1BQ0UV0Zb3JVSak3QuMHHlhcYQc/nbHvnu8CzPXzb59GsA8xcJ0OBZmSFXyzEJ4kFzi7nDQmex3cOS3XNGs/SIJ153U2juShq1kr8fnqfAns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=14XjhrlT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="14XjhrlT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 283DA1F000E9;
	Tue, 16 Jun 2026 18:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633466;
	bh=xLJfiGSLuAsCTvWao2WZL5qVd56vNlRcxq2DCpluihc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=14XjhrlTXoHtSOHRJinsHpNFVMFCpnD4tPkYlQqt6MNS+UNQ5501AyChLlCxz9Aid
	 uTxBxqTBlHmeZ1LRwy/Elz5sVgqGZ7Ab/F7j1Zk11h61z2r1fZsPI7jmhChTjFunKu
	 8tzvSNegUZLcRBwYd5eZp8IyGK5BGx6Ea2OCAw08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 083/411] Input: elan_i2c - validate firmware size before use
Date: Tue, 16 Jun 2026 20:25:21 +0530
Message-ID: <20260616145104.670268275@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 76b0d0baa9ae9c60e726bbe1b6ff0bec2c993634 upstream.

Ensure that the firmware file is large enough to contain the expected
number of pages and the signature (which resides at the end of the
firmware blob) before accessing them to prevent potential out-of-bounds
reads.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/ae2dOgiFvXRm4BHo@google.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/elan_i2c_core.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/input/mouse/elan_i2c_core.c
+++ b/drivers/input/mouse/elan_i2c_core.c
@@ -646,6 +646,11 @@ static ssize_t elan_sysfs_update_fw(stru
 		return error;
 	}
 
+	if (fw->size < data->fw_signature_address + sizeof(signature)) {
+		dev_err(dev, "firmware file too small\n");
+		return -EBADF;
+	}
+
 	/* Firmware file must match signature data */
 	fw_signature = &fw->data[data->fw_signature_address];
 	if (memcmp(fw_signature, signature, sizeof(signature)) != 0) {


