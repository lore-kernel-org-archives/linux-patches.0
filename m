Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274883876CF;
	Tue, 16 Jun 2026 16:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628580; cv=none; b=lR1Mdt8Sb9hFovJUBguqfTk48u0iPWO+LJsu9EdqL/4tywocKI3nZ/jvHcyark1rlrnU5DrfYr8fX6ZN4lqLsTIsUn+6TmuYNOwDhuqZF9Exci/H3WwdiwLpE3hfiPaTm8Ur56n61OmkaIFZJUFjkIEFVpv2fdd2DR9p5in6AEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628580; c=relaxed/simple;
	bh=+/+gI1QhQKC95tbkCpGRkIB7OD0Z8lWbtIZe1dDZ2Po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YVBWCrBl1iq8Pkcd6T0f/kiTcBqE4qQDSsFpt0TobcXg/Var7iX1zdtx8gmWlD31g6J0xAy0PXjzxzdwfch+IqW33x8yuTOvjZ63l9WYak1RVx/DaEmsgcPmc+8w5GMYsx0KSkPJNEb7W4MrDcjtgfGzNC4MFHQvP1YBe5ZejCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1h5nHYuE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1h5nHYuE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6D91F000E9;
	Tue, 16 Jun 2026 16:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628579;
	bh=pb21t1ZOrcrd2cvEuoTJmBV2kMoG1BsaMCoZ9hRQaew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1h5nHYuEH6f5lHeVCL3t5OktscjKG5/oSeZok6Ed5KmFLzRHlN6J9LYeW5WH3XWeL
	 F3cYtr5KEDWQ1TIdT1oqaIZ5Ue1JMcM4bWrQh3sC2q6BYAumOvS3gJ57+7I3q/aUuR
	 o9aU4Qd4DczjqDCyF4UJyxlxnJ6BrL5R8l1mPIJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 123/452] Input: elan_i2c - validate firmware size before use
Date: Tue, 16 Jun 2026 20:25:50 +0530
Message-ID: <20260616145124.205510112@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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


