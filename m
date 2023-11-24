Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567EE39FF3;
	Fri, 24 Nov 2023 18:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZERGSYRX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5384C433C7;
	Fri, 24 Nov 2023 18:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849647;
	bh=QUl4LDCz9UF2GvZIZWwcGW/vKs0TPeOLaa3bIYJBt4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZERGSYRX5cGZunijnDx3fvYMRMP5RHddypvJObKKL78llLRn4p0cpV2DE+t/dObr/
	 K7d2AkxsfQ/muOHz894Q82r7DNsr98MzlBdRnZ88PoKCceVFa4XczGp5gXCH0fkvpq
	 hmvF4th+pUWSZv2TQW85GQRXxsSAPjRXPEbCHHEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Savkov <asavkov@redhat.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.6 264/530] audit: dont WARN_ON_ONCE(!current->mm) in audit_exe_compare()
Date: Fri, 24 Nov 2023 17:47:10 +0000
Message-ID: <20231124172036.072152965@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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


