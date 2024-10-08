Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D6D1D0BAA;
	Tue,  8 Oct 2024 12:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390705; cv=none; b=pjqM1HM7OreOIutlI+smIcuk9WMildkoDgPnIyncjz9tK/VVCHpDVFAvWBoEH7Ay/wIbYP6KwjDdN+JANJfHsJzuBbk1ZwgZiW0fpJTkUF5kIJ8LGDg31IXYJsRzcjw7oN6qXgUaMIoQsSkruIBBvMtJhoNWktULLb6ZyhskpNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390705; c=relaxed/simple;
	bh=G/zPPQhr3ZX9CvkZ4LwOZokjTrPw+Wk8NVJQgJmZk/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KmrKlnbOQU+zrV+9y0cXvNeDx2iW3CzGlLBOVREm6kAhCQC2QUZpg3S+F3hnOJ5wEJyeYm2YyoS24zQimbtPpA5X3z7Mq0vnKUO1Uc9dZqruzSZ7kXAaQbYV0YSsKTVEBHvN4366SNs2tvlDIQUFH0zuTse+upDRgbj+fsyQ45I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cRaCPGdZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cRaCPGdZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5246C4CEC7;
	Tue,  8 Oct 2024 12:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390705;
	bh=G/zPPQhr3ZX9CvkZ4LwOZokjTrPw+Wk8NVJQgJmZk/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cRaCPGdZSQ73vHBnNqw0SJUYwec0dcxlVc5JOLSlW6ufUm3ziSZavrKc4LM1xwo+d
	 nnMUrhh21CbgLu5zl8/bl/rc5IPO2uL3e+30ogqQe2tPsNYH2gwLngtyOHN8s4soT0
	 Zd+7CDKNXmyiC+2Cs7qNivx1Nuft2oaiQsiw1oNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Aoyama Wataru <wataru.aoyama@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.10 368/482] exfat: fix memory leak in exfat_load_bitmap()
Date: Tue,  8 Oct 2024 14:07:11 +0200
Message-ID: <20241008115702.904414408@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuezhang Mo <Yuezhang.Mo@sony.com>

commit d2b537b3e533f28e0d97293fe9293161fe8cd137 upstream.

If the first directory entry in the root directory is not a bitmap
directory entry, 'bh' will not be released and reassigned, which
will cause a memory leak.

Fixes: 1e49a94cf707 ("exfat: add bitmap operations")
Cc: stable@vger.kernel.org
Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Reviewed-by: Aoyama Wataru <wataru.aoyama@sony.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/balloc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/exfat/balloc.c
+++ b/fs/exfat/balloc.c
@@ -91,11 +91,8 @@ int exfat_load_bitmap(struct super_block
 				return -EIO;
 
 			type = exfat_get_entry_type(ep);
-			if (type == TYPE_UNUSED)
-				break;
-			if (type != TYPE_BITMAP)
-				continue;
-			if (ep->dentry.bitmap.flags == 0x0) {
+			if (type == TYPE_BITMAP &&
+			    ep->dentry.bitmap.flags == 0x0) {
 				int err;
 
 				err = exfat_allocate_bitmap(sb, ep);
@@ -103,6 +100,9 @@ int exfat_load_bitmap(struct super_block
 				return err;
 			}
 			brelse(bh);
+
+			if (type == TYPE_UNUSED)
+				return -EINVAL;
 		}
 
 		if (exfat_get_next_cluster(sb, &clu.dir))


