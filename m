Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8356D143736;
	Thu, 13 Feb 2025 15:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460484; cv=none; b=qDcGyXk5cvadEYSi0F5l3l9w7nwdH6LzuAwu8OIE8whjxUFbAkcckbnzLjegpfTWJtG76fa8VTgiSDCPOg4Q0IRd51tnW11CZRsmQzMuDATRS7xgmnP7+oGJEsM2uqucxYvBOrtS1ITg36Gg5y4niYp3wDINC0qWHTrqaW4LThs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460484; c=relaxed/simple;
	bh=L0FPQ/cciSC3eIUmnVrgpy9Qthlb61qwkouDvjM/3X8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TsS7w7knAQ++j8Y3OfRPP0J7EpCBvtdun1w8lvZ1bhNj1rDofGEddUc2hQmcSx+XuxKulrzQw6H8MLiRLfpu143gijpfM3ClFjaDt4UGOcBBCUnqvoRr7PHNi55Ezbn5r+eXBYnfiywsHizWJk+ABI1azk5iTkri9xwvukKZBWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=071Llrp+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="071Llrp+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA6F5C4CED1;
	Thu, 13 Feb 2025 15:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460484;
	bh=L0FPQ/cciSC3eIUmnVrgpy9Qthlb61qwkouDvjM/3X8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=071Llrp+bfkU5OfZxf/dBXjelR/CB3hbXQXpDKcJT2ma+3HgprNGkh64zQ8VgOOk1
	 Yo8E6kjj7e5fpMUW3iDclUpBQlQhoDqchzO/LCw0xnymjX2Ptb+RTvS6ZV1FflWN/A
	 TuK7eOkziv7BBy7lrlpni4Cbj5S56lM1H80StLCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.6 124/273] of: Fix of_find_node_opts_by_path() handling of alias+path+options
Date: Thu, 13 Feb 2025 15:28:16 +0100
Message-ID: <20250213142412.242429093@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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
@@ -788,10 +788,10 @@ struct device_node *of_find_node_opts_by
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


