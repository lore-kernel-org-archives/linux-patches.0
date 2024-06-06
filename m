Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C076F146D54;
	Thu,  6 Jun 2024 14:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683148; cv=none; b=XwZ5dX4D0oyLOD5PcSNN2ZnuX5/16n6YetDT9NYI/AnEpYYo4+TF/mnF/AW0w5DgFd9vVl4hD2N/OkIUWdMkpi7BIlFiglgVgbeRiAUThqE6ggp/tBtJQzJ0n77+DnabeCeJ10U7JQvEIKB1neCqlIgZnNRO+Ere0BNKbZYqyBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683148; c=relaxed/simple;
	bh=/4Ov28ozogZ9nZyjmwuK1I4ATvtCEAC2FeBb5DLpJrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BEyIvM+a5s9QXZtDVS/2rWSecuHCduuEVsHi+WAyhOUxSuMiu5+IQp/c0IO0HHE3GYigCfBeX63dHV52uO29TWF2aOkPsU5jnDa7m4Lz/wcg0YzUiM/j7bsunx7EElVRUZkI4hgmdE+znZmoDQsdWtl0W1hD1c5moZJB1g9nsyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZsCs3eYD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZsCs3eYD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 956D1C2BD10;
	Thu,  6 Jun 2024 14:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683148;
	bh=/4Ov28ozogZ9nZyjmwuK1I4ATvtCEAC2FeBb5DLpJrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZsCs3eYDztFjpUcQlWOzf/tUeJF2LOnFhniK8/ZL6CHDGPUwkxQ+rj7uRr8dSOWNz
	 kEuWwaUcU9KkjF8Fighc3KOXZZ6KxGZypmGM64+KU0c4XYBTaGTjBe4DmgL4CprXkt
	 Ix+Hh6zCqEP8sgp2e2ca7+Rni6B5HI8Mx64Ib4Wg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.1 020/473] fs/ntfs3: Break dir enumeration if directory contents error
Date: Thu,  6 Jun 2024 15:59:09 +0200
Message-ID: <20240606131700.526499927@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


