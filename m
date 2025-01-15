Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC8A248BA6;
	Wed, 15 Jan 2025 10:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938343; cv=none; b=SRTfIyEyFD1jF75thB3xDgFYA5oKOs2+GT7/fWdI4MEN0ELeO22i0TyHqWlEqjvzM4uq42kUKeyh9f8uNg5Zus2/TO4kfGs6kQ1k0k8amgdKPnqoWaBfqtOc30frWaji/qADdJHQSSE+0iwwn7iCmEdwIYWRA/+gwFjMkd1aVEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938343; c=relaxed/simple;
	bh=bOBLWda86GNmDpoqCG/o8YFjeRwjbSMcsuGFcmTsryc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FesFkgOp4WZdwDpzL881GXbL9Vck0e965vimwwy7vDxxQXZjBRa7Jyp+T+0RsN0Wtel/cfNsRVAH6FbhYJg2/eV++nXCvtnHbsW4L5sWfosIGoLKqTk/2yh4KqKm3SrBKur3WTDjM+bA/Lj5w1TR0frXzkulCxUnYCAO3dJuk88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nUt/LzSQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nUt/LzSQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE7AC4CEDF;
	Wed, 15 Jan 2025 10:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938343;
	bh=bOBLWda86GNmDpoqCG/o8YFjeRwjbSMcsuGFcmTsryc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nUt/LzSQWb/Sip89jfU82px19WgPR2FqTexFByWDUkoQtQboh2+k3IBI8w2dSyt4j
	 cS0Bw5VV+ZYC3cW/+KkV5BnzwcnuH1iQvzvQN27k4ce5i4rJA+lSm+BaM/cpm0jJ5u
	 9lgx/OJAGeZROAnG7WSzwFu45zTVaEpM2/1wXugM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ingo Rohloff <ingo.rohloff@lauterbach.com>
Subject: [PATCH 6.12 154/189] usb: gadget: configfs: Ignore trailing LF for user strings to cdev
Date: Wed, 15 Jan 2025 11:37:30 +0100
Message-ID: <20250115103612.555721959@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

From: Ingo Rohloff <ingo.rohloff@lauterbach.com>

commit 9466545720e231fc02acd69b5f4e9138e09a26f6 upstream.

Since commit c033563220e0f7a8
("usb: gadget: configfs: Attach arbitrary strings to cdev")
a user can provide extra string descriptors to a USB gadget via configfs.

For "manufacturer", "product", "serialnumber", setting the string via
configfs ignores a trailing LF.

For the arbitrary strings the LF was not ignored.

This patch ignores a trailing LF to make this consistent with the existing
behavior for "manufacturer", ...  string descriptors.

Fixes: c033563220e0 ("usb: gadget: configfs: Attach arbitrary strings to cdev")
Cc: stable <stable@kernel.org>
Signed-off-by: Ingo Rohloff <ingo.rohloff@lauterbach.com>
Link: https://lore.kernel.org/r/20241212154114.29295-1-ingo.rohloff@lauterbach.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/configfs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/configfs.c b/drivers/usb/gadget/configfs.c
index 6499a88d346c..fba2a56dae97 100644
--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -827,11 +827,15 @@ static ssize_t gadget_string_s_store(struct config_item *item, const char *page,
 {
 	struct gadget_string *string = to_gadget_string(item);
 	int size = min(sizeof(string->string), len + 1);
+	ssize_t cpy_len;
 
 	if (len > USB_MAX_STRING_LEN)
 		return -EINVAL;
 
-	return strscpy(string->string, page, size);
+	cpy_len = strscpy(string->string, page, size);
+	if (cpy_len > 0 && string->string[cpy_len - 1] == '\n')
+		string->string[cpy_len - 1] = 0;
+	return len;
 }
 CONFIGFS_ATTR(gadget_string_, s);
 
-- 
2.48.0



