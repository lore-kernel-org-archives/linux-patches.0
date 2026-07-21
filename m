Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3D8437111;
	Tue, 21 Jul 2026 21:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670861; cv=none; b=LF0w8uVebBftLrLyWMhCLjl6T1C3EL0of+qVHpvWv8hmZFuNwuaH94USQqDSZ+SHMB1Z3ZlAe4PuA4SQmr9wpSr31wtRC669zJXtHogBFEdSE22tcVPYCaJev5PxTiQBHfRZAY8FC4vXZDanswJayhbvcDf0Gt45+M3b6y+OvD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670861; c=relaxed/simple;
	bh=Yv4QkdCxbzU4M9iuZNvwrcC0UIDLo+bs43XqHlS2Gbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=orYtsmv+TqJ7SdevPEp6p5mJJIYt67wbwLgp7LZZuSeSgNeIuSIcLMKEbJuDz9lgFO1x5CQmAsSkAxfCAqWJaZE80bRMuvmgn5tXHXOuSPkfdyAii+Ku5egp+96lMWMnjoWdNPOGBQbuYGKZWmHLmuJklCjqihwIhXkkHQkEmM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mZVh1esp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mZVh1esp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E72331F000E9;
	Tue, 21 Jul 2026 21:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670860;
	bh=liYl8cvO8H5kgSsZvtug5XdVQryfDZaMgmYiCb7YBS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mZVh1espaO91dMGP1MBCX/Js/V5uCA+EcRapCj0rZ16hvv3AMTSLpuBsnCNfZnhMB
	 EmGgFyPW1HVwFmZmvA7LmvtpjgUJxXOibwaL1wMg7APCkF/T4Ft2Jdjhuw/5RfmBFn
	 y1ZZadEWPq4PNPd0M0ivT8JeveAbdEwu1ltrAdn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 028/843] device property: initialize the remaining fields of fwnode_handle in fwnode_init()
Date: Tue, 21 Jul 2026 17:14:23 +0200
Message-ID: <20260721152406.600660994@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

[ Upstream commit 7eba000621fff223dd7bab484d48918c7c77a307 ]

If a firmware node is allocated on the stack (for instance: temporary
software node whose life-time we control) or on the heap - but using a
non-zeroing allocation function - and initialized using fwnode_init(),
its secondary pointer will contain uninitialized memory which likely
will be neither NULL nor IS_ERR() and so may end up being dereferenced
(for example: in dev_to_swnode()). Set fwnode->secondary to NULL on
initialization. While at it: initialize the remaining fields of struct
fwnode_handle too just to be sure.

Cc: stable@vger.kernel.org
Fixes: 01bb86b380a3 ("driver core: Add fwnode_init()")
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260511074927.9473-1-bartosz.golaszewski@oss.qualcomm.com
[ Fix typo in commit message. - Danilo ]
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/fwnode.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/fwnode.h
+++ b/include/linux/fwnode.h
@@ -174,8 +174,10 @@ static inline void fwnode_init(struct fw
 {
 	fwnode->secondary = NULL;
 	fwnode->ops = ops;
+	fwnode->dev = NULL;
 	INIT_LIST_HEAD(&fwnode->consumers);
 	INIT_LIST_HEAD(&fwnode->suppliers);
+	fwnode->flags = 0;
 }
 
 static inline void fwnode_set_flag(struct fwnode_handle *fwnode,


