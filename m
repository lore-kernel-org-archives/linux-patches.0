Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519EB25F797;
	Tue, 11 Nov 2025 01:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824455; cv=none; b=kCEtt24ODTDu1dW5Hl+JvfqDyVeB9BjqIhbr+YbUZpHjfaptBOT9H1DOzAEaI+fp72zg/fJQp7qg79IATELlQeZPrHxbZs7tiSLaJ3M32xyn2FkJV6RucZP9kDIyz5GzxwNjntMrNPBNc0Zd36pqKxXzpN03p1AyQz+rRA5TF6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824455; c=relaxed/simple;
	bh=E/Qs3gRZTD8mnP1GR8JeRfbBd4ZMUyHpG72uAQl1o/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SXmVuZGRadPmZjy6bFgVWgGvaDdjwQi3EaWWxaAZA2Pqm8CljqYWysq+9C2mOj48NWGwb/Kb0IA8+0eScPpVzxAsLp3QWhTgK/iJYXuFy69LLAF8s9tUbpEqJe7byAMl7zYDKlqsmv5azvMqWI6c6pGS33yUKA0vrKTctYsEotw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y4BMoyu0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y4BMoyu0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E53CBC113D0;
	Tue, 11 Nov 2025 01:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824455;
	bh=E/Qs3gRZTD8mnP1GR8JeRfbBd4ZMUyHpG72uAQl1o/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y4BMoyu0Gv454l6zUu4vNWDHeKAHT91zX+3tT3P2xgN56KUs/laH9/ueo0OZBoel+
	 QjQewOOyPj444c9l0LurHQWhMKIHvhUGP+TKPoNQaEpgoxpimuYN8U9x1Sw4l+0V6o
	 d7rlupqKHuFVWLKBjmeLQbPqTaPLLyldMPR4XBl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 503/849] fbcon: Use screen info to find primary device
Date: Tue, 11 Nov 2025 09:41:13 +0900
Message-ID: <20251111004548.594036299@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello (AMD) <superm1@kernel.org>

[ Upstream commit ad90860bd10ee3ed387077aed88828b139339976 ]

On systems with non VGA GPUs fbcon can't find the primary GPU because
video_is_primary_device() only checks the VGA arbiter.

Add a screen info check to video_is_primary_device() so that callers
can get accurate data on such systems.

Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Suggested-by: Thomas Zimmermann <tzimmermann@suse.de>
Suggested-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://lore.kernel.org/r/20250811162606.587759-4-superm1@kernel.org
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/video/video-common.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/x86/video/video-common.c b/arch/x86/video/video-common.c
index 81fc97a2a837a..e0aeee99bc99e 100644
--- a/arch/x86/video/video-common.c
+++ b/arch/x86/video/video-common.c
@@ -9,6 +9,7 @@
 
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/screen_info.h>
 #include <linux/vgaarb.h>
 
 #include <asm/video.h>
@@ -27,6 +28,11 @@ EXPORT_SYMBOL(pgprot_framebuffer);
 
 bool video_is_primary_device(struct device *dev)
 {
+#ifdef CONFIG_SCREEN_INFO
+	struct screen_info *si = &screen_info;
+	struct resource res[SCREEN_INFO_MAX_RESOURCES];
+	ssize_t i, numres;
+#endif
 	struct pci_dev *pdev;
 
 	if (!dev_is_pci(dev))
@@ -34,7 +40,24 @@ bool video_is_primary_device(struct device *dev)
 
 	pdev = to_pci_dev(dev);
 
-	return (pdev == vga_default_device());
+	if (!pci_is_display(pdev))
+		return false;
+
+	if (pdev == vga_default_device())
+		return true;
+
+#ifdef CONFIG_SCREEN_INFO
+	numres = screen_info_resources(si, res, ARRAY_SIZE(res));
+	for (i = 0; i < numres; ++i) {
+		if (!(res[i].flags & IORESOURCE_MEM))
+			continue;
+
+		if (pci_find_resource(pdev, &res[i]))
+			return true;
+	}
+#endif
+
+	return false;
 }
 EXPORT_SYMBOL(video_is_primary_device);
 
-- 
2.51.0



