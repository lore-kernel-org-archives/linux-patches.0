Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CD08F5B
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:26:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79278C433C8;
	Sun, 16 Jul 2023 20:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539164;
	bh=c3bJmWTc7AuA8YHZr8OvBmeeAOgSPV6DW5nrUb7Mhcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j5RXDKfbfG9fRZfL640m/xbunJhgAdiy77Gk8nJT1XA2luk3pC+QSlMqAKg8YVW/v
	 5jBr0kKHqZbumN5R7h0JzqIb0ImSxJ4xjH5X9ekemJProQ65H/YZB0IVupWRW6GlpD
	 cKrN4HVRxty+rOTT0YEKzbIK0vIkICwQukMITPYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danila Chernetsov <listdansp@mail.ru>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 710/800] apparmor: fix missing error check for rhashtable_insert_fast
Date: Sun, 16 Jul 2023 21:49:23 +0200
Message-ID: <20230716195005.611458045@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Danila Chernetsov <listdansp@mail.ru>

[ Upstream commit 000518bc5aef25d3f703592a0296d578c98b1517 ]

 rhashtable_insert_fast() could return err value when memory allocation is
 failed. but unpack_profile() do not check values and this always returns
 success value. This patch just adds error check code.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: e025be0f26d5 ("apparmor: support querying extended trusted helper extra data")

Signed-off-by: Danila Chernetsov <listdansp@mail.ru>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/policy_unpack.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/security/apparmor/policy_unpack.c b/security/apparmor/policy_unpack.c
index 278ed96c30a26..72aac376d3ed7 100644
--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -1064,8 +1064,13 @@ static struct aa_profile *unpack_profile(struct aa_ext *e, char **ns_name)
 				goto fail;
 			}
 
-			rhashtable_insert_fast(profile->data, &data->head,
-					       profile->data->p);
+			if (rhashtable_insert_fast(profile->data, &data->head,
+						   profile->data->p)) {
+				kfree_sensitive(data->key);
+				kfree_sensitive(data);
+				info = "failed to insert data to table";
+				goto fail;
+			}
 		}
 
 		if (!aa_unpack_nameX(e, AA_STRUCTEND, NULL)) {
-- 
2.39.2



