Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350BD1C26
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:02:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C8F5C433D6;
	Wed, 23 Nov 2022 09:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194167;
	bh=uDw6qcpKg964MxpkjM+/Tw2HMVsNpsLVwX9fKZDIuyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AOjnqU7Xn8OtuMICeg/zULxujgsvkySIEzpt7e5wBTPPA7z7cJTftjAiYFe+mul36
	 menzX2ip8w3JubG8ytvZz3X2jJmggU5eAQudYx6JM1Ykf3ZkkYj9wNq5gtnWSRN197
	 hybTMgVGElazhdVnxwKA6FBAmoBKjYkx2DfZ6SEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 4.14 83/88] gfs2: Switch from strlcpy to strscpy
Date: Wed, 23 Nov 2022 09:51:20 +0100
Message-Id: <20221123084551.552097323@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084548.535439312@linuxfoundation.org>
References: <20221123084548.535439312@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andreas Gruenbacher <agruenba@redhat.com>

commit 204c0300c4e99707e9fb6e57840aa1127060e63f upstream.

Switch from strlcpy to strscpy and make sure that @count is the size of
the smaller of the source and destination buffers.  This prevents
reading beyond the end of the source buffer when the source string isn't
null terminated.

Found by a modified version of syzkaller.

Suggested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/gfs2/ops_fstype.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -391,8 +391,10 @@ static int init_names(struct gfs2_sbd *s
 	if (!table[0])
 		table = sdp->sd_vfs->s_id;
 
-	strlcpy(sdp->sd_proto_name, proto, GFS2_FSNAME_LEN);
-	strlcpy(sdp->sd_table_name, table, GFS2_FSNAME_LEN);
+	BUILD_BUG_ON(GFS2_LOCKNAME_LEN > GFS2_FSNAME_LEN);
+
+	strscpy(sdp->sd_proto_name, proto, GFS2_LOCKNAME_LEN);
+	strscpy(sdp->sd_table_name, table, GFS2_LOCKNAME_LEN);
 
 	table = sdp->sd_table_name;
 	while ((table = strchr(table, '/')))


