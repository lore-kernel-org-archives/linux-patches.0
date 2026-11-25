Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623418;
	b=gNyNXi1E7i7fD/u5JrWdR6QB1W8uh6Af0apWsHbFJzCJpqIoAGsstgwZ5doJBS94i/8A
	 ZgLflP6orud2+wt4V++NbuD4fMwTimmw28bCaBFOpjAlpRzRmIjg1g1Tug+pix8QZmOg3
	 e+X+ek7B+K1QBwWBJdX7vyVagF8RztRkc0a4hL/ab3+od/uyb/yvVltL+YvvH94l17+uJ
	 KR0iDuUkCxw1ovuG3oylicnOsayqHm/N10wBamvpLD7jMSb/lcv20bYdhsYBS33NBBv57
	 EyDIB86Jcff/Uo3MifWzN3u5pNb67ZcULpTxSJA/VtrtsRWDoaCpTc2eqNzesXk1iFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623418;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2DzLDKSRN6o1ba/Xa2pBgRh3M6cWURHfZOZOcyz0nfU=;
	b=Q3m5APTs5UvmgOLHsb1HGqTdI7NjZs6MOcKBcZ5hwPT1InQ4dfLVPxOGuiXFo5tl5jUL
	 X+YwnOgvlQlMxCqFQ0ziKld0wEruLEFxWaOJl4/l6R9xfnDygZaOBUvz0ey3+roW69d1j
	 XVAegISqU3cDH3/wQzuddRbLFEMjKNHwCwYWCdLMog5Ab5+6/WSb1Dl4smjMEeinrC2n/
	 sKr46/N/rPOoJ4kehAi2vmEnbYvBsaM6GU+NXXt1HdEDXkMW46IUyLF4ctI+WrNfyR4TC
	 tcf9iKq5f4/DBkXlJ6Q6qEuNJAxgNCmZLI1CI6aVmgG9j6ppqznjbbQjW2rnSMmiAKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qi6fY3JL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F28606A31E;
	Wed, 25 Nov 2026 16:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qi6fY3JL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C92131F000C6;
	Wed, 25 Nov 2026 16:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623418;
	bh=2DzLDKSRN6o1ba/Xa2pBgRh3M6cWURHfZOZOcyz0nfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qi6fY3JL7i7GvhDqPuDZCd83syJz77TAham/rw8+c9caR5uJr3WXbc98+oLrqutLH
	 sf7H54UgM24+Z6lLymzHS/PaIDGZ6YdVxYK94O21oBBOpSlr7+ssPyqWD+elX9uVDL
	 M+n4MvxhSLnH5+0WItrvP/TfOz5AXrqVQ3i+GMww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5307e3bcacec2ce4c2f0@syzkaller.appspotmail.com,
	Kirtikumar Anandrao Ramchandani <kirtiar15502@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 853/990] dm: Reject table setup after queue or disk teardown
Date: Wed, 25 Nov 2026 15:37:00 +0100
Message-ID: <20261125143842.009007921@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kirtikumar Anandrao Ramchandani <kirtiar15502@gmail.com>

commit ae310e4ad872a42f4707a596e66417f2aaa52826 upstream.

A failed table load can leave a mapped device in a state where its
queue has already been initialized or its disk has been removed, while
md->type is still DM_TYPE_NONE. A later table load then calls
blk_mq_init_allocated_queue() on the same queue. If del_gendisk() exited
the old hardware contexts, blk_mq_exit_hctx() dereferences their cleared
flush queue pointer.

Reject setup attempts after queue initialization or disk removal. A
failed request queue initialization still leaves md->tag_set NULL and
can be retried. Set the request-based disk operations only after that
initialization succeeds, so an unsuccessful attempt cannot leave a
bio-based retry with request-based operations.

Reported-by: syzbot+5307e3bcacec2ce4c2f0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5307e3bcacec2ce4c2f0
Cc: stable@vger.kernel.org
Signed-off-by: Kirtikumar Anandrao Ramchandani <kirtiar15502@gmail.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2596,13 +2596,17 @@ int dm_setup_md_queue(struct mapped_devi
 
 	WARN_ON_ONCE(type == DM_TYPE_NONE);
 
+	/* A failed setup may have left the queue initialized or the disk dead. */
+	if (md->tag_set || test_bit(GD_DEAD, &md->disk->state))
+		return -ENODEV;
+
 	if (type == DM_TYPE_REQUEST_BASED) {
-		md->disk->fops = &dm_rq_blk_dops;
 		r = dm_mq_init_request_queue(md, t);
 		if (r) {
 			DMERR("Cannot initialize queue for request-based dm mapped device");
 			return r;
 		}
+		md->disk->fops = &dm_rq_blk_dops;
 	}
 
 	r = dm_calculate_queue_limits(t, &limits);


