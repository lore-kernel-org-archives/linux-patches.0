Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB1E1B85EC;
	Wed, 19 Feb 2025 09:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956979; cv=none; b=og9FHQ0G+cx9rlCYJmhCTnElbTSVlZS4x4Vb/rTGGs6fdfa909yO9nJFwaJMg3LJO4IZSFBYPd6t+eeI1HARzuAiW1JzVQ1BBDdyiJEKwqewFiRXXUpC+sA7ICx0mg+jbqgOb5koWmscT+poUHoljjUZFDZ1LsbwoanjSJyM9fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956979; c=relaxed/simple;
	bh=LgzoIW2/ckgZ7pxQtpI4KB27pyE2F3L2uQPm/1hV9EU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rZv4WDIPNeo6N8ST5Flx53oZylKmerJF4m88wxwFwdAcvdELmET8tyyT0A1Thwgs/Id6czKP16mpxNhVztZr6XoQ51U6jXgv682vPd363AK8tsvvpi/PVq8/fAau9euYD4evSwQpUGzOfJEjg6FDHQu6BPHgNIgeZP1/IzF+nqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v89soNz4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v89soNz4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E738CC4CED1;
	Wed, 19 Feb 2025 09:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956979;
	bh=LgzoIW2/ckgZ7pxQtpI4KB27pyE2F3L2uQPm/1hV9EU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v89soNz4maCwQbE/XTf6ORoiN9alclgzr3jhL6KpZB7byaWV/LwdLlVqANX30UXVB
	 MHPmL6vFlFKt9SPYJSYMuRtcepDgVAk1v5mPIWch2suqnMmrHVc22nlPWH34JE5QPs
	 zkMzr1jMB4OnoidRf5CaxgUc3T7WbSCvr/UBusHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.1 367/578] of: Fix of_find_node_opts_by_path() handling of alias+path+options
Date: Wed, 19 Feb 2025 09:26:11 +0100
Message-ID: <20250219082707.454853934@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit b9e58c934c56aa35b0fb436d9afd86ef326bae0e upstream.

of_find_node_opts_by_path() fails to find OF device node when its
@path parameter have pattern below:

"alias-name/node-name-1/.../node-name-N:options".

The reason is that alias name length calculated by the API is wrong, as
explained by example below:

"testcase-alias/phandle-tests/consumer-a:testaliasoption".
 ^             ^                        ^
 0             14                       39

The right length of alias 'testcase-alias' is 14, but the result worked
out by the API is 39 which is obvious wrong.

Fix by using index of either '/' or ':' as the length who comes earlier.

Fixes: 75c28c09af99 ("of: add optional options parameter to of_find_node_by_path()")
Cc: stable@vger.kernel.org
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20241216-of_core_fix-v2-1-e69b8f60da63@quicinc.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/base.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -974,10 +974,10 @@ struct device_node *of_find_node_opts_by
 	/* The path could begin with an alias */
 	if (*path != '/') {
 		int len;
-		const char *p = separator;
+		const char *p = strchrnul(path, '/');
 
-		if (!p)
-			p = strchrnul(path, '/');
+		if (separator && separator < p)
+			p = separator;
 		len = p - path;
 
 		/* of_aliases must not be NULL */


