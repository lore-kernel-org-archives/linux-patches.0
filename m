Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5FE3D961;
	Mon,  1 Apr 2024 16:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988468; cv=none; b=p6/qW8unT6mlBhT6XIGrENA17UM4vP7Vf8OZtqVqBQx5RcYmJB7StULDKlDdB+LexYQy8Vdeui69T5bfR8jxmX2ws6Nu0LCyTOpZ4xu03BFegdpqmtZLTkH7hYo7XIi8idLInvFc5ENGSjDDeq0cwrjJAon4FOx0p/2qBWzvGy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988468; c=relaxed/simple;
	bh=xq92jJWb8st25qJ1haVWZZSm61JrJk4n2qUDsu3MRZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j8JY3mFLqO5dDivw0fTzGJIAmNfnXmi4+BP0dcTRvhCjlYICfvXE/XEtRvH9TKUUvwmoyEXcZTDHFrzcbm85Oo6zYTDkFpMv235kxCMUpDNiXLOCAe2U2s9xHYn+0RT70lPOr5RBuMzd5MQog3+I0lJ8kf0VWkd0xACmavgBYWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ywOrotEw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ywOrotEw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18FE6C433C7;
	Mon,  1 Apr 2024 16:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988468;
	bh=xq92jJWb8st25qJ1haVWZZSm61JrJk4n2qUDsu3MRZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ywOrotEwDesyFIPEHFsU/mXWfQmo6ikOpiqbb4YG9G6DDyVxlDns6UovO1vDbehy2
	 jxHCI0ceaccwTAtWnZ/mQXVIxnFtK8c6kXOgmi/OFYvxNrgetVgmAQSMQKxWHs59El
	 s/pgeG6OSHh6HASdnBm98fy8nDZHs1nK4T/MkMq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Brown <neilb@suse.de>,
	Olga Kornievskaia <kolga@netapp.com>,
	Dai Ngo <Dai.Ngo@oracle.com>,
	Tom Talpey <tom@talpey.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 192/432] NFSD: Fix nfsd_clid_class use of __string_len() macro
Date: Mon,  1 Apr 2024 17:42:59 +0200
Message-ID: <20240401152558.864736045@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt (Google) <rostedt@goodmis.org>

[ Upstream commit 9388a2aa453321bcf1ad2603959debea9e6ab6d4 ]

I'm working on restructuring the __string* macros so that it doesn't need
to recalculate the string twice. That is, it will save it off when
processing __string() and the __assign_str() will not need to do the work
again as it currently does.

Currently __string_len(item, src, len) doesn't actually use "src", but my
changes will require src to be correct as that is where the __assign_str()
will get its value from.

The event class nfsd_clid_class has:

  __string_len(name, name, clp->cl_name.len)

But the second "name" does not exist and causes my changes to fail to
build. That second parameter should be: clp->cl_name.data.

Link: https://lore.kernel.org/linux-trace-kernel/20240222122828.3d8d213c@gandalf.local.home

Cc: Neil Brown <neilb@suse.de>
Cc: Olga Kornievskaia <kolga@netapp.com>
Cc: Dai Ngo <Dai.Ngo@oracle.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: stable@vger.kernel.org
Fixes: d27b74a8675ca ("NFSD: Use new __string_len C macros for nfsd_clid_class")
Acked-by: Chuck Lever <chuck.lever@oracle.com>
Acked-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/trace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index fbc0ccb404241..4c7a296c4189d 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -843,7 +843,7 @@ DECLARE_EVENT_CLASS(nfsd_clid_class,
 		__array(unsigned char, addr, sizeof(struct sockaddr_in6))
 		__field(unsigned long, flavor)
 		__array(unsigned char, verifier, NFS4_VERIFIER_SIZE)
-		__string_len(name, name, clp->cl_name.len)
+		__string_len(name, clp->cl_name.data, clp->cl_name.len)
 	),
 	TP_fast_assign(
 		__entry->cl_boot = clp->cl_clientid.cl_boot;
-- 
2.43.0



