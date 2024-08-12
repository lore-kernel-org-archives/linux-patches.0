Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2300183CA6;
	Mon, 12 Aug 2024 16:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479650; cv=none; b=tm0+oTRuPieppF5HRSOGQbuFVFsSTFT/exisi4kC9HRAz4QZ4yymRpdOD+JUYWvnRVQzXlLjdfNLbo3jWKM1NSOr/Sz55x2Qzyiy6d0dMusn3S5GyliKyYSE08w9FERiAaMeu+vnGz55w/KyOynntV/0azjwtrVjRoK24dlu5h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479650; c=relaxed/simple;
	bh=OfU9FIz0TlwR3T+7oPsStQAA0u5Z8/itsWbcjptYkwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r+n/OsVCZst6NrjC9r7DEseBB83vjSzYGhaHTYm1ymvUmDmfKDl+dkn6hAa5hekY218lfGjI+a4jq9G8deQVIyu8ynVUlXXreq4VEAZ9CgNmZDFUczYhqMnjSoaC/4qHmmqy1wC1rMi1fMlafyLxJIuv5aNrxfBmBglXxaRioaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dHJmKPfz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dHJmKPfz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56094C32782;
	Mon, 12 Aug 2024 16:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479650;
	bh=OfU9FIz0TlwR3T+7oPsStQAA0u5Z8/itsWbcjptYkwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dHJmKPfzfeGuvHlJdjaWv0lfTjikE7e3ecoEsecsGalakUPgF76xKMQo1jfGcuddv
	 2oqoMhag+O0MQyq1BH3KJeJS0UcrTFuab+gKtGbjMUb5WtD4y0mFdM2l1077nKAV7E
	 I5UgNMukqjdTDjj/FxFphPLuVpq2110KPCHYGSUI=
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
Subject: [PATCH 6.6 151/189] eventfs: Dont return NULL in eventfs_create_dir()
Date: Mon, 12 Aug 2024 18:03:27 +0200
Message-ID: <20240812160137.954616181@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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
@@ -806,7 +806,7 @@ struct eventfs_inode *eventfs_create_dir
 	/* Was the parent freed? */
 	if (list_empty(&ei->list)) {
 		cleanup_ei(ei);
-		ei = NULL;
+		ei = ERR_PTR(-EBUSY);
 	}
 	return ei;
 }


