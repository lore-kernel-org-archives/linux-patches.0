Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D12F35BDB4;
	Wed,  3 Dec 2025 16:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778946; cv=none; b=LjiYlDwI+pCg7iMnjxnSmzihsmYA2XHTFN1Z1kMwJwuXjnhFH35Gtc3goZ1RBOYEcF3ojRr97fxcgJ2bI7RLBXYnLiOu3w2ikFGOqCRxH8mL5vzz2VxV9x51358XdcAWPZDnNJLWaaQUnmxLg79KJLjHtCdz8aDrbN5BEq9hg7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778946; c=relaxed/simple;
	bh=r1s7vDZKIFkUtuLfuJ2JCs1TR9a9AJDPnUHrAA698TY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nE3aiDR+z3bZWb8mGZpWHuhGTf57ppb7QRzaQcIeSR66mSXReVuPymdaXo7Uy6RAWJhyAcb2HVhC1A05WITQ30q1MhYAP9g72CqoPbfIKQCghtc0UW1DAEA8MYnpCkqVeqs2lPP8NJfFK6vPOnONRnLd8nN51Q0x3VaamhtLspI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0chUpKdn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0chUpKdn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B795C4CEF5;
	Wed,  3 Dec 2025 16:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778945;
	bh=r1s7vDZKIFkUtuLfuJ2JCs1TR9a9AJDPnUHrAA698TY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0chUpKdn9rX2V9IDErQYmX5E6oTTFu8BJTOYN+7FuUl24VIrsC2HuTeiawL2VVMwg
	 OnuL8b5Sx02PeuOICkY5IsP8TL0HptU+uyJ9H4VXSoJyzAdhRTdwakE+yHHALVh553
	 IZegHCnPV/QlXEVWXDC65LcnWD3BNcIVK2gy1rwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre Gondois <pierre.gondois@arm.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Wen Yang <wen.yang@linux.dev>
Subject: [PATCH 6.1 066/568] cacheinfo: Return error code in init_of_cache_level()
Date: Wed,  3 Dec 2025 16:21:08 +0100
Message-ID: <20251203152443.122168701@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre Gondois <pierre.gondois@arm.com>

[ Upstream commit 8844c3df001bc1d8397fddea341308da63855d53 ]

Make init_of_cache_level() return an error code when the cache
information parsing fails to help detecting missing information.

init_of_cache_level() is only called for riscv. Returning an error
code instead of 0 will prevent detect_cache_attributes() to allocate
memory if an incomplete DT is parsed.

Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
Link: https://lore.kernel.org/r/20230104183033.755668-3-pierre.gondois@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Wen Yang <wen.yang@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/cacheinfo.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/base/cacheinfo.c
+++ b/drivers/base/cacheinfo.c
@@ -245,11 +245,11 @@ int init_of_cache_level(unsigned int cpu
 		of_node_put(prev);
 		prev = np;
 		if (!of_device_is_compatible(np, "cache"))
-			break;
+			goto err_out;
 		if (of_property_read_u32(np, "cache-level", &level))
-			break;
+			goto err_out;
 		if (level <= levels)
-			break;
+			goto err_out;
 		if (of_property_read_bool(np, "cache-size"))
 			++leaves;
 		if (of_property_read_bool(np, "i-cache-size"))
@@ -264,6 +264,10 @@ int init_of_cache_level(unsigned int cpu
 	this_cpu_ci->num_leaves = leaves;
 
 	return 0;
+
+err_out:
+	of_node_put(np);
+	return -EINVAL;
 }
 
 #else


