Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D9114AD0A;
	Thu, 15 Aug 2024 14:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731435; cv=none; b=K+TKbv7df2IoE5P4nS4jn+flZvFlwOK3CfRZnGIbuUn4VAUrscAW/Zojli75+Wl1XJmCcykd8HPdEhypsbXqC5BK4q7oTrmdrmlAGoqWh/YLso8cnSUc+g5+BI0mOjl2W4Ze5iHvjFlUd6gGop2TO+QRc8rXZasDHiWGo93UNQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731435; c=relaxed/simple;
	bh=mdit0r/eklCCkjoPzQJH29MnH8XHEhpQCqRTW37DDfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GXmnlirBDIoboiqCIiuomQ/z9qA8JhRerQAUkgL3eZUbpiXUNo74uR/EI8vXE23eKwb9Lb5of6cHHLETjUqYdFZb3FBYM+KhmTJqw7HrmCWcsNGJhf9AFWC5feCXzVzP9kNcYLuuQSxkypN/0ABXH+OF5BOJr/7OxCOsoACyfs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qUH+UzQM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qUH+UzQM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB867C32786;
	Thu, 15 Aug 2024 14:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731435;
	bh=mdit0r/eklCCkjoPzQJH29MnH8XHEhpQCqRTW37DDfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qUH+UzQM6ria/BM/NuRuAqQuxdYKon/EoS3rgJCpPJkxx3GsJIu2OzrkBShG91V/0
	 Jl8Vvq7jCddcJN7wxqo83OPSXy7T6OaOMsMKmv73GW3gU5WwsInUsNmkTfl7XsvxNW
	 MCD1n+U2XsNaziWOmGnHkF1RH6G7ClQtsUhyvHQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dryomov <idryomov@gmail.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 5.4 127/259] rbd: dont assume rbd_is_lock_owner() for exclusive mappings
Date: Thu, 15 Aug 2024 15:24:20 +0200
Message-ID: <20240815131907.698930138@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Dryomov <idryomov@gmail.com>

commit 3ceccb14f5576e02b81cc8b105ab81f224bd87f6 upstream.

Expanding on the previous commit, assuming that rbd_is_lock_owner()
always returns true (i.e. that we are either in RBD_LOCK_STATE_LOCKED
or RBD_LOCK_STATE_QUIESCING) if the mapping is exclusive is wrong too.
In case ceph_cls_set_cookie() fails, the lock would be temporarily
released even if the mapping is exclusive, meaning that we can end up
even in RBD_LOCK_STATE_UNLOCKED.

IOW, exclusive mappings are really "just" about disabling automatic
lock transitions (as documented in the man page), not about grabbing
the lock and holding on to it whatever it takes.

Cc: stable@vger.kernel.org
Fixes: 637cd060537d ("rbd: new exclusive lock wait/wake code")
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/rbd.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -6618,11 +6618,6 @@ static int rbd_add_acquire_lock(struct r
 		return ret;
 	}
 
-	/*
-	 * The lock may have been released by now, unless automatic lock
-	 * transitions are disabled.
-	 */
-	rbd_assert(!rbd_dev->opts->exclusive || rbd_is_lock_owner(rbd_dev));
 	return 0;
 }
 


