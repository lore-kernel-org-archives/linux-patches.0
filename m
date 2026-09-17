Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2FD55172F5;
	Thu, 17 Sep 2026 16:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664280; cv=none; b=XHZuXKQf7EEO+qI+0Xby/YEQQbACp4bJBhSabf4HuZfxyH8/0XXsG0dhOa0j1FekKJIqi8gVxRscChOOc73zpHcu6auShNfb+FEM9nojOnd2CwM8955EyBata6eGvafPrLb/4zTO3L5W1r4FYmyE3TIi39CBx9E/DUH9pS0qLnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664280; c=relaxed/simple;
	bh=Zn91s31nka3MRBj2sL4b7xYluABjKt+CpR/g1TBLuiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VYGM29AVS8VWnxPu6GXwySa3vu6kUfzBUmhk1QS5FK+nrhFTqSt9GEIuiLlboKQW7UR6PLFrgnD287QY5cPV/8EMMwj5915upHphR/maAUQGfjhR24oNbtFWBn0ITrusXUNfrMG5z8I5hdINjGxpxL8wq7K8RZPryYSIuxAqrSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HdkZSb7k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HdkZSb7k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1248D1F00893;
	Thu, 17 Sep 2026 16:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664279;
	bh=jMXKMlsg7qnZ8wNZ9nDJhWhGg5139W3aZcBydhqmKF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HdkZSb7kn88ZJesYv2ie4wq1STs2xNkpxKihvP7y6bpSFy1yvDoQvOHsAJ1qRpgRf
	 22VsOCGB5dpJHjWENTexrAgux3os8yWlkba3L7FPjJ4OiJCKU4Q1Z323d+U1e0A63A
	 yOuphftScEu9gkeFKFG8jzR6hD5vEJLwt5gnml8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiwu Zhang <shiwu.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0319/1250] drm/amdgpu: fix buffer overflow during vBIOS update
Date: Thu, 17 Sep 2026 16:01:54 +0100
Message-ID: <20260917151600.749019284@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shiwu Zhang <shiwu.zhang@amd.com>

[ Upstream commit 6229898d46c0cbc238a6fe9f11c1ea12cf8bb9c5 ]

Clamp the buffer postion to write by setting the bin attribute
to the maximum buffer size so that VFS layer will block the
out-of-bounds accessing.

Signed-off-by: Shiwu Zhang <shiwu.zhang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index dd7bc55470ac9..9ca867965e7ae 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -4296,7 +4296,7 @@ static ssize_t amdgpu_psp_vbflash_read(struct file *filp, struct kobject *kobj,
  */
 static const struct bin_attribute psp_vbflash_bin_attr = {
 	.attr = {.name = "psp_vbflash", .mode = 0660},
-	.size = 0,
+	.size = AMD_VBIOS_FILE_MAX_SIZE_B,
 	.write = amdgpu_psp_vbflash_write,
 	.read = amdgpu_psp_vbflash_read,
 };
-- 
2.53.0



