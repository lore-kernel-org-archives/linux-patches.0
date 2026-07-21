Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E16B46A61C;
	Tue, 21 Jul 2026 17:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655339; cv=none; b=aahNmmBTbhiv+MJu+YY/LHuFp7PFBw2NTPOOjDHdA+BEpyX4v0tBMYMMp+xORMMgEG58QyvJ0QBsnFkhS2xUg3zKQDyFUHQEYSUGsl5Zd0Dqt7NKxgnZ7Nq8fZRUwekxTBX++FdNMqBFrzeNdsQZP/jMigYaSg9q4orPhALq+1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655339; c=relaxed/simple;
	bh=2QsgEFWOxqy7rHmWibbj1YPA7XG1eZ/95oq5GZliFPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DL5g101dgDuaQCDy4/kqPVdvGafuEgzAZcZx9ci++WHQ7kLb63a4RCiS2LQbXHETyu5VmN3FQFv5BFL+qUohtzGbCpxRpihl2su1o94Z8vNfPJ37qvq/kLDXeKo/1FdzOJdhzsvQk2ucxe4suQprNXPKjDlpNad0MBxXEG22X+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LZNsbM5n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LZNsbM5n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C90171F000E9;
	Tue, 21 Jul 2026 17:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655338;
	bh=sVlsDbaagfH1BaLW16fMqTa6OxDQapR/LQ7GmKRiKKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LZNsbM5nZqLl91RdlHtYnVp9p7NfB5egBEwhm/PKIDf2NM2XzpjdZVbuGHDUU7CRz
	 6xCS2+RKedFg/lQHDAYKjm4mbKopyS9Uj8+N4H1J1r3UxQjWKoTXnZvaYcs6xiPoMG
	 hHHLuBrGxROrc63N6eIW5yvHCmalI0yuYqRm4Kd4=
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
Subject: [PATCH 7.1 2047/2077] device property: initialize the remaining fields of fwnode_handle in fwnode_init()
Date: Tue, 21 Jul 2026 17:28:40 +0200
Message-ID: <20260721152640.978462907@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -210,8 +210,10 @@ static inline void fwnode_init(struct fw
 {
 	fwnode->secondary = NULL;
 	fwnode->ops = ops;
+	fwnode->dev = NULL;
 	INIT_LIST_HEAD(&fwnode->consumers);
 	INIT_LIST_HEAD(&fwnode->suppliers);
+	fwnode->flags = 0;
 }
 
 static inline void fwnode_set_flag(struct fwnode_handle *fwnode,


