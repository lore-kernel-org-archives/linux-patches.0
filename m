Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6003D4134;
	Wed,  8 Apr 2026 18:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672949; cv=none; b=uQ+kwWJoTE2rZ+nMIZe2JVZJZ4YcCk+VPoc2hxLl3QkTRIK+RK62yxfoJL9LEWj0fyk+m3kqXex1X9setnrvz1saBLJ6GEHvKSn2x2wxxqi0xJrZyNcAzExaSBKBoA3WfuQo53aVgrzJ/wLtuNbcW0ODO0gaLBesFtk5TQQ4GM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672949; c=relaxed/simple;
	bh=0aVJQdyBYpBR6fkxRA0UtcDd+snSpECtqe0YyzfUUQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YoU+m90HcSkK3oPVlpYzwQkX3xmpXOccxU65tXm3KbI2gPOmqralRDIBEcKU5nam6Z8MKrvGHTTeowF0n7q40/fIyiHQkexT9OVStAQO2qglWSDQFTUg6bjjug4cTY3OJQqKj/GGGyob1nXD02/vUaksMcnijf9OOB7YbfB4MO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ATb1xyEJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ATb1xyEJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EFD6C19421;
	Wed,  8 Apr 2026 18:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672948;
	bh=0aVJQdyBYpBR6fkxRA0UtcDd+snSpECtqe0YyzfUUQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ATb1xyEJZ75fuYgUBykLi4nsXqxoTSfbCFPH9LjsQysME0UyjfMhoWVKgKX3YBia2
	 xmWgRZHy/Ow4bWSs4M7CmLnzLkW+pjSbDtI8K9FySltb/F0gbcgfIofNFT8l0R5Slv
	 LYvF8BRicc1VPWhHE+gFj4RR2RfcOOrCID/W+4d8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 011/277] HID: multitouch: Check to ensure report responses match the request
Date: Wed,  8 Apr 2026 19:59:56 +0200
Message-ID: <20260408175934.267481795@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lee Jones <lee@kernel.org>

[ Upstream commit e716edafedad4952fe3a4a273d2e039a84e8681a ]

It is possible for a malicious (or clumsy) device to respond to a
specific report's feature request using a completely different report
ID.  This can cause confusion in the HID core resulting in nasty
side-effects such as OOB writes.

Add a check to ensure that the report ID in the response, matches the
one that was requested.  If it doesn't, omit reporting the raw event and
return early.

Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-multitouch.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index af19e089b0122..21bfaf9bbd733 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -524,12 +524,19 @@ static void mt_get_feature(struct hid_device *hdev, struct hid_report *report)
 		dev_warn(&hdev->dev, "failed to fetch feature %d\n",
 			 report->id);
 	} else {
+		/* The report ID in the request and the response should match */
+		if (report->id != buf[0]) {
+			hid_err(hdev, "Returned feature report did not match the request\n");
+			goto free;
+		}
+
 		ret = hid_report_raw_event(hdev, HID_FEATURE_REPORT, buf,
 					   size, 0);
 		if (ret)
 			dev_warn(&hdev->dev, "failed to report feature\n");
 	}
 
+free:
 	kfree(buf);
 }
 
-- 
2.53.0



