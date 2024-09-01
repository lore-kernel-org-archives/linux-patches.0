Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3E2184537;
	Sun,  1 Sep 2024 16:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209370; cv=none; b=hf2TS0bsD5P0a8bMTaaC4Umdil74/S4vtKWuDEDqoH/8tm2spDWN7nFnz3C+uUiRHUVlIrEN2Hg8mIM/PTq1kEvfM4Xb+tyG5AALORmEGSo/EAclfc0BSuH6b8N8ewbC+IpLx7Y7dLpYkbFxaCX8U5ZTYLdCcSE49k+8Sbmt/HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209370; c=relaxed/simple;
	bh=Unvr3Xur3FcYoBlb03r6zeMdfSfb/rQy4Wu/geQycbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bvp+gWsxoFWNj8Nsm5rEFMqxQOwsw7WVW5fWsUepU5tu0FEC16porx9+MahH2tkMPuMq1UKKOTNj3TM6pw8qPyKyIXYcWXxM8dAYIQyLwJ+1ZN4ajIaPQZo36GoynRVDMYPjW3qTL3t7AQ2Sd6xNw7o83YctXAHDyLS+G4FbEkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hRMieM5U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hRMieM5U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E81A6C4CEC4;
	Sun,  1 Sep 2024 16:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209370;
	bh=Unvr3Xur3FcYoBlb03r6zeMdfSfb/rQy4Wu/geQycbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hRMieM5UUYoZsjKr9ZiutrjYmJahtl3/tDL9k+oyxtG54zl78TUmw43H6Hl9uRKgV
	 pwjJTTk8/5Pz5MomOoNV9Y3IcSKKPFWPPfI7DR2o7lcQCS7d6Gr4lCj3n4frBfNyXq
	 F9fNKTH5oxerknbexCsqpR5GWD49gvSzwodD0wzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.10 015/151] memcg_write_event_control(): fix a user-triggerable oops
Date: Sun,  1 Sep 2024 18:16:15 +0200
Message-ID: <20240901160814.675393252@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4884,9 +4884,12 @@ static ssize_t memcg_write_event_control
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


