Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E2C46AA6F;
	Tue, 21 Jul 2026 17:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656061; cv=none; b=pUbAPe1IwekVeCE8Bho3cjFvQq2jrOxmRu9Ii2RsPhvK7KGTwXXahnxIZ4mlYY1sgZRWvfCMLlD15JkhfdH2YPbNS4pGd2cyXLpJenF1SLpuD8gisXsdwUzGXsBZflWUwApboZDEA9ix6KAWdfj1KkUHLAPYRfTDvsJJDO09sgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656061; c=relaxed/simple;
	bh=/MwCyEwyFLFZdpu2EWp0dOKBor6aplCofc6M8UWI0ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LlGBg+F9UTWszqjg/+lKHYChl8tBOUMLVfWfqtQp1mR69pVfr3K23TRrProdsLzssM0b19xE6GR88LQLR6mFonLg5xABubNgYhcb0HvOXAgMctdNfZ+OY3zgaZBklhRSyThJ0z3R8AjwPcZaJluH4YWFylRroGZrqxqBFOe7T8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wdrVuFOb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wdrVuFOb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 514F91F000E9;
	Tue, 21 Jul 2026 17:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656059;
	bh=2DAUmbS6+1SMm1TBBz2HOWbJiqBs/GF2eUC46wblyVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wdrVuFObiuRjfs1a1VeXi6U/HVOiYC82kGrVtYLpHCT0QXZlyioxWr+zSEIa41bUO
	 /+RfBDM/ttw83rX06oOjKW7jD238Fwx4q0z9G9AnQ1AmwB+bDv0WnCydXH08SyTxGw
	 dsqQqZq45coKSnhZ0B1Fv1akiRS/LNx1cDJOPKC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Glozar <tglozar@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0245/1611] rtla/actions: Restore continue flag in actions_perform()
Date: Tue, 21 Jul 2026 17:06:01 +0200
Message-ID: <20260721152520.532836911@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Glozar <tglozar@redhat.com>

[ Upstream commit dd520daffbc901f10d49a51a58313547d417b506 ]

Currently, actions_perform() only ever sets the continue flag (when
performing the continue action), but never resets it. That leads to
RTLA continuing tracing even if the continue action was not performed in
the current iteration.

For example, the following command:

$ rtla timerlat hist -T 100 --on-threshold shell,command='
    echo Spike!
    if [ -f /tmp/a ]
    then
      exit 1
    else
      touch /tmp/a
    fi' --on-threshold continue

should print Spike! at most once, because after hitting the threshold
for the first time, /tmp/a exists, the shell action will fail, and the
continue action is not performed. However, unless /tmp/a exists before
the measurement, it will print Spike! until stopped, as the continue
flag stays set.

Set the continue flag to false in the beginning of actions_perform() to
make RTLA continue only if the action was actually performed.

Fixes: 8d933d5c89e8 ("rtla/timerlat: Add continue action")
Link: https://lore.kernel.org/r/20260526102523.2662391-1-tglozar@redhat.com
[ correct Fixes tag to include 12 characters of hash ]
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/src/actions.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/tracing/rtla/src/actions.c b/tools/tracing/rtla/src/actions.c
index 5f83ffc1008f83..084c41ebfe6d7e 100644
--- a/tools/tracing/rtla/src/actions.c
+++ b/tools/tracing/rtla/src/actions.c
@@ -228,6 +228,8 @@ actions_perform(struct actions *self)
 	int pid, retval;
 	const struct action *action;
 
+	self->continue_flag = false;
+
 	for_each_action(self, action) {
 		switch (action->type) {
 		case ACTION_TRACE_OUTPUT:
-- 
2.53.0



