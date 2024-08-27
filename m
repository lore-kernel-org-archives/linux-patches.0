Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF2E1C57A0;
	Tue, 27 Aug 2024 15:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771817; cv=none; b=lhuEjZGy2PJbK3XWhGsaNSEJTo4TvcMhhiUHHClv7GyPdyDxje1GUd16nT6QUF+i/ifn9li1zpPnHMmRXv1EaIBqKHVq+A+cZwxyn7USYuslQWaStvz+sm0wr4h8cmPip/PoR6dYJH0QTqS8miv7BLBtdCLUaU9M3ATbXhLR8T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771817; c=relaxed/simple;
	bh=UP/AzkAM6aCAVFgvER3BCA2HP/uyACkM8mCjg9SLEwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BTZpiVTbH6aIVzxAiXcFx2WBQeGVvE9hQ68S91fhWhjS6+PNmaWewKlKW1WL0inOXYas9SWJKbjplDKeyBU9qUYwS7mZ3BrYt1cWLxHCccfMKdO1WPz9ib2TjlzdDJxMb4VI0RoWOFBjP+Y5uSo/t3Eo/6U8IeT/87cxY8p/VS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mzwub8p2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mzwub8p2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63BC6C4DE1D;
	Tue, 27 Aug 2024 15:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771816;
	bh=UP/AzkAM6aCAVFgvER3BCA2HP/uyACkM8mCjg9SLEwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mzwub8p2ULWvsoMdqD9svK8qfQFl3t3nhBJuOVZaoaEgyypU9fjHmsUU2RA9S50UY
	 4go9BFZlK97aCrEKndZqX4IZvnk+yo04/OcBkWsFxRGlZ7PjysFBemLRyY3jAHBIfX
	 HzRRDMC1wxGgWDZIDP6obF7Yy0FmFJ+Lmkc8YtN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 6.1 029/321] memcg_write_event_control(): fix a user-triggerable oops
Date: Tue, 27 Aug 2024 16:35:37 +0200
Message-ID: <20240827143839.325890308@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

commit 046667c4d3196938e992fba0dfcde570aa85cd0e upstream.

we are *not* guaranteed that anything past the terminating NUL
is mapped (let alone initialized with anything sane).

Fixes: 0dea116876ee ("cgroup: implement eventfd-based generic API for notifications")
Cc: stable@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memcontrol.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4857,9 +4857,12 @@ static ssize_t memcg_write_event_control
 	buf = endp + 1;
 
 	cfd = simple_strtoul(buf, &endp, 10);
-	if ((*endp != ' ') && (*endp != '\0'))
+	if (*endp == '\0')
+		buf = endp;
+	else if (*endp == ' ')
+		buf = endp + 1;
+	else
 		return -EINVAL;
-	buf = endp + 1;
 
 	event = kzalloc(sizeof(*event), GFP_KERNEL);
 	if (!event)


