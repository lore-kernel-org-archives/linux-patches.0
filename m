Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36EDF28D85F;
	Wed, 23 Apr 2025 15:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421437; cv=none; b=f7Zu3hIzpW23EzqkKgF3JUoCCqBox3asf0b6+XU1z9dHU+a4YLwRQxuxyzWQgliW6PuHMiEH5PNuvEVthzvfBH1Ak24pPfchJ7gVNUmtiTZ+RvUHt39kdcIWYGZ75Z6umZ0+TJgbelJMUQPt2feB4kzLygQE7ZhAD8dUcQ/IFXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421437; c=relaxed/simple;
	bh=u/9ei2vJzYATrWzqVjI9yDfs3sNKx9nlKVZaO5Y7UiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MrZkAoNidxsHgEMYX0xgYAa/olyiVts8+ErC3nRDv7mFcWGisIFPapidQZSX/HUAfm3eVERJ18DBvbSqwLCphCx3Eu+irH4/0C/sd+VwKtyAmI7IUyIsPQc3VnCNB5Hv0YuBzz5dYehNVJYoSOuv5wXl/ZPTqxk4p72MiYDMbIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HjOee0F7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HjOee0F7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A013BC4CEE2;
	Wed, 23 Apr 2025 15:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421437;
	bh=u/9ei2vJzYATrWzqVjI9yDfs3sNKx9nlKVZaO5Y7UiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HjOee0F7a9iGlZW/3OZc4j9dbBIiGSSOWNHBPTolUJxmD45mxfia7LIQyzN7VNVoh
	 dsm6KpBsv2Jl8fSz97IogWzmSgGSDqTISH4TKQ99MbwbjnfMadfwjaNpgPSmIf3wn4
	 ut2hna4dwQj8ZrFi6I815jdxidbl8PArblfWYrsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: [PATCH 6.12 221/223] bpf: fix null dereference when computing changes_pkt_data of prog w/o subprogs
Date: Wed, 23 Apr 2025 16:44:53 +0200
Message-ID: <20250423142626.166908438@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -21990,6 +21990,7 @@ int bpf_check_attach_target(struct bpf_v
 	}
 	if (tgt_prog) {
 		struct bpf_prog_aux *aux = tgt_prog->aux;
+		bool tgt_changes_pkt_data;
 
 		if (bpf_prog_is_dev_bound(prog->aux) &&
 		    !bpf_prog_dev_bound_match(prog, tgt_prog)) {
@@ -22024,8 +22025,10 @@ int bpf_check_attach_target(struct bpf_v
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


