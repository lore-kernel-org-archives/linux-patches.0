Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FE125DB0D;
	Tue, 11 Mar 2025 15:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705866; cv=none; b=WO8BG4LGBa7MY6aGcy3KEjeO47cJhh2mD2aNXKi8H5e5giBWRxhnHtjIf4imC1bBfRcFd7IV5Lb5nY8gWJDiEIaWeBvXUdnIQZXIIEryw505GT8VKzRrUkAz8e23fPhuaCf+GVvs+rGbSGrQNHacPGqsJo0ES6uXTXJH8NXmgaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705866; c=relaxed/simple;
	bh=Qj4QAnVcZ/Fz+ofw4DqlHSZ5rdPGuab+cnB9JkXQzro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RqcM28inept6ds7tvyG4BOXW9U695BGu8uTBbgamwhghRrlMdSvH5eJ9pp2j5LXiEh2mrpwSJ4tClKhO+Oz3WTKSNN3XIHLSgp2W5f+4k3oiBx4NUKBI62kDBoG+T9hYRCMZpk2lw19JBSXSOkeQKi7Rhf3Zd1XO5JiPkwKWU3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uvwa9Bpv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uvwa9Bpv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14565C4CEE9;
	Tue, 11 Mar 2025 15:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705866;
	bh=Qj4QAnVcZ/Fz+ofw4DqlHSZ5rdPGuab+cnB9JkXQzro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uvwa9Bpvoqvhn2q+GmP7UU8d+bJ8fYgVsQVupG2KwcrnlVsZ1nOq9O2N0CXI4G/Tt
	 +XJLa6nlz0xChRA/zmP5xHinQDueVZ/RkJOPk26qhyAKlFkzA00bXphF2GeLw0vbri
	 jQIbgjeUKYxUoc/3EHt91Q6QEw4s18On1j41My80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 162/328] HID: multitouch: Add NULL check in mt_input_configured
Date: Tue, 11 Mar 2025 15:58:52 +0100
Message-ID: <20250311145721.344143822@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 5994e7d1b82d9..cb0bbba5c1c95 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1601,9 +1601,12 @@ static int mt_input_configured(struct hid_device *hdev, struct hid_input *hi)
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



