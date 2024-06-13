Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61751411CD;
	Thu, 13 Jun 2024 12:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281584; cv=none; b=I2nG+q6v2MAHv3uiqDrOXHgcDEbCFO250lH6lu34u1hbKNUq9Ch+b0uhkFN18P58UTAoT9xC1Wi8O3w67SQjkvAHaO+LgYzrIdn0BTfIAaK79/myM7zbsYdlnEa7eVIPjxQyu8XmlMXs5NvLmMWbvanzFSxOqBMmPHUvppRsjtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281584; c=relaxed/simple;
	bh=h8k9LpZVh1ARWKXpRTtfQ7d4xOott4E8ylirhHHXvOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WBRaVYUFIDN2AF/XcJT4n5u2zdNLxrZ0qxLqhGMvFFxOszPGABpq+GbuUQuWI+7APqLLagogoH56DkofJ66AT9yI10L5wbRXMT4ybBn9eK+Vre+I2dWVj7+lV6FZDfT1Ph3j0TaiQx3hOa9VptxygEjQMmgRLUrYwWZt2Fhb47k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m5doaz7F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m5doaz7F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22515C2BBFC;
	Thu, 13 Jun 2024 12:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281583;
	bh=h8k9LpZVh1ARWKXpRTtfQ7d4xOott4E8ylirhHHXvOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m5doaz7FZUnauwoY0lf7A8BL/P6NhdEJ0RpU5x6TU05tSaCrvtY3bQt/1uB452UOz
	 2a2Y9UosRUHsfYTmzvRyxWzDVNUmyi7W5gL+kkR5zUL2joPemez6U/t5QIKztPfeL9
	 aaUqUVo812yme7NyWkGRjt/Gn3ZgA8sthxLU+SHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Justin Stitt <justinstitt@google.com>,
	Daniel Thompson <daniel.thompson@linaro.org>
Subject: [PATCH 5.10 305/317] kdb: Fix console handling when editing and tab-completing commands
Date: Thu, 13 Jun 2024 13:35:23 +0200
Message-ID: <20240613113259.349906900@linuxfoundation.org>
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

commit db2f9c7dc29114f531df4a425d0867d01e1f1e28 upstream.

Currently, if the cursor position is not at the end of the command buffer
and the user uses the Tab-complete functions, then the console does not
leave the cursor in the correct position.

For example consider the following buffer with the cursor positioned
at the ^:

md kdb_pro 10
          ^

Pressing tab should result in:

md kdb_prompt_str 10
                 ^

However this does not happen. Instead the cursor is placed at the end
(after then 10) and further cursor movement redraws incorrectly. The
same problem exists when we double-Tab but in a different part of the
code.

Fix this by sending a carriage return and then redisplaying the text to
the left of the cursor.

Cc: stable@vger.kernel.org
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Justin Stitt <justinstitt@google.com>
Link: https://lore.kernel.org/r/20240424-kgdb_read_refactor-v3-3-f236dbe9828d@linaro.org
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/debug/kdb/kdb_io.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -370,6 +370,8 @@ poll_again:
 			kdb_printf("\n");
 			kdb_printf(kdb_prompt_str);
 			kdb_printf("%s", buffer);
+			if (cp != lastchar)
+				kdb_position_cursor(kdb_prompt_str, buffer, cp);
 		} else if (tab != 2 && count > 0) {
 			/* How many new characters do we want from tmpbuffer? */
 			len_tmp = strlen(p_tmp) - len;
@@ -383,6 +385,9 @@ poll_again:
 				kdb_printf("%s", cp);
 				cp += len_tmp;
 				lastchar += len_tmp;
+				if (cp != lastchar)
+					kdb_position_cursor(kdb_prompt_str,
+							    buffer, cp);
 			}
 		}
 		kdb_nextline = 1; /* reset output line number */


