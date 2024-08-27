Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA3773466;
	Tue, 27 Aug 2024 15:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771142; cv=none; b=HDkT1nQZdQ5i/e41CX6HxIJ09NHnTdKUjiR3s8xka6NeQg0xwLqaJiH7UG8Ks/IIwlv7YyZmVgnvCkSQMaw88OKbV92KmVrzg7kMw3rzfA7rNtzJoaDPwsyWr7Yja7w/mBGegCDp6luNrfYKLJTccvsuIKk1HTXDvLG7YM8FEv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771142; c=relaxed/simple;
	bh=TBZ25nJBstAlb8NlCnxCT43uCi+0puUCprbT9h6Z52c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BOQ4bK7whetsJ506nsxkcvaWX6OXKrDIiubDaJ/kbaupmebYpj0/y0YbOfYsmC6QKG5FWsUbFzvbL/nBI9rGdBvwNA40n6+IgGTj75EtCChNLcaRI48OruCKZASRSE2Wvu2997qNp8bOlvjNRt8YehzMK7rqX3vT6x25aT2DDTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VMANsFZL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VMANsFZL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BD13C6106C;
	Tue, 27 Aug 2024 15:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771141;
	bh=TBZ25nJBstAlb8NlCnxCT43uCi+0puUCprbT9h6Z52c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VMANsFZLJLRy8nPTO1LBaIX59GXUsylAL94+GUecobdqbbYT4aq5l3IUwqulXdR9A
	 dmaeiqMdBqM5MByNO1FtVQQ43eh83XsSqc2nGdPl4F4XKGwIW2kotV/x3B7AUHcTGx
	 BV5ex+Ic2et2gBaTZX7juMSdSIl+0cOVcXsfI2K0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 6.10 068/273] memcg_write_event_control(): fix a user-triggerable oops
Date: Tue, 27 Aug 2024 16:36:32 +0200
Message-ID: <20240827143836.003910580@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5282,9 +5282,12 @@ static ssize_t memcg_write_event_control
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


