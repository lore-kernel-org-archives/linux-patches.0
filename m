Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A973BCD11;
	Thu, 16 Jul 2026 14:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210821; cv=none; b=iG8hCULcStqzdoR6ADACLL6YsSd147gtPTdym3w6e8jtZyezEuPb0cOmo9/V1tUUpBHMEoJev3l5PFlHqiZlpxucbt3RzHpqMz0y+iDsiLhqHVxqD8atdY9HRidMWzeVwnh6k+6FTQdzTBn4sLF/BAV70t6DXQioiFPWyYi2ue4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210821; c=relaxed/simple;
	bh=kwinLw/oPe12ikEoYzJr1102onEV6rh2MsBwVyn76xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oO1cNP7e6weyXqLQpGihEBduNYScCDz/JvdR/V7IDHdK8Ovd5kRiZ25VeSxFuRtKIZb9KMGcH2XegEP3mcPvOktBKzX1KvPX4C/7mnVjBmdYAWVl8FYXuXbmb/j67ga4EZJ8iUIDqgaNPdwbY+SPW+mYIqgHlthyUo+L97xOQ7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kvhSVgBp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kvhSVgBp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 245AC1F000E9;
	Thu, 16 Jul 2026 14:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210820;
	bh=yRgP+PTrhVLfEDyMApOWNGWkpJi1Zv1vclw5pfZtQFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kvhSVgBproZ2LLyWZE4R3v8gimkwj8CI7NkvVczBRvJy4vtcEYBMNpWU4L8ju91WB
	 M64Clsejl/8iu4wBuoJC+YaQrps6WTlSK+xT1pUirrMNDW4QuVjbmvGqcl/2sWX/EF
	 OEW1nN0U8mPDiwozxsEWMl7RsN0fuNGqSdH7nvHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pratham Gupta <pratham36gupta@gmail.com>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 6.18 194/480] netfilter: ctnetlink: use nf_ct_exp_net() in expectation dump
Date: Thu, 16 Jul 2026 15:29:01 +0200
Message-ID: <20260716133048.925398946@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pratham Gupta <pratham36gupta@gmail.com>

commit a7f57320bbbc67e347bf5fff4b4a9bab980d5956 upstream.

Commit 02a3231b6d82 ("netfilter: nf_conntrack_expect: store netns and zone in expectation")
introduced exp->net so RCU-only expectation paths no longer need to
dereference exp->master for netns lookups.

Commit 3db5647984de ("netfilter: nf_conntrack_expect: skip expectations in other netns via proc")
updated the proc path accordingly, but ctnetlink_exp_dump_table() still
compares against nf_ct_net(exp->master).

Use nf_ct_exp_net(exp) here as well so the netlink dump path matches
the rest of the March 2026 expectation netns/RCU cleanup.

Fixes: 02a3231b6d82 ("netfilter: nf_conntrack_expect: store netns and zone in expectation")
Cc: stable@vger.kernel.org
Signed-off-by: Pratham Gupta <pratham36gupta@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_conntrack_netlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3159,7 +3159,7 @@ restart:
 			if (l3proto && exp->tuple.src.l3num != l3proto)
 				continue;
 
-			if (!net_eq(nf_ct_net(exp->master), net))
+			if (!net_eq(nf_ct_exp_net(exp), net))
 				continue;
 
 			if (cb->args[1]) {


