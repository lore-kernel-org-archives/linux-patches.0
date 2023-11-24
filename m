Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E5DD33076;
	Fri, 24 Nov 2023 19:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sfel7Iaa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59F8C433C8;
	Fri, 24 Nov 2023 19:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852729;
	bh=/UafLnObksuycwX7oGbJnoQJVfy4m2ex4AtyWpNmXmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sfel7IaatI4NqKG8drrUp855y68ErQDvKrf3axXB4xi4aMlv9bH7h8VmS5S2YneFP
	 rvR5yOtL90GXgZZXxL3qkrr9eESAv591G8sGRzF07lwNXIBWZRWYZkIG4KxR8KjxnJ
	 L0VV87qImI0eCaeHtmcb5HkZbJcEkhWmb5KF8x7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Savkov <asavkov@redhat.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.10 100/193] audit: dont WARN_ON_ONCE(!current->mm) in audit_exe_compare()
Date: Fri, 24 Nov 2023 17:53:47 +0000
Message-ID: <20231124171951.259331142@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171947.127438872@linuxfoundation.org>
References: <20231124171947.127438872@linuxfoundation.org>
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

From: Paul Moore <paul@paul-moore.com>

commit 969d90ec212bae4b45bf9d21d7daa30aa6cf055e upstream.

eBPF can end up calling into the audit code from some odd places, and
some of these places don't have @current set properly so we end up
tripping the `WARN_ON_ONCE(!current->mm)` near the top of
`audit_exe_compare()`.  While the basic `!current->mm` check is good,
the `WARN_ON_ONCE()` results in some scary console messages so let's
drop that and just do the regular `!current->mm` check to avoid
problems.

Cc: <stable@vger.kernel.org>
Fixes: 47846d51348d ("audit: don't take task_lock() in audit_exe_compare() code path")
Reported-by: Artem Savkov <asavkov@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/audit_watch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/audit_watch.c
+++ b/kernel/audit_watch.c
@@ -531,7 +531,7 @@ int audit_exe_compare(struct task_struct
 	if (tsk != current)
 		return 0;
 
-	if (WARN_ON_ONCE(!current->mm))
+	if (!current->mm)
 		return 0;
 	exe_file = get_mm_exe_file(current->mm);
 	if (!exe_file)


