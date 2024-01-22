Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FCEB3C0C;
	Tue, 23 Jan 2024 02:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975740; cv=none; b=kxRywfoDOrArEDnDNAep4MwWNe5Wy11QIQ/ZZe26k380blOfxbPQ+UvYlLzomYrTAz2ENAQJpK88W6wWRioXH9378Ef+/Wm3CcXqj7iBmKccFgJDU0Xp6y4lqVoz1z1EQ5AXEMKSdtvRDvxxXrnBWfonJ9CMMzABUZos7xQYHz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975740; c=relaxed/simple;
	bh=DgOFD4cDI6eoe9zQJvaB4Xg1nJAJwZO7WglOTtjLKOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TdBt2/3YabB2Z3Cxg4h0sddNsA1h+EPJWRJeF+QKyMqXMRwMurfbOqZbojj8C4+6J21cRtm6sIPTyDH8CWmSODyw0oTwoMhvHuEeD08BpCx1NkzTa5UnLfPSlraGod7imTiIR5g9+wHvPs2oT3QX/A3NVVsGR3YHEN32moCSkzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zcEhH66P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zcEhH66P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E537C43390;
	Tue, 23 Jan 2024 02:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975740;
	bh=DgOFD4cDI6eoe9zQJvaB4Xg1nJAJwZO7WglOTtjLKOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zcEhH66PPnyhhx68lxFs1LGdwCECgqIbO2ARJ8bbqyDWFtQFWCmUwDYItv3vJOLkY
	 B6XzNhyH1t8J408OeoKeEL7nqEHskUB4qsU9+m7l6MLeBx2txZB5+TSmdAihkXk/Kx
	 4/SIN8E7O2kCFS5xbhZxqlyYuUirPm628yBHjLnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 517/583] nvmet: re-fix tracing strncpy() warning
Date: Mon, 22 Jan 2024 15:59:28 -0800
Message-ID: <20240122235827.896190818@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 4ee7ffeb4ce50c80bc4504db6f39b25a2df6bcf4 ]

An earlier patch had tried to address a warning about a string copy with
missing zero termination:

drivers/nvme/target/trace.h:52:3: warning: ‘strncpy’ specified bound 32 equals destination size [-Wstringop-truncation]

The new version causes a different warning with some compiler versions, notably
gcc-9 and gcc-10, and also misses the zero padding that was apparently done
intentionally in the original code:

drivers/nvme/target/trace.h:56:2: error: 'strncpy' specified bound depends on the length of the source argument [-Werror=stringop-overflow=]

Change it to use strscpy_pad() with the original length, which will give
a properly padded and zero-terminated string as well as avoiding the warning.

Fixes: d86481e924a7 ("nvmet: use min of device_path and disk len")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/trace.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/nvme/target/trace.h b/drivers/nvme/target/trace.h
index 6109b3806b12..155334ddc13f 100644
--- a/drivers/nvme/target/trace.h
+++ b/drivers/nvme/target/trace.h
@@ -53,8 +53,7 @@ static inline void __assign_req_name(char *name, struct nvmet_req *req)
 		return;
 	}
 
-	strncpy(name, req->ns->device_path,
-		min_t(size_t, DISK_NAME_LEN, strlen(req->ns->device_path)));
+	strscpy_pad(name, req->ns->device_path, DISK_NAME_LEN);
 }
 #endif
 
-- 
2.43.0



