Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A0C34CF6
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:20:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53B1DC433EF;
	Wed,  7 Jun 2023 20:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169200;
	bh=R0DELvf/YMrD0zJkos1kwz8fEahoXM96yNAJdbs+Qls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ep2Gz8R4GP0sryhFtmE0T6WMhDwEikLXruY3VrzU02XBvInmBTNk6+Si+LRjZAnPB
	 Oh0fH7niDNo/v3wo2dpbNiD+/CMVjZyNlOyzbJkIGGn0YKbmdW+3JVbH7NNJiNwlLK
	 v27eckq2xNytEeFlC81BOUg8vo/0fT5nPYBTYpdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erwan Velu <e.velu@criteo.com>,
	Luiz Capitulino <luizcap@amazon.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 4.14 52/61] selinux: dont use makes grouped targets feature yet
Date: Wed,  7 Jun 2023 22:16:06 +0200
Message-ID: <20230607200853.130655586@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200835.310274198@linuxfoundation.org>
References: <20230607200835.310274198@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paul Moore <paul@paul-moore.com>

commit 42c4e97e06a839b07d834f640a10911ad84ec8b3 upstream.

The Linux Kernel currently only requires make v3.82 while the grouped
target functionality requires make v4.3.  Removed the grouped target
introduced in 4ce1f694eb5d ("selinux: ensure av_permissions.h is
built when needed") as well as the multiple header file targets in
the make rule.  This effectively reverts the problem commit.

We will revisit this change when make >= 4.3 is required by the rest
of the kernel.

Cc: stable@vger.kernel.org
Fixes: 4ce1f694eb5d ("selinux: ensure av_permissions.h is built when needed")
Reported-by: Erwan Velu <e.velu@criteo.com>
Reported-by: Luiz Capitulino <luizcap@amazon.com>
Tested-by: Luiz Capitulino <luizcap@amazon.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/Makefile |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/security/selinux/Makefile
+++ b/security/selinux/Makefile
@@ -22,5 +22,9 @@ quiet_cmd_flask = GEN     $(obj)/flask.h
       cmd_flask = $< $(obj)/flask.h $(obj)/av_permissions.h
 
 targets += flask.h av_permissions.h
-$(obj)/flask.h $(obj)/av_permissions.h &: scripts/selinux/genheaders/genheaders FORCE
+# once make >= 4.3 is required, we can use grouped targets in the rule below,
+# which basically involves adding both headers and a '&' before the colon, see
+# the example below:
+#   $(obj)/flask.h $(obj)/av_permissions.h &: scripts/selinux/...
+$(obj)/flask.h: scripts/selinux/genheaders/genheaders FORCE
 	$(call if_changed,flask)


