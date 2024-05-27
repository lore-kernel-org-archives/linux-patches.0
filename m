Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24ACA15FA8C;
	Mon, 27 May 2024 18:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836391; cv=none; b=NOtDoxvzrZMekjAxQAgYg0Z+HSt08FCyHSwCe0VKRq83vBfaYkC8WjgGB+hLN/yxj4gnPLIk0dwS1C0H+BUTjTA3/hGw6MCs5oR8HATjHwbwm2Kglzzln2FhbgZGLQ0l+1OmwgRBfwY19/zkoGRTI4Przwgavbx388ycdSpS7Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836391; c=relaxed/simple;
	bh=sx8dtVQkY/kJuWaCoHkHqua6a709Sh0+Q46IkyGjzPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mQCosfxlOrbBwQTUWPH9ecoDG2zSJ6UOdxHa/S2NBKphI6BV++Pp8FMdR/Rs/MtQhpaCQRJsTO9V2EMCo5bZtfRy/9dBbxRqaep7e1KWA+Exmk3hOvfw5Xf3JS722tLnCeDKVAtzBvoWbsRXqJmQBBuO0zj2B/OUnI7WwWaVuXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=geXYoweY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="geXYoweY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0C81C2BBFC;
	Mon, 27 May 2024 18:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836391;
	bh=sx8dtVQkY/kJuWaCoHkHqua6a709Sh0+Q46IkyGjzPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=geXYoweYceaD+3S7jEyRLcmFu3oTkdVCAyWbDpMDSwn88nHeo6faMZ/m6nLgpVtLP
	 RyZSYj3apH6Bv+SG3m1T4I/6sEFsuARUb31R7KtxjjOPLetDG4DSFeK0nY6pZl0YYT
	 Y3kbI1psTvoVIQnwruxuvitEE6mP54bZUyc//Kj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.9 034/427] fs/ntfs3: Break dir enumeration if directory contents error
Date: Mon, 27 May 2024 20:51:21 +0200
Message-ID: <20240527185604.834206541@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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


