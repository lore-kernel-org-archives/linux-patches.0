Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85034403EA7;
	Wed, 20 May 2026 18:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302967; cv=none; b=WCw5DurLfEELNNTvY96fQ2dxnRrwkJbP49Fardk36Zaqch5UAAUcWWe604a0YszsgEUmjKHQf+epzu3isTaCfjBDpDWI2FJp1yZfiEqtGHpQ0DWdgO5ertLhe7x3Gad1Q00YBoCeJnW5CYMa/AqvDgLYMswTXByLYOyBQdbmfg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302967; c=relaxed/simple;
	bh=Kycty08P8vfyeEUuJu1JBRmLT245+WnxkQcDivqpYs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O7STTyF60TWJoSzb7A1sazy+JDC8cbhnhk9lNkbexGOBJ5RdLm72o1gsArhfuB0YAPn8n90Hr59RXYhNO1Y6AMk9Hc3MYDBdgwVOeCRP3gv1Va7mNm70fu4EtOoYzVQY/Ep2fw1MoRPePoS5EklSFhwQVhwLllVl3CixnVA1cxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c7Ybw7h7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c7Ybw7h7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C43E71F00893;
	Wed, 20 May 2026 18:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302964;
	bh=4ydFlfpvcMnAZp8kenAuknekihW/CnROR8HsdRKHU7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c7Ybw7h7Ljd4pwTe2CHrTC8oBWjXehnvF7MZcS7+YxFGImOuZ6xVXxX+/Hbfi75B1
	 H+/wELymErbbnwJIkIJpQ0OQf+EXXvOt6xjoT/9+Mle8ULz6/x1MAHwcGw7M6yvQ6o
	 5J6s1LrsJYyvFajnlj8DH+J9pXe+j9DNgWuxc0T0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Ye Bin <yebin10@huawei.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 466/508] smb/client: fix possible infinite loop and oob read in symlink_data()
Date: Wed, 20 May 2026 18:24:49 +0200
Message-ID: <20260520162108.695273286@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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


