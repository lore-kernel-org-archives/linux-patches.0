Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8543A3E78;
	Tue, 16 Jun 2026 17:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630898; cv=none; b=S6PZX2tD8ncaB5pIEVb2n5JR9vEuAJRxoLV+WenZWQiFk23wTQXiEWcsrENK7C+559BK2SaPuluE1dvGiq1mqGa1IenCETUK1+r7IXl+YZlcSSnJkMNLy/oMdN6wGxzk84VqLfsI8f7uM4150PRfZOkR5Z7uAtxu5nbeUj+m/tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630898; c=relaxed/simple;
	bh=1W0Th9IAdNoLknYIk2M3IrtRTXfATEWEXbuJRlf4mTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BlfGzqQviGbSyyrzBGiNTFfvmgFcuKHVngavnUe/v3tURnlaJeuGGtVDk/tK1r6uZ+5pAXNZ3vPTgxMkxn21sHOKv6TYbir9fYYHoV3mNNuXZ7UddIewWi+NIV5kPWVOiKCnm/Z1tjrZlPGPGpAVQ+r7RxD5GNQBNYwSKOfx7Do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O96yPWpM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O96yPWpM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45D61F00A3A;
	Tue, 16 Jun 2026 17:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630895;
	bh=MVBiA6k1ekSEa8ErPAaB4ssmyxbSWd0uCrIW0fKw2nY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O96yPWpMpOq+rFTsXlWSKn1RhZ11+EaFvrGTyfX2lA9cYMfn1X9U37tEHhcvdtksV
	 4GDXh/6FU7C4DEsEi2oqtWfnRSh8quBrGsOkspMqBiw9BqBwO6ZGuf6n2EtFXBJvBA
	 Xtp8zIFF8asEscB34Wq5VdT5UehXQa6sut5OjFIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 118/522] Input: elan_i2c - validate firmware size before use
Date: Tue, 16 Jun 2026 20:24:25 +0530
Message-ID: <20260616145131.493328465@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


