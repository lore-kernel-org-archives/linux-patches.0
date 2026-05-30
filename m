Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439222FDC5E;
	Sat, 30 May 2026 17:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162084; cv=none; b=CEUiTGiTiJP4tFz0JT/IrmaVdf+ut+GUkxwJO/d7S92Jhb+8v8DIz+bzuZVqij4jEWWmBGhO8pfzWrT+Jt/u90hzF6HdFcZXA0+XOy3PJEE/wPJ7iWP2SYoJjVyW3XdeEYBxqVe3GhzyuEnVdCcX3Oq073hQsOcZEg4J6b9aOz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162084; c=relaxed/simple;
	bh=zHp/uvuQBa8nwA4OMk3aQMjV/p35JW/r1lZr41qTSzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqP8xaM96vcxIEcKE4H3q9T7D0TesJyMv+K3Lk8E+a3O6Za7JVJrLFElQ+yLJjjPlPikFYiRgq00NmzzvO9mHrZkBMt56uq/Bq+47u++AbDIyIVKQMEWuOypkEiHxPyzCht4hO63U/TV7zsQ63Lx46jyYlBK3pY77RNWXZbyMvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tN4Pcb07; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tN4Pcb07"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8668B1F00893;
	Sat, 30 May 2026 17:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162083;
	bh=qr9nwkRbVhG6fPyjA6eQ6gTN4w5tk/zVfN/CzvNcm8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tN4Pcb07wu+xKxW1AOugM/D/8MXYjxgI1jYqj3PYos32TnBkTZ4qgrRCAL3UOzaXe
	 gbKm8HSFf5Ll8Txdl7Z27EtBp6OlayKuI1Mykumas2lVxq6/KNTOGB2L+68eh7Vtvj
	 ypzxgD2uq63fVQvmSY+Gcrk7//LPPgaSyuAzhQ1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Ye Bin <yebin10@huawei.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 815/969] smb/client: fix possible infinite loop and oob read in symlink_data()
Date: Sat, 30 May 2026 18:05:39 +0200
Message-ID: <20260530160323.143026556@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -48,6 +48,9 @@ static struct smb2_symlink_err_rsp *syml
 				 __func__, le32_to_cpu(p->ErrorId));
 
 			len = ALIGN(le32_to_cpu(p->ErrorDataLength), 8);
+			if (len > end - ((u8 *)p + sizeof(*p)))
+				return ERR_PTR(-EINVAL);
+
 			p = (struct smb2_error_context_rsp *)(p->ErrorContextData + len);
 		}
 	} else if (le32_to_cpu(err->ByteCount) >= sizeof(*sym) &&


