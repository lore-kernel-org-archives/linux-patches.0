Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1FC231159C;
	Thu, 28 May 2026 20:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001379; cv=none; b=ADA3pulBrCqMI4reKvju/kV7vMs5OUu8HelGzMY/ZMI8Xb94Ccokis0bx7LITkKJAAceKqxZ/79fl9Ar0KbhCHeBUXgRNkvBp1QwCQD/zN+x52HEZXg0heLFIdIkcoNyH5GhKEZ2/ohiTm65bDMF9oKkPIiCMerlgp+ANtwuRoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001379; c=relaxed/simple;
	bh=HzfBcBLp1Z8JJR6xj9Oi+bPljqMF/Lp+Mo05zbHOG/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aLLonSj+6B6uXNkrbKSb2g4MqKYHoacPj+3G3VV50hBR293u8ONk0lCsGW5NULnMCJVj0MAPBPFk7uxwnpbY68a9ZULFvN9AHqwZh0yXmkycjqknR0SyB8ewMkuuwP336zQYLBUJllV212eJ0d1BY/9bXpAWVBXXv9Mm10BGbls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PE2kSysS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PE2kSysS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B6691F00A3A;
	Thu, 28 May 2026 20:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001378;
	bh=eQs7JASmmVs4grtFNrYOrpLfHl6yyp7FJSj7SYq/8M4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PE2kSysSBvhDo853gMdG+sqJHFji/+Hu5n/H2gbnOrjXmeFSAmwb/dIQOTkL/QNkd
	 cZ1njT+nfo8kLV0fbaQeUCBPyYO+ANknc1QD4N59LfIJlBo8JYPYxhk7CT3Eq8rF35
	 73L7A4fabn896GbF6lNimRMROEkf2rRhcxEmd4iM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 6.6 069/186] device property: set fwnode->secondary to NULL in fwnode_init()
Date: Thu, 28 May 2026 21:49:09 +0200
Message-ID: <20260528194930.805833009@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -193,6 +193,7 @@ struct fwnode_operations {
 static inline void fwnode_init(struct fwnode_handle *fwnode,
 			       const struct fwnode_operations *ops)
 {
+	fwnode->secondary = NULL;
 	fwnode->ops = ops;
 	INIT_LIST_HEAD(&fwnode->consumers);
 	INIT_LIST_HEAD(&fwnode->suppliers);


