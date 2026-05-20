Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26D130675C;
	Wed, 20 May 2026 17:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299832; cv=none; b=mRskVB8gCq8egjXc9wniI1oBJPdotzDcu2IfF66+zxdKfTo/F56pvBUoFbU1mPQJyIqqiO5SF+425g6tQXDRSrZ54hJinINefzC5rEASF+oqyE9vIdl5Dj9tBfYle0Z7qTMQp3JmRbsz0nH8EVq3iQOPTTB6K1Yz0UpNjxF6Ov8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299832; c=relaxed/simple;
	bh=KuSUU0F7CuaRJ43thU6y6ou6ia/P8coa/VJtVBePVVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GRLW5Sw6dzaHQeM6hWsQGx5NraUhMfnmfdJzzgNycysV7Y50gRl7wjgX3PlxJS0qYob4l6Mkgp0f+LyZ0jHmkSu1pfNNpDc5OCa6lico8mf1spFwGwNsA4vlxqpSwAmAn/9gxYDTc6NlzgICIT8D9m7QAltC+TWuvW0MN5l59Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=shBXNPvf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="shBXNPvf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C81E31F000E9;
	Wed, 20 May 2026 17:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299831;
	bh=MDb3Oa7JGAmW8yztL9sWuVGYUljKkugAzGnQtlHHcjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=shBXNPvfoGvTBI/YOsKVyRoEw0D6thrUtnPAQixr4zoDl9Oz64H4MOg7G0xbXqmfb
	 r1u0Yvyds3QkGqGi7Zt+i5QPN6LpNdkrtg/lfpQytnlo3piL5ZJ8lwiAd4xY18iX1I
	 m8/n/h2fay2LgWBQVe9Wz0OyNhrIvsRpj7D1txq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Ye Bin <yebin10@huawei.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 903/957] smb/client: fix possible infinite loop and oob read in symlink_data()
Date: Wed, 20 May 2026 18:23:06 +0200
Message-ID: <20260520162154.158183498@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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


