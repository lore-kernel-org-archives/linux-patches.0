Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81DAE1DE4CC;
	Tue,  8 Oct 2024 12:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391027; cv=none; b=MR+khH3iN+UvKNCL5MtUB/mIba+8wVCFvQyBRq3EXyRjw3v1f8E9PgipXq+KUVql79SwvO07z4/DNnJESt47DdZ/masa1J+1eedCczJaJS1UyPSqaPBe1bBfthMuRqMkUBe7C3y2+zrFSYorxP1MS1NZPFpk8/KAk30qe7NGnso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391027; c=relaxed/simple;
	bh=zSNTHHcdYlCb550mMfaZiQSP/NfF8iSSd9XUtIHjYI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Se/wMSL2hAOs+97xz3Dv+nxHyhoomJXsarYtdUrNc+0Q+F/HnLsUgpbEnKAtKI5dEOBQtdFYAkC7WZKx3FheOMuzok5xQOx8SqmSTYoWUkPnj6gDTk8MQZzaUc1NT703fYOTGkn7ViACfdzaf6+HYa23L/xRABCbKE5ZaMnAbwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FSuHF/I6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FSuHF/I6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E07C3C4CEC7;
	Tue,  8 Oct 2024 12:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391027;
	bh=zSNTHHcdYlCb550mMfaZiQSP/NfF8iSSd9XUtIHjYI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FSuHF/I6IUWOlZCqEpXVY0WO77JjSEhW3kRaG/jEwk0nMw2/T4WrB4KArCUKJWb7H
	 9Q0sraC3egrGevPsGLlTGQhOEBrnP5igmAS17ZGNbPjNdKZ+YzV/39Ung9UcCxqCD6
	 fM6VealTWFdv50qmNLQlCbtI6XMEVtovFu6N5j/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrick Donnelly <pdonnell@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.10 427/482] ceph: fix cap ref leak via netfs init_request
Date: Tue,  8 Oct 2024 14:08:10 +0200
Message-ID: <20241008115705.328004722@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

From: Patrick Donnelly <pdonnell@redhat.com>

commit ccda9910d8490f4fb067131598e4b2e986faa5a0 upstream.

Log recovered from a user's cluster:

    <7>[ 5413.970692] ceph:  get_cap_refs 00000000958c114b ret 1 got Fr
    <7>[ 5413.970695] ceph:  start_read 00000000958c114b, no cache cap
    ...
    <7>[ 5473.934609] ceph:   my wanted = Fr, used = Fr, dirty -
    <7>[ 5473.934616] ceph:  revocation: pAsLsXsFr -> pAsLsXs (revoking Fr)
    <7>[ 5473.934632] ceph:  __ceph_caps_issued 00000000958c114b cap 00000000f7784259 issued pAsLsXs
    <7>[ 5473.934638] ceph:  check_caps 10000000e68.fffffffffffffffe file_want - used Fr dirty - flushing - issued pAsLsXs revoking Fr retain pAsLsXsFsr  AUTHONLY NOINVAL FLUSH_FORCE

The MDS subsequently complains that the kernel client is late releasing
caps.

Approximately, a series of changes to this code by commits 49870056005c
("ceph: convert ceph_readpages to ceph_readahead"), 2de160417315
("netfs: Change ->init_request() to return an error code") and
a5c9dc445139 ("ceph: Make ceph_init_request() check caps on readahead")
resulted in subtle resource cleanup to be missed. The main culprit is
the change in error handling in 2de160417315 which meant that a failure
in init_request() would no longer cause cleanup to be called. That
would prevent the ceph_put_cap_refs() call which would cleanup the
leaked cap ref.

Cc: stable@vger.kernel.org
Fixes: a5c9dc445139 ("ceph: Make ceph_init_request() check caps on readahead")
Link: https://tracker.ceph.com/issues/67008
Signed-off-by: Patrick Donnelly <pdonnell@redhat.com>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/addr.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -468,8 +468,11 @@ static int ceph_init_request(struct netf
 	rreq->netfs_priv = priv;
 
 out:
-	if (ret < 0)
+	if (ret < 0) {
+		if (got)
+			ceph_put_cap_refs(ceph_inode(inode), got);
 		kfree(priv);
+	}
 
 	return ret;
 }


