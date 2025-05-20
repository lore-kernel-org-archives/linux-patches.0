Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B5E24677B;
	Tue, 20 May 2025 14:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750445; cv=none; b=bUv2jVHKNkGcwFuShrzn2zKJCn0KxDO0ZDRrliNcSaNsnCKnUP2DVEt7326dZobm/MQXSSvZdcq8VfqFTFxJkjSUQx/tknFtK1EE6ZaYM+/XCCKQR6IwaEPyvEKXxZ+57DUPdmAsuGdK2ZTex5vynx8S8WnHG1kz9qLlrJMYySQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750445; c=relaxed/simple;
	bh=h1MMft14RBQfNvSPHEsTEWJyW6B+h9SGbhQTGpBDkds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cT4gIGHIYtWyc8g0UuKGLmqM4K81pdz13l8wLe85aI1V61r8E/i/L7cE6O6sgddByBonAAQy0EIooY221YIMQNygRGhRi5/9/X56yJ9LyPzWzT4UAW/g6SREYE/VkvFzPj7aMSAvA3/pm3JtX5ExstSurK3bHbCjAijA7MoNhDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mej9XNXW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mej9XNXW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0256C4CEE9;
	Tue, 20 May 2025 14:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750445;
	bh=h1MMft14RBQfNvSPHEsTEWJyW6B+h9SGbhQTGpBDkds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mej9XNXWhWDkEIpBJpu+KGfGK23AXPyb30J0X6b+ZNvBbYAe5v8Ag0bfRfBke7Z+s
	 kWOqgDmdByivI4PtJS76jY4bpbB8AMzBpLySv19l6V6JN140qJIguS45mrtowGA9zG
	 +ENcsUFBbg2GwdiwOwZ94h+/deaUQocaz/msfWes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 003/145] drivers/platform/x86/amd: pmf: Check for invalid sideloaded Smart PC Policies
Date: Tue, 20 May 2025 15:49:33 +0200
Message-ID: <20250520125810.680357975@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 14b99d8b63d2f..e008ac079fade 100644
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



