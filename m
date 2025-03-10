Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD062D023;
	Mon, 10 Mar 2025 17:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629371; cv=none; b=vAmGIiVcUeldmK7ssnPHVAz/FxSIBSLi6x6dNMa2KZx59HepX9wLIFUilJxm96cs44eWgceg/nroNLCb9CTR3KbvfFFzLRxy8HTM9dft3r4VrbdMiCirgv3ZmsTnycalh2DvHBftDYCc/GGwbdnkZ6Sgsx31QIqMNOIJHfnNgAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629371; c=relaxed/simple;
	bh=ny110jFkFAPIolg3Qqyhdrf5gHybzaJnPndikRbXZ18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EiCRxSi5zdX5T99tFxhGaLO+BaKZm2bNkiNLWlCJSO//VJErxcsepJQGuD4Yvqe12pn+LYe5QghRxP5VmMAGDayw+bL8TnreOcfJP9tguu9U92oHg3urUIS/Orak5A6OrrxSeIcalr1LVgmPU+UL5IMeABEfgT8HlIb22ZO44Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o108fO2W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o108fO2W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 563E0C4CEE5;
	Mon, 10 Mar 2025 17:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629371;
	bh=ny110jFkFAPIolg3Qqyhdrf5gHybzaJnPndikRbXZ18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o108fO2Wh59TOEQtDQWNK6JDaknidQsH47WXMtKPZNG9/h0j6UnUhCY/yQhbkLVpK
	 iVuAwDcgryACr39aN090lji5V0jt+m2500/i7ykQgyTBnL+9qR7Lq1ZXnUFyHD4D/C
	 Jg2oD+cqisQCe8+3gBLQqRj/4F3os0jSkUfbjv5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Zijun Hu <quic_zijuhu@quicinc.com>
Subject: [PATCH 5.15 271/620] blk-cgroup: Fix class @block_classs subsystem refcount leakage
Date: Mon, 10 Mar 2025 18:01:57 +0100
Message-ID: <20250310170556.321425344@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -894,6 +894,7 @@ static void blkcg_fill_root_iostats(void
 		blkg_iostat_set(&blkg->iostat.cur, &tmp);
 		u64_stats_update_end_irqrestore(&blkg->iostat.sync, flags);
 	}
+	class_dev_iter_exit(&iter);
 }
 
 static void blkcg_print_one_stat(struct blkcg_gq *blkg, struct seq_file *s)


