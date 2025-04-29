Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8506C243364;
	Tue, 29 Apr 2025 17:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946750; cv=none; b=SrhBwoVmAuqWuu1L+toEO1z8lgdtzUzvXrG+iPvC4i570eRfLaoyHxbZ/rR0iLxXqz+SJJUxE9CWa2RdO5P0GFax8Iw/NaFxOsNFY/9sTkj8k04nxTowCsOkhqjWtgLL47+1o7K+ZWvh/5z8a0smah111CxsBAV8G0d7ryBcdfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946750; c=relaxed/simple;
	bh=WVl82863RtOHQMb404BDv2DXpYTS7QzWys4FXMkjKvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IAv7wNk5NlbOQvmgxD17TP/og/JWRI1m0NEXJWyCA2GRHOrxIP8pMweX/tif7mZ3CNhkz+h4LQFCtMv5eDNxyX85MWyi3afzvyOj/flqqJgaQVk86B9VPByIb2Lzw3XwcjeZyYS1mXbDDsYDrdIX2vIMX9685iLRH7z+N+Z2YKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rDd8MgCM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rDd8MgCM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0152C4CEE3;
	Tue, 29 Apr 2025 17:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946750;
	bh=WVl82863RtOHQMb404BDv2DXpYTS7QzWys4FXMkjKvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rDd8MgCMk9M6mP1+9QE/+Yp6JVIvIikb4AAlzcaHccxlbUOvAK1QF9UkZ4CUQV8fq
	 AcjYxfM8vxCjYe5cZsu1aAaCwA5L0oh/5ejmkyBRqFtTiq4+nWauHFbhKtveIb93Gh
	 HOqmTNCXD1lisZCZVVFuJy7nFblTPL4ZeSttspHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5.10 057/286] media: siano: Fix error handling in smsdvb_module_init()
Date: Tue, 29 Apr 2025 18:39:21 +0200
Message-ID: <20250429161110.193422646@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuan Can <yuancan@huawei.com>

commit 734ac57e47b3bdd140a1119e2c4e8e6f8ef8b33d upstream.

The smsdvb_module_init() returns without checking the retval from
smscore_register_hotplug().
If the smscore_register_hotplug() failed, the module failed to install,
leaving the smsdvb_debugfs not unregistered.

Fixes: 3f6b87cff66b ("[media] siano: allow showing the complete statistics via debugfs")
Cc: stable@vger.kernel.org
Signed-off-by: Yuan Can <yuancan@huawei.com>
Acked-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/common/siano/smsdvb-main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/common/siano/smsdvb-main.c
+++ b/drivers/media/common/siano/smsdvb-main.c
@@ -1210,6 +1210,8 @@ static int __init smsdvb_module_init(voi
 	smsdvb_debugfs_register();
 
 	rc = smscore_register_hotplug(smsdvb_hotplug);
+	if (rc)
+		smsdvb_debugfs_unregister();
 
 	pr_debug("\n");
 


