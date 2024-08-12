Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978D316D9B8;
	Mon, 12 Aug 2024 16:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480548; cv=none; b=Hp9Qh0mEzm6/n+0JQ2SusszhnQy2XYk2kD6bNkOacd9jW0++MDc0HSgBSR0zTJ83fDFrmsyjczc8ZabGfhO1psWWB9dA/d4uvbFaCYo68EDCi/BCQgrF0loUVBNUU6U37kSjNlhWvMO75UYkvQ8GbRIQLCbU0tTIkWO53elps2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480548; c=relaxed/simple;
	bh=uqSfKuiew0QyPnakfkN2XHTkSnoqDuPo2vC+wHcoZLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJRkecQ/vekwYA05Asf4e/oMBbVXt84v/NUBFRp/gQ/Qn0c60farhKwpgawA7bJMPq+dkqOOI76PSrFy6aiMLlw+U3UsjBLN3SaGcbho29tCmgse2XKH6mRMZSNP5b/Ix5SH6J5zR/qlGyAewawLYNm2nlKGZa1f1d3U9xJOM+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZeQGR+cm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZeQGR+cm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11CA3C32782;
	Mon, 12 Aug 2024 16:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480548;
	bh=uqSfKuiew0QyPnakfkN2XHTkSnoqDuPo2vC+wHcoZLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZeQGR+cmxa/DwGVsplLDnpNP5JjFQlneNWPtEMtFWNUQPt3Uk5SsUD2W6z/TaDqMX
	 gY6L8sVjcUOZwFEwq/RBhGtzKXFh5t4IFJJIfmddWH7/qh2OJYa7bh0G2GZimXzZUo
	 I8x2aazhWfAjOuwrTCZBl5PQHXoltFfQ2Tx/HfDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Mathias Krause <minipli@grsecurity.net>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.10 230/263] eventfs: Dont return NULL in eventfs_create_dir()
Date: Mon, 12 Aug 2024 18:03:51 +0200
Message-ID: <20240812160155.340996872@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

From: Mathias Krause <minipli@grsecurity.net>

commit 12c20c65d0460cf34f9a665d8f0c0d77d45a3829 upstream.

Commit 77a06c33a22d ("eventfs: Test for ei->is_freed when accessing
ei->dentry") added another check, testing if the parent was freed after
we released the mutex. If so, the function returns NULL. However, all
callers expect it to either return a valid pointer or an error pointer,
at least since commit 5264a2f4bb3b ("tracing: Fix a NULL vs IS_ERR() bug
in event_subsystem_dir()"). Returning NULL will therefore fail the error
condition check in the caller.

Fix this by substituting the NULL return value with a fitting error
pointer.

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
Fixes: 77a06c33a22d ("eventfs: Test for ei->is_freed when accessing ei->dentry")
Link: https://lore.kernel.org/20240723122522.2724-1-minipli@grsecurity.net
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Ajay Kaher <ajay.kaher@broadcom.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -736,7 +736,7 @@ struct eventfs_inode *eventfs_create_dir
 	/* Was the parent freed? */
 	if (list_empty(&ei->list)) {
 		cleanup_ei(ei);
-		ei = NULL;
+		ei = ERR_PTR(-EBUSY);
 	}
 	return ei;
 }


