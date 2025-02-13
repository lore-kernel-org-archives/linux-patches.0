Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA47126B0BD;
	Thu, 13 Feb 2025 15:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460467; cv=none; b=Qy1Xc1ZWUN06vulqUgEzK5uFvlj6j0J1bY5fKk/3uC+t9XlHQGUY8wl2i/eo9vobzs8RZxp3mwKCV2Ly9ewsyai1+ntFshzay1SqQi3ItaR1TsGyfOYepZWn9R13+3B4qLtYAPc2iP3xJFhU1PzPgT8hwMwUm9Pc1Lhq0g8zUFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460467; c=relaxed/simple;
	bh=zm040RkMbMnejHO/F4p6IBXJ1UMoGaW3pvu/5CJ0rz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YkONsYwaUyFVx1PCUoNjdUjlGu4DPtdXeybH4FEekytyGmYh5CYwvEScKnpFretM4uTzTZoFjXC0OpISnr8Ct9kUIeJ0KA9kv5Figzz2kTglu7hC4V3GfFAZ9fM6xnFzVtkGYGyZ2zCpdyAe4yHUBRIHsd6yLrRVm6NeWh7WcaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SYugKXAS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SYugKXAS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F00C4CED1;
	Thu, 13 Feb 2025 15:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460467;
	bh=zm040RkMbMnejHO/F4p6IBXJ1UMoGaW3pvu/5CJ0rz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SYugKXASE6g0aKtnyOpIWhM9je2htqkJlfCO0PwSRPd/sJgtbXCL1LRVpSEEl4W5I
	 bHkb5eAUVcJ5E20e363JH68CTQ0si5/UiTjR3Er+4JUB1ryBCXpFknSIPeNZY0uXX1
	 8r5DH21LFOfhc4m6C56vPLct1c1MNrnBS1zrCZCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Zijun Hu <quic_zijuhu@quicinc.com>
Subject: [PATCH 6.6 119/273] blk-cgroup: Fix class @block_classs subsystem refcount leakage
Date: Thu, 13 Feb 2025 15:28:11 +0100
Message-ID: <20250213142412.046934943@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit d1248436cbef1f924c04255367ff4845ccd9025e upstream.

blkcg_fill_root_iostats() iterates over @block_class's devices by
class_dev_iter_(init|next)(), but does not end iterating with
class_dev_iter_exit(), so causes the class's subsystem refcount leakage.

Fix by ending the iterating with class_dev_iter_exit().

Fixes: ef45fe470e1e ("blk-cgroup: show global disk stats in root cgroup io.stat")
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20250105-class_fix-v6-2-3a2f1768d4d4@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-cgroup.c |    1 +
 1 file changed, 1 insertion(+)

--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1139,6 +1139,7 @@ static void blkcg_fill_root_iostats(void
 		blkg_iostat_set(&blkg->iostat.cur, &tmp);
 		u64_stats_update_end_irqrestore(&blkg->iostat.sync, flags);
 	}
+	class_dev_iter_exit(&iter);
 }
 
 static void blkcg_print_one_stat(struct blkcg_gq *blkg, struct seq_file *s)


