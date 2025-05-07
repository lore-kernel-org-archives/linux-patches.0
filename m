Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7392144C1;
	Wed,  7 May 2025 19:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644939; cv=none; b=Kq/XnhOtAIKBhwvQionfZ47VYuPWzGWlgthzzAw4s1ZEheLnjNVAbxlp6d028m9Cu9SFjwCTO+3cdPYhplzYGSoIdZrQKie0aXAH8W6xnuGjtY4EhHqklpYzPUXwauot0VrrOZLaHvFpp5C2yBRE5gMEFVh7tGsZ6o/15NlA7Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644939; c=relaxed/simple;
	bh=1k7/3a5Qtb+qYYedHD0gCDCFBuQjqhNNGQXec+Hiejk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pjml/e6eB6CVsz3u71/KKKYZr2R2PVUncJqagrBt5pQ8qLD67tKtJ4z2/ojnluCHRPJGWKUqiKlt0QRhqmDg5dyZPf6y+kI7BhV4309MiyRIcizwIBzt0OHsDLqhyz2Wgsf7LFsIrpxBe5VqOh55DPNDdnMH72DcKO6QXuOkyY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nhnuY858; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nhnuY858"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56107C4CEE2;
	Wed,  7 May 2025 19:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644938;
	bh=1k7/3a5Qtb+qYYedHD0gCDCFBuQjqhNNGQXec+Hiejk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nhnuY858kDiX6YKpE21p9YrN1VNwiszwA3BP86NAmAlGqMb3UQt8EdWZYHHz682G3
	 KON3li60LUjNTe1Tb6ytkkZpHhTMLsyu3D3oo96kSFgDSxq9fpWCgdm/7+q66kPI5v
	 99odgo0tf10bnKfHh92TH41d4cizUctEen926aKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: [PATCH 6.6 041/129] bpf: fix null dereference when computing changes_pkt_data of prog w/o subprogs
Date: Wed,  7 May 2025 20:39:37 +0200
Message-ID: <20250507183815.207042638@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Eduard Zingerman <eddyz87@gmail.com>

commit ac6542ad92759cda383ad62b4e4cbfc28136abc1 upstream.

bpf_prog_aux->func field might be NULL if program does not have
subprograms except for main sub-program. The fixed commit does
bpf_prog_aux->func access unconditionally, which might lead to null
pointer dereference.

The bug could be triggered by replacing the following BPF program:

    SEC("tc")
    int main_changes(struct __sk_buff *sk)
    {
        bpf_skb_pull_data(sk, 0);
        return 0;
    }

With the following BPF program:

    SEC("freplace")
    long changes_pkt_data(struct __sk_buff *sk)
    {
        return bpf_skb_pull_data(sk, 0);
    }

bpf_prog_aux instance itself represents the main sub-program,
use this property to fix the bug.

Fixes: 81f6d0530ba0 ("bpf: check changes_pkt_data property for extension programs")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202412111822.qGw6tOyB-lkp@intel.com/
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20241212070711.427443-1-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -19908,6 +19908,7 @@ int bpf_check_attach_target(struct bpf_v
 	}
 	if (tgt_prog) {
 		struct bpf_prog_aux *aux = tgt_prog->aux;
+		bool tgt_changes_pkt_data;
 
 		if (bpf_prog_is_dev_bound(prog->aux) &&
 		    !bpf_prog_dev_bound_match(prog, tgt_prog)) {
@@ -19936,8 +19937,10 @@ int bpf_check_attach_target(struct bpf_v
 					"Extension programs should be JITed\n");
 				return -EINVAL;
 			}
-			if (prog->aux->changes_pkt_data &&
-			    !aux->func[subprog]->aux->changes_pkt_data) {
+			tgt_changes_pkt_data = aux->func
+					       ? aux->func[subprog]->aux->changes_pkt_data
+					       : aux->changes_pkt_data;
+			if (prog->aux->changes_pkt_data && !tgt_changes_pkt_data) {
 				bpf_log(log,
 					"Extension program changes packet data, while original does not\n");
 				return -EINVAL;


