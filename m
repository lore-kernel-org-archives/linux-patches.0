Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0DD363C4C;
	Wed, 20 May 2026 18:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301621; cv=none; b=sIGb0o2jwW9sbfc0iqZPepyrui5o6FQ81ABbNpt2B6gkNKXwIeBtVDwKWlak5syS1V8yNa3k/onUi45X21uQ2X54MKbN9AJwfFesiN8e3HXPsHBGHEl14H05xXuA4uVlNgEAmInYzuRgfmc9IYJGwF+PmLzEQyLfOwcgJzR/T6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301621; c=relaxed/simple;
	bh=9cq6uUNqbD9a2vnsBtIthQvkoBhE//7/4Nyu108J+jY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=muPD8DDgQ3n2nCwEO5G58r7bvZ+yLsrQNwMyBubIIHuxqaPSzw1tyTvErki4xmoH2YKGqcNfzAKZErxq1Dci6YLmPVRpOzU4ZrR3AZsdvH0gfj5PYpDUxKrI6aPbPABKOvf3uHSlFelMVtyFKRt7SQnCs4XSEmweM9Ho74de7dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qUmMHGPx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qUmMHGPx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0997C1F00893;
	Wed, 20 May 2026 18:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301620;
	bh=kfYfNhy115zCNOl9m5w0zpna5XZ/L9vF0z7U91EFr94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qUmMHGPxj8b4O+cWR4AePh5e/ysOwY5hOxHXIGqdqky67enFUWNExKD1uO7LDOItW
	 rkwMyW1FgzDexcwA6WFIM5VonMn65ECsLddPIE+ETAB1AEliUkEfjXHyezf6/5D2Ed
	 AWfcDD/pNpC2yBG0caL6Jt27mgKiSowH51h39bew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Ye Bin <yebin10@huawei.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 625/666] smb/client: fix possible infinite loop and oob read in symlink_data()
Date: Wed, 20 May 2026 18:23:56 +0200
Message-ID: <20260520162124.821300612@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Ye Bin <yebin10@huawei.com>

commit 7d9a7f1f96cd617ee9e75bb22217c709038e26b8 upstream.

On 32-bit architectures, the infinite loop is as follows:

  len = p->ErrorDataLength == 0xfffffff8
  u8 *next = p->ErrorContextData + len
  next == p

On 32-bit architectures, the out-of-bounds read is as follows:

  len = p->ErrorDataLength == 0xfffffff0
  u8 *next = p->ErrorContextData + len
  next == (u8 *)p - 8

Reported-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Fixes: 76894f3e2f71 ("cifs: improve symlink handling for smb2+")
Cc: stable@vger.kernel.org
Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2file.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -49,6 +49,9 @@ static struct smb2_symlink_err_rsp *syml
 				 __func__, le32_to_cpu(p->ErrorId));
 
 			len = ALIGN(le32_to_cpu(p->ErrorDataLength), 8);
+			if (len > end - ((u8 *)p + sizeof(*p)))
+				return ERR_PTR(-EINVAL);
+
 			p = (struct smb2_error_context_rsp *)(p->ErrorContextData + len);
 		}
 	} else if (le32_to_cpu(err->ByteCount) >= sizeof(*sym) &&


