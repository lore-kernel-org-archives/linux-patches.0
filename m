Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636483FB1B;
	Mon, 23 Jun 2025 21:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715361; cv=none; b=lLh6WINrn8cxLLhnWDU6NuXRH07hHrE6K19M4mq8Yk7Ve17b8pjkr2/y/99TBcSwAnoF2PdLJ5R6hSqSO5wGI/5s0DNe3kxUPajVpA7vBUnW8T6ke778boFGZ0pKgrEGw3GV5ctP3XE2JxYEOyk+3ebu+x+R35FQk60Eb+lE3uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715361; c=relaxed/simple;
	bh=4vM97e8Ok/JeLUDjgdaN0p81sHRrfBEKLFM8hLKRb8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TnQwmLRvtpzpW13ezlRZ1YUQBy6UeXBi2+jkOSK+rIpkSB+K+NWbuRlIzs/kuRxcdXRgSvOZNSn27aCySOLhXQx6lOzxuofob0yxuvpbfkiQG1J1E5k27wjfqj9ZBga1QDRXi0rvxyd3a8IepoF9liQgj6C2Fjyg9kFT+auSvRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jetCCWFe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jetCCWFe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF850C4CEEA;
	Mon, 23 Jun 2025 21:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715361;
	bh=4vM97e8Ok/JeLUDjgdaN0p81sHRrfBEKLFM8hLKRb8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jetCCWFey6CKmVWv/7Ctg4dNPLvmZg2YyMBrdBNMoczClN1X32O9OkyoUQhaq1DtU
	 BhNjWNh3rXutxDq8Tt0ZxicTnZitTuEEVYPlulGU0iS/66pqmKKIwu4/C6wEmUOWL7
	 RkJJMfG5kF3g3NRwstjGDvKpYqRVKcbdlZEIi8NU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 270/355] software node: Correct a OOB check in software_node_get_reference_args()
Date: Mon, 23 Jun 2025 15:07:51 +0200
Message-ID: <20250623130634.873065070@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b664c36388e24..89b53ca086d6a 100644
--- a/drivers/base/swnode.c
+++ b/drivers/base/swnode.c
@@ -508,7 +508,7 @@ software_node_get_reference_args(const struct fwnode_handle *fwnode,
 	if (prop->is_inline)
 		return -EINVAL;
 
-	if (index * sizeof(*ref) >= prop->length)
+	if ((index + 1) * sizeof(*ref) > prop->length)
 		return -ENOENT;
 
 	ref_array = prop->pointer;
-- 
2.39.5



