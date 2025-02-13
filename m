Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517CE26B099;
	Thu, 13 Feb 2025 15:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459273; cv=none; b=G0IwMr4cvYVVmkmoENbVG4u1DdyCN9KQSa066vp6AROOlnET2msi8ZXRpPvp05mfcG1WXbDXliollablZ6EEX4avZZw/XbKd/SXZyoKMJ7KvEreBXBfWtPNAAzLzUw6RC2LUZazi6ETu0Q1dfF9W44qjWz8OVsaQ025z3pV6ko8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459273; c=relaxed/simple;
	bh=A6jDHvhjFz8GQmdZBNQZYrprlXGr9FIhxq8J2MYavvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E+e0psltl9vDTkZA6arMC31vk31+K8mnNFs/uWF6onpna86v4DfLRroX2M/+59SdMR8O4Zq1weTG8uBBjp1DNWUw5Xogz7th4OEEJQlWTtjyh119ezu2wIPuMEgdTfAB1++0mL+OS5rbKGtie+k8/FqesZgLMlRryZIJ1O/TEfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zbRhm10R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zbRhm10R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B75B8C4CEE5;
	Thu, 13 Feb 2025 15:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459273;
	bh=A6jDHvhjFz8GQmdZBNQZYrprlXGr9FIhxq8J2MYavvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zbRhm10Rq+gPJDELjnXJSuaBqGw+t69oP/wCMAwRnIhZFNnGQOwvkz08QjCF54582
	 J79U9MHTCBB//C2jTv0tuCsXNhLM8cBIwZQo5WWdt2L/XLzGGFi1LavwMa31lYNzRZ
	 lXKqqoOormsQjBU3gECkQSfGHHmVZ/4ClZ4vjUSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.13 217/443] of: Fix of_find_node_opts_by_path() handling of alias+path+options
Date: Thu, 13 Feb 2025 15:26:22 +0100
Message-ID: <20250213142448.988998930@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -894,10 +894,10 @@ struct device_node *of_find_node_opts_by
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


