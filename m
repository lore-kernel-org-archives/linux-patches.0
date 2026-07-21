Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F383AFB0C;
	Tue, 21 Jul 2026 20:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665186; cv=none; b=UUsB3GzvYKzB4+NHDWcA3eQMuTic8jbcArF4mCPRcLBPumoWpJwifDmmCTWmu5ovFPoMWHNRXmFG0Jt1bYNC0i+/YDAL08V0TCKsEgr0Gyf/L7vgvfKte47AYx495GbkorV+jnymhRJ0sJPmeCEqyCsKbFdSEAzRkLOk4+eS+Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665186; c=relaxed/simple;
	bh=OYzUcBIciUpP6aNFVCeeTwkhRsM006HDQtI/Drsc8U0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tKcfBt3kvZ7h7GBCxibMPz0/YEhFZXbdw6h4fjxDVS8QeMTkMA6jbo8G767eaLf6n0Cos98o0HK5Ol8WCfVdmJCj2fCNTJlfyFTT9EFpv7EPQEfWqDRaDI+MPh5Cq3ILD7229tTnrSZct5XWnEqWjqEKyVi159n3k69dhT41jLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iNbZcJGO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iNbZcJGO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 293581F000E9;
	Tue, 21 Jul 2026 20:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665185;
	bh=L/mrSNzoNsm080BAI8d7sfzE3qgJITys1dTJh5GZdCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iNbZcJGOcetVTUq/yIMZXlLL1N0eLRkjIcoNgPSARyr05vZzQtEB3QogzU4QqyrG8
	 NtQ7e9gQGAcEVO2A5N5HeOg7Rfap4yxZA3pX8epeTazIZ8vGVwqBRmROAjGp/b4fJA
	 p1zMLamIXknrYdKtQ8GIg0NVlbhkg+RiDJ5Ooa8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Portnoy <dddhkts1@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 0182/1266] ksmbd: add a permission check for FSCTL_SET_ZERO_DATA
Date: Tue, 21 Jul 2026 17:10:19 +0200
Message-ID: <20260721152445.877398678@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -8407,6 +8407,12 @@ int smb2_ioctl(struct ksmbd_work *work)
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


