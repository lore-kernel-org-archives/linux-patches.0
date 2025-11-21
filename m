Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7336834C983;
	Fri, 21 Nov 2025 13:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732114; cv=none; b=BeC+KnsuL2LBgdZmcLlNxEj/hAsbcL0XJjjqHTMe1hUs+Dc+pF047HAxj5rKpfMP1x+R8f72puAEGzThfbN2txwhzZjdaP1VVLW4zHSqKQhv/X6nAo/LFQE8Y49uXIrczSQXbBvntDxEJUcwGzANtaCnF+hJDuVYEvB8t5/xrRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732114; c=relaxed/simple;
	bh=KJ1VKxAuGB13jg6QebVb6bl1tr5l+rBS/TDnYTG7NqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jnUXJqOJr1/0B0A3oty+sFSlTFHSPXd/nEa/e/51dHsWfSiV66KHaAQY6vQUnhsbzoVs6us0qZq+Vj1OpAiUc7RFPp9a1AGZKbF91hxTdjFSpLMY8PfL+rtFI18gxl0O8RwC4FwmePKPuuJmoWN0duUV1ICHY1WlsUXqTtV3hEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AKvudplF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AKvudplF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE749C4CEF1;
	Fri, 21 Nov 2025 13:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732114;
	bh=KJ1VKxAuGB13jg6QebVb6bl1tr5l+rBS/TDnYTG7NqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AKvudplFFX/aE8cLuCYJLaooUEaNjywXNxnQcr0lxqJu7mQnjtf2QvktEnZinAzVC
	 bHNN4XfwjiXHoWt/Zd4MjQvhmsWrD8LH42ihrX7A+zkl8nuYtXOd/v1FKXX88aZtMW
	 UFLOtzDfHqggnxjAIfhFy/KvNJXh8h4EfHDZ0rtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 001/529] NFSD: Fix crash in nfsd4_read_release()
Date: Fri, 21 Nov 2025 14:05:00 +0100
Message-ID: <20251121130231.045324780@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Chuck Lever <chuck.lever@oracle.com>

commit abb1f08a2121dd270193746e43b2a9373db9ad84 upstream.

When tracing is enabled, the trace_nfsd_read_done trace point
crashes during the pynfs read.testNoFh test.

Fixes: 15a8b55dbb1b ("nfsd: call op_release, even when op_func returns an error")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -978,10 +978,11 @@ nfsd4_read(struct svc_rqst *rqstp, struc
 static void
 nfsd4_read_release(union nfsd4_op_u *u)
 {
-	if (u->read.rd_nf)
+	if (u->read.rd_nf) {
+		trace_nfsd_read_done(u->read.rd_rqstp, u->read.rd_fhp,
+				     u->read.rd_offset, u->read.rd_length);
 		nfsd_file_put(u->read.rd_nf);
-	trace_nfsd_read_done(u->read.rd_rqstp, u->read.rd_fhp,
-			     u->read.rd_offset, u->read.rd_length);
+	}
 }
 
 static __be32


