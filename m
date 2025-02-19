Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A64155753;
	Wed, 19 Feb 2025 08:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739953835; cv=none; b=jFjrCUbnJxhxeAKtz5g/TRIf4AWoVKmw6HdpQEITcWnVCo3iNEqOff/QnBZt/wEpa7mrLzAt9WPMtiawZ6BntbbonZ3/fEz14SklHu0pYKgLaTTwzcF6YXKiff4SQLr+u03Rd81Eq/9NxXYLek4bwTMlyc+Qjx8+CUVPosXUMPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739953835; c=relaxed/simple;
	bh=UvWW3FJrvK6fFryn71boterP599IFTEKFLCQYjneDFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hKKRqAmo/kUyt4HvqswO+tc6ZpuaK1daDsWs+fhZHqRLXLX+0HRvi7kUfKMGnbC6cslEcE+DVusfV0/x9RteJlx1EkkYESXlMkG3U4u+28TWCenhYZ4RuYQ6qBZxQxSbWPubd85kkwgRPLLkzJ/G1Nd1K17lyg5n1GgdWPqdajk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PbdA03J9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PbdA03J9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A83C4CEE7;
	Wed, 19 Feb 2025 08:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739953834;
	bh=UvWW3FJrvK6fFryn71boterP599IFTEKFLCQYjneDFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PbdA03J9TCxlWG+C2LJE3g+YqySrKJ3ZCIclJ3uii+/AUT4J0FOEKZ77vlf24Bs3i
	 oEvj2w2VcPkrCrTsSPfqhey3yAAK92QF4U5X0JdhINP8bzMS8pDqE7VeP6dsLwv413
	 rGCv3S2hKgJ/1raP7ju4lVWEAhbAkMouoyzPCnAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 013/274] HID: multitouch: Add NULL check in mt_input_configured
Date: Wed, 19 Feb 2025 09:24:27 +0100
Message-ID: <20250219082610.057633555@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 82900857bfd87..e50887a6d22c2 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1679,9 +1679,12 @@ static int mt_input_configured(struct hid_device *hdev, struct hid_input *hi)
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



