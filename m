Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679992FDC20;
	Thu, 16 Jul 2026 14:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212009; cv=none; b=NWJsTgniBN+vWNW9P0B6okeRoy6QXlnLOK5wYbapmmlSWpUx5VoEh6Iq8AiPRysCk9GdJ6L1h58FveuR9++wqt3J5d1lSnlVkyAKTHwX5UmGdNsVxG3hQJwIl3R3RRavGTnW7IiqzgW+8CZxi8mWtuFKFH1CukwkemXYAv0U4CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212009; c=relaxed/simple;
	bh=qba0TF9F/KoQlVdHncpDnWy6a3NChxwu+UCT76GMfNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ndPPwGozBo7RTuQ77HAMQ6aX68IC4WMoQWw92FHZm7SGfF0QYLwkp9TgCa4fjt1VoIK/XOA6PTEtwFy88KTBc6YzBCkfAftZAcw+krlyzPe6GBiFv+QYfPAE/xWa+Ya1OprMr3XIserb6IBgn1wFphtJiEiLb6p61Kqv/g5rwI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IiW+BVsv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IiW+BVsv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9230F1F00A3E;
	Thu, 16 Jul 2026 14:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212008;
	bh=vINGTTpNEXaeEvYNYkEhZRnNkA4wgP7aXR7HqeR5smc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IiW+BVsv/8v5gT8bMEIv8239tpe7REUpGGLwFSFKFn0wNndUThPQo29IInkPWV9W8
	 svOyEeoXh1VzgEY4BambIzfa9I8MG6fzP1SnrviiU4Qu/3rAuqNpwMLEVX4qYH06zV
	 e0ZmIrodMDaTBmycFzbNBaSRVFmJNISU1OZChPuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Portnoy <dddhkts1@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 164/349] ksmbd: add a permission check for FSCTL_SET_ZERO_DATA
Date: Thu, 16 Jul 2026 15:31:38 +0200
Message-ID: <20260716133037.052784538@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -8417,6 +8417,12 @@ int smb2_ioctl(struct ksmbd_work *work)
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


