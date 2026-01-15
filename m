Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13BAD3BB9F4;
	Thu, 15 Jan 2026 17:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496711; cv=none; b=ZSUhSb9pyR6wmRQSoiIqZIOt5nDCaejxgGC0qeaLa6NgwtDi/vnXBFZvZi6dlpAuJ5WiN9Byv40a1iiqBijYZ153aek2ug3tkcAT2zN+oALs6TpFpHPRfEuQWxBZmiQ0fjc49eb+E/0rZpcTXEUXtcVQv05IGa2M4bvXjEkGISM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496711; c=relaxed/simple;
	bh=UQGironoa64IgdCnNHncUxVw/6NmqBVd8zPDHOQ+X48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NSfJww2i4JmNeQ6ExC5kuj8vWGawBaLv1hYtgwY+b03FU+tYo+e4Pw6MOn5ZbAzkd6T3mnBhN7luAoJSa95KuXR8Ui5p7RYyzBFeMY2FGbWeVIJTM+ugiAF3K0AMipsclE2WOdNHR67Piwc0jxYBOTeH2rh2tmTSKormMUHzSO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cIWddl0b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cIWddl0b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877C0C116D0;
	Thu, 15 Jan 2026 17:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496710;
	bh=UQGironoa64IgdCnNHncUxVw/6NmqBVd8zPDHOQ+X48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cIWddl0bQlg7Sb5m9gv6nqM8ISFg0LSbbAbdTpZl6zeS3SBb2qeXy3zRKZwh2v6DF
	 kb/7ANjFI3J6lUIEUUqTurJgSxAFS73602SfjPX4r6yF8eA9Ttr1DGd6DI/YOpaA9Y
	 g5NDT3jkYEGbZv/gZkm7EaZFtuFwbeykYYVqJhTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+881d65229ca4f9ae8c84@syzkaller.appspotmail.com,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 101/119] bpf: Fix reference count leak in bpf_prog_test_run_xdp()
Date: Thu, 15 Jan 2026 17:48:36 +0100
Message-ID: <20260115164155.599237976@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 84ed67a15dee0..5b732c380c223 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -1299,13 +1299,13 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 
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
@@ -1317,7 +1317,7 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 			if (copy_from_user(page_address(page), data_in + size,
 					   data_len)) {
 				ret = -EFAULT;
-				goto out;
+				goto out_put_dev;
 			}
 			sinfo->xdp_frags_size += data_len;
 			size += data_len;
@@ -1332,6 +1332,7 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 		ret = bpf_test_run_xdp_live(prog, &xdp, repeat, batch_size, &duration);
 	else
 		ret = bpf_test_run(prog, &xdp, repeat, &retval, &duration, true);
+out_put_dev:
 	/* We convert the xdp_buff back to an xdp_md before checking the return
 	 * code so the reference count of any held netdevice will be decremented
 	 * even if the test run failed.
-- 
2.51.0



