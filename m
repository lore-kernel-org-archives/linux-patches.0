Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144453BFE38;
	Thu, 15 Jan 2026 17:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497181; cv=none; b=Kwbd2FEu1LRwnYyTDMXb6lyVoUi0oBX0tqfjZvlEJPkfhYwHBsmQuakE+SqZe/Dpbtcf4nFIlhNXzEj5Ae91tBBP1bITl3RvQfd506Rx3X+1MSnwqumAG8QMS/hw3iygLbeb1UyrMcNMcM1B9mDtib0IbRXFBaqITVB3AqIBsKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497181; c=relaxed/simple;
	bh=Z2S0DtX2TSudQaZyMuruH7AlIWVULBulGmjfyQjf6aA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hIpL6TLeUttHLJTm2odybedwIe/DVTu4qCyyVtIY5a62D7wLJMrnGWoga3LtG/glMCAAnhDW6M3ctXkFp8FUvW8/VXkizKIiFpNMZshVPVYJWHuvNidqVQpxVYvPjreHo0JJuBYwhURgluIgDqLwZ4MY7YrZCG2iAQi5D6nYTCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hBuWPOkc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hBuWPOkc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C51C16AAE;
	Thu, 15 Jan 2026 17:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497181;
	bh=Z2S0DtX2TSudQaZyMuruH7AlIWVULBulGmjfyQjf6aA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hBuWPOkc+dUkDbs8EMa5dcb8bXiI8GPb5HgUNsRSoiqYKsZ9QFA1YGAdksxwGXRF/
	 nJ/IxUNb2A4k4LOL+aaGovUpfd37dqMq5Z0MBqYwNFQwU3v8QSbGJHZ4eDx+Ypz1S9
	 2XOAL3wwbT9+mmayw69UaH367JnKBKoOt8aRy5Mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+881d65229ca4f9ae8c84@syzkaller.appspotmail.com,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 65/72] bpf: Fix reference count leak in bpf_prog_test_run_xdp()
Date: Thu, 15 Jan 2026 17:49:15 +0100
Message-ID: <20260115164145.860790979@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>
References: <20260115164143.482647486@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit ec69daabe45256f98ac86c651b8ad1b2574489a7 ]

syzbot is reporting

  unregister_netdevice: waiting for sit0 to become free. Usage count = 2

problem. A debug printk() patch found that a refcount is obtained at
xdp_convert_md_to_buff() from bpf_prog_test_run_xdp().

According to commit ec94670fcb3b ("bpf: Support specifying ingress via
xdp_md context in BPF_PROG_TEST_RUN"), the refcount obtained by
xdp_convert_md_to_buff() will be released by xdp_convert_buff_to_md().

Therefore, we can consider that the error handling path introduced by
commit 1c1949982524 ("bpf: introduce frags support to
bpf_prog_test_run_xdp()") forgot to call xdp_convert_buff_to_md().

Reported-by: syzbot+881d65229ca4f9ae8c84@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=881d65229ca4f9ae8c84
Fixes: 1c1949982524 ("bpf: introduce frags support to bpf_prog_test_run_xdp()")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://lore.kernel.org/r/af090e53-9d9b-4412-8acb-957733b3975c@I-love.SAKURA.ne.jp
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bpf/test_run.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 88fdcfb2fdd30..59edba6994c34 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -1373,13 +1373,13 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 
 			if (sinfo->nr_frags == MAX_SKB_FRAGS) {
 				ret = -ENOMEM;
-				goto out;
+				goto out_put_dev;
 			}
 
 			page = alloc_page(GFP_KERNEL);
 			if (!page) {
 				ret = -ENOMEM;
-				goto out;
+				goto out_put_dev;
 			}
 
 			frag = &sinfo->frags[sinfo->nr_frags++];
@@ -1392,7 +1392,7 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 			if (copy_from_user(page_address(page), data_in + size,
 					   data_len)) {
 				ret = -EFAULT;
-				goto out;
+				goto out_put_dev;
 			}
 			sinfo->xdp_frags_size += data_len;
 			size += data_len;
@@ -1407,6 +1407,7 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 		ret = bpf_test_run_xdp_live(prog, &xdp, repeat, batch_size, &duration);
 	else
 		ret = bpf_test_run(prog, &xdp, repeat, &retval, &duration, true);
+out_put_dev:
 	/* We convert the xdp_buff back to an xdp_md before checking the return
 	 * code so the reference count of any held netdevice will be decremented
 	 * even if the test run failed.
-- 
2.51.0



