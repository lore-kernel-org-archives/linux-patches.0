Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931CF33A9FC;
	Tue, 21 Jul 2026 20:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666478; cv=none; b=jNj7LEAkuvq/QyuqfDjGdkUY9EYo0jsh4coJRpMthMly1b+JSKJi0PDjkHD4UbEK9M5hKssEgMgboOmqtQDl7gzDTN9QL3jU2A+Ck7J5vow/EE/8Gl/p1CVtGLZYA4TkQGpaoP1MZ5e+V3E3NQny5KOIFmJHHTpWjOnOt2NABtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666478; c=relaxed/simple;
	bh=TYavxxVcNZeyUWZo1E4qvescDHAHyiSi7/bAh1YfENw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EB2qJCy8YuZVYsUXTLyITbrVGTOpvZh8yN17HF91tQSh5l8j0TVkZ2ktGwg/7sDMZ6LDCvwmTlyLbAGWHGyvhnVV3KOb3GfArur/mOFSvytr4L+TUHrJWB7crLdwEc5SnzM0TyQQ4NMrqmGvJqL33i9ChnEeeX2pWysE5j0yEu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c0+GSYGt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c0+GSYGt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 043461F000E9;
	Tue, 21 Jul 2026 20:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666477;
	bh=bYNc7LQAnVdjnvHqrnMhKf3K3bDTuZ2OruKd/TBxnaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c0+GSYGtuOUwNd2i4lZygU+9KQGIuILoio2DfLWfS7ONKQtg3Xd2vplVzdlTOnvzw
	 F5y/HQ04hibE9K0qNpok9Z/mLjcmV42ryHHjNzQXmLiVXHzQGKKEAm3TK727W963Ba
	 5SmIlOn5tBhAUM6HvVaYhxq4QVGjkjUq2JlvZO9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0699/1266] apparmor: fix rawdata_f_data implicit flex array
Date: Tue, 21 Jul 2026 17:18:56 +0200
Message-ID: <20260721152457.501919312@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3fdb084db3a917..bb183924b7a2cd 100644
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
@@ -1436,7 +1436,7 @@ static ssize_t rawdata_read(struct file *file, char __user *buf, size_t size,
 	struct rawdata_f_data *private = file->private_data;
 
 	return simple_read_from_buffer(buf, size, ppos,
-				       RAWDATA_F_DATA_BUF(private),
+				       private->data,
 				       private->loaddata->size);
 }
 
@@ -1469,8 +1469,7 @@ static int rawdata_open(struct inode *inode, struct file *file)
 	private->loaddata = loaddata;
 
 	error = decompress_zstd(loaddata->data, loaddata->compressed_size,
-				RAWDATA_F_DATA_BUF(private),
-				loaddata->size);
+				private->data, loaddata->size);
 	if (error)
 		goto fail_decompress;
 
-- 
2.53.0



