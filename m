Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE32762D2;
	Thu, 15 Aug 2024 14:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730755; cv=none; b=VLOPV5U9MJMrnvlvPW/pG981fkVVjLB+Zb1mmJl81qkpisZ3rUJ1F3fnuIY7zcXIjvyidu/70MVmB/lP8tQYGeJ2wWKwjceaaQ58H6MBkvdWVZREDOvUSwCEwfOmOwYtylY5jqDQn7A257dRAfps+2NaMeYrd4VXi5Oy+3CHIyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730755; c=relaxed/simple;
	bh=SlcaWm6mVHXofjUM5Mwcz4Eqcjbt/z7sAtzHEy7zDoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BPvVtGuWJ7qFxT/RZfqXvbKyuTta48oEkhxW7NtjVfZQokr3uptGFHdGPEgtH9/C4JLvoT2XYkwUMMwXIBVbvDN8d/f33WgDDfNnz6ApvPFnBxk+HPNOcvKJcFJsA8ghAiR+ZBxLZEn5W2K6cr8YPM3cDbZXfzq4Qy6X8ETlu0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BOhQImHq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BOhQImHq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A1F0C32786;
	Thu, 15 Aug 2024 14:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730755;
	bh=SlcaWm6mVHXofjUM5Mwcz4Eqcjbt/z7sAtzHEy7zDoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BOhQImHq6WG36kSyrZGMEVUsAcKnbb8wyMliFr3pDxVBE5ue/bTl9KVC8wfErDX31
	 DzQ13v90t9vh0tBgmAv7I7RWiersFAbX/PkX2WPwQhVLtTMq86NjqpFgvDq1yUnkil
	 JqR7fXIH0rnbwE2k/SrN7z//nG/1jC/y6tVAlToQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 22/38] sunrpc: use the struct net as the svc proc private
Date: Thu, 15 Aug 2024 15:25:56 +0200
Message-ID: <20240815131833.807902638@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131832.944273699@linuxfoundation.org>
References: <20240815131832.944273699@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 418b9687dece5bd763c09b5c27a801a7e3387be9 ]

nfsd is the only thing using this helper, and it doesn't use the private
currently.  When we switch to per-network namespace stats we will need
the struct net * in order to get to the nfsd_net.  Use the net as the
proc private so we can utilize this when we make the switch over.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/stats.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sunrpc/stats.c
+++ b/net/sunrpc/stats.c
@@ -309,7 +309,7 @@ EXPORT_SYMBOL_GPL(rpc_proc_unregister);
 struct proc_dir_entry *
 svc_proc_register(struct net *net, struct svc_stat *statp, const struct proc_ops *proc_ops)
 {
-	return do_register(net, statp->program->pg_name, statp, proc_ops);
+	return do_register(net, statp->program->pg_name, net, proc_ops);
 }
 EXPORT_SYMBOL_GPL(svc_proc_register);
 


