Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B270837DEBF;
	Sat, 12 Sep 2026 07:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199130; cv=none; b=LUbeCc3VYze59gMZ5g8iWIbUPyEIC1FDzamGCjv32zeKHzcBtBsHwtV7rNoM7OWecokCHBFNZZdsBnU1ISH/Ip386TaJQN9rKX0ev35LK/c75fsGU+vFWJvQIBPCNhRZrQSJWD0GVno0lItUBai3hXr95pQSbPIo1muVRJC3GOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199130; c=relaxed/simple;
	bh=Z3707+t0X4EzNhBvGf8C4LIHNn8zXCjpqlLmYEYYz10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kL1rNhSGpOOD71OG1WKZN3JEHdYHeoLnAM+Wb/0HH/vmsyGVBV+rKclYASyFCOa7MJWbcclyR3lEZKF5qRP/rwHtDaP72c/WAZPmkr3f3SrxGp5O3tf3YiF1hr86Ff87Y/VFI96J3vI4mtsy7WrR3YZrafudeOdicP/r4x0K4aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bLCoCc+D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bLCoCc+D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1BA51F000FF;
	Sat, 12 Sep 2026 07:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199129;
	bh=7KKXRtufCVrYLlWix4+zGnx1iFgqIXAv1RXBHFKlVIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bLCoCc+D8L9vIYXp1pb5cimxa6h6JlVe/5AT1fNqpdK1KTX9mACJvUQOqB6uMNUVr
	 5HxO/2ivot/HDO+dCSAuAlPP651yZ2kkxv8wysBv4UagqGnCOONLfrLBOb4feEaUPs
	 6tglbQF4uDH+z4GourBrdke5yYClW6b4SCKcnifs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Alban Bedel <alban.bedel@lht.dlh.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0522/1815] software node: Fix software_node_get_reference_args() with index -1
Date: Sat, 12 Sep 2026 08:37:52 +0200
Message-ID: <20260912065701.145759499@linuxfoundation.org>
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

From: Alban Bedel <alban.bedel@lht.dlh.de>

[ Upstream commit ba3dedcf3bd47017307595a7e54924198f018246 ]

The bounds check for the index passed to
software_node_get_reference_args() was failing when passed UINT_MAX,
this in turn would lead to an out of bound access in the property
array. Fix the bound check to also cover the UINT_MAX case.

Fixes: 31e4e12e0e960 ("software node: Correct a OOB check in software_node_get_reference_args()")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-devicetree/20260611103904.7CB131F00893@smtp.kernel.org/
Signed-off-by: Alban Bedel <alban.bedel@lht.dlh.de>
Link: https://patch.msgid.link/20260611164005.2930205-1-alban.bedel@lht.dlh.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/swnode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/swnode.c b/drivers/base/swnode.c
index 869228a65cb36..2bc76f01eb77d 100644
--- a/drivers/base/swnode.c
+++ b/drivers/base/swnode.c
@@ -537,7 +537,7 @@ software_node_get_reference_args(const struct fwnode_handle *fwnode,
 	if (prop->is_inline)
 		return -EINVAL;
 
-	if ((index + 1) * sizeof(*ref) > prop->length)
+	if (index >= prop->length / sizeof(*ref))
 		return -ENOENT;
 
 	ref_array = prop->pointer;
-- 
2.53.0



