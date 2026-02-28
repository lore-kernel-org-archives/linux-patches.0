Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42AD347FCC;
	Sat, 28 Feb 2026 18:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302438; cv=none; b=KTDx4EeU36AcHAQPN2triXbT5YBZ0z8LJLyiz5BD3bgYsL0XWZCeJOyaM8jGzAv5XleOVE4c0+CdOkmgXIKMRB92EtdxeKNmZV8Qyn1tMk91tO6jzJKTZEG44qGo4zxBfD3h0pDyRimpyJtYnLYv0FR9jni7r6ICqHvYpJsmvtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302438; c=relaxed/simple;
	bh=Z6L9Lz9s1n90ASYbuykRsrtcy9VRJg3MdNLm71XjeQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BCoqA9XBZAqeW9JcZdoc3pWCRH8R9axnSnadfPw7Mwh4UQPMeTMzIjT2arG09GD99pdLgH56N3wiT/by9z8d3Uh7XybaqhnmUzBhPSHTnZ/k0Hx/eY/Cfj3I+6gou1n3ZMphtYv8U+6ZulbZ+KxDXCz2js+VKi2apse0NubuaEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KE/0oDgt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KE/0oDgt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E5C6C2BC87;
	Sat, 28 Feb 2026 18:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302438;
	bh=Z6L9Lz9s1n90ASYbuykRsrtcy9VRJg3MdNLm71XjeQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KE/0oDgt0SGHk+O1N4+k0LxjNEj4GlgSXz6zMQmyFkL79W6z5HBD0HaipAnsha0se
	 /cYUj9J23r1J65W6jx3jJP2hRHmc9aghjqBxzGd6dvsp2pvnTIitK2HK6wNtaJih2H
	 DykRK+XmWwkh8RKTieC2jH6s3sZlbuSf63jmrYBV1hKyTGb3yIO01tL9heJDmOJhy7
	 K18WUrUcrCduspe9pwC4hZGxiqrvVLQalcVmK1wcMvSQcxPkhPm30MwjLjB0kmT9i/
	 GyUHc0OuOUVuT5pVZ67HGdS35PsGUbqar8toAVTsvkFdr/CpeEop8GGQVR6n64OENY
	 P1VvcWEXIKv2Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Daniel Hodges <git@danielhodges.dev>,
	stable@vger.kernel.org,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.1 176/232] SUNRPC: fix gss_auth kref leak in gss_alloc_msg error path
Date: Sat, 28 Feb 2026 13:10:29 -0500
Message-ID: <20260228181127.1592657-176-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Daniel Hodges <git@danielhodges.dev>

commit dd2fdc3504592d85e549c523b054898a036a6afe upstream.

Commit 5940d1cf9f42 ("SUNRPC: Rebalance a kref in auth_gss.c") added
a kref_get(&gss_auth->kref) call to balance the gss_put_auth() done
in gss_release_msg(), but forgot to add a corresponding kref_put()
on the error path when kstrdup_const() fails.

If service_name is non-NULL and kstrdup_const() fails, the function
jumps to err_put_pipe_version which calls put_pipe_version() and
kfree(gss_msg), but never releases the gss_auth reference. This leads
to a kref leak where the gss_auth structure is never freed.

Add a forward declaration for gss_free_callback() and call kref_put()
in the err_put_pipe_version error path to properly release the
reference taken earlier.

Fixes: 5940d1cf9f42 ("SUNRPC: Rebalance a kref in auth_gss.c")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Hodges <git@danielhodges.dev>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/auth_gss/auth_gss.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
index 3ef511d7af190..85e6f6b3c6d8e 100644
--- a/net/sunrpc/auth_gss/auth_gss.c
+++ b/net/sunrpc/auth_gss/auth_gss.c
@@ -39,6 +39,8 @@ static const struct rpc_authops authgss_ops;
 static const struct rpc_credops gss_credops;
 static const struct rpc_credops gss_nullops;
 
+static void gss_free_callback(struct kref *kref);
+
 #define GSS_RETRY_EXPIRED 5
 static unsigned int gss_expired_cred_retry_delay = GSS_RETRY_EXPIRED;
 
@@ -535,6 +537,7 @@ gss_alloc_msg(struct gss_auth *gss_auth,
 	}
 	return gss_msg;
 err_put_pipe_version:
+	kref_put(&gss_auth->kref, gss_free_callback);
 	put_pipe_version(gss_auth->net);
 err_free_msg:
 	kfree(gss_msg);
-- 
2.51.0

