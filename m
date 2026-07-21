Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D3F434E4F;
	Tue, 21 Jul 2026 21:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668125; cv=none; b=gOks42VtTW/rp6DqKkTh194QA3SvuZaJqDa8L+3EappGzdiq/zPyRS9i5kdbqhHI6wRufsek3ArpdsGWhudy/bgELAEaWF5Fz7KNK2Rp74+9SEfl3C6MV4lFmrrL4S27oj2nKNdcBy9YrdgcMCAWJUUG2k8CBccAGxMhkvus+CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668125; c=relaxed/simple;
	bh=WNvtTtnKD3Qs62DRmi5kiD52CgQ1Bud6b6u6w17gP24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p7LN7yIP/+3nIlxF3Z3nX5uZy/+WZHz2qheXFjyxotenBUoK+cI6l4hgG6kiDqbfRfqvHJv0fYQVHOBsWZkZDO3ULV3+80oRK6wmkPtR9zGQnjl7ohklZwNbcaPi6QlPvQjUT5Dos7QE3edKomENoZIcgxeJVGosYcSjkQLCI6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l3pEkxfP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l3pEkxfP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710121F000E9;
	Tue, 21 Jul 2026 21:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668123;
	bh=C3Ztu7/UVmHJKqOt7BNWe3bP24D3hbOKmeixpkYuIoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l3pEkxfPfznEvxYfzESWxhjcgdpmzSh4HQu9kakuVjn/8BQBGpaUB9qFHIBBtWNj/
	 iluoLOjB4zGI0wVRAM7DrEwKclem74JjIHuj8umRlTOEFWwiSfvafOBAXFzR2TEBUZ
	 VEofGLgmnvh4DVTRQ1AMivNa/ZUo3sVDtv70iPxE=
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
Subject: [PATCH 6.1 0014/1067] device property: initialize the remaining fields of fwnode_handle in fwnode_init()
Date: Tue, 21 Jul 2026 17:10:15 +0200
Message-ID: <20260721152424.850732876@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -195,8 +195,10 @@ static inline void fwnode_init(struct fw
 {
 	fwnode->secondary = NULL;
 	fwnode->ops = ops;
+	fwnode->dev = NULL;
 	INIT_LIST_HEAD(&fwnode->consumers);
 	INIT_LIST_HEAD(&fwnode->suppliers);
+	fwnode->flags = 0;
 }
 
 static inline void fwnode_set_flag(struct fwnode_handle *fwnode,


