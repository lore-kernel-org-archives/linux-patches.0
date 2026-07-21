Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3980C39A7FD;
	Tue, 21 Jul 2026 19:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660659; cv=none; b=DLDVCQJ3p050N7JTVesRKtUDHGtRPpIdvw4TA0ffKmjtKxLhLW7P0v7x0xGWuCrU39BVMvMjNzf+NJhU5Qj1qFochcOHyFkmoYKPyQutNIBvKle2KY1gmDdQ9XroF/AzSwiVofHFiNhZKfbxqTpq03kx1NjYg0OyEBUShVXxdDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660659; c=relaxed/simple;
	bh=H8yJT1iQXZkL4nOuGhw3gDKnDNZVM9mXLQYOBxigSQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lIBIacmwIy3TJFnPmA5E+86l2u0wkw0O6AZByPrhvdQdBrNI5OqXXt2YMa+iOtpPjfZoe5tkeRIMb6kAs7G46B9Ju1RJTHYevo3EHCqHeOpmA9tFzDPm32+Rv+7vlqdmv6QpHYRi9GXzv1YCA5dmc9bEjZWKjWeR55jdN7tRw6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U+By8a1b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U+By8a1b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0721F00A3E;
	Tue, 21 Jul 2026 19:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660658;
	bh=UZeT0kLQRqNNHCuhIgVlPRPNf3K1qyfq2GosCO9xExk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U+By8a1bX5D6M0Hk3KdZa0oH2H6SKKObwFS02FPSOj/NkwHQiaVv/rlSlEhbHIFDB
	 wsKU6BeIrhfElBV3FncG11ig58f5XJvk50KF/1GGp/EL9+3Fsc27xRAv9GgLtDWRjd
	 MMory9JSjoBwl4+V3p+D1bm5dSzhX2PaPDRYFESI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Kan Liang <kan.liang@intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1019/2077] tools lib api: Fix filename__write_int() writing uninitialized stack data
Date: Tue, 21 Jul 2026 17:11:32 +0200
Message-ID: <20260721152616.856538276@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 438ece06185696e14c63c6113d5e2d34ec0a9680 ]

filename__write_int() formats an integer into a 64-byte buffer with
sprintf() then passes sizeof(buf) (64) as the write length.  This
writes all 64 bytes including uninitialized stack data past the
formatted string.  Most sysfs files reject the oversized write,
making the function always return -1.

Fix by capturing the sprintf() return value and using it as the
write length.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Fixes: 3b00ea938653d136 ("tools lib api fs: Add sysfs__write_int function")
Cc: Kan Liang <kan.liang@intel.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/api/fs/fs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/lib/api/fs/fs.c b/tools/lib/api/fs/fs.c
index 3cc302d4c47b16..d16911818d4d35 100644
--- a/tools/lib/api/fs/fs.c
+++ b/tools/lib/api/fs/fs.c
@@ -376,12 +376,13 @@ int filename__write_int(const char *filename, int value)
 {
 	int fd = open(filename, O_WRONLY), err = -1;
 	char buf[64];
+	int len;
 
 	if (fd < 0)
 		return -errno;
 
-	sprintf(buf, "%d", value);
-	if (write(fd, buf, sizeof(buf)) == sizeof(buf))
+	len = sprintf(buf, "%d", value);
+	if (write(fd, buf, len) == len)
 		err = 0;
 
 	close(fd);
-- 
2.53.0



