Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90E935E1D5;
	Sat, 12 Sep 2026 16:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231529; cv=none; b=fOybxewBVWtyZZcpjUePYmVROkpi7FqHgSPiOtQFWdCmse7oRrPiIlaPKl8ksiCPNWKGIbjW2nM7TUBxD8x78H9mg0aQZRqXnBIfE47LnCE9hnlsdNjLav+gKJyj2je17m4BGE3RhWtbPmFiximXb+ug6d4HxNvwPPvCdEoRFqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231529; c=relaxed/simple;
	bh=f18tUERPze/dfQ/14pbbZXEweO+tR7NrPHrLCiNGObg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hlwbtgcMH1b07GXGNNYxa6iYFF3s1L8JoCV69R9cPEOdMAmYL5oCGy6VeJjl+yXJGPU1VRQF2pvD3w/FU8GNkYAemEKmL6XwmqCxj7m31s9OGhrVj+NP0aXN7BZuN3wdhsetJ9vE/volsACYiyVK8P927PfSlxLYhD/KmRRPQWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rorpIWMf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rorpIWMf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC39F1F000FF;
	Sat, 12 Sep 2026 16:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231527;
	bh=n4kcPL3eZoEF89mHFN3jZZOltzAQRjsJagkH2tK2WXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rorpIWMf6leHgQlPcMGYYJuFtCcI6yAL91s5kpRGtTaZOCjheGPWI+N/Pq51O9H7f
	 6EyX7Q02IJn+AahLi7Mgnmv8AS8G6rTa5vqY4lvMd5jS7xDh0Dv99KcqT1E8LcuXRY
	 6h5AgokUOtQmzouXFr2a6Y22m4H6o6FK06nJA4eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0974/1191] ubi: fastmap: erase_block: Get erase counter from wl_entry rather than flash
Date: Sat, 12 Sep 2026 09:01:42 +0200
Message-ID: <20260912065610.089126486@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit 08a4267874164b2e9c8c50831acd466f47208acc ]

Just like sync_erase() does, getting erase counter from wl_entry is
faster than reading from flash.

Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Stable-dep-of: 420477a84f1e ("UBI: Preserve torture flag when rescheduling failed erasures")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/fastmap.c | 27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 5dbab1237fee9..f579493b24b80 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -1400,36 +1400,27 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
  */
 static int erase_block(struct ubi_device *ubi, struct ubi_wl_entry *e)
 {
-	int ret;
+	int err;
 	struct ubi_ec_hdr *ec_hdr;
-	long long ec;
+	long long ec = e->ec;
 
 	ec_hdr = kzalloc(ubi->ec_hdr_alsize, GFP_KERNEL);
 	if (!ec_hdr)
 		return -ENOMEM;
 
-	ret = ubi_io_read_ec_hdr(ubi, e->pnum, ec_hdr, 0);
-	if (ret < 0)
-		goto out;
-	else if (ret && ret != UBI_IO_BITFLIPS) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	ret = ubi_io_sync_erase(ubi, e->pnum, 0);
-	if (ret < 0)
+	err = ubi_io_sync_erase(ubi, e->pnum, 0);
+	if (err < 0)
 		goto out;
 
-	ec = be64_to_cpu(ec_hdr->ec);
-	ec += ret;
+	ec += err;
 	if (ec > UBI_MAX_ERASECOUNTER) {
-		ret = -EINVAL;
+		err = -EINVAL;
 		goto out;
 	}
 
 	ec_hdr->ec = cpu_to_be64(ec);
-	ret = ubi_io_write_ec_hdr(ubi, e->pnum, ec_hdr);
-	if (ret < 0)
+	err = ubi_io_write_ec_hdr(ubi, e->pnum, ec_hdr);
+	if (err < 0)
 		goto out;
 
 	e->ec = ec;
@@ -1440,7 +1431,7 @@ static int erase_block(struct ubi_device *ubi, struct ubi_wl_entry *e)
 
 out:
 	kfree(ec_hdr);
-	return ret;
+	return err;
 }
 
 /**
-- 
2.53.0



