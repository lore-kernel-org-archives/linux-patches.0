Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A095241C8C;
	Sat, 30 May 2026 18:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164930; cv=none; b=u6Kacs+g2OGnudTrnRWnkoVx0Q7vKPsEDID++L/DPPblWMzCXuEUWPbV5EpjeQpAD8BRj3aKL9kHaZjRSRmhGOt3FkL99+JBGFmYGRcb9zpRe1ndZs2qus5zg9cGXV+swmH+75ZtcTg5gCP8JnKvgGK7jtXm0djf9u9iTS/d2NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164930; c=relaxed/simple;
	bh=5DlMUbPZ+T81SXtNNe1yNx2ecs5GABMu3EgMtP/nRHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DGqaFo6/J97xbFr9pZha/xpCwvXFvRqRq+PVdo/lE6v0LfXoQ2skx5DzPQx0QB3h1d/XviERQaDXBmC6Q3U/Xp2zANqztFNG+BIWP/oy5vboRNbDwRNvqGZd+LhbM+Ge7VLDTCxzmRW0FE6sdCNMdKWQsnPNTooPuOfUJziV8oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fvsQCWiQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fvsQCWiQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ACD21F00893;
	Sat, 30 May 2026 18:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164929;
	bh=RE+VeYt+a6/ewnWIrJjhZlmIAdPt9oYdwqW0g+1Vox4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fvsQCWiQjFpfPgkBgIECO7txAwfChTWT55vQaXovytv/mINvNpyRIUJBXGoZkEuPK
	 oTYDUIr1oPhlEbIH1mWFVaAH8D6aTK0ixJac7RyzJuX2fXfZbmuBtRpttm1yt5BCtJ
	 u+cp8W1Uf5Zc4LcmLBbnzWqOP2ZGfX0jJinbNQYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 5.15 701/776] device property: set fwnode->secondary to NULL in fwnode_init()
Date: Sat, 30 May 2026 18:06:55 +0200
Message-ID: <20260530160257.955986093@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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
@@ -172,6 +172,7 @@ struct fwnode_operations {
 static inline void fwnode_init(struct fwnode_handle *fwnode,
 			       const struct fwnode_operations *ops)
 {
+	fwnode->secondary = NULL;
 	fwnode->ops = ops;
 	INIT_LIST_HEAD(&fwnode->consumers);
 	INIT_LIST_HEAD(&fwnode->suppliers);


