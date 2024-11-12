Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96DC213EF8;
	Tue, 12 Nov 2024 10:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407622; cv=none; b=WM1/9uMFx+XWYEYbsmFJYhwa8iqVCSPvRNuWjcsPvGtOuZoAOVcqGKxlHrAiTWMZKxeazRCDBY5eUM8/ie0fWbLS1++TmBrKYXiHO6kfQd/O46fN1ZGR6ju5ueUKgqn3kAyT/8yldC/bUTJPymIl2WbOYeKhd1Vq2QbP7N5clvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407622; c=relaxed/simple;
	bh=ZRDFNyvTOaZLHNyzDkYV6A2rFMz5uuXjF0qUO/yqjPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HfhbsTI/CNXXrZzP4HltpDmlU9oUqjtjvFBtUW/6bSVpHEsCNoILCGzr4cM+QOCKO/tpjsgv8HrrnYVpJHCshTVG6qWzOCtmmYIfvXaaTx0FAke/R5V3tEigbNBzYEg6tuDou1rLqR6x4IO6wJAT24joNGyZyKkcjlXHI3uDWkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zOWIF1a4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zOWIF1a4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A995C4CECD;
	Tue, 12 Nov 2024 10:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407622;
	bh=ZRDFNyvTOaZLHNyzDkYV6A2rFMz5uuXjF0qUO/yqjPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zOWIF1a4KLcZAilAPnRKK/RgDr4Qm/MZA4dQeFasTvHaj2i9sL+YNR4SvYmy4LdFT
	 G9FVLjJmx9+/XEbQgIPLgr+Zvd+7s/DXheN88usxrELCr9M4ApCYXbLJH3qBwt0PZ6
	 muEaXS7AVavilh2H+IA1URZSmbUrg17PKKDZimog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Beno=C3=AEt=20Sevens?= <bsevens@google.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 024/119] HID: core: zero-initialize the report buffer
Date: Tue, 12 Nov 2024 11:20:32 +0100
Message-ID: <20241112101849.636601751@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 85ddeb13a3fae..1467c5a732db4 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1875,7 +1875,7 @@ u8 *hid_alloc_report_buf(struct hid_report *report, gfp_t flags)
 
 	u32 len = hid_report_len(report) + 7;
 
-	return kmalloc(len, flags);
+	return kzalloc(len, flags);
 }
 EXPORT_SYMBOL_GPL(hid_alloc_report_buf);
 
-- 
2.43.0



