Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542812D3A69;
	Sun,  7 Jun 2026 10:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828710; cv=none; b=agz2UdVChCqUtDlRrceYUzSYiK75TMFEwZmKnaI+66IDoqFoOXnsglM+gNyE6XO/aNeecarZz29GrBwWFNhaC4aRr31MkgSFz/rtEZjq74TZLgOxOdBFZseHPBvANq9/ZxnAWCMBsr9zWLGcuMkIvnNU68L5v94b+i2HEXqhD6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828710; c=relaxed/simple;
	bh=BCJhY60iKyCgumRNYYrj2ZaT2NK0ZRvng2PqGJVOsqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s74G8GhflR61Y0AjP6Fkcdj08/VcZrsEw3kN4JABZLU1ZmNLAAbbvNdRoy5bbTZ2aww/QEYrMm7RkI/DMbAwhRz5bG5lNeufwR0T5TP/oMMhvKN6XZBWIgGNeNO2ev22llk6WpdssdtqIKJ1QDCELYma1Oplzxrcm/9x7/xLiw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jr/308dm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jr/308dm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6288E1F00893;
	Sun,  7 Jun 2026 10:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828709;
	bh=bdFjrj36CS4UADTyGAxSwcBxBR86LqgvSIk+uEg8jPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jr/308dmMZpJrlfXEbxzEYS24zZVutbq7/xLTyst/7VbS9I4Lz6p9xrK96lAdy7QQ
	 ct45AR2BTAFplZRmk1RsKxBvVrDU+ACBWd2naT6R5c8ofDIQ45kkNhmmcGqTN0KsNX
	 +nKXscHoTO9OERR7DlxSbdTtYpW7//9YnyuRyqjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.0 205/332] Input: elan_i2c - validate firmware size before use
Date: Sun,  7 Jun 2026 11:59:34 +0200
Message-ID: <20260607095735.595080279@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -645,6 +645,11 @@ static ssize_t elan_sysfs_update_fw(stru
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


