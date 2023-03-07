Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34B0BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:35:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB91C433D2;
	Tue,  7 Mar 2023 18:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214146;
	bh=bhPVx887wSAvLdlf0wjlLgBymg2a9kYS3ydX/VlCrYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X9jwSKBCdzR1bnjnlflEU2Iys4Silp34vZ/zoTXVvQo9MkGnw2TFonU0q8dp+rO+r
	 hDb0QRYErj+V30ez8XGS4DtZc3vv4FNu4QXZukptoEIabzeyCphiehlYN+uRbRm5au
	 VFUwFfER7wCqeETOHnJ3jgXIbHw28HwzYGjILBHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 6.1 707/885] udf: Truncate added extents on failed expansion
Date: Tue,  7 Mar 2023 18:00:41 +0100
Message-Id: <20230307170032.784780456@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jan Kara <jack@suse.cz>

commit 70bfb3a8d661d4fdc742afc061b88a7f3fc9f500 upstream.

When a file expansion failed because we didn't have enough space for
indirect extents make sure we truncate extents created so far so that we
don't leave extents beyond EOF.

CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/inode.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -526,8 +526,10 @@ static int udf_do_extend_file(struct ino
 	}
 
 	if (fake) {
-		udf_add_aext(inode, last_pos, &last_ext->extLocation,
-			     last_ext->extLength, 1);
+		err = udf_add_aext(inode, last_pos, &last_ext->extLocation,
+				   last_ext->extLength, 1);
+		if (err < 0)
+			goto out_err;
 		count++;
 	} else {
 		struct kernel_lb_addr tmploc;
@@ -561,7 +563,7 @@ static int udf_do_extend_file(struct ino
 		err = udf_add_aext(inode, last_pos, &last_ext->extLocation,
 				   last_ext->extLength, 1);
 		if (err)
-			return err;
+			goto out_err;
 		count++;
 	}
 	if (new_block_bytes) {
@@ -570,7 +572,7 @@ static int udf_do_extend_file(struct ino
 		err = udf_add_aext(inode, last_pos, &last_ext->extLocation,
 				   last_ext->extLength, 1);
 		if (err)
-			return err;
+			goto out_err;
 		count++;
 	}
 
@@ -584,6 +586,11 @@ out:
 		return -EIO;
 
 	return count;
+out_err:
+	/* Remove extents we've created so far */
+	udf_clear_extent_cache(inode);
+	udf_truncate_extents(inode);
+	return err;
 }
 
 /* Extend the final block of the file to final_block_len bytes */


