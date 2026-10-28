Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210153;
	b=VTWGTUj8E26bgvsID7LLNCXJxu7gIKbZm1zIEBlTmwkIBbP6hfJ/+aJj3O8ihS7NPOec
	 wlGCE/MutUgNyxYTrOFiZb/MiGAD8rkwbkCr3td5JmQF5ncy6hrxnCw1cLfwCqlMcGCjn
	 SK/GBLdxg+Vy/+9Cdv1EN6zxZ7+yJrl/4k6NkkaBkgvf/9A45c6tHXvFQnmTBYLOOzIrG
	 rbITMzRSYKLqmM/XAi2q6sv6CVioKSBsuYy0NGI2YTcRqPbELxPLR7C7x3Ve2ZKN0kQsB
	 zVtnQr7+kOVcS8nUfI7bvZDiOpGxu1Af1APR5GEc4ym7IdfEpaCDqERoeqwbJ0QLW6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210153;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kMmhsDfJrpViHw9jBwEBCMIA2KSWANALf73F3shFMxg=;
	b=uSZRYyludGW5CN8vLogVvg3doQ1W/v0t9eNlrqvYaNcP/7jKOdq9OpAHAUOsq1TGPLlz
	 oikZqQkquTL2GZ1NxlxGAtms9DwTydsQN5t/xkrx1Fut37GcOct9gLSRfzuHMxwMr8GkT
	 n8G7Gx0q8miIuYLo8Mf1F8nJXI97b6dB0ERATjXYcX+7q58d5MwWqGCby97ItRt4cLVmf
	 mFtcOmeMCNN4WJ8I4/g8czgoYXSnK5hbDHw1b0lTjCjSsxNS2Mgfz6gDUlAn5ch2iHAjZ
	 gua0e7V+EssAlVVtMEAUaigepnMK+SYyqkHAAz4F9cIqkr8Pwhzi0aOUAwYYxOmGB2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TJzjcfCq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6F760A260A;
	Wed, 28 Oct 2026 17:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TJzjcfCq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02FB1F01829;
	Wed, 28 Oct 2026 17:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210153;
	bh=kMmhsDfJrpViHw9jBwEBCMIA2KSWANALf73F3shFMxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TJzjcfCq9P7rhQ6QNG+wC+ESq9XgB30HOOXte+QaceRmYAOP8v3yveARaburGY+G2
	 puLtnmhevGz7gvjXO24zjN2eh75lDW125vKFJQt4pNjOJWuhVZPvjsaKtz/9VfAqXV
	 FWdgaAV9YonU1j7ibvxM/XFsF/8CrnKbJib5iQ8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 093/168] eventfs: fix SRCU read lock leak in eventfs_iterate()
Date: Wed, 28 Oct 2026 18:00:29 +0100
Message-ID: <20261028165945.290691264@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Qi <joseph.qi@linux.alibaba.com>

Commit 25d27d5fa864 ("eventfs: Use children field for rcu head and add
memory barriers") added an early bail out to the ei->children loop:

	smp_rmb();
	if (ei->is_freed)
		return -EINVAL;

Upstream wraps eventfs_iterate() in guard(srcu)(&eventfs_srcu), so that
return still drops the read lock. The 6.6.y backport instead brackets the
function with srcu_read_lock() and a shared "out" label that calls
srcu_read_unlock(), so this path returns while still holding eventfs_srcu
for reading.

The unbalanced reader prevents the grace period from ever completing, so
the call_srcu() callback queued by free_ei() never runs and the
eventfs_inode is leaked. Every readdir that races with removal adds
another reader.

Set ret and jump to "out" like the other bail out paths in this function
do.

Fixes: 25d27d5fa864 ("eventfs: Use children field for rcu head and add memory barriers")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/tracefs/event_inode.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/tracefs/event_inode.c b/fs/tracefs/event_inode.c
index 880a4d667472b..ca55828e7446d 100644
--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -748,8 +748,10 @@ static int eventfs_iterate(struct file *file, struct dir_context *ctx)
 		 * Matches the smp_wmb() in free_ei()
 		 */
 		smp_rmb();
-		if (ei->is_freed)
-			return -EINVAL;
+		if (ei->is_freed) {
+			ret = -EINVAL;
+			goto out;
+		}
 
 		if (c > 0) {
 			c--;
-- 
2.53.0



