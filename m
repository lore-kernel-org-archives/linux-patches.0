Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB03B2336A9;
	Thu, 12 Dec 2024 16:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019613; cv=none; b=Iv93NJWr5DS7NkRGsbP8tB52cgcIB1MPi7CGBAyFShSXMUo9Z4ING3Z+CAfY3+/P3HoM8hTtwV/Uz7NZLu3haZ/DDyGHCkJ7ZI8ZebdEFHpzc4NzuTZm1YBQUvxeuM2nDIn9ygwldJJN5zNsIMobawKzDk0PBLZFeGdPyDAtOng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019613; c=relaxed/simple;
	bh=cj22shcpSXWeFyEeYrMQXf7ikurx9PbJtk1IlpoINVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o87/AlgEPqzypgBL2u6BvfybY3xsPqJyRZBBTx9q22CIYAWhO6L7Jkcwxk2RsuV29nygv5y3uGcJmfIIXZQbLzNf83gSXF/ERz/40T/lSLpLDJ01daHax83AZrIZhkjG/Rh9NzsbZJ2RdMPS4sbbhRq8jq4p4bzzjS2o76hWNlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B1HoGKAF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B1HoGKAF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2AAEC4CECE;
	Thu, 12 Dec 2024 16:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019613;
	bh=cj22shcpSXWeFyEeYrMQXf7ikurx9PbJtk1IlpoINVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B1HoGKAF5Qe8K/W65orln0bpjYV0VL1clJ3M9Rg881d61LiB7M4Vk+53yWGP06VLr
	 HYsFo0PEoRpnLYYBcNGphBc6czyFJSYmqQqhnXF7IQdo+AOMGUwn1nq7LfoSd4CV/W
	 pNetzNk+wNtPyvHZGXefwp7OGIxfvHvRJx7+AKKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Zekun <zhangzekun11@huawei.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 252/772] powerpc/kexec: Fix return of uninitialized variable
Date: Thu, 12 Dec 2024 15:53:17 +0100
Message-ID: <20241212144400.334198889@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Zekun <zhangzekun11@huawei.com>

[ Upstream commit 83b5a407fbb73e6965adfb4bd0a803724bf87f96 ]

of_property_read_u64() can fail and leave the variable uninitialized,
which will then be used. Return error if reading the property failed.

Fixes: 2e6bd221d96f ("powerpc/kexec_file: Enable early kernel OPAL calls")
Signed-off-by: Zhang Zekun <zhangzekun11@huawei.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://patch.msgid.link/20240930075628.125138-1-zhangzekun11@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kexec/file_load_64.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kexec/file_load_64.c b/arch/powerpc/kexec/file_load_64.c
index 180c1dfe4aa77..04d100ca18b86 100644
--- a/arch/powerpc/kexec/file_load_64.c
+++ b/arch/powerpc/kexec/file_load_64.c
@@ -911,13 +911,18 @@ int setup_purgatory_ppc64(struct kimage *image, const void *slave_code,
 	if (dn) {
 		u64 val;
 
-		of_property_read_u64(dn, "opal-base-address", &val);
+		ret = of_property_read_u64(dn, "opal-base-address", &val);
+		if (ret)
+			goto out;
+
 		ret = kexec_purgatory_get_set_symbol(image, "opal_base", &val,
 						     sizeof(val), false);
 		if (ret)
 			goto out;
 
-		of_property_read_u64(dn, "opal-entry-address", &val);
+		ret = of_property_read_u64(dn, "opal-entry-address", &val);
+		if (ret)
+			goto out;
 		ret = kexec_purgatory_get_set_symbol(image, "opal_entry", &val,
 						     sizeof(val), false);
 	}
-- 
2.43.0



