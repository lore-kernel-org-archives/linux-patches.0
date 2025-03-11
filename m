Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3C025D908;
	Tue, 11 Mar 2025 15:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705717; cv=none; b=MdZ3vpLrPjPXY6ChKuWnfzYAAXXeiT61lGTz8+hCqstKJjK0QQh/mojnHbd50xdINYPG69mS9bnBLhrhhXplrfn5BPzjvYmUGCy3LhjVQ9rNDg1DzKppYWO4l10BSZdieZcFgrL870/8bSZdi+eVo2iPJ5yNBaka4xt+42mCtek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705717; c=relaxed/simple;
	bh=HKhhZPyt8k1knJXhVB8I3Jl6AOrq+Yh833Yx7Azi+JE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ONPP48OWEVu5rzFjndbQGWA6/yfLgqyXltdFtg7l9ygZcb0foVBJOfnKTsNYzZ4mh0yMUyDUC+1ckxW8jfBUndw5NIUWVr2EwdFPumeXCVyAgJvDIARcLlwp/u95R6QNbcdwAti1bvTYSqBdDxJvWAUg83aO0I4jolNlKrLOU9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aEudC4hZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aEudC4hZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB871C4CEE9;
	Tue, 11 Mar 2025 15:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705717;
	bh=HKhhZPyt8k1knJXhVB8I3Jl6AOrq+Yh833Yx7Azi+JE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aEudC4hZGQ5+VAd5+Y0aUaoDdC730TocKFmsQTNJB2dz6kjP58+acKlOLFmg8+Ul0
	 UukYye7GfGH+EBx4uG4sJ9nj0xfbzjXE7YcS7OGDsoHIOnHDejPKPer5pcSP3vhOh7
	 kdJ1g0ohocVUa6bjdDSKIpYH7/FjLafbQUQnK9Ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 5.4 131/328] of: Fix of_find_node_opts_by_path() handling of alias+path+options
Date: Tue, 11 Mar 2025 15:58:21 +0100
Message-ID: <20250311145720.108032627@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -988,10 +988,10 @@ struct device_node *of_find_node_opts_by
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


