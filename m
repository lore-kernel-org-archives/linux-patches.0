Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5922E736D;
	Tue, 21 Jul 2026 17:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654422; cv=none; b=erW057vPDdmtVf4dcNl+9LCbJd1O/A8yvYAeFp69TQdWbG6b5iRBI3+D2BUwHvX7DleRdyXErVzj1Hm9j9drROWLERCuhYzM4DP4RPxDYGqdfH5UGIBH8C2N62jm3N8cWToEwEzDbHI0u9EAA/bfbYOYRnivYGUlaIIDnlzeJd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654422; c=relaxed/simple;
	bh=xdKS6z6TqFnpMp3L9h7TH7UBh4D1dPulBGEM9RAulFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L8HP0w2lVRvVedqLbX5mL8kms583wacFgm9fZrA+DSez4FwZyRe2YAHO6yd3Ozteh7CSSNKDTPMTyoBznnfWsBihar+6NGJYbr4dDkI+lpZbMMrlWVCrcDGphXJd4tksGDXgevnHXdT0VpX9xT2WM3x6B5Q/1FV+CKTQnt2aMlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2dS/0+bE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2dS/0+bE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CBD01F000E9;
	Tue, 21 Jul 2026 17:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654420;
	bh=ERpBgyw13ZbEfC1O3pRn205rx5Ug+t8AWIlQNTKPbMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2dS/0+bEp6IxjNwcz1PJYntWW14Qp2RILwKdC3CYowgB439YQnfKxoRS6cR74Yhkw
	 Xi5brpd6wt4sU35SX2P0ASchwfYG3KcYG2HJniippziCfbxLjtH8vlVp2rU810AI61
	 xWVMnfp2PY8hT0Mo/scZuVWVKREWIss+fz9T5x/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.1 1697/2077] ntfs: do not replace volume name after lookup errors
Date: Tue, 21 Jul 2026 17:22:50 +0200
Message-ID: <20260721152632.785444278@linuxfoundation.org>
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

From: DaeMyung Kang <charsyam@gmail.com>

commit 40d88020d0797f96a93edd2e8edc413c2e2d8f84 upstream.

ntfs_write_volume_label() removes an existing $VOLUME_NAME attribute and
then adds the replacement. The old code only distinguished lookup success
from all other results, so any lookup error was treated like an absent
label and the add path still ran.

That is unsafe once lookup-time validation rejects corrupt $VOLUME_NAME
records with -EIO: the corrupt record would remain in place and a second
$VOLUME_NAME record could be appended next to it.

Only add the replacement after the old label was removed successfully or
after lookup returned -ENOENT. Propagate all other lookup errors, and
also stop if removing the old attribute fails.

Cc: stable@vger.kernel.org # v7.1
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/super.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -452,10 +452,15 @@ int ntfs_write_volume_label(struct ntfs_
 		goto out;
 	}
 
-	if (!ntfs_attr_lookup(AT_VOLUME_NAME, NULL, 0, 0, 0, NULL, 0,
-			     ctx))
-		ntfs_attr_record_rm(ctx);
+	ret = ntfs_attr_lookup(AT_VOLUME_NAME, NULL, 0, 0, 0, NULL, 0,
+			       ctx);
+	if (!ret)
+		ret = ntfs_attr_record_rm(ctx);
+	else if (ret == -ENOENT)
+		ret = 0;
 	ntfs_attr_put_search_ctx(ctx);
+	if (ret)
+		goto out;
 
 	ret = ntfs_resident_attr_record_add(vol_ni, AT_VOLUME_NAME, AT_UNNAMED, 0,
 					    (u8 *)uname, uname_len * sizeof(__le16), 0);


