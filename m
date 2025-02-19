Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5333B1A841F;
	Wed, 19 Feb 2025 08:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955505; cv=none; b=EUrCbnDITj2Nm6WDOa/KlbeLPh+UHHy+bb10GJ8XzeUCa2uu2VFziP2bzucz0y0TkF3Q1wdTeGQd6iu9kZatHvAL3Q52S73kE2vh7XonI/AFEw9DVQX93gzHdRdDJ0uWLtB9nm7nMT/1SLMj0BpQYQp+QG1lrmHtWRJ/v9DN3og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955505; c=relaxed/simple;
	bh=+vwtQkmq3ZRhEt0Z1y7MRBDdTpKQKQ/2IGK+xClhelo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HKNXL8lumTCcKI1q78qpESDb5HN54RmE/3qTyQtdsgbR3VIBaYgAESwIiwsieYuH+1etmpR8P5Y5kqWZWG/NvbyPTJZh2RO4eNTK8Za7oJq0Q+kIIp5LKRzOX4SgdBGha/V2S3TNU3ZO+HVG7dh4UoVYFo/RMwLaNBSpHyaMT+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S1zG8MUF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S1zG8MUF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE15BC4CED1;
	Wed, 19 Feb 2025 08:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955505;
	bh=+vwtQkmq3ZRhEt0Z1y7MRBDdTpKQKQ/2IGK+xClhelo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S1zG8MUFfrJ10M8cMg3OMUyTU3mh7bOfaJ6LOZ7NRH/glcnmn9dPwgT4Y6audcavM
	 HKuc9WKYZeYB89zhDyoSxuBf4RbG0/U0n10vM/ajrogoIRxnGlW/8/NVhkZHwoFGdK
	 CSYgNZihcegttp4kU6VQv5lJcHgYoJByCEcWI4fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 004/152] HID: multitouch: Add NULL check in mt_input_configured
Date: Wed, 19 Feb 2025 09:26:57 +0100
Message-ID: <20250219082550.197660638@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Charles Han <hanchunchao@inspur.com>

[ Upstream commit 9b8e2220d3a052a690b1d1b23019673e612494c5 ]

devm_kasprintf() can return a NULL pointer on failure,but this
returned value in mt_input_configured() is not checked.
Add NULL check in mt_input_configured(), to handle kernel NULL
pointer dereference error.

Fixes: 479439463529 ("HID: multitouch: Correct devm device reference for hidinput input_dev name")
Signed-off-by: Charles Han <hanchunchao@inspur.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-multitouch.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 5ad871a7d1a44..6386043aab0bb 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1668,9 +1668,12 @@ static int mt_input_configured(struct hid_device *hdev, struct hid_input *hi)
 		break;
 	}
 
-	if (suffix)
+	if (suffix) {
 		hi->input->name = devm_kasprintf(&hdev->dev, GFP_KERNEL,
 						 "%s %s", hdev->name, suffix);
+		if (!hi->input->name)
+			return -ENOMEM;
+	}
 
 	return 0;
 }
-- 
2.39.5



