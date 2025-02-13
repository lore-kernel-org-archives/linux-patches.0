Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6303C28382;
	Thu, 13 Feb 2025 14:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457542; cv=none; b=JwxfSdBcNMeV8Kmw+/mhtvWmGmJiYat0GDUM2vCp0YkPLHjBPcDOTiSvt3Zf4Bl0OoW+URuZv2bn7j7i4Yuq5KZ5YvyNjiPvWkzRhH4KApRe5tW4BODGO3ISH145dX/99agRnvL1qbxv9Ul2l2hwRIyeq5cEc7Jl86qH80GFzWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457542; c=relaxed/simple;
	bh=moXUfdBBPkGJ2PeQ6PoJy+IKXfF/USttt89k2ewOvCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tHlg8qWVsrnAtFWpTEYFd8rS0Y7vQVs9D8+hIdmbaF9tsMgpbl8l2gLSrhdxeU37wuq9gh4BW1iYGSlZfVr4kqS1QlitPWca8LlGPr+6uE3IgIT0g9y1A/d1gCKDZSzGaq4jNUsodPPP9Pj59ZVQ5QSfOjWfyl2uBzqJ2bt8hnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zLQ/QzO9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zLQ/QzO9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB7B5C4CEEA;
	Thu, 13 Feb 2025 14:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457542;
	bh=moXUfdBBPkGJ2PeQ6PoJy+IKXfF/USttt89k2ewOvCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zLQ/QzO9pyrNUD1VtUxpquWp0cOClogb1GsvwFdN6RKQ6LPbZbvN5ae6I85jQfqEL
	 x3L45cnFgvMhvi8O7r0097HRk26pMPEMKokY99+wqtuqHv6M/9LrWIke21BSPXUgLi
	 6rImo13DmzHzuCI0yyDfGgY7vQ+hDHOJr+CCfhbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Nicolas Pitre <npitre@baylibre.com>,
	Kees Cook <kees@kernel.org>
Subject: [PATCH 6.12 142/422] binfmt_flat: Fix integer overflow bug on 32 bit systems
Date: Thu, 13 Feb 2025 15:24:51 +0100
Message-ID: <20250213142442.026038863@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 55cf2f4b945f6a6416cc2524ba740b83cc9af25a upstream.

Most of these sizes and counts are capped at 256MB so the math doesn't
result in an integer overflow.  The "relocs" count needs to be checked
as well.  Otherwise on 32bit systems the calculation of "full_data"
could be wrong.

	full_data = data_len + relocs * sizeof(unsigned long);

Fixes: c995ee28d29d ("binfmt_flat: prevent kernel dammage from corrupted executable headers")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Acked-by: Nicolas Pitre <npitre@baylibre.com>
Link: https://lore.kernel.org/r/5be17f6c-5338-43be-91ef-650153b975cb@stanley.mountain
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/binfmt_flat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -478,7 +478,7 @@ static int load_flat_file(struct linux_b
 	 * 28 bits (256 MB) is way more than reasonable in this case.
 	 * If some top bits are set we have probable binary corruption.
 	*/
-	if ((text_len | data_len | bss_len | stack_len | full_data) >> 28) {
+	if ((text_len | data_len | bss_len | stack_len | relocs | full_data) >> 28) {
 		pr_err("bad header\n");
 		ret = -ENOEXEC;
 		goto err;


