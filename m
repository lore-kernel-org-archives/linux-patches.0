Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292FD1C57A3;
	Tue, 27 Aug 2024 14:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769822; cv=none; b=Jlp31Rjf8UtSCwvg/IXD/VK0v3T3/jrS/DjW4YtlWSu23zEJoGk4NBY7VRv93NMaRTIUu8lKhUzEPu52ATOAOfvjkeF6B6tMHR2jDhbWN2T7BCjS9Ln0AYKdVFDQ6ajRZvyLDtboCxn7TjounHSxDdJePOV0sHmH9UbqtZo8j+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769822; c=relaxed/simple;
	bh=kWHiiYXo0sH6YRjKZQgykXd6VFLMCSeH5Hkqyiuyiy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NikkwNr+wNIGAJWenY4snnUO8OE0sPXpYl+To3PI9Hh0gDe63dPIZmQfCsyz9iGE7PuDi7iEXc6Ck9ZxFDCgmuCN2XWNSNYhh92xcDiAVuekeDuaN4BqxTx4lisbmPWxvTXr5WiWKbPe+xRbX5DUN/016ABqVPXDuqcUDUkeIBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ceQIoNPK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ceQIoNPK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3966BC61053;
	Tue, 27 Aug 2024 14:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769821;
	bh=kWHiiYXo0sH6YRjKZQgykXd6VFLMCSeH5Hkqyiuyiy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ceQIoNPKzJkMqhtwqE3+Cr0CaalMZsPhV+oCKS9jVLeFBr0lMW6DzUbVysCZ5npcR
	 9gWskL8S4VVuV9YivwDrNxa0n9ZWVqnRhIgS2TzbCgckBJkrbxToDS1CysLe3cJ+8i
	 yri5LQMCkdOgTfVDJR/tlnx43iIyXB27jmN1FnlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 6.6 044/341] memcg_write_event_control(): fix a user-triggerable oops
Date: Tue, 27 Aug 2024 16:34:35 +0200
Message-ID: <20240827143845.092755461@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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
@@ -4880,9 +4880,12 @@ static ssize_t memcg_write_event_control
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


