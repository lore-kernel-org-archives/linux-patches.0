Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A26920DD62;
	Tue, 12 Nov 2024 10:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407340; cv=none; b=qOX5z4jDtjV7jDUENW1kvWlmqOsHyjKcGCCUG7dbFuiThKtc6l5DG8XdG3hcasyoHVclZ0foAab2FQPhwNATtOoCsG0c84lD0IzP4SwARQkkkXrq/WG8oE0d7ZAEVSseXaQOrOoBhfojD9fbKhn/7E4z4cWNdxL+7IU+iVBfbAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407340; c=relaxed/simple;
	bh=NGcC9zJ6wJmrdUSRp5A9/5WOFxFoWv/GbPWLd9r2eg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ABpH4ubze0WG7bTrXS76Fi10DQBb1eGNf3c5K+8Mn0V23OoCTYvREFlmcrZ14gSLme2MSvQQlNG3wD7HQJuwgx3KU+APzmgAfjiQjpU1d8ObuxVGeGMnBR2meLAVMBZ/vcVM92G8HljmhdvzAsLy4W+gqbJCtI2VXkKxbw3JddU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pz0WUmDS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pz0WUmDS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C1BC4CECD;
	Tue, 12 Nov 2024 10:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407340;
	bh=NGcC9zJ6wJmrdUSRp5A9/5WOFxFoWv/GbPWLd9r2eg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pz0WUmDSzry4j453EpqAnIE9DlZ4Nvma9VQyJZI8c07vkvAEf63CBW1Iu7RRXRHbL
	 z0qxQPG6ifNnGXAtkWgvWoVAskUX7Y4Q9bKNQiF8IHExohb1gAHqHnPot1A/fFdC6W
	 ePe6GlWtR7LB6n1M6ITVXI/QRyCBmaJVPvyXuyU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Beno=C3=AEt=20Sevens?= <bsevens@google.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 16/98] HID: core: zero-initialize the report buffer
Date: Tue, 12 Nov 2024 11:20:31 +0100
Message-ID: <20241112101844.888730261@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e2e52aa0eeba9..b5887658c6af6 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1878,7 +1878,7 @@ u8 *hid_alloc_report_buf(struct hid_report *report, gfp_t flags)
 
 	u32 len = hid_report_len(report) + 7;
 
-	return kmalloc(len, flags);
+	return kzalloc(len, flags);
 }
 EXPORT_SYMBOL_GPL(hid_alloc_report_buf);
 
-- 
2.43.0



