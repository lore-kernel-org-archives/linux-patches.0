Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6FA7423A8E;
	Tue, 31 Mar 2026 16:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975728; cv=none; b=sR8oHDlKVT5OclJwHZh/DdWH0qu2u3xk/+Dm5WtegmS5uPIQyB1jaGmgP5ln2YOGPoPk3pW6ieSCjxqeGDbv/isVMKBUCPwWUBD5toAXUz58jyWIP6LDXXV5xJAHv3DgoKZxmvkjI+xiquHsNzbviysWyiBt543AWluQc0/8u9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975728; c=relaxed/simple;
	bh=vIonFI4pqnAsaJU0Azcm/QfiL6Za1v4evgbzspz1U1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Khwlb7IoV4cxY6d4FhCk7tUvLydDGc1lT9wAOTZF9jryt/N/jgGRehnYys4gmgdHAR9+lFCTL2uu/tUSkb/57N91SSWu8xLx1oc9BNpQLqe9L8P7bf5XrNtWjm0y8p0f074xToOLhIg+9OlbTxbf1MIMJNW14wCmtFgCyhyPLcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ou0NWoiJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ou0NWoiJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75BF5C19423;
	Tue, 31 Mar 2026 16:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975727;
	bh=vIonFI4pqnAsaJU0Azcm/QfiL6Za1v4evgbzspz1U1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ou0NWoiJ9FyJHmQqD+MxK/1nlPwTGLX8llQBn8LsvpuGvZU/dbpK+d9m46UVo4QVA
	 zCHv/PzMTTxC3ThBpt0Aovc32bfWpG5As2DLYy1hxcRehhoPKrTkOlOTgrHw+Cm3Fz
	 +RdTInB5+oJ+ChxOgGv+7UbI5Ux5R7J3fbqn5mwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Anas Iqbal <mohd.abd.6602@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 062/244] Bluetooth: hci_ll: Fix firmware leak on error path
Date: Tue, 31 Mar 2026 18:20:12 +0200
Message-ID: <20260331161743.978925797@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anas Iqbal <mohd.abd.6602@gmail.com>

[ Upstream commit 31148a7be723aa9f2e8fbd62424825ab8d577973 ]

Smatch reports:

drivers/bluetooth/hci_ll.c:587 download_firmware() warn:
'fw' from request_firmware() not released on lines: 544.

In download_firmware(), if request_firmware() succeeds but the returned
firmware content is invalid (no data or zero size), the function returns
without releasing the firmware, resulting in a resource leak.

Fix this by calling release_firmware() before returning when
request_firmware() succeeded but the firmware content is invalid.

Fixes: 371805522f87 ("bluetooth: hci_uart: add LL protocol serdev driver support")
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Anas Iqbal <mohd.abd.6602@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_ll.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/hci_ll.c b/drivers/bluetooth/hci_ll.c
index 4a0b5c3160c2b..4d987dece2d0c 100644
--- a/drivers/bluetooth/hci_ll.c
+++ b/drivers/bluetooth/hci_ll.c
@@ -541,6 +541,8 @@ static int download_firmware(struct ll_device *lldev)
 	if (err || !fw->data || !fw->size) {
 		bt_dev_err(lldev->hu.hdev, "request_firmware failed(errno %d) for %s",
 			   err, bts_scr_name);
+		if (!err)
+			release_firmware(fw);
 		return -EINVAL;
 	}
 	ptr = (void *)fw->data;
-- 
2.51.0



