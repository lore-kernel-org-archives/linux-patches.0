Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D2B248BA6;
	Wed, 15 Jan 2025 10:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937870; cv=none; b=JbsTgi5NH2PC18ig4k/ZJRVYu8Yq0BWCGkTNekFwuAcH5PX/XpD/9qd9ZdAh7ExpfMy+C6UxpuZHtjg8rh/gxW3at7ZBdo/2iu4ygZ8R11L0ypONEPzfPQ5t7Gj/w9lRxUSO/y18CIH/f1PQh+zkBjTzGGeeq0mInbacL9k1dio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937870; c=relaxed/simple;
	bh=UjXA3FDKNBK5wSME/mmmSA/qXB9MsS0wXbskA1ENZSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z5wPTeU9Rn6vIdzdG+Fhz8RtgNhSeQlA9TCkngQyHho72VwuMDbtjKTeup/rhmoQiCd9/ZSqKANbb7q4TCkgAVKA8OeqGha8/wpwgRVIB0n0hcpTpQgilE42CIBXfmFrYz6I4H1plrUKCWBpZ2aMP/D3NG/+hUjpXP8B4Cfk448=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qG7rIQcO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qG7rIQcO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 798C4C4CEDF;
	Wed, 15 Jan 2025 10:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937869;
	bh=UjXA3FDKNBK5wSME/mmmSA/qXB9MsS0wXbskA1ENZSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qG7rIQcOX+1cvGnf0lmd+W58JSy7VxUzo4um98HCrS+kUsE7vMtJ8AWZpgFIs9Gh8
	 sda3riEojsunxYkkDscvuh2XREIHF9+mmDfKtONYJsVk81ECj8zzST7Idd4/AK9udW
	 bwg86PUnHIUgVkWnfoX45jUMC2o3NbKpWbGmdumU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+91ae49e1c1a2634d20c0@syzkaller.appspotmail.com,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 016/189] exfat: fix the new buffer was not zeroed before writing
Date: Wed, 15 Jan 2025 11:35:12 +0100
Message-ID: <20250115103607.006634155@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Yuezhang Mo <Yuezhang.Mo@sony.com>

[ Upstream commit 98e2fb26d1a9eafe79f46d15d54e68e014d81d8c ]

Before writing, if a buffer_head marked as new, its data must
be zeroed, otherwise uninitialized data in the page cache will
be written.

So this commit uses folio_zero_new_buffers() to zero the new
buffers before ->write_end().

Fixes: 6630ea49103c ("exfat: move extend valid_size into ->page_mkwrite()")
Reported-by: syzbot+91ae49e1c1a2634d20c0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=91ae49e1c1a2634d20c0
Tested-by: syzbot+91ae49e1c1a2634d20c0@syzkaller.appspotmail.com
Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/file.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/exfat/file.c b/fs/exfat/file.c
index fb38769c3e39..05b51e721783 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -545,6 +545,7 @@ static int exfat_extend_valid_size(struct file *file, loff_t new_valid_size)
 	while (pos < new_valid_size) {
 		u32 len;
 		struct folio *folio;
+		unsigned long off;
 
 		len = PAGE_SIZE - (pos & (PAGE_SIZE - 1));
 		if (pos + len > new_valid_size)
@@ -554,6 +555,9 @@ static int exfat_extend_valid_size(struct file *file, loff_t new_valid_size)
 		if (err)
 			goto out;
 
+		off = offset_in_folio(folio, pos);
+		folio_zero_new_buffers(folio, off, off + len);
+
 		err = ops->write_end(file, mapping, pos, len, len, folio, NULL);
 		if (err < 0)
 			goto out;
@@ -563,6 +567,8 @@ static int exfat_extend_valid_size(struct file *file, loff_t new_valid_size)
 		cond_resched();
 	}
 
+	return 0;
+
 out:
 	return err;
 }
-- 
2.39.5



