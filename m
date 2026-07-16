Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4CE328505E;
	Thu, 16 Jul 2026 14:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211722; cv=none; b=RSrma5FXJW+FcEYle/YtTz3KmPFGdS74IGsdyghlTksG/v9Hz93Eb3z2/meOCNLQTHxww1s1HWGhhFfOHarz8SU4WO+OgTvVxOkixSRo3JvS932NMR3/2h1Xbgr6JsPIkzgh64XKIGVf3+u/T2vLhQvEGYahXp90rYdz9UP5sgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211722; c=relaxed/simple;
	bh=KnWWdBq3lA2TV9QtQ5vKLFpUYnyapf3qwT5y4/qyBKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d7Wxgw3oQpxPdx3sCFTsZngwLSdqIh/FbWeM/5cP26+YUBKR9kjq/gfO02v61k8cW8U72akjPHW2ZdbzrSLt7U8sWl1ou1lszU7rmQQFqcHoNu/kF8VGZmieS8E3QsqXxT20pACATtz0T7hcU2hEKC5bJytIxt5PKXyKgiLEGJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TSxXuPrv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TSxXuPrv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A37B1F00A3A;
	Thu, 16 Jul 2026 14:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211721;
	bh=O7pwyXk9BE0sGgr3OvdScgWpgloSFeKuyaNQtk4Uc+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TSxXuPrvpU8U24lhSwYIJYUbyvWM+CNVfoZailI3DqWUpBtd+yxPbk6Ek4SX/NQHf
	 dKU0T9ywbiVGGKzBq/CNfzyPvNfj+VkoNAkcImEhpgWwOiyb/OeA4smWz7DJ1Uk/pJ
	 tbL2NMzbsr4RwZzwuMRpqdTITPIPo4zOz798wqh4=
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
Subject: [PATCH 6.12 012/349] device property: initialize the remaining fields of fwnode_handle in fwnode_init()
Date: Thu, 16 Jul 2026 15:29:06 +0200
Message-ID: <20260716133033.567844817@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -202,8 +202,10 @@ static inline void fwnode_init(struct fw
 {
 	fwnode->secondary = NULL;
 	fwnode->ops = ops;
+	fwnode->dev = NULL;
 	INIT_LIST_HEAD(&fwnode->consumers);
 	INIT_LIST_HEAD(&fwnode->suppliers);
+	fwnode->flags = 0;
 }
 
 static inline void fwnode_set_flag(struct fwnode_handle *fwnode,


