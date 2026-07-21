Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6380446EF62;
	Tue, 21 Jul 2026 19:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660608; cv=none; b=PXLsBnCm3AzQXyVj1k2ihJPrKD5jQ8gw2fdDdKr70YYFwgryS5Gzz7PSyh8JywqBMz8Q8jJ6NwfsOthQZaBHyrux2n6yS9MPXRueDS+mTmbygv8mgcLJLSPRAk+viMKcoSx4OKF88cFb8Gs/AmMLEYc6LC/pcTC4FTl6SCj3yvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660608; c=relaxed/simple;
	bh=x78sD1THw5xXB8ZQijc5me7Q74N7vdZk5ufr5biDDik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ELO7v3SboHrC0yg9Vg5Qlo/x5Z6fCrvIWH4nnGFO+YsMsc9SOZkXNVNZUp67Yhb05uNs4cPEI/HMHmzbGR7oczskwcvrw5w/KS6aTNTb1pJmz2VxztV1AZY6RUJDVjrwSSWcnSiz94pQbO8tLHkIlE/N1mUyCDbYqUVLAUhhMTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sHhxdrNe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sHhxdrNe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 222CD1F000E9;
	Tue, 21 Jul 2026 19:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660605;
	bh=ggbAx7nweku0rIScoWJYrDTexNEUV33etWUtq1xk9zA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sHhxdrNeOOqsa3rmytWuu80pLM/b/GCZPtMO+kmeKuhgbds2EDIQ8B4OPEsk26OG9
	 WjwwO9UuhvPClg9utddqONUSWBF/zFVyeXSuxgyre9tgHIxQB3LwY17F2NFqrUoeMr
	 1zDLALNumxwzaYmO7oaibbkiMgfOiR5ytY+YuAxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1042/2077] apparmor: fix rawdata_f_data implicit flex array
Date: Tue, 21 Jul 2026 17:11:55 +0200
Message-ID: <20260721152617.390313655@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index aeff3d2d863bc5..725a69aa1c2a37 100644
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



