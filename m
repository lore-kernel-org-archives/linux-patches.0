Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED7625F98F;
	Thu, 17 Apr 2025 18:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914647; cv=none; b=mSRpSdwgulZFFDW6h1/tRM8ZsMNLcVZTupFnDm0SD34fk4JQamBnjsb2ZQ52MBsOTrswWhQwFgq4/RCAlsmjXvPiHNKzfaOwszPjOld017nIkBPa0qIFBF8uA9689Ex+MFt3BDlnXUfixQHh1DqS5pnsm4PhIelDM18vmsJphjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914647; c=relaxed/simple;
	bh=yW6MLj+SpD8XjP+W3HoXbaVV5mfOCGJYLGLule3tV94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YmqySw9rnbKb07Q5u4equaCj6vMYOckfokc+EJdc8xLqlSRlRE2nsCFIMT1Ovb5XYKrBwbtV3QiSVC6CKSGI8MEAvSI60ZVDH31YjZYinBU/TwUTj9JwPviQufSapYB60v0CWU5nmj+C+qfBbRMTUnuMIbl+RQKuYtmUfyTwYag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LHa0vdve; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LHa0vdve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D545C4CEEA;
	Thu, 17 Apr 2025 18:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914647;
	bh=yW6MLj+SpD8XjP+W3HoXbaVV5mfOCGJYLGLule3tV94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LHa0vdveEXfonk8yejLX+0BhrNtsUGwqkaJf82bZegiuitKPfhu4uufg9ITZ0oCVW
	 Q1jveKRptCXEM8KXWDDp9jDmcRUa+H9Z8XbEOTjweju5xEITO/b2QHhY3uV/fpo/+I
	 FL2+JctJC4nMoDlIQh4ftLVaXcSI1GLi63QKZSb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.13 285/414] smb311 client: fix missing tcon check when mounting with linux/posix extensions
Date: Thu, 17 Apr 2025 19:50:43 +0200
Message-ID: <20250417175122.890230335@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2494,6 +2494,8 @@ static int match_tcon(struct cifs_tcon *
 		return 0;
 	if (tcon->nodelete != ctx->nodelete)
 		return 0;
+	if (tcon->posix_extensions != ctx->linux_ext)
+		return 0;
 	return 1;
 }
 


