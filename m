Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F5E17C208;
	Fri,  6 Dec 2024 15:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498291; cv=none; b=q7nbwzERpPzZ99gEteX+qyguzAsgmRvs1p+KOW9cCtCRxQOf01JQ2rQcp12/trNAemj2R5EMDceOWRmhhPKUl47g/oLSFUo0bZickoAORIhfMhciaehY9sm3emsmw1Xd4Qt/wkXffIPR+aC4DNyEs95d8BwWGDdc/RtpiZ2WNSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498291; c=relaxed/simple;
	bh=fKQTNwQjzyFkK6jw5w0howoQQMEr6SSuXCYv24LihsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b8jA38TRL7OJMRsph2ZbXp8o2YARngZCLyJ7YA3p2Ywrr6eM3HPmPtYf7DTGt48PgJOOrijYpi+0S/Q3xmttb1/zA4Zn+ZBYVJ1OsIp+U5SlHzbQQpgJFZv/EeAj78spn4/kgkEFAAs2XloFsMT707iTjW6ktPjYBlE1rO/Xb2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qyNzhZUP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qyNzhZUP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450EFC4CEDE;
	Fri,  6 Dec 2024 15:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498291;
	bh=fKQTNwQjzyFkK6jw5w0howoQQMEr6SSuXCYv24LihsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qyNzhZUPkx2O87xHf1/Ura1nNS7Ost63TCWXoKi/Phk7vLs0tBQugQ9mv4bcwUWQu
	 fWFNilRTH/5+x101VJ/A7JZp+0QOmZKwOH4pdPpaN9wxBLwlm21obLbbc/aLF+8Fvz
	 r8eRLMhvRmWi+6Znq/KauatkMkGT2Q+pn+le4rSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 541/676] smb: client: handle max length for SMB symlinks
Date: Fri,  6 Dec 2024 15:36:00 +0100
Message-ID: <20241206143714.491908058@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.com>

commit 0812340811e45ec4039d409049be53056182a552 upstream.

We can't use PATH_MAX for SMB symlinks because

  (1) Windows Server will fail FSCTL_SET_REPARSE_POINT with
      STATUS_IO_REPARSE_DATA_INVALID when input buffer is larger than
      16K, as specified in MS-FSA 2.1.5.10.37.

  (2) The client won't be able to parse large SMB responses that
      includes SMB symlink path within SMB2_CREATE or SMB2_IOCTL
      responses.

Fix this by defining a maximum length value (4060) for SMB symlinks
that both client and server can handle.

Cc: David Howells <dhowells@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/reparse.c |    5 ++++-
 fs/smb/client/reparse.h |    2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -35,6 +35,9 @@ int smb2_create_reparse_symlink(const un
 	u16 len, plen;
 	int rc = 0;
 
+	if (strlen(symname) > REPARSE_SYM_PATH_MAX)
+		return -ENAMETOOLONG;
+
 	sym = kstrdup(symname, GFP_KERNEL);
 	if (!sym)
 		return -ENOMEM;
@@ -64,7 +67,7 @@ int smb2_create_reparse_symlink(const un
 	if (rc < 0)
 		goto out;
 
-	plen = 2 * UniStrnlen((wchar_t *)path, PATH_MAX);
+	plen = 2 * UniStrnlen((wchar_t *)path, REPARSE_SYM_PATH_MAX);
 	len = sizeof(*buf) + plen * 2;
 	buf = kzalloc(len, GFP_KERNEL);
 	if (!buf) {
--- a/fs/smb/client/reparse.h
+++ b/fs/smb/client/reparse.h
@@ -12,6 +12,8 @@
 #include "fs_context.h"
 #include "cifsglob.h"
 
+#define REPARSE_SYM_PATH_MAX 4060
+
 /*
  * Used only by cifs.ko to ignore reparse points from files when client or
  * server doesn't support FSCTL_GET_REPARSE_POINT.


