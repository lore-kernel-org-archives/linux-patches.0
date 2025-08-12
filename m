Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8702E7BD4;
	Tue, 12 Aug 2025 18:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022042; cv=none; b=dfPydxOF5AwZiMPvxalpTXMLEkJND1hvLd4mZGwr08z1UQgKStBx8yz+Rf5jty+VNYejKujqhdqyjQlYUB3caZ78XbuR2uXRLU1uWOzBGPgLjhVAodS7fBLlMJ1WJOVDXGENcBE33nGHcMXpVnGNM4AnH9TaMOfa9LBPBBvjlJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022042; c=relaxed/simple;
	bh=JI+QqJ9iHxX/k0h+brwFkQ6aKTKNs2kBgmAkEu70Aqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X7FsWQVN5UKP6ee1g2P3ZkG/bxoMyybBd/HUjVBiZiKFjrlT8Aqag4UbcMgQYjtSP01aMlPJZphPiMhj3cFo383Dp2PYBl2MRdGET6ZzEijxMqdjuOoCxFizYDIxVbZdtg4Hf/vIiCjC2/7BtqcW94eGfl3DS22aCwMMUpIUX4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hzFQVnTh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hzFQVnTh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D283BC4CEF0;
	Tue, 12 Aug 2025 18:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022042;
	bh=JI+QqJ9iHxX/k0h+brwFkQ6aKTKNs2kBgmAkEu70Aqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hzFQVnThNHZdyLcGMmLocKzrfYPa9EkNNc1PWMP/6FJTr/VGlhE7Hq8SmffTgbqFq
	 DfECzTYg2LHr5Am4ByiAVDXNkxXsVqsz0r+F0eHMKQQbG5n9bCa6MLZwj99NGLTTUv
	 MGibDQqCRsVubySjKEox0gTX2+tny1dfib9i84CA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hansg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 039/369] mei: vsc: Unset the event callback on remove and probe errors
Date: Tue, 12 Aug 2025 19:25:36 +0200
Message-ID: <20250812173016.230423308@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

From: Hans de Goede <hansg@kernel.org>

[ Upstream commit 6175c6974095f8ca7e5f8d593171512f3e5bd453 ]

Make mei_vsc_remove() properly unset the callback to avoid a dead callback
sticking around after probe errors or unbinding of the platform driver.

Fixes: 386a766c4169 ("mei: Add MEI hardware support for IVSC device")
Signed-off-by: Hans de Goede <hansg@kernel.org>
Link: https://lore.kernel.org/r/20250623085052.12347-8-hansg@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/mei/platform-vsc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/misc/mei/platform-vsc.c b/drivers/misc/mei/platform-vsc.c
index 20a11b299bcd..ab80bd3271b2 100644
--- a/drivers/misc/mei/platform-vsc.c
+++ b/drivers/misc/mei/platform-vsc.c
@@ -379,6 +379,8 @@ static int mei_vsc_probe(struct platform_device *pdev)
 err_cancel:
 	mei_cancel_work(mei_dev);
 
+	vsc_tp_register_event_cb(tp, NULL, NULL);
+
 	mei_disable_interrupts(mei_dev);
 
 	return ret;
@@ -387,11 +389,14 @@ static int mei_vsc_probe(struct platform_device *pdev)
 static void mei_vsc_remove(struct platform_device *pdev)
 {
 	struct mei_device *mei_dev = platform_get_drvdata(pdev);
+	struct mei_vsc_hw *hw = mei_dev_to_vsc_hw(mei_dev);
 
 	pm_runtime_disable(mei_dev->dev);
 
 	mei_stop(mei_dev);
 
+	vsc_tp_register_event_cb(hw->tp, NULL, NULL);
+
 	mei_disable_interrupts(mei_dev);
 
 	mei_deregister(mei_dev);
-- 
2.39.5



