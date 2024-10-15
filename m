Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0021C07F1;
	Tue, 15 Oct 2024 13:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998154; cv=none; b=VtMfZG7LuO2+vupw7JkOIASsqxy2Q6uJ3Js9VoOjjxppeb+sXkdUh12nDSRtGRpp5de8kFoa4Mk3vK1TYUN7gSAMonHG1UuDS9sNXLl+i2vmNHK7hLqeuDNr6dnjW1Ugk9/uhanFl1VAixEcz414dXqAdzEe9kGZdVnQUBlRSJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998154; c=relaxed/simple;
	bh=f0ybB5bWO+jqW0BYi4nCZnPn+9dH06Uqoa1E720xG1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fTlu5WqLlMyVvkjO4ou6ibLC2QEYvtO24R5WiAMe2JkE3DuoX1J1cYVHeaRFYFOBBuYRICvJ3EZKktPPwDogxhtB3zJtAIpwJT1clgMsntADiRpaCliX0sxwhkwCec1cSWumsKX5/e0RxotT6aU7C4a2iUWnAb1lJswd98MjcHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oc1Bn27O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oc1Bn27O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F62AC4CEC6;
	Tue, 15 Oct 2024 13:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998154;
	bh=f0ybB5bWO+jqW0BYi4nCZnPn+9dH06Uqoa1E720xG1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oc1Bn27Okn8j+MQzHReCzjfFk7ytjOYFJjIZ4qr4QtYTsnDcqnKT6PaxWx251bv7E
	 F5fxcMk2AEHQRmhNOAVLuShSVH+3U1rcjhohtwc0uVC01NIAUUPrvd3iXrxAxAytyr
	 ldFMaPdV2cTvyuFgAm4SYVJZbewCfpWeHi9PQCME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Aoyama Wataru <wataru.aoyama@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 5.10 394/518] exfat: fix memory leak in exfat_load_bitmap()
Date: Tue, 15 Oct 2024 14:44:58 +0200
Message-ID: <20241015123932.183215565@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -110,11 +110,8 @@ int exfat_load_bitmap(struct super_block
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
@@ -122,6 +119,9 @@ int exfat_load_bitmap(struct super_block
 				return err;
 			}
 			brelse(bh);
+
+			if (type == TYPE_UNUSED)
+				return -EINVAL;
 		}
 
 		if (exfat_get_next_cluster(sb, &clu.dir))


