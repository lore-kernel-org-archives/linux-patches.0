Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C963BBEB;
	Fri, 15 Nov 2024 06:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731652973; cv=none; b=hCCKO2gchgtcVBWV47Tyn84awIJVrSpACZvFM5/H6h0m5HUbNuDJUzKuIF3DGFC7th798cqRxEESnXqXMO5hiIUxZKFjhWkksm+7bpD+VtM8iH3yiiADF8W4GMORQz8Ah5E8bFuPlOSjCA1b5hbhTFp264CthfHlxIfCGWrd5Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731652973; c=relaxed/simple;
	bh=jGKA14LnH6KPx7pF4KiFBWiIIG0wkbdv+6PDEJIEPk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X4ZBxIwu1KjPW9t4bMgRbnwiRAg5IxZs7o9b3ha1e4PVMHqnUqXBZAZ/Rqedr/mmMlmWpK3TBGKfnCNz8Ghsv6uP4ih4VZFL64rR5VZ/KtfSYqJG22mqWfeVGo/+Fd8IZGlH4gf1E4naKjNxiVSjXYaq45nhsOO1mIt4inMje5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sx3J9GpN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sx3J9GpN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83B4AC4CECF;
	Fri, 15 Nov 2024 06:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731652973;
	bh=jGKA14LnH6KPx7pF4KiFBWiIIG0wkbdv+6PDEJIEPk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sx3J9GpN7FtyBW5yTEnF4k+WHt8FTMLBw1fveU26k7HPmzRzLmf9zHBvmcgbfobEK
	 6WULpgCbkZY+xdYdBhpLKkKttnzxr1PMfjTfZo+yLf/SkDsC9kw7KkxfLTzOdrbHc0
	 qJOUW8fqJf2fHGP8w7cE35aJ/95WDeEc/vqZfWFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Beno=C3=AEt=20Sevens?= <bsevens@google.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 09/66] HID: core: zero-initialize the report buffer
Date: Fri, 15 Nov 2024 07:37:18 +0100
Message-ID: <20241115063723.177865856@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.834793938@linuxfoundation.org>
References: <20241115063722.834793938@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 2462be8c4ae65..10ee4d3269b96 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1657,7 +1657,7 @@ u8 *hid_alloc_report_buf(struct hid_report *report, gfp_t flags)
 
 	u32 len = hid_report_len(report) + 7;
 
-	return kmalloc(len, flags);
+	return kzalloc(len, flags);
 }
 EXPORT_SYMBOL_GPL(hid_alloc_report_buf);
 
-- 
2.43.0



