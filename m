Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF01217F34;
	Thu, 12 Dec 2024 15:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018164; cv=none; b=Ln/OTmklc4PwGvKdpR1TFTATihnNMLSAlmoC87qphepOB/6QQYN1Ep9I4godIrTmqgQ5SbL5hwAMSlbW8TMb683tyAD1y7N3o+WZBmotU035tK3XtCwqOC4UlNcnmzlYrF3pcQg4SG6CSYurM668YfFZIdMV6y9TSqa7v+dBFnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018164; c=relaxed/simple;
	bh=HwvJ0CWgP5N8EnFK2dE5gVQQGJwVWCdyDgiW5nV11Zs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=roPk6Wx1VdhbRLytOgTVTFI3YnAQ4dPYuqxZ3r75XD1XM23ZrgwhPT/9EnKWjGWMKKRp9S7GiOv30PfEukfItqsszlIkKWNS6LIdoMBLZxAuau2z7GaHuKUQaGwffUwtISZmo8EoVNmsSVP0X05oQspmcGXJnbAcJlE5HQx9xsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K73xJ6lz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K73xJ6lz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49FD7C4CECE;
	Thu, 12 Dec 2024 15:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018163;
	bh=HwvJ0CWgP5N8EnFK2dE5gVQQGJwVWCdyDgiW5nV11Zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K73xJ6lzgZ/4GhK1gndNtLoSpu4MWXpDuc5FpojCu+e2lWU2TiUcCjd0V20BvQ6PB
	 VJYNYauce/1+/sUqNcwbFsGhsAgxhzS3OcPQLbBWDfa2Ps3do8RUupFC0u5E7Cblk9
	 zx+CNxb749ebzjSOvJhAtt3WhK5CyyBJJPT4h9Xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 215/356] dlm: fix possible lkb_resource null dereference
Date: Thu, 12 Dec 2024 15:58:54 +0100
Message-ID: <20241212144253.115469117@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
User-Agent: quilt/0.67
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lock.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 652c51fbbf768..6712d733fc90b 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -2698,16 +2698,14 @@ static int validate_lock_args(struct dlm_ls *ls, struct dlm_lkb *lkb,
 	case -EINVAL:
 		/* annoy the user because dlm usage is wrong */
 		WARN_ON(1);
-		log_error(ls, "%s %d %x %x %x %d %d %s", __func__,
+		log_error(ls, "%s %d %x %x %x %d %d", __func__,
 			  rv, lkb->lkb_id, dlm_iflags_val(lkb), args->flags,
-			  lkb->lkb_status, lkb->lkb_wait_type,
-			  lkb->lkb_resource->res_name);
+			  lkb->lkb_status, lkb->lkb_wait_type);
 		break;
 	default:
-		log_debug(ls, "%s %d %x %x %x %d %d %s", __func__,
+		log_debug(ls, "%s %d %x %x %x %d %d", __func__,
 			  rv, lkb->lkb_id, dlm_iflags_val(lkb), args->flags,
-			  lkb->lkb_status, lkb->lkb_wait_type,
-			  lkb->lkb_resource->res_name);
+			  lkb->lkb_status, lkb->lkb_wait_type);
 		break;
 	}
 
-- 
2.43.0



