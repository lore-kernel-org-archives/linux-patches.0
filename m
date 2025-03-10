Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A0E22DFF3;
	Mon, 10 Mar 2025 17:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629562; cv=none; b=bFQcNzbHV0Znc4b6Nl3h/nIFI4/FzeCCQosbREQ14kuLKGFOi9y1tyU11sF01fxSFJwien3UCjHT7LHdyRcBYVo6Y72yh7Bhv1nVPPg/LGe3yAdUoDT1xizy2smIQCwT2tOG6gXHKgYZuCt4R4mWiUxwUPV69WTpBxX2/rHIuW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629562; c=relaxed/simple;
	bh=C9Ny0UdSJDX9Ywfo6j3MqmHiLmCVKghZbx0Kgd1RaDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TgprLpfjYnB+VXOGawigCZvpwDr+wWfT/0ORfCIXyvjhu1vD1565R5p7uls5ycpPTEWYVN0sCj82XQwG10/+HAubvXsLllmy3yaWL7zdnH97H9BKhKY7T5c1HFXr5SF7xtdmdoinTYlrwnqhwRRnYHlDZIelg1SME0OKFNQh9BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nOxsbalC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nOxsbalC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11DFCC4CEE5;
	Mon, 10 Mar 2025 17:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629562;
	bh=C9Ny0UdSJDX9Ywfo6j3MqmHiLmCVKghZbx0Kgd1RaDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nOxsbalCpfSscqz3bWcLh2nvC0Mi0bg+Y1BgbR6syRDN6lTzzkbA2YgMnAZz1AFJS
	 G6JDHwHInlrkJgM1ihQ1mE89VU3pBHySMcvcwf36cOK6TaOc1rig2dHuYuD2ORw+Aj
	 0Ghm0q/k3+FCd+uC4mGNwVExKxeJHBtJ3ZJXTmvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 337/620] HID: multitouch: Add NULL check in mt_input_configured
Date: Mon, 10 Mar 2025 18:03:03 +0100
Message-ID: <20250310170558.913108460@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index df7b620fa23ee..bc9ba011ff607 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1671,9 +1671,12 @@ static int mt_input_configured(struct hid_device *hdev, struct hid_input *hi)
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



