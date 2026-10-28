Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210621;
	b=2nAa/VOsK2uXUF4FeLVZR8WPM8vggcetUwKeS5aWtj2lEmkzJZbrRvxSL1/CANj1vmwB
	 nsAxNAJ0zfliVBUVhVEYRvkE7AGhDg6zkbAETZISu4m5Lo3iBqrOomfieBHvlsemWLJtv
	 HIE89jyhFG6we3VWxqdIz1BQxamo+XtDuqSU7KvcgTgrwPuqW/ANqKVemGeFaDVg8xDG7
	 27NuzpJpePxTaCLufr7O/3d4IsmgSLg4BlZuMZ4FrVkGHTkCBCgdkmolW9eSl2wTpie2H
	 ZawRfzg74RrQI6uwQPwpJzBLbL0uUcJTOpvc8lypnk4Qv5eMbkHdQUkRvZG0xLfxhww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210621;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yEPh39SURMtKzoUHb4QJ0mrUmn0+J96NCS7KnnUnetw=;
	b=X12ID0jxYj8RVOw56jOQYF5UFScVaYGBTr2WyvgYUsO7gbh/pZtpF/JbOStPztubvy2O
	 x3Y/HwrNUkdyGqXMYKElHkKAXeB/SHrONwW9CKIzjSSnY1Mka9kgBfj9NOyhqYTfw3tAE
	 5w+kaFnWEPLd0EecZryeeD5fkFpXGJG9ilDCEKNAHIWIX1MwAN8QnKlnx6uDNzJrDBe6e
	 QtXRbyXku9/DMSiFXIFSn/N8xzTbAOpp58m99iHK+8TYW0PupEPZ69Cdw+S1KSd2VNhWr
	 Q/aMDbMrgMjwLXHvqIXT+xg4ZDsRVx6sHHsZJJCiCntSBjCq7E6UhoP4RPK89Ng4WoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hU2LFW8X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B0B606A31A;
	Wed, 28 Oct 2026 18:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hU2LFW8X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D141F01825;
	Wed, 28 Oct 2026 18:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210620;
	bh=yEPh39SURMtKzoUHb4QJ0mrUmn0+J96NCS7KnnUnetw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hU2LFW8XHRv+BxY8OBMV6v5G2Hjn98tx3YPgZb3XBfAwCDPS8rmIYsxd38ArSf3fG
	 zWt+vEtuCf8hJaZ3rnFN7fiQSzIAD3/cQerUf7j17d+CI8f90NkxZpn6O8/FvVtM9R
	 mHy6zGCT5ZessJp0kGXDcPkedr0n66rDuSJ9H6s4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Guanghui Yang <3497809730@qq.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 091/571] f2fs: fix dentry folio leak in find_in_level
Date: Wed, 28 Oct 2026 17:53:58 +0100
Message-ID: <20261028170010.183801146@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guanghui Yang <3497809730@qq.com>

[ Upstream commit cca7d3e30bf30333314e31bc70b9a739f1342167 ]

find_in_level() gets a dentry folio with f2fs_find_data_folio() before
calling find_in_block().  If find_in_block() returns an error, the
function stores the error in res_folio and breaks out of the loop without
dropping the dentry folio.

This leaks the folio reference on the find_in_block() error path.  Drop
the dentry folio before returning the error to the caller.

Fixes: 7ad08a58bf67 ("f2fs: Handle casefolding with Encryption")
Cc: stable@vger.kernel.org
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Guanghui Yang <3497809730@qq.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ Replaced f2fs_folio_put(dentry_folio, false) with f2fs_put_page(dentry_page, 0) for the page-based API. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/dir.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index da717e4d6aee7..8ec23b8af64e1 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -372,6 +372,7 @@ static struct f2fs_dir_entry *find_in_level(struct inode *dir,
 
 		de = find_in_block(dir, dentry_page, fname, &max_slots, use_hash);
 		if (IS_ERR(de)) {
+			f2fs_put_page(dentry_page, 0);
 			*res_page = ERR_CAST(de);
 			de = NULL;
 			break;
-- 
2.53.0



