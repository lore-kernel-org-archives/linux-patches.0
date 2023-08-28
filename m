Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D318C11C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:16:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 553D1C433C8;
	Mon, 28 Aug 2023 10:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693217770;
	bh=EHj29GQnG02zd8np8eMvezUS8DcQD2GzUHhgSHD2hKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HtCVrn8PxGk1qwIA8/Mq17YZodUms27Vi82V2k7ASJyy0jSUNQ+X0V92l+eYRh0as
	 aXJystcJlHmH3Um6KdAR/rRuYSNvBnnJubFqfy2dFQLurXSUuYWQBtKJDI/liV8Kp4
	 JXXJr+FxpcysJs4ke/4quBmyNRIZQdiDcIExebk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Carlos Llamas <cmllamas@google.com>,
	stable <stable@kernel.org>
Subject: [PATCH 4.14 33/57] binder: fix memory leak in binder_init()
Date: Mon, 28 Aug 2023 12:12:53 +0200
Message-ID: <20230828101145.472053568@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101144.231099710@linuxfoundation.org>
References: <20230828101144.231099710@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qi Zheng <zhengqi.arch@bytedance.com>

commit adb9743d6a08778b78d62d16b4230346d3508986 upstream.

In binder_init(), the destruction of binder_alloc_shrinker_init() is not
performed in the wrong path, which will cause memory leaks. So this commit
introduces binder_alloc_shrinker_exit() and calls it in the wrong path to
fix that.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Carlos Llamas <cmllamas@google.com>
Fixes: f2517eb76f1f ("android: binder: Add global lru shrinker to binder")
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20230625154937.64316-1-qi.zheng@linux.dev
[cmllamas: resolved trivial merge conflicts]
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c       |    1 +
 drivers/android/binder_alloc.c |    6 ++++++
 drivers/android/binder_alloc.h |    1 +
 3 files changed, 8 insertions(+)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -5658,6 +5658,7 @@ err_init_binder_device_failed:
 
 err_alloc_device_names_failed:
 	debugfs_remove_recursive(binder_debugfs_dir_entry_root);
+	binder_alloc_shrinker_exit();
 
 	return ret;
 }
--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -1033,3 +1033,9 @@ void binder_alloc_shrinker_init(void)
 	list_lru_init(&binder_alloc_lru);
 	register_shrinker(&binder_shrinker);
 }
+
+void binder_alloc_shrinker_exit(void)
+{
+	unregister_shrinker(&binder_shrinker);
+	list_lru_destroy(&binder_alloc_lru);
+}
--- a/drivers/android/binder_alloc.h
+++ b/drivers/android/binder_alloc.h
@@ -128,6 +128,7 @@ extern struct binder_buffer *binder_allo
 						  int is_async);
 extern void binder_alloc_init(struct binder_alloc *alloc);
 void binder_alloc_shrinker_init(void);
+extern void binder_alloc_shrinker_exit(void);
 extern void binder_alloc_vma_close(struct binder_alloc *alloc);
 extern struct binder_buffer *
 binder_alloc_prepare_to_free(struct binder_alloc *alloc,


