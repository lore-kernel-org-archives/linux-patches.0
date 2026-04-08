Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4815A324B1F;
	Wed,  8 Apr 2026 18:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672499; cv=none; b=qJ7iK2bFCWbXbRw9MNqu6KxEQX9e4V4ulHu4Q0KbXEhGDJqTI6U8V0iJBtglEC0ngW4s1TuAvoIF58k3JKvhsfyI/+wxYuqe8JPd4BHYZ/PKNPi1wqhcgt4vSbNqzjBLYvoIbl2cOKgKxcuY8v7F6CpqoTc1e3MOFul+UXFG5sI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672499; c=relaxed/simple;
	bh=QW1QXpGLPzn7wvKn7cHaSBmAGyMS+9RX0nija80CROA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=de6KuM3O78E+EL69leaB9TWyIuHfV0ZPs6RiYGEKHHKG8QgQt1wuQU4q80owT666nSgtGZjmGFMuuGgflLE9JIr5m/jCN0SfOkqD7970R1G51pj4f36Try1yO9x9ftb77oXGbeIymutZ6y1ok/SFp4vzeyirBZBCJFmQkSG99fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H5uNJEQz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H5uNJEQz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E910C19421;
	Wed,  8 Apr 2026 18:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672498;
	bh=QW1QXpGLPzn7wvKn7cHaSBmAGyMS+9RX0nija80CROA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H5uNJEQzcZdHGnWGRj2qRC+XHRwocw8MIq1lhcxRorvH78g5KguElQ+YqD4DQrxCU
	 6E7Lj9p9mr7beUAIAQrh1Ng29Yi76uR0eghmZmJTNPdlXrUUTw4qne7RpiIErKxy5c
	 eJkpLIAqb62mQMKefQYCYAsb3cpA+yRdxyI9bEQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 007/160] HID: multitouch: Check to ensure report responses match the request
Date: Wed,  8 Apr 2026 20:01:34 +0200
Message-ID: <20260408175913.459385199@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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
index b6c2cb7153fde..0039508943626 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -472,12 +472,19 @@ static void mt_get_feature(struct hid_device *hdev, struct hid_report *report)
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



