Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F2A26F46F;
	Thu,  2 Jul 2026 16:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011521; cv=none; b=FJ+NcK6x9Uue7zFUspPhqugwxizTNKOdiE4J2K2ToZupWG0E6uORBfdY4sdcGNWl6YSoWJxLuhBlReJFAtA08werBkPGZj/y8XyHA8+lwy7cmxjDGWLeodV3G0m6ZQ4iVTRvHhKmb7bPYtu7XFIWOJjIOdkVW5epgZcH+Mh+5SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011521; c=relaxed/simple;
	bh=Glv9WQ8pvMJdDpT77I3WctiNgSzpGIFFOBEUa8YQHog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R5bFde8XbQnzZTR2aniftvHRUtOHrgNKkyGh5GOA28DH4e/xhVmju9sgG7QZVHxg6Z3mnMXoqLUHzS1Q+U+OyG7vyS8GruQ/VL7ZwEHyhvG7rCAG3g0/Zq8XlOYH0jqWdirqruAbHdnSLFghWbU16vWW79yXhh9QknhrkBgA344=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T/EPs3L0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T/EPs3L0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF191F00A3D;
	Thu,  2 Jul 2026 16:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011520;
	bh=yAjf/Tyb5faQ/vGz4ztGS+Op9hxrwoNT96nav4a8O+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T/EPs3L0wqZkdV7UzKpUOOFzI35zn1hijN8zkP82em8LcrfK1DDbCItn7grsY7wLO
	 oFlUw13VXVYF1bSiXRdGlzpY6mGu0lfGlrHgPKnKbIJTFKrE4GV25zBLMpDoJHLL0n
	 GwHIJbxLOMpzWCNmlorgGVWAhT0PeDAK73wCaUI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Yan <sdjasjbuaa@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 7.1 030/120] ntfs3: reject direct userspace writes to reserved $LX* xattrs
Date: Thu,  2 Jul 2026 18:20:26 +0200
Message-ID: <20260702155113.585850995@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.964534952@linuxfoundation.org>
References: <20260702155112.964534952@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -851,6 +851,12 @@ out:
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
@@ -955,6 +961,12 @@ set_new_fa:
 		goto out;
 	}
 
+	/* Do not allow non privileged users to change $LXUID/$LXGID... */
+	if (ntfs_is_reserved_lxattr(name) && !capable(CAP_SYS_ADMIN)) {
+		err = -EPERM;
+		goto out;
+	}
+
 	/* Deal with NTFS extended attribute. */
 	err = ntfs_set_ea(inode, name, strlen(name), value, size, flags, 0,
 			  NULL);


