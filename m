Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1BF35E53F;
	Tue, 16 Dec 2025 12:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887328; cv=none; b=iO1/+kFSAFtZs9FsmQPe27Yauzrd2ZLjvFaZtWzz+WitfrkUIu3e3iPRmOKOhLum4xTFuFF93Tyac80oRt18MNNa+E61MMbqx1b4LFeKT8Az91bhQ3uweapgNzmtRaZt+mr6dphvH3pJAP0VdSBadWWyLFcgfmaV54+i1ffYUQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887328; c=relaxed/simple;
	bh=QvG8sCUz37MjSQ7L/sB1qy3Py5jx103Dta3cGmOia0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q9zK+b5Ng/awVtEKU6OvFQBOVVe7W5c8VxYdzM0ZCfSHmiLqapSzpwdqQkHS3yM9IcHbTVxCq/5j5vUN7nk+nawBj+UfcFa+MjTyGECR8DhTFCdjKUhdqeWQ3Y1JpPe5yZ+cXyCLPj2HAVzRNwXJg1FkPJ9SjuSUy5aC+txCsu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yqOXm1B9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yqOXm1B9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F54C4CEF1;
	Tue, 16 Dec 2025 12:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887328;
	bh=QvG8sCUz37MjSQ7L/sB1qy3Py5jx103Dta3cGmOia0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yqOXm1B9wMTfywJpYzC/cIvbuHF/lvBv/3xcZ8Dqv176m4MOfIwMygkGbPi7GBUJd
	 cPztMatb1rjP3o+m/w3R7OJyoj5NJ+KstVjVxK7rsxyoD7U4DeH3OuZlDsp53wrkWw
	 GnFd7EEUS1f9hcwUmT6YQFM3EniOeaGheWlcYipo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 196/614] ns: add NS_COMMON_INIT()
Date: Tue, 16 Dec 2025 12:09:23 +0100
Message-ID: <20251216111408.479312979@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit d915fe20e5cba4bd50e41e792a32dcddc7490e25 ]

Add an initializer that can be used for the ns common initialization for
static namespace such as most init namespaces.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://patch.msgid.link/87ecqhy2y5.ffs@tglx
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 3dd50c58664e ("ns: initialize ns_list_node for initial namespaces")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ns_common.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/ns_common.h b/include/linux/ns_common.h
index f5b68b8abb543..3a72c3f81eca4 100644
--- a/include/linux/ns_common.h
+++ b/include/linux/ns_common.h
@@ -119,6 +119,16 @@ void __ns_common_free(struct ns_common *ns);
 		struct user_namespace *:   CLONE_NEWUSER,   \
 		struct uts_namespace *:    CLONE_NEWUTS)
 
+#define NS_COMMON_INIT(nsname, refs)							\
+{											\
+	.ns_type		= ns_common_type(&nsname),				\
+	.ns_id			= 0,							\
+	.inum			= ns_init_inum(&nsname),				\
+	.ops			= to_ns_operations(&nsname),				\
+	.stashed		= NULL,							\
+	.__ns_ref		= REFCOUNT_INIT(refs),					\
+}
+
 #define ns_common_init(__ns)                     \
 	__ns_common_init(to_ns_common(__ns),     \
 			 ns_common_type(__ns),   \
-- 
2.51.0



