Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB20D47A64;
	Mon,  1 Apr 2024 17:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990988; cv=none; b=MroO8g+qH3592LvcFvWWyuYS+ERHL4tfgAaz/T8yc3San2SwLbs+EuLxfyvWLbKR17L91jvCQ4Zg+vqUxkkcITnxLUj7wweBlOet/D2JaJnRPjXBniIchxXYe9XqseZCvGqugXngQpuxDEIxsAF09W9Z5XD1plt+T+pPAQgm8dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990988; c=relaxed/simple;
	bh=N0AwHkp3QQut8MObPlgOI7vPn78xdbBkmWcCJwXcmBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eRfIKViW6dQpLX6y6Uark7JE7Rjk5dvfkmM50Pbc4NNGwoY1cq8iaTOabI0MG4/4zWcoR3D7kSGWA5f2quYu0UnOGaCD7ezKzvbdmiEUMAOq0+JMBa8QX9cYzhgbqDeY8p7IjidW+kcnFsX6AYhjtpj6aW1UFIVeXxTAQFFcQvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YIbw0Zn9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YIbw0Zn9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D88EAC433C7;
	Mon,  1 Apr 2024 17:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990988;
	bh=N0AwHkp3QQut8MObPlgOI7vPn78xdbBkmWcCJwXcmBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YIbw0Zn9WoEbW3fmhB/yDctqU7BFvtocNCQQ50+JAl+FWK3h/PfbzIeaOB3Jxo+QB
	 HRjBbdDVct0zs7Y3W9UP9vAeLraCJhqKfqM0pM92vwFETY2BHTDIL7kL/2BQVENdGU
	 ZLDlRzT3oboC2zcmK7LxvpbSeSMh5SWGX+UDErvU=
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
Subject: [PATCH 6.1 129/272] NFSD: Fix nfsd_clid_class use of __string_len() macro
Date: Mon,  1 Apr 2024 17:45:19 +0200
Message-ID: <20240401152534.707073228@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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
index 4183819ea0829..84f26f281fe9f 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -842,7 +842,7 @@ DECLARE_EVENT_CLASS(nfsd_clid_class,
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



