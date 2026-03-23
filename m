Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527F03BC666;
	Mon, 23 Mar 2026 16:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283372; cv=none; b=XJERX/TyLDUkKVD8ENroDmxyItuDiXT17j07R8brKysUlyXCF9/MSJfR4Eb1qUfbQz9UHDzeZ8l4mpoq9Sodldkqkxv20WrppFlQunnQFgWkVcGBa3AJ/wzOBPJVFwN5PZpXpNqHpmYAFlW9BbIbw61qfStDIbgIw0hwDj48gR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283372; c=relaxed/simple;
	bh=3adE1lrSVhu7muIYGjUPxg+Q05VuPN9jkF6WiFyea+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DcYP86tAB7ASWVSwvu5pqbyJeCVh1L0CxziYt13BA93Pbbp+HXEXTy/2kHXYcvSlTk3tiU7SkbtBdf4/eMDVVR8QBrVzRsIdLhDDra6xden5fkEOr78mGx5ubosB4bHvwsnNWumydXJ2eUBZ9/MqiZjkhOlb99EGNDrmVuQk7EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xLJ7i+/9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xLJ7i+/9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6866C4CEF7;
	Mon, 23 Mar 2026 16:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774283372;
	bh=3adE1lrSVhu7muIYGjUPxg+Q05VuPN9jkF6WiFyea+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xLJ7i+/9zRbgJRFOeb3HoURbuZN9HaaNBCfCibHWg6twgoCmLFZ3lXfmysOXTH4+M
	 oCkp1x2dak19OzVrU5PPqXuWteOeep6yTr0Z0swalPvw8i+fSqvbtF5rCoT5yjWPNd
	 CzVmnJyGQJPH/IMFxcpdrr5pt2bznhJPf/q86kBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Johnny Hao <johnny_haocn@sina.com>
Subject: [PATCH 6.1 472/481] dlm: fix possible lkb_resource null dereference
Date: Mon, 23 Mar 2026 14:47:34 +0100
Message-ID: <20260323134536.721033111@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit b98333c67daf887c724cd692e88e2db9418c0861 ]

This patch fixes a possible null pointer dereference when this function is
called from request_lock() as lkb->lkb_resource is not assigned yet,
only after validate_lock_args() by calling attach_lkb(). Another issue
is that a resource name could be a non printable bytearray and we cannot
assume to be ASCII coded.

The log functionality is probably never being hit when DLM is used in
normal way and no debug logging is enabled. The null pointer dereference
can only occur on a new created lkb that does not have the resource
assigned yet, it probably never hits the null pointer dereference but we
should be sure that other changes might not change this behaviour and we
actually can hit the mentioned null pointer dereference.

In this patch we just drop the printout of the resource name, the lkb id
is enough to make a possible connection to a resource name if this
exists.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
[ The context change is due to the commit e1af8728f600
("fs: dlm: move internal flags to atomic ops") in v6.4
which is irrelevant to the logic of this patch. ]
Signed-off-by: Johnny Hao <johnny_haocn@sina.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dlm/lock.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -2908,16 +2908,14 @@ static int validate_lock_args(struct dlm
 	case -EINVAL:
 		/* annoy the user because dlm usage is wrong */
 		WARN_ON(1);
-		log_error(ls, "%s %d %x %x %x %d %d %s", __func__,
+		log_error(ls, "%s %d %x %x %x %d %d", __func__,
 			  rv, lkb->lkb_id, lkb->lkb_flags, args->flags,
-			  lkb->lkb_status, lkb->lkb_wait_type,
-			  lkb->lkb_resource->res_name);
+			  lkb->lkb_status, lkb->lkb_wait_type);
 		break;
 	default:
-		log_debug(ls, "%s %d %x %x %x %d %d %s", __func__,
+		log_debug(ls, "%s %d %x %x %x %d %d", __func__,
 			  rv, lkb->lkb_id, lkb->lkb_flags, args->flags,
-			  lkb->lkb_status, lkb->lkb_wait_type,
-			  lkb->lkb_resource->res_name);
+			  lkb->lkb_status, lkb->lkb_wait_type);
 		break;
 	}
 


