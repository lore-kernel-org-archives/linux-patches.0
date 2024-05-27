Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFFB168C4;
	Mon, 27 May 2024 19:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837493; cv=none; b=bVNWq5b2DjryuzUNsvyewXuiT9HbtkSCJ/lXxi1xDuXI/FeXIKhjazd6n5FhXSwftmwsG+aTOUI0VceVyu/jyGRloHZD572xiOATrLPJdgq/SQru8Pj4CUqApTYcoxXIQSCefrVQc0U0zDxBDOkGnx2Itfo09x4oKt7hLP4YYtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837493; c=relaxed/simple;
	bh=qt4evT/fkdXzWf82o8QO2UDA6orF8zq1GjKPAw1amHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tCc+whVTft7GHEJ0qz4dMBpY0ZEa0Uj+44vLtBaabc0zKQ6b6bF3+AxCbu/pAq9NJiHPXpmKCXbxt/ilRPHqvUQB7STNRPyV3K+ag2ij7/IXayW6dbTevVr2VGvuSEsR8sLoG4U8cBJDKdM8aXyympUmvmw6KrK3j1/Alcc/8po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oZWEvW+6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oZWEvW+6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1014C2BBFC;
	Mon, 27 May 2024 19:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837493;
	bh=qt4evT/fkdXzWf82o8QO2UDA6orF8zq1GjKPAw1amHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oZWEvW+609Ua0rytOUBdUNIZxzE9wIhph0Px42KHZ7bPeKhF/N/M1teVetRMi1KUm
	 he90aR8AdNmpM6BvbIXLpiL7hP4Y6SjJXvEc7ESUYmOW7e8tG9vjEBYSd8Ejg2j2X5
	 CKB8lUNM2aZSA6ilxpsUs94UuZy//K8bio7PdWiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.8 031/493] fs/ntfs3: Break dir enumeration if directory contents error
Date: Mon, 27 May 2024 20:50:33 +0200
Message-ID: <20240527185629.423375623@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

commit 302e9dca8428979c9c99f2dbb44dc1783f5011c3 upstream.

If we somehow attempt to read beyond the directory size, an error
is supposed to be returned.

However, in some cases, read requests do not stop and instead enter
into a loop.

To avoid this, we set the position in the directory to the end.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/dir.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ntfs3/dir.c
+++ b/fs/ntfs3/dir.c
@@ -475,6 +475,7 @@ static int ntfs_readdir(struct file *fil
 		vbo = (u64)bit << index_bits;
 		if (vbo >= i_size) {
 			ntfs_inode_err(dir, "Looks like your dir is corrupt");
+			ctx->pos = eod;
 			err = -EINVAL;
 			goto out;
 		}


