Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3BC1411CD;
	Thu, 13 Jun 2024 12:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281589; cv=none; b=btexMuIz+AAwptRFviOfQk4K7P/bu3Xr+a/PJczeOgdZWP8l0yjBLY5NG6G1++glT96f9I/vOhLH1TvC/4cO75Z4kX7+B7bVQE06fab1Yjacd1QjjdK7U8kfgNh0WwCHQA+qkT2FLJLvXS0I34p/b8zovq7LFp7tG27pE2OPyXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281589; c=relaxed/simple;
	bh=TfyS45aETlC6nXuEg6klS5ybX/t1cCKnR5+xPxgImmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m2S7Iu35TYM1i7+lvj2TDee+qX5WrhDYXLPUC+zBGewC7w44FfDEPH9fjahPaJ5incntKKNn7KhSLfGrB3dW0HyD8FbDzJKPoM6b1OTd8bLGwwN7moCfbg8+3jRpeweN6K1hQ081fvicH88oY5P+rfBdz66TcF/50Q4esRsGhqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oFih0qa0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oFih0qa0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0571C2BBFC;
	Thu, 13 Jun 2024 12:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281589;
	bh=TfyS45aETlC6nXuEg6klS5ybX/t1cCKnR5+xPxgImmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oFih0qa0u4SogJa9WNFSwcgJV6uiKfNGtH6RBDGBIeOG4Zab8w8DDyPNfFdCC1VzM
	 77PWIAYKVtGLYfqjNYUar5PuS0JvZ5HRjSdpUomAmOapqM4u5bIKQpb1QCvjA1mqYG
	 RqmGxpbGnoRyvNfwf6V+xQdXIb1VJK/LKGU7+ZJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Justin Stitt <justinstitt@google.com>,
	Daniel Thompson <daniel.thompson@linaro.org>
Subject: [PATCH 5.10 307/317] kdb: Use format-specifiers rather than memset() for padding in kdb_read()
Date: Thu, 13 Jun 2024 13:35:25 +0200
Message-ID: <20240613113259.429704557@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Daniel Thompson <daniel.thompson@linaro.org>

commit c9b51ddb66b1d96e4d364c088da0f1dfb004c574 upstream.

Currently when the current line should be removed from the display
kdb_read() uses memset() to fill a temporary buffer with spaces.
The problem is not that this could be trivially implemented using a
format string rather than open coding it. The real problem is that
it is possible, on systems with a long kdb_prompt_str, to write past
the end of the tmpbuffer.

Happily, as mentioned above, this can be trivially implemented using a
format string. Make it so!

Cc: stable@vger.kernel.org
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Justin Stitt <justinstitt@google.com>
Link: https://lore.kernel.org/r/20240424-kgdb_read_refactor-v3-5-f236dbe9828d@linaro.org
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/debug/kdb/kdb_io.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -305,11 +305,9 @@ poll_again:
 		break;
 	case 14: /* Down */
 	case 16: /* Up */
-		memset(tmpbuffer, ' ',
-		       strlen(kdb_prompt_str) + (lastchar-buffer));
-		*(tmpbuffer+strlen(kdb_prompt_str) +
-		  (lastchar-buffer)) = '\0';
-		kdb_printf("\r%s\r", tmpbuffer);
+		kdb_printf("\r%*c\r",
+			   (int)(strlen(kdb_prompt_str) + (lastchar - buffer)),
+			   ' ');
 		*lastchar = (char)key;
 		*(lastchar+1) = '\0';
 		return lastchar;


