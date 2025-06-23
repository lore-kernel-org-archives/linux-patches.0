Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14BCB4409;
	Mon, 23 Jun 2025 21:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714446; cv=none; b=i4RiDe38QHTD7CoDts+8TL72TAeFQxhTyfrs0dohnhT+nbfEc0CX4KMTFJRRfhqyYXbXWfrnS0e96l2SHXoeC5k9V4ZPczbWlQEmyUyEkeh+xPBwnIY5+O5WuiTknYs8JyOn2Obl6TYyGpXKVnHFOm6EvxO0dQ64AXXpVjoAc9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714446; c=relaxed/simple;
	bh=J/5K9t3agVva8ue1HDUklup5OjALSproTpzKCT2SIgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j2Bjma2aRtjD6lJJFS8CLh15mu/ubYdw/EPLJZMMpqCGG4UWVT0HEuoNLSBfU9YnxkgcF/mR6L8cVBzxh5pzYBOvZQ1v+peOj91IVTY4ldpXR66D5KLOrVlxUxHMmXfCZYMgr57umq3Re6QoXb02wrVZaLxvi52w34MPR/zgh3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p6t2L9rB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p6t2L9rB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2FB2C4CEEA;
	Mon, 23 Jun 2025 21:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714446;
	bh=J/5K9t3agVva8ue1HDUklup5OjALSproTpzKCT2SIgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p6t2L9rBwv8ojVt5ZFy7XAqVMfE1mRX6UYpU5x1cOZDeOkdCQMhwYpQKTv5sS4VtU
	 dnpcte/cYeLcGJmvHghBZHCyroML0oLuTqQh5SlZpmd7P/P+IRhgkcmYRVCOCqeAEX
	 Eq7arBqeid+vd04t16PuOOPsSNPU/yjtk+7cXIDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 400/592] software node: Correct a OOB check in software_node_get_reference_args()
Date: Mon, 23 Jun 2025 15:05:58 +0200
Message-ID: <20250623130709.957164354@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit 31e4e12e0e9609850cefd4b2e1adf782f56337d6 ]

software_node_get_reference_args() wants to get @index-th element, so
the property value requires at least '(index + 1) * sizeof(*ref)' bytes
but that can not be guaranteed by current OOB check, and may cause OOB
for malformed property.

Fix by using as OOB check '((index + 1) * sizeof(*ref) > prop->length)'.

Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20250414-fix_swnode-v2-1-9c9e6ae11eab@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/swnode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/swnode.c b/drivers/base/swnode.c
index 5c78fa6ae7725..deda7f35a0598 100644
--- a/drivers/base/swnode.c
+++ b/drivers/base/swnode.c
@@ -529,7 +529,7 @@ software_node_get_reference_args(const struct fwnode_handle *fwnode,
 	if (prop->is_inline)
 		return -EINVAL;
 
-	if (index * sizeof(*ref) >= prop->length)
+	if ((index + 1) * sizeof(*ref) > prop->length)
 		return -ENOENT;
 
 	ref_array = prop->pointer;
-- 
2.39.5



