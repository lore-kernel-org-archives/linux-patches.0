Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426AA30D3EF;
	Sat, 12 Sep 2026 18:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238909; cv=none; b=YWZ56dPL5tmE7vXVH1KSuzTI6e9lu+oToVR4LXvjiB4ic8n2aQmyQQietZFYAlznrVlyTuxIepJx67d/AAzGNLWjNx+w41o3VAUNdPrWqBalyXlzN2EMpqxmUsbA8Bs5fYGaZ2yzDJJPsTFyt4GJoarcU6wMkhzuZyneS6MrDpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238909; c=relaxed/simple;
	bh=2wg7+Ut2zgEjUXzM8mlx8wVtvwvUdCTgwwSf4x63xZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mx3razHeCSzAnJIG0Om+Boe5ynufIk98OgLipUEJ7ntw+Iz6EsI/iOHIMo+DE9t+CZS+hd9RCh5iiQiSTo+lf9e/FK1hcd+MNGTHs0wNIXZBEXRX9N8ZEXguPQU4gcoua3TknN2TPK1m9JHUwX3hhuO7zHrvdxDrH2erBNu8OIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HwyMQgTS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HwyMQgTS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F347C1F000FF;
	Sat, 12 Sep 2026 18:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238908;
	bh=NOBqtcO6MMPEoIXRO+ZgTbC4t0age5NDMYb3878Om/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HwyMQgTSkM+f/cAm96IeGRwAkrTOu9CWfKMsgWx3EdH31GEG4hr1l6SvxtCVQ+L4/
	 0WcJ40376X7oNYlaSouDgOJXf5kG59Yi/gLOPw1T2wEvAwPb7BL7wFqZpzccWWDbN0
	 u7wS6buw5k93/E5cS6rrQJgwL7Q003Hbwl/t8SGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Alban Bedel <alban.bedel@lht.dlh.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 557/935] software node: Fix software_node_get_reference_args() with index -1
Date: Sat, 12 Sep 2026 08:59:47 +0200
Message-ID: <20260912065539.605703579@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0af6071f86641..d4f012677bd44 100644
--- a/drivers/base/swnode.c
+++ b/drivers/base/swnode.c
@@ -524,7 +524,7 @@ software_node_get_reference_args(const struct fwnode_handle *fwnode,
 	if (prop->is_inline)
 		return -EINVAL;
 
-	if ((index + 1) * sizeof(*ref) > prop->length)
+	if (index >= prop->length / sizeof(*ref))
 		return -ENOENT;
 
 	ref_array = prop->pointer;
-- 
2.53.0



