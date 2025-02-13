Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068B0281349;
	Thu, 13 Feb 2025 14:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457711; cv=none; b=LSsVFWjdLTIu5lHZCno7TZmCk6YGVDGP962T4VUovLxyhW/WQSsfBIW6W8goOk/MrCqqTMBwjuQygJYZMYpmz/BrB0gtAbpMKaWiTx2ojP6wwG6J53Zebf0p3T3IRJXWIndudYAJ0pBGBOTcbrIcu8Qr3y6oYma+nZ77TiSi8ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457711; c=relaxed/simple;
	bh=L3sSenT3ie9bNkl3pp+PjmaTN7XesDtdedfuw4Z9pGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cJ8MoYA/j72a5oIgicoYOBU/K0hQC61vW1Z6XmFFtjs4wqqP/owBM+dyN474VSjXUsdCmxhMwl3ZdkAh0q0203YCPR8IZ57bgxYTmKyRcQW+Oy3j+G3eI740OR6do8KVBuT5j70MRzkxN/iALjCeWh0nsoKN7pZ/glhyFO2rsNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vdya1WDB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vdya1WDB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6679DC4CEE2;
	Thu, 13 Feb 2025 14:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457710;
	bh=L3sSenT3ie9bNkl3pp+PjmaTN7XesDtdedfuw4Z9pGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vdya1WDBIbF62diUi4f0pk9GbsfZMViV5R6/goO1TMZSb+TvgYaO1d7Qoext1MLxZ
	 tJ/1MXKjK4yaIOdTVqVBgS/1aQCfq2sXU6kN3Z+2QIIg2olxOlV9dPB8tyhi2d9Ddm
	 qGTpTlPxGSDFUCHOeV4AP0AtNIJcAsp5V0eJXsqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Zijun Hu <quic_zijuhu@quicinc.com>
Subject: [PATCH 6.12 190/422] blk-cgroup: Fix class @block_classs subsystem refcount leakage
Date: Thu, 13 Feb 2025 15:25:39 +0100
Message-ID: <20250213142443.877884686@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1138,6 +1138,7 @@ static void blkcg_fill_root_iostats(void
 		blkg_iostat_set(&blkg->iostat.cur, &tmp);
 		u64_stats_update_end_irqrestore(&blkg->iostat.sync, flags);
 	}
+	class_dev_iter_exit(&iter);
 }
 
 static void blkcg_print_one_stat(struct blkcg_gq *blkg, struct seq_file *s)


