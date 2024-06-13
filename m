Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685DF6AFAE;
	Thu, 13 Jun 2024 11:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279543; cv=none; b=LrKXYRABYygyn+9CdexU1H4Nn7pxEW3X9T592LQ4CMkMANBlmuXv3KOI5YkCm4NYmYhbX7ga6wydm+HK38j4WZda8idP0rNknLJsMcI2gmt1IPDLfiBcpQqMrSxzbDDJdgPbVq6hB2pMwxn+9haU3oDxI1FSsLptYE8eQFzhDCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279543; c=relaxed/simple;
	bh=sUvVrn+TjMI+hhXFHmWpy5sIlSEHz7kOR/xw22l1d0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HlBLgDjKzN2CahXpo9QVMw8SzdDx9b7WLJ/1ilrAn4f0frvlYVH/rSpz2j45ZchEHd9OQLzuU0QF2l2BX+Z66SS8os3MrlcMXALn+6D4f2fJ7zwoUk76nJPVZaiLDu8u8XVb9xb79nAiXtZOnwy2TA7sJfsLibLRgWX505d0Anw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KQiXu+t4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KQiXu+t4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D187C2BBFC;
	Thu, 13 Jun 2024 11:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279543;
	bh=sUvVrn+TjMI+hhXFHmWpy5sIlSEHz7kOR/xw22l1d0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KQiXu+t4kAIeU+Ja2P2tP2F+fcqKDpvJQAZAwry8AXhsiUCUcocydbCO7mMNWvVcz
	 bBm+Fn0JuKkRafJP6XqsMAPRD9PDTIYz8YZ7hOHbmctsq5YT4BSUEjYNidpFiITy1B
	 lM6FeMrl5WXCOHQn5Ex1VvI9XIxi5NFmmZ/2Tly0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Justin Stitt <justinstitt@google.com>,
	Daniel Thompson <daniel.thompson@linaro.org>
Subject: [PATCH 6.9 111/157] kdb: Merge identical case statements in kdb_read()
Date: Thu, 13 Jun 2024 13:33:56 +0200
Message-ID: <20240613113231.713950031@linuxfoundation.org>
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
@@ -317,6 +317,7 @@ poll_again:
 		}
 		break;
 	case 14: /* Down */
+	case 16: /* Up */
 		memset(tmpbuffer, ' ',
 		       strlen(kdb_prompt_str) + (lastchar-buffer));
 		*(tmpbuffer+strlen(kdb_prompt_str) +
@@ -331,15 +332,6 @@ poll_again:
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


