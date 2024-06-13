Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D971411CD;
	Thu, 13 Jun 2024 12:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281586; cv=none; b=Hcino4Tj/k+8jjcXBCytzkGISDKMKZGfS+NU974OoAGOWW3ZsK0vnwpD58LiO0RQ56Dffr/0+TnoVh3FsfENpVILYW6edTR7sxliHuc9FscLkDpaNbd9sxq5Vql317m+ueFblDGe4g+5oZsL2Mytws0s9vxAZvT6wvpzBpGZnv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281586; c=relaxed/simple;
	bh=Zk6IUx7UjsafQcWCCPdA5JjTj8Jhpa7euY3ezyfKaa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X0Re3Wwgz6Eg+sVTDg5ryfXzC2+NJlg8Md+Il2I8ZrINF4ag+ad9ki8xMbzjMrH0QEIvdcMweI7XggrNhGdgQ3dyERXEZxAkucD+o2sh1cEo4d82h6rjiLm9f+21lbPxxYPKNom2DiAc17D4gc8pcImP8EoI91u/LhjTWahY0Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Op2xJQ+r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Op2xJQ+r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1183EC2BBFC;
	Thu, 13 Jun 2024 12:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281586;
	bh=Zk6IUx7UjsafQcWCCPdA5JjTj8Jhpa7euY3ezyfKaa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Op2xJQ+rg9ZElyArNJeDK3FMhgHohgnJthKarO9OXYKzyqz9C4ATKvYTUzNUg9kna
	 AyTJocYIzAwBy4T5PwNt/V7avQ1hvaQeZCwVwgKrXqiSPCMMJx1E2OhEXYtVNS1Akx
	 lkdVIpt6LUVI+2q9y5hcNXH09fA7Itlv0zeRKugk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Justin Stitt <justinstitt@google.com>,
	Daniel Thompson <daniel.thompson@linaro.org>
Subject: [PATCH 5.10 306/317] kdb: Merge identical case statements in kdb_read()
Date: Thu, 13 Jun 2024 13:35:24 +0200
Message-ID: <20240613113259.389080643@linuxfoundation.org>
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

commit 6244917f377bf64719551b58592a02a0336a7439 upstream.

The code that handles case 14 (down) and case 16 (up) has been copy and
pasted despite being byte-for-byte identical. Combine them.

Cc: stable@vger.kernel.org # Not a bug fix but it is needed for later bug fixes
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Justin Stitt <justinstitt@google.com>
Link: https://lore.kernel.org/r/20240424-kgdb_read_refactor-v3-4-f236dbe9828d@linaro.org
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/debug/kdb/kdb_io.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -304,6 +304,7 @@ poll_again:
 		}
 		break;
 	case 14: /* Down */
+	case 16: /* Up */
 		memset(tmpbuffer, ' ',
 		       strlen(kdb_prompt_str) + (lastchar-buffer));
 		*(tmpbuffer+strlen(kdb_prompt_str) +
@@ -318,15 +319,6 @@ poll_again:
 			++cp;
 		}
 		break;
-	case 16: /* Up */
-		memset(tmpbuffer, ' ',
-		       strlen(kdb_prompt_str) + (lastchar-buffer));
-		*(tmpbuffer+strlen(kdb_prompt_str) +
-		  (lastchar-buffer)) = '\0';
-		kdb_printf("\r%s\r", tmpbuffer);
-		*lastchar = (char)key;
-		*(lastchar+1) = '\0';
-		return lastchar;
 	case 9: /* Tab */
 		if (tab < 2)
 			++tab;


