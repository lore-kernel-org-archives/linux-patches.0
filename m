Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16084156256;
	Mon, 14 Oct 2024 15:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919312; cv=none; b=DxOB28QNQrB53/RA5qDPHokRCAaDHaVNy6XMUunsOPEpOZt4+kaw8xlyaSdlnnB9ZonVcTTo+dKgp5hF2BO6MFTJhSSGHvUu+0SnPi6wbsvpiwdw0fRTqLOoErYyXX3mkprGfl0jcOLQFgbFBuDCAPDLJESRcEZCZ2Rh3OHaGLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919312; c=relaxed/simple;
	bh=9l3gz/TMclfhSQc3w5591RFautQ3YgGOoVEKQoK0b28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CifSNQOIRxMUQ2skyKtIYVpaHZL/E/b8bFuoQFCvdljem0nzu87GQ9MhosszuGPJeRLDXBZXkUmIe/2IR6shbaVNTlnKTEAbM6KHqDJMsuqCCv2AM9u8JYQNvmqeGUysNZvPO9Ju+43Pl5ZxMdce7OoKNTTDuVeiwQ3bg5WWEiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WYbj+15E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WYbj+15E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7725FC4CEC3;
	Mon, 14 Oct 2024 15:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919312;
	bh=9l3gz/TMclfhSQc3w5591RFautQ3YgGOoVEKQoK0b28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WYbj+15E8yYeolg2L7euwo6373SP6mlbxsonAAlwhmxmhve86PNB/zfrO5Ad7LAec
	 tOVnQg3JKwBB+jcrXr+MF9zI4LeJpb5mn1H1HeERnOflYB/+bcd5IEkbw8VyVaF8Q2
	 5pLaUuLggKsFfR5NVq7CcjPpkRT2SszcVxpxDMac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Aoyama Wataru <wataru.aoyama@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.1 574/798] exfat: fix memory leak in exfat_load_bitmap()
Date: Mon, 14 Oct 2024 16:18:48 +0200
Message-ID: <20241014141240.554855976@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


