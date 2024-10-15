Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F211CFEA9;
	Tue, 15 Oct 2024 12:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993891; cv=none; b=ukvImrLtEWFjyLPW4IrTmzZvZBORI8ORX4PSVHLeM7v3SqFcOCsjawnA9KD0Yyh94bqJ+JPAs7O7yrurV8VY8oF3sWMgJdGpVZGphY0sI1S4zSnwpTLRNzctqd+g4D9FsOjen823/pZhKOv7tyEG62z0pZMz4KAM3aEzxrxqqiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993891; c=relaxed/simple;
	bh=mTWH6Fk7nxhNb6hPBez7TzQ2ghaZb+Pe7kVYevSsXIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VOF5FhOJqxxFjycOCLPPOv3GP5+MrITR7rXqZ+y049BKG+wava5dGOyTW177VvAFWEcgbLmoM3DIR4F2Fb+LPp2oJwMhF7cCyobOc+zkonwylhHAD8B0hegMsrzqbbYvjiVeioc2x6eXXrczPZaLwwf/LEZIomwGnbpsrJWVZi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TxPxQ2gA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TxPxQ2gA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 179DCC4CEC6;
	Tue, 15 Oct 2024 12:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993891;
	bh=mTWH6Fk7nxhNb6hPBez7TzQ2ghaZb+Pe7kVYevSsXIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TxPxQ2gAbWZwtpvDvqJal1zEaYWGYdhQyisrlFzN+lGugx/VCulm7kZyvGE734X64
	 4UysZlZu1OwlkXJO88pY04v8SQpq75e6EMP3t5qhrRYKFrfJ/iaOX/LpExhXQpsnqg
	 Oq46Qd65GkWQFWwE0WYG8doLACbaqD3Ic5DEBhoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Aoyama Wataru <wataru.aoyama@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 5.15 518/691] exfat: fix memory leak in exfat_load_bitmap()
Date: Tue, 15 Oct 2024 13:27:46 +0200
Message-ID: <20241015112500.903784802@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


