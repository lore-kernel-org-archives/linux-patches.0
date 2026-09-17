Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6764C10F2;
	Thu, 17 Sep 2026 18:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668307; cv=none; b=FsELwyOKe7Rr0Btf1umFf1L7a75BYRxHLRa96RTVa7S6MP19OyGfSFNDfkAv/Rvv9gTGC6r8TLQVLUMlNpQLMsSLDG38erfYbvpOYa45RVxS/HZvLPkQjn2pLlrVSVQpMFBnbvIAo93p4fLqVw5BctMr8PpIeEtfBDjhSnqzLKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668307; c=relaxed/simple;
	bh=7jwWhg/qf40bAXVLcg7g45JywG/6I6Wnv8hKZjUe96k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mi1vGfIWX9We7IwvdqjfXfOdtY/tNM34F8pzupVANBqrpXwneNNZ7Yj/uCCT7ogoxLljlYpAiK1E3b8Y6eFrIACxO3dzkaQx6b258je4ehDlbqKUkGPKq6h+gyXd5SlmfTinrm32h6AYrTVxIjSqIG+aWj3Z0X+zhKswCMJc548=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2gq52qGN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2gq52qGN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A9711F000FF;
	Thu, 17 Sep 2026 18:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668306;
	bh=eodzxkq34Yw4ckx9b5K+6k9jpNscDwD7xNPFVw+rAKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2gq52qGN3U6O4bC+HYYhsVMYRq8FmqL2Nbz5mz0QVtmGTHGumLI1AzQ9n5nPfLRN7
	 t2w3tqdG6efLYLCsI5M1GoTNZhXkEMnlGD1zPkGKDTZa02mD5m3Nr4rXRZtJWLNT3U
	 KupNIQeMrNwQTioieqAXUfA0jUdx3VQXT1gpuHWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0382/1102] cachefiles: Fix double fput
Date: Thu, 17 Sep 2026 16:05:25 +0100
Message-ID: <20260917151549.245080624@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit af6830cc12dfe86c832dccc9c9878a93aaa22f83 ]

Fix a double fput() in error handling in cachefiles_create_tmpfile().

Link: https://sashiko.dev/#/patchset/20260608145432.681865-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260625140640.3116900-4-dhowells@redhat.com
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cachefiles/namei.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
index 2b3f9935dbb44..2249ed7f0a407 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -497,7 +497,6 @@ struct file *cachefiles_create_tmpfile(struct cachefiles_object *object)
 	ret = -EINVAL;
 	if (unlikely(!file->f_op->read_iter) ||
 	    unlikely(!file->f_op->write_iter)) {
-		fput(file);
 		pr_notice("Cache does not support read_iter and write_iter\n");
 		goto err_unuse;
 	}
-- 
2.53.0



