Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820D1383BA;
	Mon,  1 Apr 2024 15:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987129; cv=none; b=obXAlymE2ioAtuDud23hHHN798eAV9GHnno0GnQfkkhRCy3cS9yPayks6Vq3hMkhPrXJ1in1t5siGaxTvaAgce78J5Bk+H7WdWCbVee2YChQMlcOG0yARt6DD8HBkVjrUkuJ+KuYszYhRtQ1O6gQphVndT7lc0I8gBMr47SHv30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987129; c=relaxed/simple;
	bh=jD4Mo7SKQ5zAzBj+MAxzPQBx2ZbZC1ctqsM9Oo3zqg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lopDWPWfKn/gMUS7pebA8qwLbnEhxOYaanBrrLJI4Y12972NCis5SDv610fpJa5K4M9WmwPXT4uLb4KhagP3cpz60/AQI/8tJnZBGlGnb/sUgNPp5qYKSxMvWG++c7Kxt40g3R3KpnmX7RJ59iC5yMv3Uh1FheV9Y7xn9i8km6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JE0NIOBI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JE0NIOBI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 011E2C433C7;
	Mon,  1 Apr 2024 15:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987129;
	bh=jD4Mo7SKQ5zAzBj+MAxzPQBx2ZbZC1ctqsM9Oo3zqg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JE0NIOBI/m1PK7YK3qMVyEVGCzGCgdUewYRI4lrNl630Gk6wpa51CzYsRDEkKkKUm
	 1Vjubcv3oJSnbbVyc00+tEzIpxIhbFP/ZeQ14fu4SrtpSamXGlClkGYC/dN/Yi1rkL
	 8gjQvzGAIAL72pIdPRPM7SKPzfaoKB5Zh5OL5KOI=
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
Subject: [PATCH 6.8 192/399] NFSD: Fix nfsd_clid_class use of __string_len() macro
Date: Mon,  1 Apr 2024 17:42:38 +0200
Message-ID: <20240401152554.912954977@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index d1e8cf079b0f4..2cd57033791ff 100644
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



