Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF83B13A411;
	Thu, 13 Jun 2024 12:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280579; cv=none; b=u5wo8cIN0UCk1ZW04GNFS7gp8Ycp96g4ggZt4oOUvFvrowbRhNXNVU9zi5TYzGKQac0YORotzzPxyOwb7HCeaMy2f0nM/OkELcWzO833HOEc8npZTdbslFlKkb7ce2wOdVx0/8BO4mohQpEyiQbAx0JfF05Hg39vSirUo1gyD7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280579; c=relaxed/simple;
	bh=AajLS8WzWO8AxOpOJ4nsRqdPkQFiYkUbzbtR+HMAtWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X0fxsyMb2P8TgfI/a+SfYadNv3mYELxl42Ta/2djRSJ5LjhSYbUbVCXc5n9vXWWxFnafinkD8Oja2lvlLNiqYL+OrPGy4Ab2fKqzO30YTgQcxgiZ6F/cTEHV8/h6MV6GKHqyZqPPQNPGv4KfZqM3AZx3w/bCPTnwXVNJRerxPO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eRdQ8Kzx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eRdQ8Kzx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36219C4AF1A;
	Thu, 13 Jun 2024 12:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280579;
	bh=AajLS8WzWO8AxOpOJ4nsRqdPkQFiYkUbzbtR+HMAtWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eRdQ8KzxSRK4AQ9eaHOixN+Fg1FMWQV7ymzgE/JNMHfAcAOcT7Y2OBJ4uyNzj9ZGd
	 6cmKe/EiM0ihffSOrmziVs3sfnohMooMeR+quqvi0jfmd9IwX5RoKkPdAVdykszZhw
	 GWFm+PRIbQlLqzmfw1N5QukQTtci0+SRLAJW6W9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Justin Stitt <justinstitt@google.com>,
	Daniel Thompson <daniel.thompson@linaro.org>
Subject: [PATCH 6.6 101/137] kdb: Merge identical case statements in kdb_read()
Date: Thu, 13 Jun 2024 13:34:41 +0200
Message-ID: <20240613113227.215328144@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


