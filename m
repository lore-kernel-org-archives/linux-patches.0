Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921BB417357;
	Thu,  2 Jul 2026 16:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009699; cv=none; b=YQ0g8UsOR/kfHozVw0dJeHj38RlQ9jH5Sa40ZqoyTHBwED0BpS+RWcA0nJHI3F/o2bMLc+r4LrqhIkmIClKDEBPR9EdQyET0spOhSk9nyCb9yduWJ1Jd2zNBDyqc9E5FAZHwnZBE90gVojHVl0TlO1eNo0mXcdP9y2GCofeW3mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009699; c=relaxed/simple;
	bh=OrUFmmZYT4clliZbCYk/9sCDY11vHULMWa27hEA7iQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KzofUUKgbWK6FxGfcP/gnY3D/7JQ0s6fB/PQWVCxFZKU+V6yPDNSpSvVaHNFmSkRLAMVlSCg126oALwpmSFGrXhvY+6al81ONB5AzEjbVwk5XmBCIiDnpcotj2ybZpByF9TvSO8Im9KbnqUmx9Ux2cwXx0dcPmxwOguiQtYPZ50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zSbxwlSZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zSbxwlSZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3B571F00A3A;
	Thu,  2 Jul 2026 16:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009696;
	bh=h27Aug2LM3iWykheemiRw+N7RAkRUhgofxFjZXmrdOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zSbxwlSZmLlrqWHhU+snA8oI01T4P7SFhLbsJ91Oz8u+e1yhJhu1HwjUntFe1ak0F
	 Mfq8Ef6T94DhhV6LNKFB8LN/rJxndyJ098ENpnhc7KPDd0cqKBXYrbobBDdDr272aW
	 EhUM0g3Bt23SjPlmTpoLWUED4CfOb4xzbq5xmc0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Yan <sdjasjbuaa@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 5.15 54/95] ntfs3: reject direct userspace writes to reserved $LX* xattrs
Date: Thu,  2 Jul 2026 18:19:57 +0200
Message-ID: <20260702155110.345461955@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155109.196223802@linuxfoundation.org>
References: <20260702155109.196223802@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

commit 5b08dccecf825cbf905f348bc6ccb497507e28e2 upstream.

NTFS3 uses $LXUID, $LXGID, $LXMOD and $LXDEV as internal WSL
permission metadata and reloads them into i_uid, i_gid and i_mode
from ntfs_get_wsl_perm().

Because the empty-prefix xattr handler also lets file owners call
setxattr() on these names directly, an unprivileged writer on a
writable ntfs3 mount can plant root ownership and S_ISUID on their own
file and gain euid 0 after inode reload.

Reject direct userspace writes to the reserved $LX* names. Internal
ntfs3 metadata updates are unchanged because ntfs_save_wsl_perm()
writes them via ntfs_set_ea() directly.

Signed-off-by: Zhen Yan <sdjasjbuaa@gmail.com>
[almaz.alexandrovich@paragon-software.com: added an additional check for non privileged users]
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/xattr.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/fs/ntfs3/xattr.c
+++ b/fs/ntfs3/xattr.c
@@ -844,6 +844,12 @@ out:
 	return err;
 }
 
+static bool ntfs_is_reserved_lxattr(const char *name)
+{
+	return !strcmp(name, "$LXUID") || !strcmp(name, "$LXGID") ||
+	       !strcmp(name, "$LXMOD") || !strcmp(name, "$LXDEV");
+}
+
 /*
  * ntfs_setxattr - inode_operations::setxattr
  */
@@ -949,6 +955,12 @@ set_new_fa:
 		goto out;
 	}
 
+	/* Do not allow non privileged users to change $LXUID/$LXGID... */
+	if (ntfs_is_reserved_lxattr(name) && !capable(CAP_SYS_ADMIN)) {
+		err = -EPERM;
+		goto out;
+	}
+
 	/* Deal with NTFS extended attribute. */
 	err = ntfs_set_ea(inode, name, name_len, value, size, flags);
 


