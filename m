Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6871DC998;
	Tue, 27 May 2025 17:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365437; cv=none; b=E+KDhmRU8rV4e1NwogtEIIxyWqmkPXxXFRwAiS7Wt4RNS/GMrFm7AbAssgTrcMZ4vSKZTZ3y6NhebPQupzW312O8YLa4RD4lq7TxZKBiNvHouAniRc/3993OqSOoApiifYvGz9R1JASOaQEwDbrhuXOjokl4V0FHWWil1DKVQeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365437; c=relaxed/simple;
	bh=xt3CeJuNKuQa9OeJ4+nf5Y5lyuG5sdH8zNkb6Hj+zuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cdMr6MrdMlOghA6gYAAnAeEmhXvt59WGKZzHbKWBYsYO0/8mYdNlp/i8n8ChibrGaWw4ZN6ezrdz6ISbHK0jGWT000awkKWQe20J8VIBTvPfZwjuCj9ntfyhYwCzuYZBUXOUG2bJH5cElUJm1kmQbjUZBG9Vv4fmLe+xy88jTRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LypG1Bo4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LypG1Bo4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AA3EC4CEEB;
	Tue, 27 May 2025 17:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365437;
	bh=xt3CeJuNKuQa9OeJ4+nf5Y5lyuG5sdH8zNkb6Hj+zuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LypG1Bo4Enng3+4nTjcLzHFDRFwdj3nktC4sUGaADObNnzmaPn4jP3JinZsVdRCHW
	 bSkwUwqF7euikMhnXDSqYFo8M2eYGWbut0MasvKbspO8ixVuWxOGW+AmFIJc+UFVp5
	 8GMAde701uygBiC2YagQrRadNWMPGTssEq37fn2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Wang <x.wang@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Fei Yang <fei.yang@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 374/626] drm/xe/debugfs: fixed the return value of wedged_mode_set
Date: Tue, 27 May 2025 18:24:27 +0200
Message-ID: <20250527162500.216576933@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Xin Wang <x.wang@intel.com>

[ Upstream commit 6884d2051011f4db9e2f0b85709c79a8ced13bd6 ]

It is generally expected that the write() function should return a
positive value indicating the number of bytes written or a negative
error code if an error occurs. Returning 0 is unusual and can lead
to unexpected behavior.

When the user program writes the same value to wedged_mode twice in
a row, a lockup will occur, because the value expected to be
returned by the write() function inside the program should be equal
to the actual written value instead of 0.

To reproduce the issue:
echo 1 > /sys/kernel/debug/dri/0/wedged_mode
echo 1 > /sys/kernel/debug/dri/0/wedged_mode   <- lockup here

Signed-off-by: Xin Wang <x.wang@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Fei Yang <fei.yang@intel.com>
Cc: Shuicheng Lin <shuicheng.lin@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250213223615.2327367-1-x.wang@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_debugfs.c b/drivers/gpu/drm/xe/xe_debugfs.c
index fe4319eb13fdf..051a37e477f4c 100644
--- a/drivers/gpu/drm/xe/xe_debugfs.c
+++ b/drivers/gpu/drm/xe/xe_debugfs.c
@@ -147,7 +147,7 @@ static ssize_t wedged_mode_set(struct file *f, const char __user *ubuf,
 		return -EINVAL;
 
 	if (xe->wedged.mode == wedged_mode)
-		return 0;
+		return size;
 
 	xe->wedged.mode = wedged_mode;
 
-- 
2.39.5



