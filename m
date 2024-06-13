Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3990C145FE3;
	Thu, 13 Jun 2024 11:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279540; cv=none; b=prl6EjOf7FpLEYd7VNZZ6AycUpsgzsJwVQmFbZtE9vzPG/VZXpdfIixg3agQfcQINpHdixHYKFXjcw8JdYTzmXA9T2QH2kFMM0qOHPu6AL4t5tetSvgnvNbu3TQmpdz37qVx7Qs9zL0dtra5eZPo9H+gx28ap2V4rEs4cNuHoG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279540; c=relaxed/simple;
	bh=apHMU9DT0kUooxC181yfnKYkQn0ZNBwv516cav0o2p0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Roiy3eF1Ej5gHf7qCpi06z3T2ksWQ/jT1dDZq1vC9j0WAQfgONr+lRB4MtwE5k3y1RrDzPx3LUJ5oGOU/QI+uN2d79DS6kvpFphmY75HhTgIA2WJYEdvjoy0GqXSouwRiYsg9Ku+UPn/mpLa0Zr6gmd2ks5guS/5Z7WBwHnw9ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p0abde8c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p0abde8c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B89B5C2BBFC;
	Thu, 13 Jun 2024 11:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279540;
	bh=apHMU9DT0kUooxC181yfnKYkQn0ZNBwv516cav0o2p0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p0abde8c4n0U1Tf7lX6ytAK0GDfhrKrQ1t0jICJVAx+09vfwsFKP7cSKtUbXy2SJY
	 ZYSBecI8h+oA1wzABCSRXfuvTa7giAZ9/FZQOFn6pha2OPNEfxPD2HpdMIYs/lovJy
	 VW7SJeqi0COMpsHZbE0BghmyhQ9LD4xZ0XCJGnOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Justin Stitt <justinstitt@google.com>,
	Daniel Thompson <daniel.thompson@linaro.org>
Subject: [PATCH 6.9 110/157] kdb: Fix console handling when editing and tab-completing commands
Date: Thu, 13 Jun 2024 13:33:55 +0200
Message-ID: <20240613113231.673696824@linuxfoundation.org>
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
@@ -383,6 +383,8 @@ poll_again:
 			kdb_printf("\n");
 			kdb_printf(kdb_prompt_str);
 			kdb_printf("%s", buffer);
+			if (cp != lastchar)
+				kdb_position_cursor(kdb_prompt_str, buffer, cp);
 		} else if (tab != 2 && count > 0) {
 			/* How many new characters do we want from tmpbuffer? */
 			len_tmp = strlen(p_tmp) - len;
@@ -396,6 +398,9 @@ poll_again:
 				kdb_printf("%s", cp);
 				cp += len_tmp;
 				lastchar += len_tmp;
+				if (cp != lastchar)
+					kdb_position_cursor(kdb_prompt_str,
+							    buffer, cp);
 			}
 		}
 		kdb_nextline = 1; /* reset output line number */


