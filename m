Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D68415F2B;
	Tue, 21 Jul 2026 18:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657376; cv=none; b=YEiHbDNJJ6ysuM+sfpCwDECG6VZi25KMvvbF8LCiPat4NLhk1h+meYXJ2Lssa70sJiZnTyUn9F7tRzuLilBV6peXnWc2DNg3RyTJpuaDEF+b4whNAYmQkYqBpP81yRdHMssqJ+KegWBxHf+6dE+V5qPKauIawvfqLYBtMSQzUss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657376; c=relaxed/simple;
	bh=F205Vb2DaLlFZy5UR6Ws1sXTXMLA6WhvGZea5ZBmK30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J7YNOtVvc4dXtKvLVC4y/+Na2zdxK/4sgq1mQcAvdyNXE50qB62ozQIuSCBVdvPRt7Z9ihV2P9sfsKCXx3o2Pvk9dAnmZ6FHwSl/N3aHB7hx7+Eb4NNUcTkh547j1C/MP2cOL5a13l6fw9wXdZSKpoKJ+z/0ahM4pnR/XnNhxL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e6hadwRg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e6hadwRg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E6041F000E9;
	Tue, 21 Jul 2026 18:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657375;
	bh=PeE01ITbjunr27Z26VVZzP2p+LvGei8DGt4pLBIJKbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e6hadwRgd7hwICcOkMghxc65j5ZmoUCOFUcG6DfWJ/SF9MFhpc40Z1odIMECiZmn3
	 EUz+hOQRha4R9H8FDmd2/I+EhhWWtJZ8wP8CuHusHuc1lJFhGD2hs0hT3+d28pwUQt
	 ryIngfDgIy3Ndli5mQnuL0vGWBTRz+jZT+3704LA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0739/1611] apparmor: fix rawdata_f_data implicit flex array
Date: Tue, 21 Jul 2026 17:14:15 +0200
Message-ID: <20260721152531.999244069@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 5b326d0b170fae..921daf31267abb 100644
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
@@ -1442,7 +1442,7 @@ static ssize_t rawdata_read(struct file *file, char __user *buf, size_t size,
 	struct rawdata_f_data *private = file->private_data;
 
 	return simple_read_from_buffer(buf, size, ppos,
-				       RAWDATA_F_DATA_BUF(private),
+				       private->data,
 				       private->loaddata->size);
 }
 
@@ -1475,8 +1475,7 @@ static int rawdata_open(struct inode *inode, struct file *file)
 	private->loaddata = loaddata;
 
 	error = decompress_zstd(loaddata->data, loaddata->compressed_size,
-				RAWDATA_F_DATA_BUF(private),
-				loaddata->size);
+				private->data, loaddata->size);
 	if (error)
 		goto fail_decompress;
 
-- 
2.53.0



