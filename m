Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC76B43C04B;
	Thu, 30 Jul 2026 15:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424648; cv=none; b=C37VwpkhGuFzYSZZpYaf5rPdOl2b7M6i3HpbkB/tTpmtVR9aNTO6BXQXtR9v8Dgt8FMRQcbZx9aSnx87KGlmWbOPF0m1B8DxGAUH4yYvQik8C+gt1rUu8V2QWJDJcX3ps/kv4oJpDfpKVyeEgTD0mo4CPvJ6/OFVvqRoK/m2hug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424648; c=relaxed/simple;
	bh=0ZxvXvXBdTWZnBAAQv4l7bbwh5latK8mAySYeIPT9T8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MBNGSifIjk6AG70/i4CGxsI23KNXNMvbiBllvOXLWeHO2KB/Gmt0HjzzJCXYAwleNTp3vM1SVrgEYKHG/F9Ye6K7aubQrkYMaH3fxiK40z6o8KqCphbvUSSrd5GVbz6oyV+T/ozobKQTLeMUMXcgxsf/d4qQDXJXHsQQJe3EgOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qr/QZZjA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qr/QZZjA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D884B1F000E9;
	Thu, 30 Jul 2026 15:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424646;
	bh=idhAudsA4Wt/1704oiBD4goD5u6zs5FauSmYjtLPMuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qr/QZZjAdfv7s8/BzymWW/DSQDXjQ1q0YUFz6BxkW55/cHgpIWYF5f9WdatUDJ34V
	 mV18Yp4D+HRTLfPT3C5SZGj2fv7xf66t838i2HHYtvpcC2FEas77dxMoxJJcmiYHQm
	 srwD5OTX1ct4ZfcNQdRexAijYS61Ei+aWZIoTZSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Zi <me@ziyao.cc>,
	Xi Ruoyao <xry111@xry111.site>,
	Zixing Liu <liushuyu@aosc.io>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 468/675] platform/loongarch: laptop: Explicitly reset bl_powered state when suspend
Date: Thu, 30 Jul 2026 16:13:18 +0200
Message-ID: <20260730141455.076518531@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Zixing Liu <liushuyu@aosc.io>

commit 91a70492c03040d51b36f595530d6491d5d6c541 upstream.

On EAECIS NL60R with EC firmware version 1.11, resuming from S3 has a
very high chance (>90%) of causing the EC to lose the previous backlight
power state. When this happens, the laptop resumes normally from S3, but
the backlight remains off (when shining on the screen with a flash light,
we can see the screen contents are updating normally).

Since there is no generic way to query the EC's backlight state on
Loongson laptop platforms, assume the worst-case scenario and restart
the backlight power inside the kernel each time the system resumes.

Cc: stable@vger.kernel.org
Fixes: 53c762b47f72 ("platform/loongarch: laptop: Add backlight power control support")
Tested-by: Yao Zi <me@ziyao.cc>
Tested-by: Xi Ruoyao <xry111@xry111.site>
Signed-off-by: Zixing Liu <liushuyu@aosc.io>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/loongarch/loongson-laptop.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/platform/loongarch/loongson-laptop.c
+++ b/drivers/platform/loongarch/loongson-laptop.c
@@ -189,6 +189,7 @@ static int __init setup_acpi_notify(stru
 
 static int loongson_hotkey_suspend(struct device *dev)
 {
+	bl_powered = false;
 	return 0;
 }
 


