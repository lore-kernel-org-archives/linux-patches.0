Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7CB273D6C;
	Mon, 13 Oct 2025 14:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760366879; cv=none; b=QxDmGSDByfLNtByl8qgl6cEyNNEF0G2kxoZCB0uDSDNT3ELs6nUFU+cYb5VTyaRUrt9qxju49DgczHQKdrS+F478p2v/kyMzJfqolz2xi7CqE+yEPpDIPudd3SkHM6nJtgU6Pl5UtyjC98ZQGnwPCJQao38LeBHMT1n25ffiBtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760366879; c=relaxed/simple;
	bh=v2yoDHozpAIpIM5nl6SspEnmaaa/Ji9Rv6c/J4Pduao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E6V7v10hubGnrGwbHjsfBQBRFBLTmbKqLyeZtB54WJhtERmMtc/3WWXNs8SPDUG9gyLvnJgkJXFBtTsUckD1z+t5KMe151OgbqfHMJhX2BHzL2eoT/6AYNwXQehVpJjXmPgovhR2blsgm+gxrt4FEbbr35VOD8pNWyg+L9DAIIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KJM95KNy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KJM95KNy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE60C4CEE7;
	Mon, 13 Oct 2025 14:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760366879;
	bh=v2yoDHozpAIpIM5nl6SspEnmaaa/Ji9Rv6c/J4Pduao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KJM95KNyU0gmmJ6TOFapD+IQ4niEblw45gwqFKaUiuNkZHIIy+ty/q+DU7QpAirKY
	 VvbpOLFBkAH3rBJnF1qPtaxyT7OctKSieE706vwI1evb/Cx0ov9V4VbXq7iEPUmbqX
	 qhH55g61IGxPO9KsHiy9P8H6o80CfsCrrznv6E9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre Gondois <pierre.gondois@arm.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Wen Yang <wen.yang@linux.dev>
Subject: [PATCH 6.1 004/196] cacheinfo: Return error code in init_of_cache_level()
Date: Mon, 13 Oct 2025 16:42:57 +0200
Message-ID: <20251013144314.717294692@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

commit 8844c3df001bc1d8397fddea341308da63855d53 upstream.

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


