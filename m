Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE3E15820C;
	Tue, 11 Mar 2025 15:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706922; cv=none; b=W5EeALfM5LSlyPZmyPm9TuDye+UvZqa+BxI6LVSA4xsc3t2LPR9UEjsf1moM8s31zOATQvl+bZQhQLtOSmUGjsk43rEf7AcCSQKefrspuwqGVAMgpHUuwYA97T0yeTmpgKraY86wJIzg649Ei9Wips9JErL45eHitCljicIQXsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706922; c=relaxed/simple;
	bh=JTAZkLVowFQM2i2kWxx5XBm6bP0yiZpYCfVLKBesME8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mx/RtypX2gW/hMLpMHkgHrTrYMu2WC+TcalyERNBc2BepNGlmBwGrreOq1GBvZds0/YW/Y24ZVEKVG+9h0Kjjbu7dP1z4PVzPK38DIcVSj6PynFW6zfb9bt/zMDCSiZVfI2tHbVh82Yltp5tGji5e+udtDixJfzJclziqqGHq/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CcQanFoD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CcQanFoD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A01CC4CEEA;
	Tue, 11 Mar 2025 15:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706921;
	bh=JTAZkLVowFQM2i2kWxx5XBm6bP0yiZpYCfVLKBesME8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CcQanFoDroSKClgiCquyvDISjxECXqGf0m0GWlKiOlTu+fGt5dbFasAO7oXWr1u/y
	 /iwFnBFZjDfuwqQy8ZMrXMh8dddHC6gFRyd3rhTdbMUNII31Ny/BlQ8EP6GlPL18q2
	 GIWSYTsJeskMLtFMZGhH5eR5uD/+0H8FiLNdsl1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 5.10 182/462] of: Fix of_find_node_opts_by_path() handling of alias+path+options
Date: Tue, 11 Mar 2025 15:57:28 +0100
Message-ID: <20250311145805.542437185@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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
@@ -926,10 +926,10 @@ struct device_node *of_find_node_opts_by
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


