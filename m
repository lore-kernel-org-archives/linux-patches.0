Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75CE23F9FF;
	Thu, 12 Dec 2024 16:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020104; cv=none; b=cA0VcdU+QE3cIfai0HT0KWMAujmLqMw54o7ApmEMFNQTCQ2ZMRa0vanqvlG6iyWYZfUUNCA5jEZoCrQNDPNTvKCjskhCZ+ew6s8f7ti/wupSyT09dziTYrOGVOek7LES7iZPaWy4NwQSg0ZHBExGsisxeJJHIHNEhbmxn+eRZI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020104; c=relaxed/simple;
	bh=iNeoI3mlimzKLt6fjmH/2hKxmknqckg0u5tHZCjNrHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NG32+InphCDmJ8qO70hDr+EbYKJbDsWPFVOV5vF79yPCwal9vtqEYetb5io6gkSqXXUTgdR6Neyu1+fn7zDiL1RIBqrq01Vjgk1prASXlXWRs5tSliBqaUernVyksxTJ2gkA6obKkKJsSZ+LoxYsa/tKMCZcpVJkDNddP8O0Ky4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rhnsDMGn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rhnsDMGn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC84FC4CED4;
	Thu, 12 Dec 2024 16:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020104;
	bh=iNeoI3mlimzKLt6fjmH/2hKxmknqckg0u5tHZCjNrHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rhnsDMGnLrL6egER36hdujgoZpjrVerpq0Gqcfrv76UJkTKSRnm1A8t+AhgPfQxFL
	 xYMxcDssk3BrCt8IqRq6PtqP7ZMcCiRkUteXXWOrTvax6yJYrPqfRvk8f+NkQSgDQ/
	 aOhxFVEAlUSo+J99sQdUVuOXwBqBAyrjr0Ixjifs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7f4a6f7f7051474e40ad@syzkaller.appspotmail.com,
	Ahmed Ehab <bottaawesome633@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>
Subject: [PATCH 6.1 378/772] locking/lockdep: Avoid creating new name string literals in lockdep_set_subclass()
Date: Thu, 12 Dec 2024 15:55:23 +0100
Message-ID: <20241212144405.519183281@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahmed Ehab <bottaawesome633@gmail.com>

commit d7fe143cb115076fed0126ad8cf5ba6c3e575e43 upstream.

Syzbot reports a problem that a warning will be triggered while
searching a lock class in look_up_lock_class().

The cause of the issue is that a new name is created and used by
lockdep_set_subclass() instead of using the existing one. This results
in a lock instance has a different name pointer than previous registered
one stored in lock class, and WARN_ONCE() is triggered because of that
in look_up_lock_class().

To fix this, change lockdep_set_subclass() to use the existing name
instead of a new one. Hence, no new name will be created by
lockdep_set_subclass(). Hence, the warning is avoided.

[boqun: Reword the commit log to state the correct issue]

Reported-by: <syzbot+7f4a6f7f7051474e40ad@syzkaller.appspotmail.com>
Fixes: de8f5e4f2dc1f ("lockdep: Introduce wait-type checks")
Cc: stable@vger.kernel.org
Signed-off-by: Ahmed Ehab <bottaawesome633@gmail.com>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Link: https://lore.kernel.org/lkml/20240824221031.7751-1-bottaawesome633@gmail.com/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/lockdep.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -229,7 +229,7 @@ static inline void lockdep_init_map(stru
 			      (lock)->dep_map.lock_type)
 
 #define lockdep_set_subclass(lock, sub)					\
-	lockdep_init_map_type(&(lock)->dep_map, #lock, (lock)->dep_map.key, sub,\
+	lockdep_init_map_type(&(lock)->dep_map, (lock)->dep_map.name, (lock)->dep_map.key, sub,\
 			      (lock)->dep_map.wait_type_inner,		\
 			      (lock)->dep_map.wait_type_outer,		\
 			      (lock)->dep_map.lock_type)


