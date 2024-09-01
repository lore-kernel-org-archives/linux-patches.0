Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D15F2C1B4;
	Sun,  1 Sep 2024 16:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207567; cv=none; b=mmNMGbb4TRwo8N9k1LL7BaW1E+HHrnlRlKN7apwYn7vdNXNFsRvqYNhAkDkkpKB4tXdpU3LeErjM4wZpxRJS1G5sq9PssaQLPlORfiALTdrXyoW9uUGAKsDJBMrWZucRumKvOq8VODZkyMkpKajDExAj6ulMU12L38EsBDi8bLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207567; c=relaxed/simple;
	bh=WKIcprMpLv5iJcoi6qcoZfB1SP9vdZxCKhZ01gz6TBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LgnpkZvo8yL4ALjiprEimrz+2zjaW7SRyrRJDy+PejblLuhQ7RJo/ifba6UOJaDTUmTLXYs8xr/Mwg98nGJIQl/QPkSXC7Y432pZ71E2Nr1q+H+X6TzPTMFTb7vP6J53hdt8G4Rm0KiAXg1hx4BgFmYbQRlt7i27U80s1jf3DXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1RPwK2ER; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1RPwK2ER"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C647C4CEC3;
	Sun,  1 Sep 2024 16:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207567;
	bh=WKIcprMpLv5iJcoi6qcoZfB1SP9vdZxCKhZ01gz6TBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1RPwK2ER/TTGf0F+LxKGPeWA+XrLiUtj5wMWLC4GV4lUS3/Unw1Nun/ATgquMr8rg
	 nYX/cj6TSDHUz0+JoUHM+MnyNOGZtLliYmBWYq8R1K8MylAx4c27n9V2XsXLxs67pZ
	 Ra/w7jI5rthTdkyz9MJsIXCcp/xuDkQ+M5mbdakM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 4.19 11/98] memcg_write_event_control(): fix a user-triggerable oops
Date: Sun,  1 Sep 2024 18:15:41 +0200
Message-ID: <20240901160804.111962173@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4140,9 +4140,12 @@ static ssize_t memcg_write_event_control
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


