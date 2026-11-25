Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620356;
	b=3BN9ajlro6LcJay09pdz1ZX0Lclmpv+aBbvqDiPd08TWgTX1h+ntwh9s88z9HbsM3BPh
	 MjomJHAuqAbgP5GHOroFRNewMFfEPlcKqb/l0URIAWGiMfXRYLpomCHENOwFogEp3eiEi
	 RFs/9t3Kkb91RkQ7ZO1JSFXIofXs08ew8EWXZBgkVkQDm9oXaeKQoH/XuBUIifwNa+npC
	 cvGcJAS3dRQRb+t2QnPiZ8kkg/FlWDsF3oH+36NNZx6z6GgBk20PPLe2IUNvvSh2paKVb
	 9y2e0u9VstFXWhV6BkAXtI6BAWUapFAPtp3FpUmXPLWYNRGvRCaAWpLPlwpVy49G5kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620356;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cZ4diMr79wnsfWrChN2dQl/j43tEY6uXIvCfLVj3iiI=;
	b=KpC1tLv3H1P++sHesxwdnOOIMpTyksWqHwoJldUoZXTVFKgLUHBPF+03YcBCGLgcwBxN
	 7h7Y56xI1mFb0Z/aiF5HzM5hVG9UuotIXsN58MroXkQhQ27Z7XN52d9sjfNGEfWGrLOGE
	 5yX11YJmD4Z3/tKOTC/HFDD5byBt96ExK2yLvqShBu/0OcH8TPA8fNSuuPdvvin//fyMN
	 sqJfmIs9gx8i9+iZzATQXHiWzl821JOEh4RfynJlLu5Ue2Y6LKD3PLkCa7yt9/okAzmpp
	 cg3AKfUp0e92l/wxivnqCuIK2Zpnvptdh6NxCnuIjMNyLLcMJAv91AqPXOXssbbR7qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i9G2BNz6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68D1606A321;
	Wed, 25 Nov 2026 15:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i9G2BNz6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC16F1F000C0;
	Wed, 25 Nov 2026 15:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620356;
	bh=cZ4diMr79wnsfWrChN2dQl/j43tEY6uXIvCfLVj3iiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i9G2BNz6hJc/rn8ueNO3P5jDtJaRlcUTNn37b46lur5BCLizwbAKqOoGQ8DmvgnEk
	 NLaKCsO+pXqBPlDE1xMcVtRBgwCfM28aH/fWaLFEj5Hf+VAfyG+C1fW4MoqKWHZMpx
	 PPdSOFMZolVcLL+Y7PiYZD0gh916uQQqiy7gYpQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.3 0845/1005] smb: client: retry writes that couldnt be issued due to a reconnect
Date: Wed, 25 Nov 2026 15:36:23 +0100
Message-ID: <20261125143841.508586031@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

commit 64db0dc1f3e689145e698bc1b20ee70b1724b945 upstream.

__cifs_issue_write() fails a subrequest with -EAGAIN when its handle got
invalidated or its credits belong to a session from before a reconnect,
both before sending anything.  netfs used to retry any -EAGAIN by itself,
but now only retries subrequests marked for it, so these writes fail and
their folios end writeback clean, losing the data.

Mark them for retry instead.  The retry gets the handle reopened and
fresh credits in cifs_prepare_write().

Fixes: 82e8885bd763 ("netfs: when subreq is marked for retry, do not check if it faced an error")
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/file.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -187,10 +187,12 @@ out:
 	return;
 
 fail:
-	if (rc == -EAGAIN)
+	if (rc == -EAGAIN) {
 		trace_netfs_sreq(subreq, netfs_sreq_trace_retry);
-	else
+		__set_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags);
+	} else {
 		trace_netfs_sreq(subreq, netfs_sreq_trace_fail);
+	}
 	add_credits_and_wake_if(wdata->server, &wdata->credits, 0);
 	cifs_write_subrequest_terminated(wdata, rc);
 	goto out;


