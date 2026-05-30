Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A2A33F590;
	Sat, 30 May 2026 17:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163033; cv=none; b=sKz2MaGdwo3mm2IVTzThxhVQbCNpc57dRHk5a2h2sDTP7KRMc51xSN2HSPbeLDs+iQpaUyRXsVwrUGemeNw2tr1DmCzCaXCWfBUE0LhVlbKOGCE0KLiPSOZWd4wW1/r3T8Ujk+AoowAg4gw7mN1t4FqDyKewuxGlOivhS/X1l2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163033; c=relaxed/simple;
	bh=FF4laYzPrJ0z+X43O/pjuadN04pdbc/HooA74cXQnKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ObJHQ5InrshvCtNWb3UpgcoWFuIcd9RXRJU9ohWWtiv4CFPMEPBYT1u3QT+C0K55yzyhpYyhjC5Y8rxjuNhpnnf+/FpUzfikbb8kBa4uIps5l4EMjsnU3Q5wmjRW2tNF6szIOATxrRJ0mN7JS7d+iD+E2RwcALpQkQOxG4fX3QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UGIVAWK1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UGIVAWK1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D1B1F0089D;
	Sat, 30 May 2026 17:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163032;
	bh=//R7PpTJ2lRHK8dkXTGmFWsg7t3RfFnDiznjOGDF3K4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UGIVAWK1fMIRyuV6aM2kbLfn6NarbnZthPxxoztReGQg1kxZue6lwzkWtIYo2vhT4
	 qo8DLI22+9mF9bNxamA3Tgzi+CmHb3TJ14ICWyqn+q8UmNCW0w/3jESZECPs+/n5H7
	 a2uzd9dKbl3M4lR03NUq9XvfeetWQAO3FOOAQjn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Johnny Hao <johnny_haocn@sina.com>
Subject: [PATCH 5.15 136/776] dlm: fix possible lkb_resource null dereference
Date: Sat, 30 May 2026 17:57:30 +0200
Message-ID: <20260530160243.920880159@linuxfoundation.org>
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
[ The context change is due to the commit 9ac8ba46a701
("fs: dlm: handle -EINVAL as log_error()") in v6.1
which is irrelevant to the logic of this patch. ]
Signed-off-by: Johnny Hao <johnny_haocn@sina.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dlm/lock.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -2923,10 +2923,9 @@ static int validate_lock_args(struct dlm
 	rv = 0;
  out:
 	if (rv)
-		log_debug(ls, "validate_lock_args %d %x %x %x %d %d %s",
+		log_debug(ls, "validate_lock_args %d %x %x %x %d %d",
 			  rv, lkb->lkb_id, lkb->lkb_flags, args->flags,
-			  lkb->lkb_status, lkb->lkb_wait_type,
-			  lkb->lkb_resource->res_name);
+			  lkb->lkb_status, lkb->lkb_wait_type);
 	return rv;
 }
 


