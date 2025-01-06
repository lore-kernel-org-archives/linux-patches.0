Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A87224CC;
	Mon,  6 Jan 2025 15:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177298; cv=none; b=Y07oRercXUC4oJ2S0cB5243G3UijvPY/TJvoCU5jewJa5/lYhpZzUU5v299LWr5imZ93z5YRPjQShzoCH+fdbP4gYTy7uzzpo9GHN3IO+vUtZ0J1KUhb/Lh8RfFPRgE1PDVezNwQk5MoSgpjqOdGerzTLRmU+e0QAEehoMgRt2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177298; c=relaxed/simple;
	bh=5NOX3zsgHaea+EVWhoLlpRMxL9Mi8X03H3klm2K/7Co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hrSpDj1fGmw4oxY4vAbcgQ7stuEGqbi4MClG+/KBkVHnYwtDRxqJLW+kwLPmQNFZLPNOAx0UqPGD4xzT7Cz/Ah9Uy8p1yvn1mSbz9nfA4LLwg/XMlM0rSunKg1SXL8GkV/PDd1L+MdkJvUPLriVOgrz520OsWNzVhSmvd31ZTiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zkuIMv9t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zkuIMv9t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E413C4CED2;
	Mon,  6 Jan 2025 15:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177297;
	bh=5NOX3zsgHaea+EVWhoLlpRMxL9Mi8X03H3klm2K/7Co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zkuIMv9tIxpH6wDR0j28PxysyvEIKnTcwBl9flZy/yL8yoRrVVEWYO/DiVcEGHyth
	 5Ba461s0Z0+JPyyFcHAanfbkdlSuH5G9oat2HndW2pxHVvaSvIgCf7AJv1g88JEeJB
	 grOYXA8ET6drOOrDRJhuBgYMmGaO8399iEs0SsXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubli@redhat.com>,
	Patrick Donnelly <pdonnell@redhat.com>,
	Milind Changire <mchangir@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 117/222] libceph: add doutc and *_client debug macros support
Date: Mon,  6 Jan 2025 16:15:21 +0100
Message-ID: <20250106151155.026866681@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Xiubo Li <xiubli@redhat.com>

[ Upstream commit 5c5f0d2b5f92c47baf82b9b211e27edd7d195158 ]

This will help print the fsid and client's global_id in debug logs,
and also print the function names.

[ idryomov: %lld -> %llu, leading space for doutc(), don't include
  __func__ in pr_*() variants ]

Link: https://tracker.ceph.com/issues/61590
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Patrick Donnelly <pdonnell@redhat.com>
Reviewed-by: Milind Changire <mchangir@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Stable-dep-of: 550f7ca98ee0 ("ceph: give up on paths longer than PATH_MAX")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ceph/ceph_debug.h | 38 +++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/include/linux/ceph/ceph_debug.h b/include/linux/ceph/ceph_debug.h
index d5a5da838caf..11a92a946016 100644
--- a/include/linux/ceph/ceph_debug.h
+++ b/include/linux/ceph/ceph_debug.h
@@ -19,12 +19,25 @@
 	pr_debug("%.*s %12.12s:%-4d : " fmt,				\
 		 8 - (int)sizeof(KBUILD_MODNAME), "    ",		\
 		 kbasename(__FILE__), __LINE__, ##__VA_ARGS__)
+#  define doutc(client, fmt, ...)					\
+	pr_debug("%.*s %12.12s:%-4d : [%pU %llu] " fmt,			\
+		 8 - (int)sizeof(KBUILD_MODNAME), "    ",		\
+		 kbasename(__FILE__), __LINE__,				\
+		 &client->fsid, client->monc.auth->global_id,		\
+		 ##__VA_ARGS__)
 # else
 /* faux printk call just to see any compiler warnings. */
 #  define dout(fmt, ...)	do {				\
 		if (0)						\
 			printk(KERN_DEBUG fmt, ##__VA_ARGS__);	\
 	} while (0)
+#  define doutc(client, fmt, ...)	do {			\
+		if (0)						\
+			printk(KERN_DEBUG "[%pU %llu] " fmt,	\
+			&client->fsid,				\
+			client->monc.auth->global_id,		\
+			##__VA_ARGS__);				\
+		} while (0)
 # endif
 
 #else
@@ -33,7 +46,32 @@
  * or, just wrap pr_debug
  */
 # define dout(fmt, ...)	pr_debug(" " fmt, ##__VA_ARGS__)
+# define doutc(client, fmt, ...)					\
+	pr_debug(" [%pU %llu] %s: " fmt, &client->fsid,			\
+		 client->monc.auth->global_id, __func__, ##__VA_ARGS__)
 
 #endif
 
+#define pr_notice_client(client, fmt, ...)				\
+	pr_notice("[%pU %llu]: " fmt, &client->fsid,			\
+		  client->monc.auth->global_id, ##__VA_ARGS__)
+#define pr_info_client(client, fmt, ...)				\
+	pr_info("[%pU %llu]: " fmt, &client->fsid,			\
+		client->monc.auth->global_id, ##__VA_ARGS__)
+#define pr_warn_client(client, fmt, ...)				\
+	pr_warn("[%pU %llu]: " fmt, &client->fsid,			\
+		client->monc.auth->global_id, ##__VA_ARGS__)
+#define pr_warn_once_client(client, fmt, ...)				\
+	pr_warn_once("[%pU %llu]: " fmt, &client->fsid,			\
+		     client->monc.auth->global_id, ##__VA_ARGS__)
+#define pr_err_client(client, fmt, ...)					\
+	pr_err("[%pU %llu]: " fmt, &client->fsid,			\
+	       client->monc.auth->global_id, ##__VA_ARGS__)
+#define pr_warn_ratelimited_client(client, fmt, ...)			\
+	pr_warn_ratelimited("[%pU %llu]: " fmt, &client->fsid,		\
+			    client->monc.auth->global_id, ##__VA_ARGS__)
+#define pr_err_ratelimited_client(client, fmt, ...)			\
+	pr_err_ratelimited("[%pU %llu]: " fmt, &client->fsid,		\
+			   client->monc.auth->global_id, ##__VA_ARGS__)
+
 #endif
-- 
2.39.5



