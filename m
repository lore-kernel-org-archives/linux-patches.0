Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A000F1FBE9E;
	Tue, 20 May 2025 14:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750104; cv=none; b=RsEM1FRsTZ8dHlDrZmS0CUarkgamV9+6hlh7OV2X7S1SGq88W9xXDklUA+mpEeGHwMo4cJssRrX4y/K0yoFdoyFkQ1w8Z3czD3tu/NEPf4rJNqx0INA3fXZUV/0ymRmHdXxfEL6ueEv2nrgYnIYg8RMv08sjmW62GYLJsyWT1Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750104; c=relaxed/simple;
	bh=0Xi6kJ7rfBNkr1+qT56mBZHQ+xXhfWGOU0+FRmZFSEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tcOsBulVUqdcegRd+i6mAlsmk8p1XYFmq4K4GwUeUwu5ylZ9MigiH32aQ11m80axrQ0kJhgCu9bsrMOScyuneF08KboxZsAmr5rAUiFjofsWlKz8BtR5mFnI5NS2Vz2iA3ksK73aaZ1IIq/GNdz60IZeCNkqwGGur+mRcU8xzAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ndaCBr75; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ndaCBr75"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27EBDC4CEE9;
	Tue, 20 May 2025 14:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750104;
	bh=0Xi6kJ7rfBNkr1+qT56mBZHQ+xXhfWGOU0+FRmZFSEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ndaCBr75VqaEa9PzIJ0SamnUXQVyR/tuIQkU8U+s7kJTllpQBL6RlyaaQkfKXF9qR
	 9lJDzRl98tonTHDcEv3e/+NoYaswmVbtoWInuujLAkZrjaTSZI1JkRHgUQyRHlCKRs
	 l9NblmPLN8Z4e2iQA8P9dUKW1JXFn2J+1fyY1LYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 003/143] drivers/platform/x86/amd: pmf: Check for invalid sideloaded Smart PC Policies
Date: Tue, 20 May 2025 15:49:18 +0200
Message-ID: <20250520125810.179550368@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 690d722e02819ef978f90cd7553973eba1007e6c ]

If a policy is passed into amd_pmf_get_pb_data() that causes the engine
to fail to start there is a memory leak. Free the memory in this failure
path.

Fixes: 10817f28e5337 ("platform/x86/amd/pmf: Add capability to sideload of policy binary")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20250423132002.3984997-2-superm1@kernel.org
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmf/tee-if.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/amd/pmf/tee-if.c b/drivers/platform/x86/amd/pmf/tee-if.c
index cb5abab2210a7..804c4085b82fb 100644
--- a/drivers/platform/x86/amd/pmf/tee-if.c
+++ b/drivers/platform/x86/amd/pmf/tee-if.c
@@ -364,9 +364,14 @@ static ssize_t amd_pmf_get_pb_data(struct file *filp, const char __user *buf,
 	amd_pmf_hex_dump_pb(dev);
 	ret = amd_pmf_start_policy_engine(dev);
 	if (ret < 0)
-		return ret;
+		goto cleanup;
 
 	return length;
+
+cleanup:
+	kfree(dev->policy_buf);
+	dev->policy_buf = NULL;
+	return ret;
 }
 
 static const struct file_operations pb_fops = {
-- 
2.39.5



