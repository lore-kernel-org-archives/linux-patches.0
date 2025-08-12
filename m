Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67666268C73;
	Tue, 12 Aug 2025 17:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021426; cv=none; b=eJDaSXSdGDRaF32YzvMiGEM6y/MFoB/cvvSPZM9nrY3RSoj9cSuYUHA8OUgKTkx03TxXHtvxCe9Mmcxb2nPkzeTtnSQw5jek2rZZvr7vI2B5or1Q9BS2HLYeoSLzBQ1pHmnbuE4UMYuythRXWPvp2dErr0BYBSzyQmoNPk9NKwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021426; c=relaxed/simple;
	bh=IzWe0FlXtO3MnTCHXeekdykiAPgYNm5zIDwOm6JAktU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m+NsfXBsLrqnAzEAaiHRIvn4HWPwl9/SUyipjmuUlDO4toNP8ASajFpzyBH5ARtU3FTYKknSyNeCRtP9DfOLvbfZ7IJKcYMl8ygHH5kajssc+vX0lrnQulAGKR+CSweQgy3kZIAJ4usEzI2miUaqMu4CY2UP3+CiMsg5i9yjzOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YcX55j4E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YcX55j4E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8565C4CEF0;
	Tue, 12 Aug 2025 17:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021426;
	bh=IzWe0FlXtO3MnTCHXeekdykiAPgYNm5zIDwOm6JAktU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YcX55j4EQb3SQGExuLRvUMAjXoga4PBCZnA0FkovgtBnHI6yQq0cHieRC0yxXSXD3
	 YWh6ybeLM9m1UbTxw83/F2XQxPaiApyFhjaqbfjxth7CK8tTs9sgiow/Ym5BaMMXVa
	 xQn4M7kmg4pPR2CFtRjgJ3j5HR53Ys+48gDssmXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 243/253] smb: server: Fix extension string in ksmbd_extract_shortname()
Date: Tue, 12 Aug 2025 19:30:31 +0200
Message-ID: <20250812172959.200375072@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

From: Thorsten Blum <thorsten.blum@linux.dev>

commit 8e7d178d06e8937454b6d2f2811fa6a15656a214 upstream.

In ksmbd_extract_shortname(), strscpy() is incorrectly called with the
length of the source string (excluding the NUL terminator) rather than
the size of the destination buffer. This results in "__" being copied
to 'extension' rather than "___" (two underscores instead of three).

Use the destination buffer size instead to ensure that the string "___"
(three underscores) is copied correctly.

Cc: stable@vger.kernel.org
Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -508,7 +508,7 @@ int ksmbd_extract_shortname(struct ksmbd
 
 	p = strrchr(longname, '.');
 	if (p == longname) { /*name starts with a dot*/
-		strscpy(extension, "___", strlen("___"));
+		strscpy(extension, "___", sizeof(extension));
 	} else {
 		if (p) {
 			p++;


