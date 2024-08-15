Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F751714A1;
	Thu, 15 Aug 2024 13:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729923; cv=none; b=LQ3l69cvWmCIz2DR58syGQ3Tp3QSHka9UKC8KZ6fpWpzcP3DPOutg1wtSuIKi5kygPxj+XFNqvUX7KoBicjVnTf4GTV8RAx2YNGNtahEsoq0QK6URtjtui3IUoZb99oMKrelE/IOHjrsVvg7Zi1MLK2hyyyGaVcw6wuFHRyI/3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729923; c=relaxed/simple;
	bh=1BhXfw4V41YwiEd/yrwkH01fY808g7qFeXeaLpLQPnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WOK2AmXh+ESHG/UwvXlGHZBCWMZi7GN8/gwQAXz+A4KynsLkXnzIMooq4LEZARCk2n4LDPqQubDSMK467gONhHLcdKf9QKDhIB3vO2guf3xSl0Re4E+Jz60lsi//l551H7zIC+pe4T/VGOidbYrx/cO5c8YL+wCT8KSwIQHIi1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r/Wnc6Dr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r/Wnc6Dr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 839A3C32786;
	Thu, 15 Aug 2024 13:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729922;
	bh=1BhXfw4V41YwiEd/yrwkH01fY808g7qFeXeaLpLQPnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r/Wnc6DreLGClalaeSQr0KhYMj9knF0Sz0lsjJo2CYNdW1SmJ6+D8x9Jf24zKhwVY
	 gECPjhEF3GmFHWWdubTGfwPolQiWgLo9s6rHGBKRwPUyNcTK1QCuZ3JkiDtz0WKGrR
	 GgreJKw24P5WzRnCboo+3k3fPimmly8404TejjB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ian Rogers <irogers@google.com>
Subject: [PATCH 5.15 232/484] perf/x86/intel/uncore: Fix the bits of the CHA extended umask for SPR
Date: Thu, 15 Aug 2024 15:21:30 +0200
Message-ID: <20240815131950.367588895@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kan Liang <kan.liang@linux.intel.com>

commit a5a6ff3d639d088d4af7e2935e1ee0d8b4e817d4 upstream.

The perf stat errors out with UNC_CHA_TOR_INSERTS.IA_HIT_CXL_ACC_LOCAL
event.

 $perf stat -e uncore_cha_55/event=0x35,umask=0x10c0008101/ -a -- ls
    event syntax error: '..0x35,umask=0x10c0008101/'
                                      \___ Bad event or PMU

The definition of the CHA umask is config:8-15,32-55, which is 32bit.
However, the umask of the event is bigger than 32bit.
This is an error in the original uncore spec.

Add a new umask_ext5 for the new CHA umask range.

Fixes: 949b11381f81 ("perf/x86/intel/uncore: Add Sapphire Rapids server CHA support")
Closes: https://lore.kernel.org/linux-perf-users/alpine.LRH.2.20.2401300733310.11354@Diego/
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20240708185524.1185505-1-kan.liang@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/uncore_snbep.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -459,6 +459,7 @@
 #define SPR_RAW_EVENT_MASK_EXT			0xffffff
 
 /* SPR CHA */
+#define SPR_CHA_EVENT_MASK_EXT			0xffffffff
 #define SPR_CHA_PMON_CTL_TID_EN			(1 << 16)
 #define SPR_CHA_PMON_EVENT_MASK			(SNBEP_PMON_RAW_EVENT_MASK | \
 						 SPR_CHA_PMON_CTL_TID_EN)
@@ -475,6 +476,7 @@ DEFINE_UNCORE_FORMAT_ATTR(umask_ext, uma
 DEFINE_UNCORE_FORMAT_ATTR(umask_ext2, umask, "config:8-15,32-57");
 DEFINE_UNCORE_FORMAT_ATTR(umask_ext3, umask, "config:8-15,32-39");
 DEFINE_UNCORE_FORMAT_ATTR(umask_ext4, umask, "config:8-15,32-55");
+DEFINE_UNCORE_FORMAT_ATTR(umask_ext5, umask, "config:8-15,32-63");
 DEFINE_UNCORE_FORMAT_ATTR(qor, qor, "config:16");
 DEFINE_UNCORE_FORMAT_ATTR(edge, edge, "config:18");
 DEFINE_UNCORE_FORMAT_ATTR(tid_en, tid_en, "config:19");
@@ -5648,7 +5650,7 @@ static struct intel_uncore_ops spr_uncor
 
 static struct attribute *spr_uncore_cha_formats_attr[] = {
 	&format_attr_event.attr,
-	&format_attr_umask_ext4.attr,
+	&format_attr_umask_ext5.attr,
 	&format_attr_tid_en2.attr,
 	&format_attr_edge.attr,
 	&format_attr_inv.attr,
@@ -5684,7 +5686,7 @@ ATTRIBUTE_GROUPS(uncore_alias);
 static struct intel_uncore_type spr_uncore_chabox = {
 	.name			= "cha",
 	.event_mask		= SPR_CHA_PMON_EVENT_MASK,
-	.event_mask_ext		= SPR_RAW_EVENT_MASK_EXT,
+	.event_mask_ext		= SPR_CHA_EVENT_MASK_EXT,
 	.num_shared_regs	= 1,
 	.constraints		= skx_uncore_chabox_constraints,
 	.ops			= &spr_uncore_chabox_ops,


