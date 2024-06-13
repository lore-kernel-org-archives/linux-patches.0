Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9487F146586;
	Thu, 13 Jun 2024 12:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280257; cv=none; b=dx100WhXmBfCShGDFRICdb8FsDcHYJf9bpYvSoLVHQMBJupvhYfGRXLYPqcN2s6aMtHEv1Ol+EoYDj48meKNE0Erej9fbVpLTiqxTwWFv/I/R9uPJZE8J13/KwmY9jCXwV7rJE5dPhNKLHBQjLF86nIgihiiljWZILTsOEsP/EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280257; c=relaxed/simple;
	bh=EkzQtEhpzGtlwfNv863lAZ/FN56nT2VJFMTSeRIITUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=My8OLK4mmKbtv3gJvM04MhgsuXeRZw06gzr//62Pz9xi/UuJw9xYluiIlDfIRLyW8ftI9JIHCQwaPQhDvaXqH9QvjOs+AWWv6isgcopbF87L9vJeMAj5+bPLErdoz5TlPUVfoa0FOmDjGnlNSyItMgMjfGqBERL2vE3vZXI+WL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zPiuWBXv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zPiuWBXv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19D98C4AF1A;
	Thu, 13 Jun 2024 12:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280257;
	bh=EkzQtEhpzGtlwfNv863lAZ/FN56nT2VJFMTSeRIITUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zPiuWBXvgNwjMGRyTmvRqvQ/Kc0oPpi+HO+ea7Kb3jmbGtepjwj5GYdgy/y+WNkdk
	 MgxxVIjeMYwYjbfcZDuKZSSgKMNKEy0NZAjfXCdLxRk57cypMZOjOUJTgfP5o1g8Qh
	 INA3z9CHzhIe3jRM/IIMYHnkMJbpWcACWHmJokcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Justin Stitt <justinstitt@google.com>,
	Daniel Thompson <daniel.thompson@linaro.org>
Subject: [PATCH 5.4 196/202] kdb: Use format-specifiers rather than memset() for padding in kdb_read()
Date: Thu, 13 Jun 2024 13:34:54 +0200
Message-ID: <20240613113235.304649660@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -315,11 +315,9 @@ poll_again:
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


