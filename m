Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B273A4F4B;
	Tue, 21 Jul 2026 19:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663252; cv=none; b=lvBKqiUf3y7pQng4qq5SJnzsfySrk+KJNjWucavZZLcA9sNLUuLnFbjx66Ph9MkrH0weJn2Gy95yOk1EaKdq2t0Rr7dRwowCl3DYWtX+ukwvZNb6SbckvCLQeP0uDD0Q9biPf+oAiSFGaBYYTQKL6d2RZswsheddqG70GjYbEw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663252; c=relaxed/simple;
	bh=pBPQys5RmrWZafIa6S70QJHFbgMJUR8l18Sr+/+I7DE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tLQCVgTrHVQX+607hrjZsDocCiY2nMy6ESM9+184CSMcEPRUww/N+GGGP9pkvSFFJdvLJHwCndkXhckzk49yrdSROnCjHdsrtV1yOkYBzweb0D6utWDyZ+B0M8noAU39IyDAOkdYzoChmZ0c05smb4jQLNHT6LIGhNjDl4c0I/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PTeN1iSr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PTeN1iSr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA13C1F000E9;
	Tue, 21 Jul 2026 19:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663250;
	bh=taO8/G9RxKdpionACXYUIJIxPwrNQD6m2tdXIYZh7b8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PTeN1iSrUEe3J4S8zm1+ZBgMKXZtg1PB7O5R0Slt6ReyGD50yxoRyfelNClicXTK2
	 o4yQZyUqSaRdtv5Y5RcS5KGKuq/0K0DYFLl1qcc4HNBbFSmsHAEm0TZjDgp8CKQMg9
	 3iNHmsChcqg2TgOrahPMzf92pO/AQORhcsKdlrBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgiy Osokin <g.osokin@auroraos.dev>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0753/1276] HID: picolcd: prevent NULL pointer dereference in picolcd_send_and_wait()
Date: Tue, 21 Jul 2026 17:19:56 +0200
Message-ID: <20260721152502.929593795@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Georgiy Osokin <g.osokin@auroraos.dev>

[ Upstream commit 0021eb09041f021c079be1022934a280f7f176c0 ]

In picolcd_send_and_wait(), an integer overflow of the signed loop counter
'k' can theoretically lead to a NULL pointer dereference of 'raw_data'.
If the loop executes more than INT_MAX times, 'k' becomes negative,
making the condition 'k < size' true even when 'size' is 0.

Change the type of 'k' to 'unsigned int' to prevent the overflow and
eliminate the out-of-bounds access.

Found by Linux Verification Center (linuxtesting.org) with the Svace static
analysis tool.

[jkosina@suse.com: extended hash length]
Fixes: fabdbf2fd22fa17 ("HID: picoLCD: split driver code")
Signed-off-by: Georgiy Osokin <g.osokin@auroraos.dev>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-picolcd_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-picolcd_core.c b/drivers/hid/hid-picolcd_core.c
index 297103be338157..282f11ec5df741 100644
--- a/drivers/hid/hid-picolcd_core.c
+++ b/drivers/hid/hid-picolcd_core.c
@@ -72,7 +72,8 @@ struct picolcd_pending *picolcd_send_and_wait(struct hid_device *hdev,
 	struct picolcd_pending *work;
 	struct hid_report *report = picolcd_out_report(report_id, hdev);
 	unsigned long flags;
-	int i, j, k;
+	int i, j;
+	unsigned int k;
 
 	if (!report || !data)
 		return NULL;
-- 
2.53.0



