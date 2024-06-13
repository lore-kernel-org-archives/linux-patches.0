Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099AB6AFAE;
	Thu, 13 Jun 2024 11:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279546; cv=none; b=jRFOmuaphOo3TA45i063aXCPnQu0BFTPbeNy9wx1Wzu/O12sTupD5XxWeCTMfJzUyCb79kK/nRLyZYBf9rlyp+MCUz/M8+6kKZrzxhImh6GyyP6BmH01RMi2js0EjOwrVuuVkJypDMtUrE/zjpVVEq0CNhMhozuzeDrxKjXO7KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279546; c=relaxed/simple;
	bh=quC5Kp709LzddE3yqcMwf+JRDm9QawVSRRt7IT4fS9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LYa+uSNWcjB49aHIFRAMtKm+CjhgrxS252NGnGOsz0nf91jKcXBmD/oqSctn+44eem3a5MLBcQwBfS73Ay/IhYqAEdlEMTvw3GOktJoDSzAsVAn3bnI1VyM8z8GaDxbauLXZrZx0jG6T/Lxp1oiMy/SrVSx4aj6TUqB9F9Gh4M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0pDOBdIj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0pDOBdIj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82EE8C2BBFC;
	Thu, 13 Jun 2024 11:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279545;
	bh=quC5Kp709LzddE3yqcMwf+JRDm9QawVSRRt7IT4fS9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0pDOBdIjECGGZxkghGYnGDRNfujBo6LOiXcOmZvF595Y1dU9bN2bRZJBgWB9KHWK2
	 Pr1k6tZzXeDosAP5yPBjX+lzbxGwtG1XVlSXfuVYGLUYTz5zyVnVvFlFG/iqb4VcL5
	 XrZN/HKoYH5hIr2MMwKOzXFeCo9/8oNSO+8VskGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Justin Stitt <justinstitt@google.com>,
	Daniel Thompson <daniel.thompson@linaro.org>
Subject: [PATCH 6.9 112/157] kdb: Use format-specifiers rather than memset() for padding in kdb_read()
Date: Thu, 13 Jun 2024 13:33:57 +0200
Message-ID: <20240613113231.753658261@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
@@ -318,11 +318,9 @@ poll_again:
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


