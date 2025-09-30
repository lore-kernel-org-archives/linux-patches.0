Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73037245010;
	Tue, 30 Sep 2025 15:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245967; cv=none; b=LfagV+tzdAABVRMVa3Pq4y+Y2eMLH7cdAuF13CiTO8Cz41t4Jscv7O8SPbrXuPzYAOxX67rFrR4LxuoaYXVj1/Au3vMFZgStgonq42rIWBhxx/Lc3orxn9Sq8Udok6kxbBmSuRGdZd6LUei4vqBw6MKvN87TxGmK3bO4NkAWkPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245967; c=relaxed/simple;
	bh=M2IDzM3LgnZhhoMERKs+EgcMGMkcAyp+P+wT1FB329w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ENr2KMxGeypS/EX9vTO5cd49Jxe4Zb4zhbx4fzMAS7KD/0/Fme6DrfqiN3Kkw2aAV3pk2115JQCQKGv4o7pFLY70UW7Hp66Lnxcri6n1nnGyn0bGCj+IUi6KGFoLomMVY1gqndTGXayk18yNIR6pzyH1gHx4bRhefFHTkpu9ASU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jbc4YaGz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jbc4YaGz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF95AC4CEF0;
	Tue, 30 Sep 2025 15:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245967;
	bh=M2IDzM3LgnZhhoMERKs+EgcMGMkcAyp+P+wT1FB329w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jbc4YaGzn5J+Ju1t1bvTzTak7oRbE2pAiOcT2bBbsafqt/63Z7qHbZuU8xdVHMf/F
	 /IxYQ+d/wSTDSAOmmokD9GQM08c/EnxGn8QxHgAMDGcMrP914TSSHo1ZOk6NUyPfH0
	 +hdBb5d0ZdemV5QCPWT6wNPk5pPCHu0wl2JDsJAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Tissoires <bentiss@kernel.org>,
	Kerem Karabay <kekrby@gmail.com>,
	Aditya Garg <gargaditya08@live.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 12/89] HID: multitouch: take cls->maxcontacts into account for Apple Touch Bar even without a HID_DG_CONTACTMAX field
Date: Tue, 30 Sep 2025 16:47:26 +0200
Message-ID: <20250930143822.378962516@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
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

From: Kerem Karabay <kekrby@gmail.com>

[ Upstream commit 7dfe48bdc9d38db46283f2e0281bc1626277b8bf ]

In Apple Touch Bar, the HID_DG_CONTACTMAX is not present, but the maximum
contact count is still greater than the default. Add quirks for the same.

Acked-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Kerem Karabay <kekrby@gmail.com>
Co-developed-by: Aditya Garg <gargaditya08@live.com>
Signed-off-by: Aditya Garg <gargaditya08@live.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-multitouch.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 39a8c6619876b..ec676f26800ea 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1327,6 +1327,13 @@ static int mt_touch_input_configured(struct hid_device *hdev,
 	struct input_dev *input = hi->input;
 	int ret;
 
+	/*
+	 * HID_DG_CONTACTMAX field is not present on Apple Touch Bars,
+	 * but the maximum contact count is greater than the default.
+	 */
+	if (cls->quirks & MT_QUIRK_APPLE_TOUCHBAR && cls->maxcontacts)
+		td->maxcontacts = cls->maxcontacts;
+
 	if (!td->maxcontacts)
 		td->maxcontacts = MT_DEFAULT_MAXCONTACT;
 
-- 
2.51.0



