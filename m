Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09308269D18;
	Tue, 21 Jul 2026 18:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659082; cv=none; b=bZni9Gh14B7iKgqHrdMO75qChOjVAkmKFAjcYIp/zyuDnujBEZySgraHIXX+u/+I7eWeUHCgq5Y5uDXYkyYnorB2wWmHiDe7q+7OE5NOzEp08BrARbFTCcuXd/5424RklKJukI9sdjsYtluFBdoJFk9oxF0cPi+cHGdv3qQEplE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659082; c=relaxed/simple;
	bh=LwUcjnl0UlcO4BUdtGehjX9vkeYKmGNHW8I+GZXQpio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s/isVOq7lJQMGPISfPpqWS2imJjkluAAFNVJJltT6TJeQmzv1VGNnp2Zt4EU9KJSqY7hY9tJIvQFXt/Wa2t/BX1b03i0wk4MU8LcN58yn21ZD/O1JxpzjZ7BroyhBlANs0tPJoMuAeex7eAhqQkp7D4ixKbTlF0M7mAQhtMiq54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KGkSbx8z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KGkSbx8z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E9C1F00A3D;
	Tue, 21 Jul 2026 18:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659078;
	bh=QlKs/7/ZIL40o0/f3W6Z7m5m8fvmk1W6650iSZcgUik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KGkSbx8zztF+6GnQ2Bm70kexhBSYe7mbtEybJGdXCT2bEYVa34VnqJSbdG4/zwAVn
	 WQXmyUJPEtlg/DE+YakVO4A40p21WD4JIzVMlm/4ZH/hfPXJ7mK7pm4RFxP7/FeH0x
	 eoyeWWHybWWYp4wVsQ3dCFnPmDv+BmUD0rmpyhXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 1383/1611] Input: ims-pcu - fix race condition in reset_device sysfs callback
Date: Tue, 21 Jul 2026 17:24:59 +0200
Message-ID: <20260721152546.550311078@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 411b8c4b274737c3bf08e1e025801161603cfffc upstream.

The ims_pcu_reset_device() sysfs callback calls ims_pcu_execute_command()
without acquiring pcu->cmd_mutex. This can lead to data races and
corruption of the shared command buffer if triggered concurrently with
other commands.

Acquire pcu->cmd_mutex before calling ims_pcu_execute_command().

Fixes: 628329d52474 ("Input: add IMS Passenger Control Unit driver")
Cc: stable@vger.kernel.org
Reported-by: Sashiko bot <sashiko-bot@kernel.org>
Assisted-by: Gemini:gemini-3.1-pro
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/ims-pcu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/input/misc/ims-pcu.c
+++ b/drivers/input/misc/ims-pcu.c
@@ -1166,6 +1166,8 @@ static ssize_t ims_pcu_reset_device(stru
 
 	dev_info(pcu->dev, "Attempting to reset device\n");
 
+	guard(mutex)(&pcu->cmd_mutex);
+
 	error = ims_pcu_execute_command(pcu, PCU_RESET, &reset_byte, 1);
 	if (error) {
 		dev_info(pcu->dev,


