Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836F146D544;
	Tue, 21 Jul 2026 19:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662698; cv=none; b=kHgNDJxpJrCjiZc8jYDUHJJPJZjAmWna6uVG7+3XGmHUFmHEB0GMSVIaTwnMojsv3aNt5fPPRj4qHNxM2hm1PpJCJLTWz6C78cs/O5aYWo9ttb59GFKHUjyepycKqRDef1IzOQYRPIhZWY6NnUgJt/Zm46TWiDBZU+qxSU9jBow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662698; c=relaxed/simple;
	bh=136Fu9GRWEZ8Pt9m4LGSMZLXoU/z/Wqx+FIayGkPwN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Am0PBNT6UqIOxfNwC5vDoNNaIO2r97Cmkm5LiQvsgqpJ537+G/lDzOMB7+iG2hwojJmF4I9OqnT76Z7LlGPZ+a8xKQ+6A8HQIWjbSl2hhHjUq3jsJKBvdrj/lxgxrIfK4Bz+eA5Ojl4Fbdaa1dpvgrYrqbKF7N++9oQzzGOzmro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aenb+38y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aenb+38y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 428ED1F000E9;
	Tue, 21 Jul 2026 19:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662689;
	bh=w4Erm5zwi/iBKd0ynhTiZEdLP1+eYEC1woH22P24KIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Aenb+38ye/ObBfM8+RNNrXFQSEnh9DEy0CwuMy/a6xeBkvmAG7Bz/JLv036gbEzvJ
	 6voCTB/Hw+AXiqZuYQTG0U7vfrZhAaP9A69wj5ar/wC9YJ4u/FuLsqun+QPqKupsna
	 zrdhDnJmx87qyn/ezEwcE/EguRHodsO7DvWNJvR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0539/1276] apparmor: fix rawdata_f_data implicit flex array
Date: Tue, 21 Jul 2026 17:16:22 +0200
Message-ID: <20260721152458.183084172@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit ad213bbbc0e3e270ce7df2d9d80d4ce3826993d7 ]

rawdata_f_data has a blob of data that is allocated at its end but
not explicitly declared. Makes sure it is correctly declared as a
flex_rray.

Fixes: 63c16c3a76085 ("apparmor: Initial implementation of raw policy blob compression")
Reviewed-by: Georgia Garcia <georgia.garcia@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/apparmorfs.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index 4120480193a5d9..0064a06cea162d 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -71,10 +71,10 @@
 
 struct rawdata_f_data {
 	struct aa_loaddata *loaddata;
+	DECLARE_FLEX_ARRAY(char, data);
 };
 
 #ifdef CONFIG_SECURITY_APPARMOR_EXPORT_BINARY
-#define RAWDATA_F_DATA_BUF(p) (char *)(p + 1)
 
 static void rawdata_f_data_free(struct rawdata_f_data *private)
 {
@@ -1434,7 +1434,7 @@ static ssize_t rawdata_read(struct file *file, char __user *buf, size_t size,
 	struct rawdata_f_data *private = file->private_data;
 
 	return simple_read_from_buffer(buf, size, ppos,
-				       RAWDATA_F_DATA_BUF(private),
+				       private->data,
 				       private->loaddata->size);
 }
 
@@ -1467,8 +1467,7 @@ static int rawdata_open(struct inode *inode, struct file *file)
 	private->loaddata = loaddata;
 
 	error = decompress_zstd(loaddata->data, loaddata->compressed_size,
-				RAWDATA_F_DATA_BUF(private),
-				loaddata->size);
+				private->data, loaddata->size);
 	if (error)
 		goto fail_decompress;
 
-- 
2.53.0



