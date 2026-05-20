Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D523F929A;
	Wed, 20 May 2026 18:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300844; cv=none; b=cl7o1tOO1KL7xsl2F92MKRk0nzXXaDJyrP8Jlz31o3yjiKOc1XKZp2toT/bC2ycuNZIRfv8KhDYhNNj7tLSUHe+h7DVylEoac5Btf++NGlwnCFzoNldOBa0v+1jGe4b4Njsdp/Y9HQytXukOPHFU6IM625xBt7M+/++WnK2fuGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300844; c=relaxed/simple;
	bh=+68rHRACDx3S22QLXYLxqx5yGhDv4Dpr+kidkevsFoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KhLhDxoDr4acMU2Srh7e2DxxLTRhS24YCEX3uJmK+HKqaSeHQP031jnlT4dAqU7PJKKX35nvJBuYBRNYcQBVGP8J8rcVsM570GlU41g/6hMeMSfLtm6SZVhE9+NjhJ3YRjHbD2Pr8pM4k6z0A6a2/42I/aN/z2jlHu0TeToQ1gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bOsL+vOT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bOsL+vOT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD941F000E9;
	Wed, 20 May 2026 18:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300842;
	bh=nGKGuV0XbdHp4an8+tYnhRx4GaHmoNwNU9cIpV57Jp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bOsL+vOT9WNvlWwdIKrASlvXy06IWUycCiYNe8b10lCpk6AOPX4RaVIEFNwKAY+xm
	 UJCduHCa+cpsYKH1MjFyi2RRoNQZGb5Kql7KWe2Vtn3sMEqRojXHSO4yPAHUc/kHBs
	 gfpIeLzL0YBHCxG0eeOic6q4t52Xv+9KHAnAAnwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Benato <denis.benato@linux.dev>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 328/666] HID: asus: do not abort probe when not necessary
Date: Wed, 20 May 2026 18:18:59 +0200
Message-ID: <20260520162118.336642811@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Denis Benato <denis.benato@linux.dev>

[ Upstream commit 7253091766ded0fd81fe8d8be9b8b835495b06e8 ]

In order to avoid dereferencing a NULL pointer asus_probe is aborted early
and control of some asus devices is transferred over hid-generic after
erroring out even when such NULL dereference cannot happen: only early
abort when the NULL dereference can happen.

Also make the code shorter and more adherent to coding standards
removing square brackets enclosing single-line if-else statements.

Fixes: d3af6ca9a8c3 ("HID: asus: fix UAF via HID_CLAIMED_INPUT validation")
Signed-off-by: Denis Benato <denis.benato@linux.dev>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-asus.c | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/hid/hid-asus.c b/drivers/hid/hid-asus.c
index cba383ccfc74c..552a049c7d148 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -1220,22 +1220,17 @@ static int asus_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	 * were freed during registration due to no usages being mapped,
 	 * leaving drvdata->input pointing to freed memory.
 	 */
-	if (!drvdata->input || !(hdev->claimed & HID_CLAIMED_INPUT)) {
-		hid_err(hdev, "Asus input not registered\n");
-		ret = -ENOMEM;
-		goto err_stop_hw;
-	}
-
-	if (drvdata->tp) {
-		drvdata->input->name = "Asus TouchPad";
-	} else {
-		drvdata->input->name = "Asus Keyboard";
-	}
+	if (drvdata->input && (hdev->claimed & HID_CLAIMED_INPUT)) {
+		if (drvdata->tp)
+			drvdata->input->name = "Asus TouchPad";
+		else
+			drvdata->input->name = "Asus Keyboard";
 
-	if (drvdata->tp) {
-		ret = asus_start_multitouch(hdev);
-		if (ret)
-			goto err_stop_hw;
+		if (drvdata->tp) {
+			ret = asus_start_multitouch(hdev);
+			if (ret)
+				goto err_stop_hw;
+		}
 	}
 
 	return 0;
-- 
2.53.0



