Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967C280045;
	Mon,  8 Apr 2024 13:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582026; cv=none; b=rEego6PiJ1qW2wCDj2g+o/21Oq5gtOdtHQN1NBhkxTCoQfXktsS+nXqC1CrNd7P6axnZzeNfujRLcliDoC9EWqpaKUW3W7LcYkpkv/DEHBOFhkY+B707aNda/SjCsRX7fTuGM0qGR6bO0vSuEdnh7Q8eiQ/e29fsWQ95GQWPRJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582026; c=relaxed/simple;
	bh=k3zjyJixK9aPP//mcX1SL+d4UZoPhK8TYhtyez7Rj0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f8JzTTxsj7PDkVkyStRWiUwVtmq27BzWnxnWBrT6/uhRdLs6fGgfAHfEbDVKmUTrBdKwjWrKiyVOtSfqzx+IOdyInlFfrYiJR5rjjRb88CMxHi3DjL2NJdVUg+Wh2n9+4JBtox623Ya4VgN7HZNQh2X44+ujdmZMJhL2jfM8aIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XhK663Wi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XhK663Wi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FCFAC433F1;
	Mon,  8 Apr 2024 13:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582025;
	bh=k3zjyJixK9aPP//mcX1SL+d4UZoPhK8TYhtyez7Rj0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XhK663WiHBs40Ku9KB7ixBagkBDt/0xafnSUBW34UrxOX6cS/CSfwZXTo+Iel6hJI
	 +iNLBVvmqHzFNF1vvI80kkh9973A18TjsqZyLjfwjHrKVCnJQXHA2xi6QarsujI7Jl
	 j5fxtykxbj52Lrc4sbbZxzfivah1WgmY5uXVWdHI=
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
Subject: [PATCH 5.15 105/690] NFSD: Fix nfsd_clid_class use of __string_len() macro
Date: Mon,  8 Apr 2024 14:49:31 +0200
Message-ID: <20240408125403.305319478@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0fc1fa6f28e0b..7e7d0f1705ed3 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -606,7 +606,7 @@ DECLARE_EVENT_CLASS(nfsd_clid_class,
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



