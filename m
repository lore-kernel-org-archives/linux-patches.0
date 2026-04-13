Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7742FFFA4;
	Mon, 13 Apr 2026 16:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097551; cv=none; b=Aggz1mVB6alGnCFafTzrgT2OEG3mmmigXTRDNhdJIoGv00gcCXPdAGqag3rMEZkLMPIwzga5EL/C3x4N1rXIsK705wgJsSCce/oRRqafMHopHAglFHImcMhs8ANNtIG70ZEFqHOQxnVAb2GtllzSKX5c7SOY97Rglvn1roq2QN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097551; c=relaxed/simple;
	bh=E9USwjHObIQzhKKPP3ffcCPQQwHIGT4vKQDlEcMHQD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dhjpXzKFimAXieQiotA0TADa4NWJqF3vPMpFhjprK7phheEw29pVxSkv/9mmPfqTUkYdtR05lXm4oPGRG0xqPMxZFfLfIoSJgnsD6u7OojmpwwMVCDtTggu7gfsQUxuaNMQME1DnJ11nHmdqPIUbiy8RJZB1jGnG8EAJw5W0UhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sWP+H8CN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sWP+H8CN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842B1C2BCAF;
	Mon, 13 Apr 2026 16:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097550;
	bh=E9USwjHObIQzhKKPP3ffcCPQQwHIGT4vKQDlEcMHQD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sWP+H8CNbuOlB39EV2JlCsin90k8MsTXkfV/8LXaTu2CUReC9gS5GPo1cW9SHnOX6
	 +0WmJo3smO6o0Lmi+v/Mn8Zjyu29KYiF7gufiJhd/YQM7aw2CVSomtRwWaQqgoQu9w
	 yISgYn5u/U3Q4kLWXXTSiD2lYw8aAnYfdyr+/8KA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Law <objecting@objecting.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 5.15 180/570] lib/bootconfig: check bounds before writing in __xbc_open_brace()
Date: Mon, 13 Apr 2026 17:55:11 +0200
Message-ID: <20260413155837.199218034@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

From: Josh Law <objecting@objecting.org>

commit 560f763baa0f2c9a44da4294c06af071405ac46f upstream.

The bounds check for brace_index happens after the array write.
While the current call pattern prevents an actual out-of-bounds
access (the previous call would have returned an error), the
write-before-check pattern is fragile and would become a real
out-of-bounds write if the error return were ever not propagated.

Move the bounds check before the array write so the function is
self-contained and safe regardless of caller behavior.

Link: https://lore.kernel.org/all/20260312191143.28719-3-objecting@objecting.org/

Fixes: ead1e19ad905 ("lib/bootconfig: Fix a bug of breaking existing tree nodes")
Cc: stable@vger.kernel.org
Signed-off-by: Josh Law <objecting@objecting.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/bootconfig.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/bootconfig.c
+++ b/lib/bootconfig.c
@@ -466,9 +466,9 @@ static char *skip_spaces_until_newline(c
 static int __init __xbc_open_brace(char *p)
 {
 	/* Push the last key as open brace */
-	open_brace[brace_index++] = xbc_node_index(last_parent);
 	if (brace_index >= XBC_DEPTH_MAX)
 		return xbc_parse_error("Exceed max depth of braces", p);
+	open_brace[brace_index++] = xbc_node_index(last_parent);
 
 	return 0;
 }


