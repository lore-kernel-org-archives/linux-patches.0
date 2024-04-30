Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486C712D1EA;
	Tue, 30 Apr 2024 11:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475714; cv=none; b=AAs1OxYoq8Rd+9hqg69Cx41ei4epIQ3tMaKA1JyXxgFE7SmP/XsiJw6LMkqVA1sOVH6B8FmpM+YHB6/leB5gocRCCIEB7QxO7HyU+sXIXpO/jJWNrtgou4qiyREkoYWT81nYr2+5izMSVGE3ogiGJXwMXiHt2KYhSPEVgYREZtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475714; c=relaxed/simple;
	bh=db2GWncdnCfVpSkptLL+1MOVlYMIsdL2Q2xJTW5TuiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XyWeY3GAfp4Acd5N2BtGMvXGMcwUfLYCOZvyju522xXDRDKTUX6i3EiqtNgvE3Jc6WT32PbS2EIyLGB1zHpEb4JzXpfO/+Q1b9F3UKfpyGYU/JmmcuzYgT3PHp0warOgoaidIr04Q+M6K8WZ1UWgmiLo7s2HaUlAinqlbH272vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K3WKpzuX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K3WKpzuX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE9B6C2BBFC;
	Tue, 30 Apr 2024 11:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475714;
	bh=db2GWncdnCfVpSkptLL+1MOVlYMIsdL2Q2xJTW5TuiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K3WKpzuXt9OSqDQVRJW8Iv6FCPV/tfXVuA4LOfFQ7vlwmIIAXJAUWh99/3WTeXShn
	 1zhyeDqt9GO5KU06UztGsn4vWxyVph7C2cGjQAPc5yW0Tasa45MQUvIPoXObZNNbth
	 zCRE0c49Zc1q/ea83mND7CvSS+MiKYL6szqMsgmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jingbo Xu <jefflexu@linux.alibaba.com>,
	syzbot+26eedf3631650972f17c@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>
Subject: [PATCH 6.6 181/186] ovl: fix memory leak in ovl_parse_param()
Date: Tue, 30 Apr 2024 12:40:33 +0200
Message-ID: <20240430103103.285965689@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

commit 37f32f52643869131ec01bb69bdf9f404f6109fb upstream.

On failure to parse parameters in ovl_parse_param_lowerdir(), it is
necessary to update ctx->nr with the correct nr before using
ovl_reset_lowerdirs() to release l->name.

Reported-and-tested-by: syzbot+26eedf3631650972f17c@syzkaller.appspotmail.com
Fixes: c835110b588a ("ovl: remove unused code in lowerdir param parsing")
Co-authored-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/params.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -438,7 +438,7 @@ static int ovl_parse_param_lowerdir(cons
 	struct ovl_fs_context *ctx = fc->fs_private;
 	struct ovl_fs_context_layer *l;
 	char *dup = NULL, *iter;
-	ssize_t nr_lower = 0, nr = 0, nr_data = 0;
+	ssize_t nr_lower, nr;
 	bool data_layer = false;
 
 	/*
@@ -490,6 +490,7 @@ static int ovl_parse_param_lowerdir(cons
 	iter = dup;
 	l = ctx->lower;
 	for (nr = 0; nr < nr_lower; nr++, l++) {
+		ctx->nr++;
 		memset(l, 0, sizeof(*l));
 
 		err = ovl_mount_dir(iter, &l->path);
@@ -506,10 +507,10 @@ static int ovl_parse_param_lowerdir(cons
 			goto out_put;
 
 		if (data_layer)
-			nr_data++;
+			ctx->nr_data++;
 
 		/* Calling strchr() again would overrun. */
-		if ((nr + 1) == nr_lower)
+		if (ctx->nr == nr_lower)
 			break;
 
 		err = -EINVAL;
@@ -519,7 +520,7 @@ static int ovl_parse_param_lowerdir(cons
 			 * This is a regular layer so we require that
 			 * there are no data layers.
 			 */
-			if ((ctx->nr_data + nr_data) > 0) {
+			if (ctx->nr_data > 0) {
 				pr_err("regular lower layers cannot follow data lower layers");
 				goto out_put;
 			}
@@ -532,8 +533,6 @@ static int ovl_parse_param_lowerdir(cons
 		data_layer = true;
 		iter++;
 	}
-	ctx->nr = nr_lower;
-	ctx->nr_data += nr_data;
 	kfree(dup);
 	return 0;
 


