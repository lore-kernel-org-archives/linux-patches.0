Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DE81CAA6C;
	Wed, 19 Feb 2025 09:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956965; cv=none; b=i0fZH5/bqq5B3Cg39S70w9xZI2iWdWh5w8gHZI5csaFWCjZbJn2DDAQdCko3TJiBQPm7c7z/9pi3uzDV7OaDgkE8HWuvWJUYBFfBZ8/y4L27wFDcWMBMDWjodcq/C9+Tv3MBlZjzFudCVCbQqDKl1C9z3v4xNQkhiREBizzSkl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956965; c=relaxed/simple;
	bh=r1e0hchxDqAlQAErbfOlk7LET+lYtTjPGHYse1CxOaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gHkxHmR+w3F+ZP8IPUY0EX9XEIQYCyUWqzX2r8VG4TFQVgbALVhE4jgZlXEzKOvnmcW22Qoz8Q7eo5Dja1p7AWebryWWqPa2jEaPlXzKRFqPPiUeH1+s9seFS7+Lw2DLM5KLdnwoUv8D5pRRYFIkD1S/kx1RyhvoLwAB0jyN12I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mwKxZNJ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mwKxZNJ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 808F0C4CED1;
	Wed, 19 Feb 2025 09:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956964;
	bh=r1e0hchxDqAlQAErbfOlk7LET+lYtTjPGHYse1CxOaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mwKxZNJ4x/4i4IbE2nyNrDiY2tkzh3qcA9rOwd/UL29hhOAT+3HBkeXRxlrzbAqiq
	 lEcDADNJaeObKKL+HvwjqtF0azqBTIPb3Nz6O5KWnHRHrr5INZ+t6sWM9iXj2K3U8U
	 n7gfxoa6PLhRn6jW6ZEZ5gusm0GRgzoF+uksqOY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Zijun Hu <quic_zijuhu@quicinc.com>
Subject: [PATCH 6.1 362/578] blk-cgroup: Fix class @block_classs subsystem refcount leakage
Date: Wed, 19 Feb 2025 09:26:06 +0100
Message-ID: <20250219082707.259743925@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -924,6 +924,7 @@ static void blkcg_fill_root_iostats(void
 		blkg_iostat_set(&blkg->iostat.cur, &tmp);
 		u64_stats_update_end_irqrestore(&blkg->iostat.sync, flags);
 	}
+	class_dev_iter_exit(&iter);
 }
 
 static void blkcg_print_one_stat(struct blkcg_gq *blkg, struct seq_file *s)


