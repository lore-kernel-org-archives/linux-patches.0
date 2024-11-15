Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E911618A92D;
	Fri, 15 Nov 2024 06:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653699; cv=none; b=AYwtxAka7ayFSMapmbGPZyHhQ2TNbOzJOtW2gxj0p+6uaZ4t4+JoyMvceSUg7TVrhHCGbX6vuaLYdr8NL50wfG65gL1scXkO0nphB1QtbpIgElwkg/axT7zVSgpXvux0H7xj+GLK7YKzbRIeyfP4+IJP7pZPfVZxGFzYG/eeu+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653699; c=relaxed/simple;
	bh=Nbl5RmyJY2OaV7EKHzKsN863KHy5tfTXOLGbBTr3+xU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ro+65dZzwMFviwZStU1PwMYMbMaL7itrnuQF6wLP2nX9TqkLMzQXlDvYCtg9NaOMxoUh3FmZjjBDtABY1skLAKeCHNwh6G0LlZNPkqNzN3MUQ1TjIsn2kS+MIXd1S74Grl/Blx4A5IUxT5KlByMi510rjy13lgTXQ1nNhIovfmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JHvzbAgf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JHvzbAgf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A8FC4CED0;
	Fri, 15 Nov 2024 06:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653698;
	bh=Nbl5RmyJY2OaV7EKHzKsN863KHy5tfTXOLGbBTr3+xU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JHvzbAgfSGEBAkLyZRO44nupaDNoq0+kK+fiOHK3uYEJdEbvz2Mdoxgrz6shjhjcr
	 hydsF86owuRr3t3jezvcuC8gknJ4U7fsa41rfZ+tuhTDMqLFM/EPLT4dYPRIDBGhgp
	 JSVbuCSMRC8yRsKrNbVz2vbXhOQ+9QwdK4t0KX4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Beno=C3=AEt=20Sevens?= <bsevens@google.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 11/82] HID: core: zero-initialize the report buffer
Date: Fri, 15 Nov 2024 07:37:48 +0100
Message-ID: <20241115063725.973211058@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
References: <20241115063725.561151311@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Kosina <jkosina@suse.com>

[ Upstream commit 177f25d1292c7e16e1199b39c85480f7f8815552 ]

Since the report buffer is used by all kinds of drivers in various ways, let's
zero-initialize it during allocation to make sure that it can't be ever used
to leak kernel memory via specially-crafted report.

Fixes: 27ce405039bf ("HID: fix data access in implement()")
Reported-by: Benoît Sevens <bsevens@google.com>
Acked-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 5281d693b32d2..0fef4bdb90f14 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1664,7 +1664,7 @@ u8 *hid_alloc_report_buf(struct hid_report *report, gfp_t flags)
 
 	u32 len = hid_report_len(report) + 7;
 
-	return kmalloc(len, flags);
+	return kzalloc(len, flags);
 }
 EXPORT_SYMBOL_GPL(hid_alloc_report_buf);
 
-- 
2.43.0



