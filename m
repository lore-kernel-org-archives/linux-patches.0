Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACBA248881;
	Wed, 25 Feb 2026 01:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983611; cv=none; b=Fy/lyxvlx9K6ssfX8Thxxi+g9Kz6SJU4a8mHpOr/yl6CG8cfcOOPAJS+fewI+Z7zjFO44BRcG5X8eYaAHjPytFXrKcXSnWDAH7YRsfOJyxqN6vi2WmSR+zqbDWKWgxMNSh3HM2bV5SfMlYcQMtB3rRZ4LL01rjsyMfIMNTqxwuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983611; c=relaxed/simple;
	bh=Rk6/ez/L8oCsU7jYWhJuuXvpcpYf45bFdHqC2IMcEHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fFGQHIBpuwmEAoaHibnccBAFKAvtabiZR5Pb4qt1QGnL4/IO4vpTko+82e2wWOenIfFpwwXGdbomJheNRI9pnEiHklj2SZZ6KjJD1ziI+tgbyuZaFmw0LqOGFk8x4tMDJfm9Y1zbjPcggoiLPoiiV961wKqamwCNIVSDt8Mp1pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=poDqyujx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="poDqyujx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45111C19423;
	Wed, 25 Feb 2026 01:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983611;
	bh=Rk6/ez/L8oCsU7jYWhJuuXvpcpYf45bFdHqC2IMcEHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=poDqyujxTtHVR5IJHAc4a7tEy3EqAuRZ6x3uOa0fxFYvO8aIj9cZGzL3XBqBITeZ7
	 fx3TDf7spw35BgqRbdE+sFFF5mZIFvp9hQl4YTs7feTj8vuUpzLX52zA+kvh56ag5n
	 zE9mSogxWJLbL5piuzs6BN/XPv+7jwDKcXhPTpqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Zilin Guan <zilin@seu.edu.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 706/781] drm/amdgpu: Fix memory leak in amdgpu_acpi_enumerate_xcc()
Date: Tue, 24 Feb 2026 17:23:35 -0800
Message-ID: <20260225012417.067197384@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit c9be63d565789b56ca7b0197e2cb78a3671f95a8 ]

In amdgpu_acpi_enumerate_xcc(), if amdgpu_acpi_dev_init() returns -ENOMEM,
the function returns directly without releasing the allocated xcc_info,
resulting in a memory leak.

Fix this by ensuring that xcc_info is properly freed in the error paths.

Compile tested only. Issue found using a prototype static analysis tool
and code review.

Fixes: 4d5275ab0b18 ("drm/amdgpu: Add parsing of acpi xcc objects")
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
index d31460a9e9582..7c9d8a6d0bfdb 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
@@ -1135,8 +1135,10 @@ static int amdgpu_acpi_enumerate_xcc(void)
 		if (!dev_info)
 			ret = amdgpu_acpi_dev_init(&dev_info, xcc_info, sbdf);
 
-		if (ret == -ENOMEM)
+		if (ret == -ENOMEM) {
+			kfree(xcc_info);
 			return ret;
+		}
 
 		if (!dev_info) {
 			kfree(xcc_info);
-- 
2.51.0



