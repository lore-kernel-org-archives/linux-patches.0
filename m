Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A7D33065C;
	Thu, 28 May 2026 20:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999603; cv=none; b=kFOVwcdFxQKxrDfJGL8BPBuaneY5voKk7iOmTPVGzgvCD1tKjYjpx0oiC/Eu2CoiqXdMDat0nRu8V3dmkvcxT7mUy94MvBhvN01URezEof2JnWPgs8p1EKpKge252nAWDwbtWP003vWTGu+88KQKlt8MSYZ3m53++PIgk09JITY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999603; c=relaxed/simple;
	bh=nT2gu1aLWfIJom8IqXUpbKI8VVX8+gZZv5S5wg3c6wI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mG9DBn9DN0ZZY82n7deVDn0uoxjq8F1ud1LKMEUjdjDrO3GAMxUwAoU8Xh6tRuVlmJKFXSwc2RN0be+RfnxN/rcy2SEdbLX5UB0tve37AsZStt1AB8G2lii+w+ryIMIOz2FSnJ5m0caNBONnw/nCobOslVJFCFGOl3TSMdMmdXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sURZVRVq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sURZVRVq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B35C1F000E9;
	Thu, 28 May 2026 20:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999602;
	bh=sg+93V7SO98i9dYIwEGUs2XRxVEsmhOurs2Ml85HBhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sURZVRVqXb63dMx6Eh02bK1emY8lhYgP85Et4cBggDRi6ZrdCo4sGm/SOY5DhOrvh
	 1pNirNYLGP83J1huu1Zb7F2pYcWz1WusYGS+yVuqAxz3wz9j+aWXN9q+26sSqsMyZB
	 7zCK6VSILobpwpi9jtapxwsM5sVzPgTtE8edtC5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 6.18 126/377] device property: set fwnode->secondary to NULL in fwnode_init()
Date: Thu, 28 May 2026 21:46:04 +0200
Message-ID: <20260528194642.000601448@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

commit 215c90ee656114f5e8c32408228d97082f8e0eef upstream.

If a firmware node is allocated on the stack (for instance: temporary
software node whose life-time we control) or on the heap - but using a
non-zeroing allocation function - and initialized using fwnode_init(),
its secondary pointer will contain uninitalized memory which likely will
be neither NULL nor IS_ERR() and so may end up being dereferenced (for
example: in dev_to_swnode()). Set fwnode->secondary to NULL on
initialization.

Cc: stable <stable@kernel.org>
Fixes: 01bb86b380a3 ("driver core: Add fwnode_init()")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Reviewed-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Link: https://patch.msgid.link/20260506115701.23035-1-bartosz.golaszewski@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/fwnode.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/fwnode.h
+++ b/include/linux/fwnode.h
@@ -208,6 +208,7 @@ struct fwnode_operations {
 static inline void fwnode_init(struct fwnode_handle *fwnode,
 			       const struct fwnode_operations *ops)
 {
+	fwnode->secondary = NULL;
 	fwnode->ops = ops;
 	INIT_LIST_HEAD(&fwnode->consumers);
 	INIT_LIST_HEAD(&fwnode->suppliers);


