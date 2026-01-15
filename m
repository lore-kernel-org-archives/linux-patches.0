Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3665B3BC4E8;
	Thu, 15 Jan 2026 17:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497001; cv=none; b=AhcXRCWBI7cdLMxRvc4V0gm7d8tH0TojtwIqrBxiblh1bzbWoaZRsNuWN+EiX45pfEI95s33z210SUx+ZRMgZ5qOim5/nNSj0ynbD/hQlzS7FcM2ieZHwiPtYT+ZGruWq96E2yg7cY3uAU/8PiVNi+4FkTalPyRxkHUgAJba73I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497001; c=relaxed/simple;
	bh=1isOONgbOKA3tSCIDlfYPiD/wlcA5Mc0cnuGhph+0Yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pjtmXSMUGGef+IlcW4JrB52SOi27jCqPg5/SMlX7Ipxn0Cf3NNdv2n6tKeh31ghiYBZZ8m42c7hanIoSSp/dYXR7CtE1XKmiG2rnV4d47qmpBiBGQ624Aprp+Retj4QoPerfe3p9sGPYDui4LCO0Mm2ctIYoKjBBOvdLOhIF8w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y858YchH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y858YchH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B60DC19423;
	Thu, 15 Jan 2026 17:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497000;
	bh=1isOONgbOKA3tSCIDlfYPiD/wlcA5Mc0cnuGhph+0Yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y858YchHWH27JY0z37eW+t2AOpkLjuyTAQtDFK1kCI5OXg9dLlu4KIBe/4nMmccvK
	 VhNg7Toklxqs7jCzEN1/W0xA790zTQGjfNa84vBCVbgL6H4QKzHaSmUU+N9FWlr8rK
	 Dty6zYjLBGJcLl5y2TdFAbBy8apKndPycuTlalJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+881d65229ca4f9ae8c84@syzkaller.appspotmail.com,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 77/88] bpf: Fix reference count leak in bpf_prog_test_run_xdp()
Date: Thu, 15 Jan 2026 17:49:00 +0100
Message-ID: <20260115164149.104962248@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1989d239939b1..7e11ec31d40e4 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -1243,13 +1243,13 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 
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
@@ -1261,7 +1261,7 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 			if (copy_from_user(page_address(page), data_in + size,
 					   data_len)) {
 				ret = -EFAULT;
-				goto out;
+				goto out_put_dev;
 			}
 			sinfo->xdp_frags_size += data_len;
 			size += data_len;
@@ -1276,6 +1276,7 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 		ret = bpf_test_run_xdp_live(prog, &xdp, repeat, batch_size, &duration);
 	else
 		ret = bpf_test_run(prog, &xdp, repeat, &retval, &duration, true);
+out_put_dev:
 	/* We convert the xdp_buff back to an xdp_md before checking the return
 	 * code so the reference count of any held netdevice will be decremented
 	 * even if the test run failed.
-- 
2.51.0



