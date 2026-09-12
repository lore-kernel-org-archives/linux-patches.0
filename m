Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4392B372ECE;
	Sat, 12 Sep 2026 07:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199115; cv=none; b=qa9+I2tgXhNSO4K51sLWbcovucwx7VbfVTlCmePKljUpHwxackjvn+vHHK7ello1CouiDPOwjvv8IjruQU2P6kDWSwE8kwx8vpaH7RdUR4KP4OkI/Nu+iBoUSj2cqETCayZCcTFUVhC5ba2ybnAoSJsKRT7AZ3IZZIGyekm0Exs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199115; c=relaxed/simple;
	bh=Rdkw3kcuTq8bW2ccGFOwwL21by4w2BBd3XEo5NmTfsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gUqw7rBqJH4YuRCUzefOCUqrJjWx6+BUVPaPb+mxw6x+JTLwauI2cNDFSnGxDQmja5qAepZii2hGJsifTOMJaZrTrd76yyukyg6V62zlQo+45pwar2zr76ETsdWqk+ZzwLZ/R+oz8CkJqLUktgIn8zYzME3by9/rkSsIxVKZzec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PX3t28DB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PX3t28DB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 499FE1F000FF;
	Sat, 12 Sep 2026 07:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199114;
	bh=RZ4s9JsUMS4VxWN/sf751uoKUwUjhRz3JL186Bclfbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PX3t28DBwRgQEZDoKWos/k7tx3Ajq/JLz3VKfxkfajckxkDMfSKXQKAaJCjt+t7Vz
	 17Mkifs5Q/97blEHG1hR1HK4cN6Ep5SpRXiWU8h6l5Y9E5GryFnplSDnZLQfF0Hp5Z
	 8+7Or1T2whaRzR/KCSOO8Ix/jewTTLitW+w0yECY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre Gondois <pierre.gondois@arm.com>,
	Breno Leitao <leitao@debian.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0502/1815] cacheinfo: dont propagate DT/ACPI error when arch supplies info (arm64)
Date: Sat, 12 Sep 2026 08:37:32 +0200
Message-ID: <20260912065700.676888878@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 274259391c14166fcabae74f9fc0104223ff27a1 ]

cache_setup_properties() sets use_arch_info = true when DT/ACPI
provide no cache nodes and the arch can derive the topology from
CPU registers (e.g. arm64 reading CLIDR_EL1), but still returns the
original -ENOENT. cache_shared_cpu_map_setup() bails on that error
before the new flag can take effect, so the first CPU brought online
always trips a misleading warning:

  cacheinfo: Unable to detect cache hierarchy for CPU 0

Subsequent CPUs skip cache_setup_properties() entirely because
use_arch_info is now true, which is why only CPU0 hits it. This is
reproducible on arm64 with the QEMU 'virt' machine, whose default DT
has no cache nodes.

Clear ret after setting use_arch_info so the caller proceeds and
populates the shared cpu map via the arch-supplied leaves.

Fixes: ef9f643a9f8b ("cacheinfo: Add use_arch[|_cache]_info field/function")
Reviewed-by: Pierre Gondois <pierre.gondois@arm.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Sudeep Holla <sudeep.holla@kernel.org>
Link: https://patch.msgid.link/20260611-cacheinfo-v2-1-6069ef066cf3@debian.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/cacheinfo.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/base/cacheinfo.c b/drivers/base/cacheinfo.c
index 70701d3bc81c6..9f9c72727a059 100644
--- a/drivers/base/cacheinfo.c
+++ b/drivers/base/cacheinfo.c
@@ -401,9 +401,14 @@ static int cache_setup_properties(unsigned int cpu)
 	else if (!acpi_disabled)
 		ret = cache_setup_acpi(cpu);
 
-	// Assume there is no cache information available in DT/ACPI from now.
-	if (ret && use_arch_cache_info())
+	/*
+	 * No DT/ACPI cache nodes; fall back to arch-derived topology (e.g.
+	 * arm64 CLIDR_EL1) and clear the error to avoid a spurious warning.
+	 */
+	if (ret && use_arch_cache_info()) {
 		use_arch_info = true;
+		ret = 0;
+	}
 
 	return ret;
 }
-- 
2.53.0



