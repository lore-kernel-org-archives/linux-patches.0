Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4A633C527;
	Fri, 21 Nov 2025 13:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763730881; cv=none; b=nMPIw0yqXweaMF6BUE+wfyoJKby04QAyBWEBAMF+eTG0gp0/mv6B13Z2ItUMwKkmrm+hMBOrxW3MvYJqCaLsmM7IJ7PZAw1InGUXtHxaSk1P+g2qbgiStsrQg5OgeAP2VV1nQa0tmcmbPb7bBvHRMivM/1NSzME6Hz5h0JqFq64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763730881; c=relaxed/simple;
	bh=IYDEJ5Z/lnFP6N9FxVpGMysDyhm8+2MuwWWwM2uVB5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n9a5c0w1qHNYXt5NySXkhtL4lk//V9ieCNR1ENLG+JWzakaN2xZDDGAoSt9Rc1rPbONHXNxN9iZb4zUB1drmduNr0ucw4FcGRSAYvvJB5/EIyrtr1MypKV+Br9+3astxnQEOSMKTmy0HcF5oaQVuhJ7uh4/URvIcxxOTdrUZOng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Tyboker; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Tyboker"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74CB5C4CEF1;
	Fri, 21 Nov 2025 13:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763730881;
	bh=IYDEJ5Z/lnFP6N9FxVpGMysDyhm8+2MuwWWwM2uVB5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Tyboker+axaEHJf5e7vkBcbUhMqGD+2OtXNMTQBDzfP0qgUbejxrMs96PKiLUN59
	 PKE1CujPH9+vjMpRxdsSi4QjCoR/edIhpr59hxcb5kCFIe/RChhOGBKPFgh97pBPxl
	 k5annyDHyWFfZ/JBQya6BKTxS9OJkeDfBUcshD84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Shuhao Fu <sfual@cse.ust.hk>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 007/247] smb: client: fix refcount leak in smb2_set_path_attr
Date: Fri, 21 Nov 2025 14:09:14 +0100
Message-ID: <20251121130154.862329963@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuhao Fu <sfual@cse.ust.hk>

[ Upstream commit b540de9e3b4fab3b9e10f30714a6f5c1b2a50ec3 ]

Fix refcount leak in `smb2_set_path_attr` when path conversion fails.

Function `cifs_get_writable_path` returns `cfile` with its reference
counter `cfile->count` increased on success. Function `smb2_compound_op`
would decrease the reference counter for `cfile`, as stated in its
comment. By calling `smb2_rename_path`, the reference counter of `cfile`
would leak if `cifs_convert_path_to_utf16` fails in `smb2_set_path_attr`.

Fixes: 8de9e86c67ba ("cifs: create a helper to find a writeable handle by path name")
Acked-by: Henrique Carvalho <henrique.carvalho@suse.com>
Signed-off-by: Shuhao Fu <sfual@cse.ust.hk>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index e441fa2e76897..ff9cb25327458 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -1294,6 +1294,8 @@ static int smb2_set_path_attr(const unsigned int xid, struct cifs_tcon *tcon,
 	smb2_to_name = cifs_convert_path_to_utf16(to_name, cifs_sb);
 	if (smb2_to_name == NULL) {
 		rc = -ENOMEM;
+		if (cfile)
+			cifsFileInfo_put(cfile);
 		goto smb2_rename_path;
 	}
 	in_iov.iov_base = smb2_to_name;
-- 
2.51.0



