Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE439283C94;
	Wed, 23 Apr 2025 15:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421191; cv=none; b=E2hjui4HhPmuHUjoc5xc9Tjfe5S2Qyo1XN3xygtZocVwhVMp5QJPGhg5vwj6BUwezCQLmtzbfznMz5tygZlxFEUakn1FQ5ACmR15lz3QAdWyVQRJmKz13Tq6wCKTM31WZM5C2MMBx3MxWnCY7CQoNK1l4ZCbGsgrwmRP93M1xHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421191; c=relaxed/simple;
	bh=DfVDD87xQscKk9MNAV4HjyfC/fXZY/wfAMe59nqwwF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HCipfjh0Vm466adHPIMTwK3mletSkPx6SOwzVL0WCCr8hHVQXJWkFYfQoymCefmV12iJn0zaMph8jP8WSI/Gbm2wA/isYXiN8fuijbvRZ8k4rL5Sw6jvjIbV6ifSGlEkyBuPM6NPMHXPvWAuviQZFECFAzulTzr8WlKkAr+jXQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w8sn3/Ju; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w8sn3/Ju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 427FCC4CEE2;
	Wed, 23 Apr 2025 15:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421191;
	bh=DfVDD87xQscKk9MNAV4HjyfC/fXZY/wfAMe59nqwwF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w8sn3/JubSD1N5xrwhoTRRRGFTupvDkX6lAkBUlaQL0g7GNNdUk1klQrPkvMhDzRH
	 6f1o7rBhRWNC0vUDPn+KXVcH0YNhgCcxNDIgZoy1pduEbSvFUqAr8PNF0weeWI5z9X
	 ps83e0KFpF+GqCWVUrLO3P+9XgSh5YQkf/TRoXBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 116/291] smb311 client: fix missing tcon check when mounting with linux/posix extensions
Date: Wed, 23 Apr 2025 16:41:45 +0200
Message-ID: <20250423142629.114793957@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <stfrench@microsoft.com>

commit b365b9d404b7376c60c91cd079218bfef11b7822 upstream.

When mounting the same share twice, once with the "linux" mount parameter
(or equivalently "posix") and then once without (or e.g. with "nolinux"),
we were incorrectly reusing the same tree connection for both mounts.
This meant that the first mount of the share on the client, would
cause subsequent mounts of that same share on the same client to
ignore that mount parm ("linux" vs. "nolinux") and incorrectly reuse
the same tcon.

Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2417,6 +2417,8 @@ static int match_tcon(struct cifs_tcon *
 		return 0;
 	if (tcon->nodelete != ctx->nodelete)
 		return 0;
+	if (tcon->posix_extensions != ctx->linux_ext)
+		return 0;
 	return 1;
 }
 


