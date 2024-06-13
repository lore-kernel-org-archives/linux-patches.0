Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F1981AA7;
	Thu, 13 Jun 2024 12:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718283008; cv=none; b=GCl+kXXSBn/sUXTAAl8xGSPhGy2w1E751bZmqe0rKt62wio819OiOsEyicrIYnudpcH59nPzpwAhsPPGKAxixYnutuLIGNkN3DO9Yj+ITBwI8HVTRED412TZjiD5aXmy0f6Pa3P4gPUMavusBVxVCH2bPG0Q54/wh86QkrGf0Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718283008; c=relaxed/simple;
	bh=TViRWNGidfCYnDjxxcJ+X1z/lrNu20921Odc0kfSJBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NnkH6A2tEtb9bnquaY6HyhFAuOqQ/36Lpu/mtS1uZvS0vL/mcwRzbfkCvCwa6a+7KS+u2jL3LwjPPVUqV3D6dHCnzBzQ+/EDL815M/RlLjprGVe8uv4YrwbZvaZf0k8b3LRUmwHEkuXa01wGvJGl3Hf3nYwOsv0+FIcS7Do8sPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eii0S+BE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eii0S+BE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78EBFC2BBFC;
	Thu, 13 Jun 2024 12:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718283007;
	bh=TViRWNGidfCYnDjxxcJ+X1z/lrNu20921Odc0kfSJBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eii0S+BEAQEHa/CMlQkDRBJfPEQ6gIk94wuMeDGltiBtAp9EDZo1gNbOwj/wmBX6+
	 7UA5Gs42O5KQVFN6S5m+yFx05S4EEhlttlFSAeVJcQx81HYFw8M1Nossbb+fgfP/MQ
	 lA/azBObXPbBrZesl7Uv4TTS1ModiRzFsESVvzpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Justin Stitt <justinstitt@google.com>,
	Daniel Thompson <daniel.thompson@linaro.org>
Subject: [PATCH 6.1 68/85] kdb: Merge identical case statements in kdb_read()
Date: Thu, 13 Jun 2024 13:36:06 +0200
Message-ID: <20240613113216.762509042@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113214.134806994@linuxfoundation.org>
References: <20240613113214.134806994@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -303,6 +303,7 @@ poll_again:
 		}
 		break;
 	case 14: /* Down */
+	case 16: /* Up */
 		memset(tmpbuffer, ' ',
 		       strlen(kdb_prompt_str) + (lastchar-buffer));
 		*(tmpbuffer+strlen(kdb_prompt_str) +
@@ -317,15 +318,6 @@ poll_again:
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


