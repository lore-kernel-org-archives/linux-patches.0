Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB44814A62B;
	Sat, 30 May 2026 17:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161655; cv=none; b=Wx6eEbEPzb4Qyw5/vxC+GyAx7simO7rRFN1D8GCiywwdmTR9bbC8+kgFrkLS4YKQFyX2+8bSE2sHO1BaIDwDGvh6Qgyoi/I24hAETWmY6q40s9z62irKxrn09Q2d3T1n4+UgBDH+zMFzHrNGx7ZXTyKMVGhYXomVcsEpX57LOu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161655; c=relaxed/simple;
	bh=yDUHe0UKbvWAtfIS1kvJY7mdsAyM6ghZ4VPi5TYUaWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QNijE35qDwjtOwNacSguhfHI/3qDFcpRArfDryg9aC/BwLhgeGEo41ZaT6pjYkeSMwN+qTXDC8WlN5LANc1DB3M38AROK0ayW4XGq5h5SF7pDAlj/BEz8HGLY6IqzoN5SI7rIZd7xtawH7KZ6YQA6Akv17M9xgFssJEyTOD4f+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UFxWT1WS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UFxWT1WS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 315AD1F00893;
	Sat, 30 May 2026 17:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161654;
	bh=eeFot4DXHstXAKA6oNY0m4a/aFSPVNqs9ooLK7if568=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UFxWT1WSuWuplBOxhKWdeOfDzSt3VBDIVMBbMO2rUg50Cp0gQdMtrPvDCkP5nke++
	 NyxCmmAvpLFEigedpSk5PmQ5xdAS/t1XmDdR5xERbeI5P/EalYqAf9vbeuDuHT5Dyf
	 S8d7H9YEORdPOvnP2jr2u4ZGn6aSYK8c5ytDAZCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 687/969] container_of: add container_of_const() that preserves const-ness of the pointer
Date: Sat, 30 May 2026 18:03:31 +0200
Message-ID: <20260530160319.478218722@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 64f6a5d1922bf6d2b2d845de20d4563a6f328e2d ]

container_of does not preserve the const-ness of a pointer that is
passed into it, which can cause C code that passes in a const pointer to
get a pointer back that is not const and then scribble all over the data
in it.  To prevent this, container_of_const() will preserve the const
status of the pointer passed into it using the newly available _Generic()
method.

Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
Suggested-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Rafael J. Wysocki <rafael@kernel.org>
Link: https://lore.kernel.org/r/20221205121206.166576-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 21e92a38cfd8 ("tcp: add data-race annotations around tp->data_segs_out and tp->total_retrans")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/container_of.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/container_of.h b/include/linux/container_of.h
index a6f242137b116..c8d7cf8b8522c 100644
--- a/include/linux/container_of.h
+++ b/include/linux/container_of.h
@@ -21,4 +21,17 @@
 		      "pointer type mismatch in container_of()");	\
 	((type *)(__mptr - offsetof(type, member))); })
 
+/**
+ * container_of_const - cast a member of a structure out to the containing
+ *			structure and preserve the const-ness of the pointer
+ * @ptr:		the pointer to the member
+ * @type:		the type of the container struct this is embedded in.
+ * @member:		the name of the member within the struct.
+ */
+#define container_of_const(ptr, type, member)				\
+	_Generic(ptr,							\
+		const typeof(*(ptr)) *: ((const type *)container_of(ptr, type, member)),\
+		default: ((type *)container_of(ptr, type, member))	\
+	)
+
 #endif	/* _LINUX_CONTAINER_OF_H */
-- 
2.53.0



