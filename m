Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7361E1DE3A7;
	Wed, 19 Feb 2025 08:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954699; cv=none; b=kxanhmgsLNwGG7EAng7+ddilZu9fr9v2ukXv1fQRuBT8v+kL+VXDvkU2OnQJ7wcPS4vdMkWUmQ75yR3pX4tjLUcKGBQUWb6Dt8ybXJRLGYEYDWdP3s3GebpdxCMg/t3FGopKBDfPbHmnzb5UP6FGRI8f6jpCKLbQaMtbpTX9GdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954699; c=relaxed/simple;
	bh=O3i6VOrpTPMH2NkH2rskFatMvUmDeZ0ZLTRMrB7p7V8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OOApXmyMhKxevqiaGAdEW2qIl4cpFkYqgvSmKRyFJpZzBxHEHxqmGF+yyZ7es7W759p2td1HSVUI4nRcdg/6ml1oRvkWYFHbCCjwwhZxGiSUqEXw959SNBxVIQ3I2HjVLDgQMeZ0ncxwTjlQw53jRrAGHp4YI02yObeu0Rv4ano=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UKV5llj4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UKV5llj4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD72BC4CEE6;
	Wed, 19 Feb 2025 08:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954699;
	bh=O3i6VOrpTPMH2NkH2rskFatMvUmDeZ0ZLTRMrB7p7V8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UKV5llj4FpudcQp/1wgif5yE0NUwOvxGADO9xzDq4L7r+isSwxTASGgE99HRs1OwZ
	 xVZ775jMLuyrYjt8uwifRKywRhWvQkT4sNFw/dgoFQ4MwBrYgkNcOUzrLoK5g++bDB
	 MHV730PIaa0KXVrMzSi6kF2BW1tT1HvcKG7wMBMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 010/230] HID: multitouch: Add NULL check in mt_input_configured
Date: Wed, 19 Feb 2025 09:25:27 +0100
Message-ID: <20250219082602.102552932@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 369414c92fccb..93b5c648ef82c 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1673,9 +1673,12 @@ static int mt_input_configured(struct hid_device *hdev, struct hid_input *hi)
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



