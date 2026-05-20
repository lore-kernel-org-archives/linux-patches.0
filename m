Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0200231842;
	Wed, 20 May 2026 17:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297155; cv=none; b=R3t90COriWfJgfNNt2C/JGcn1a6E71/yUSRqBMKhgrkD9rHDIrSkeH7V1c3TFn6F6TTAN8ZYXOBUlGKi274EWoZfENabyUgteO4ybgXG5xi+OsTD9NjhjM/KRx5QOx8c+yomyjWkMlwX/fwb6rGW5URFJB22RF4CPlbO2OMjM9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297155; c=relaxed/simple;
	bh=bVZD0pBxdKG/RTrRmigCkWsu8a78QqdvScnkUT7vwV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BN2oMg+ErtN+h5uUMp2W62c//dFJ46rNfxOsCU7sGYPBGWeivp3c9HtXbDSqRBFUbtLOVKzFjBPcMM0myVEt21EsNmBKiyWUyAQcYucxMKUJP8jfqB541dgVSdXDOJhzgxcTsYb+eDcg3NWhATm6A3jAlBiP74F49Mo9haNZ+8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WUKDUUI7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WUKDUUI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00B171F000E9;
	Wed, 20 May 2026 17:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297154;
	bh=Qe3Lc8Yod/qCto8EeXP69v3PfXlkQdL1gtC6IGthEDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WUKDUUI7w5vZ/ni1l8fgvb1GorWrH7nGH916cSw96Arbo1K51ftGa0YEo6KdZpq/R
	 DUfmCOrBZ+OKC6RSKGs2Pqw6NGeevvik19oWe6cX81wkMoI720NoGdth5dTRCVc0e0
	 2OxADe6IWpXX+4MBghg0qQjDhgTylWPGtqgB0cLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Ye Bin <yebin10@huawei.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 7.0 1071/1146] smb/client: fix possible infinite loop and oob read in symlink_data()
Date: Wed, 20 May 2026 18:22:01 +0200
Message-ID: <20260520162212.470044075@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


