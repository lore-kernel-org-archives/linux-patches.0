Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AACB3BCD05;
	Thu, 16 Jul 2026 14:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210891; cv=none; b=DF1Dx/QBmu38sViLEBvM2T3X7aTzEGmDfHPqYNrdlsr6nVprwG0K74eTrZhGEr8Fa9OkCvch5b/7+p5WEfAwndTRNTglAUL3CEeRIdFHduNxzWInGNFYF1NLB2iYlDN7QRdE9MtuSZwkdENvjL/WYw2LBmSN/wFhX57+KV6nEHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210891; c=relaxed/simple;
	bh=vR0fDXJ7blYWW0UvpMVC6MM0te0Y/HawaROzvbyWfyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=byOEEr8WvBcw7G1e++YlAHAcd849qUdcdi4G7Nzk9Swu+mLt6iq3CpSBqksyFK7rME2aDnpK2OuZfyYDGhfTEr9HuhAvDH1kqWrGzWs0kaXbYVmffAGhc2uyeB2mrDj2FkUDfa5w0xZWW7u8x6BSsu29A00wvzYQZFM7DzY5//k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nj/DVLVL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nj/DVLVL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1401F000E9;
	Thu, 16 Jul 2026 14:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210888;
	bh=pxU4ccuFyfaqoKOJYT/67dYEypz7J2Sp6r/jPWdao04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nj/DVLVL5/IBMX1TVLOXqgzAWd8P3COgS8rLbgFdCA5yMtr/85IMR0haC2BeOmZA+
	 BItVnJdggYQe5AkzjFA077q7axPUf4tcEBrWs+NLlatUzDmZ85GLzmZPonti6Lcp70
	 sYrw21fAKNPHEtIel3hb0Dj01Qr7rpjDwyH6mvb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Portnoy <dddhkts1@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 218/480] ksmbd: add a permission check for FSCTL_SET_ZERO_DATA
Date: Thu, 16 Jul 2026 15:29:25 +0200
Message-ID: <20260716133049.448289900@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gil Portnoy <dddhkts1@gmail.com>

commit 3320ba068198adc144c89d6661b805acce01735b upstream.

FSCTL_SET_ZERO_DATA in smb2_ioctl() destroys file data via
ksmbd_vfs_zero_data() -> vfs_fallocate(PUNCH_HOLE/ZERO_RANGE) after
checking only the share-level KSMBD_TREE_CONN_FLAG_WRITABLE, with no
per-handle access check. A handle opened with only FILE_WRITE_ATTRIBUTES
still yields an FMODE_WRITE filp (FILE_WRITE_ATTRIBUTES is part of
FILE_WRITE_DESIRE_ACCESS_LE, so smb2_create_open_flags() opens it
O_WRONLY), so the vfs_fallocate FMODE_WRITE check does not stop it; only
the missing fp->daccess gate would. Reproduced on mainline 7.1-rc7 with
KASAN by an authenticated SMB client: a FILE_WRITE_ATTRIBUTES-only handle
zeroed 4096 bytes of file data it had no FILE_WRITE_DATA right to
(6/6; a FILE_READ_DATA-only handle was correctly denied).

This is the unfixed sibling of commit cc57232cae23 ("ksmbd: fix FSCTL
permission bypass by adding a permission check for FSCTL_SET_SPARSE").
Because SET_ZERO_DATA writes data (not an attribute), require
FILE_WRITE_DATA.

Cc: stable@vger.kernel.org
Signed-off-by: Gil Portnoy <dddhkts1@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8488,6 +8488,12 @@ int smb2_ioctl(struct ksmbd_work *work)
 				goto out;
 			}
 
+			if (!(fp->daccess & FILE_WRITE_DATA_LE)) {
+				ksmbd_fd_put(work, fp);
+				ret = -EACCES;
+				goto out;
+			}
+
 			ret = ksmbd_vfs_zero_data(work, fp, off, len);
 			ksmbd_fd_put(work, fp);
 			if (ret < 0)


