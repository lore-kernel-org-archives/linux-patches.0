Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2442017BEAE;
	Tue, 10 Sep 2024 09:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725960986; cv=none; b=dJ7MbiLCMUnazr5DiUL57aR+o9IRMBn4RuG0vKQ4Ep7JWP3aDjIZl5hfRztnrTVPRl5vW2U3/ZD9VbkYGaPBTg4UX9mha5pbA5iyUMK+fckKY1yFZRKm8V99JAAAFYQcSBk/bIjxRKbutO5jM03OB05Tq97JecVhKP10VxrKLwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725960986; c=relaxed/simple;
	bh=wKtmImX3N8Oiii/AlY62kug3cjVfEJfa+ExNVqE2Ik4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Efqe68r2TZPp8B7/cDmbz2wx0gqIhkc5+NK1wyDRylBlpyqm+L0oLHNPxRbdX47PZx/TdojU8D7gNGCxWUKGTRBFs+LYW8MiUBdFI24fSsf6AFl6eaupRZkES6gKVfnWR5Fpa2YCrCJrUn/JS3FW22M9CKy6PssmK7vF+guPZXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VTm3tYKJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VTm3tYKJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CA4CC4CEC3;
	Tue, 10 Sep 2024 09:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725960986;
	bh=wKtmImX3N8Oiii/AlY62kug3cjVfEJfa+ExNVqE2Ik4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VTm3tYKJKXSYP2jePe8b/U1ceZCEG66huCcm+9eOpw/8FhkIW+5s/PqAysYvkxBpx
	 QtzvtRgZvu+WPTPaewao8idbOe/eNjtlMCo3JmITPn7pt0byACJXkoel6tsuUodSDa
	 d50xT391+vS/9BpMtOB8u6r7vkw5066lqWlYJj2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 4.19 15/96] udf: Limit file size to 4TB
Date: Tue, 10 Sep 2024 11:31:17 +0200
Message-ID: <20240910092542.090898060@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit c2efd13a2ed4f29bf9ef14ac2fbb7474084655f8 upstream.

UDF disk format supports in principle file sizes up to 1<<64-1. However
the file space (including holes) is described by a linked list of
extents, each of which can have at most 1GB. Thus the creation and
handling of extents gets unusably slow beyond certain point. Limit the
file size to 4TB to avoid locking up the kernel too easily.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/super.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -86,6 +86,13 @@ enum {
 #define UDF_MAX_LVID_NESTING 1000
 
 enum { UDF_MAX_LINKS = 0xffff };
+/*
+ * We limit filesize to 4TB. This is arbitrary as the on-disk format supports
+ * more but because the file space is described by a linked list of extents,
+ * each of which can have at most 1GB, the creation and handling of extents
+ * gets unusably slow beyond certain point...
+ */
+#define UDF_MAX_FILESIZE (1ULL << 42)
 
 /* These are the "meat" - everything else is stuffing */
 static int udf_fill_super(struct super_block *, void *, int);
@@ -2307,7 +2314,7 @@ static int udf_fill_super(struct super_b
 		ret = -ENOMEM;
 		goto error_out;
 	}
-	sb->s_maxbytes = MAX_LFS_FILESIZE;
+	sb->s_maxbytes = UDF_MAX_FILESIZE;
 	sb->s_max_links = UDF_MAX_LINKS;
 	return 0;
 


