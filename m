Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585F41E1A05;
	Mon, 23 Jun 2025 21:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715075; cv=none; b=s496jgoGHQC9NtCjKWa3IKFvjUdWSUvBR3gyFlPtgrDXxtZhhLsqVGT7zKnGC7BlJfZYlmB1f4kxbwI0XGiFn1uWKJ2HTBVv7IGYBp3NsY3ArKI2YKVqmv/BgdYI6dFFsQXGc3yOEOZ5MSv57KLXl2Nho8ccj7+JHo0LQQzGvmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715075; c=relaxed/simple;
	bh=vQpEAsV+SHEVNdOhjk+0X5i7tRMpPGRNTEu4SaptXlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gzWAsD5Y9DaqbP2dLveeTIs0S/eFFBEl53zRS6CTUkgMEXDXNL5veoHHE14zzheS6cf1Dvhf4boBDUSNXP8M2LISK7tnR8BgtLkd68HUR+nI5i6bFE1ejOmwrrLfz7JEOO/b/c2ztSUw6Up121Oo/TaGm531vJGFkgE/Jdpl7oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ck3JzLto; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ck3JzLto"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6981C4CEEA;
	Mon, 23 Jun 2025 21:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715075;
	bh=vQpEAsV+SHEVNdOhjk+0X5i7tRMpPGRNTEu4SaptXlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ck3JzLtoBk/G+51dnWljmkmg7HvMcNSYI/M+rSKB2XX+xfF25R3yZ9I+Er0Nm9VBk
	 49HkfTMKkV/wlxavHG9paNs8jLVOlixXlDz8My+gOhNUhLwFv2HkA913yVuaTet1xU
	 lfC08AQFQnSiPmspgk1sNnsTiLIiEldq3J1pCuj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 178/290] software node: Correct a OOB check in software_node_get_reference_args()
Date: Mon, 23 Jun 2025 15:07:19 +0200
Message-ID: <20250623130632.233087368@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 079bd14bdedc7..a7a3e3b66bb5e 100644
--- a/drivers/base/swnode.c
+++ b/drivers/base/swnode.c
@@ -518,7 +518,7 @@ software_node_get_reference_args(const struct fwnode_handle *fwnode,
 	if (prop->is_inline)
 		return -EINVAL;
 
-	if (index * sizeof(*ref) >= prop->length)
+	if ((index + 1) * sizeof(*ref) > prop->length)
 		return -ENOENT;
 
 	ref_array = prop->pointer;
-- 
2.39.5



