Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A0510A1F;
	Mon,  4 Mar 2024 21:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587719; cv=none; b=bJDPx5OtfRuW3MZDu0p0Y1rpcEaEM4ExmQq9N//VmeP5xV+zTIMuzC77PldoE7BS/hgBkIymGEMhrX2BIuADKDi9+6siUBwwEZXcAbNMSkzinBJmOLRjqIDAKmPsO0FJPXIfIqSoQpvZA17cew+NOfNta0vRI2dEDgLyvmlJ6q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587719; c=relaxed/simple;
	bh=4I0y6kZC4ZxuCS/ZNAN45LX1mgLi1LHY5z6ZHnITcrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PbZ7LJLZAlahIsUPLHUymATpi+XW6TQ9yzBTdh9ABOrWMGPYlN4CYdvJSMf5qvXUJITFaxu9eLrGiEViZ+5lg22H1/rEdcEjLXWSuxqF4Hmyqf+3ih6gw7V+qwRuleWf1KW7CHtmyzfPSb2t62lrRf6zm5tJ12cm/OxW/k7/HEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M6KgSrEc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M6KgSrEc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D91FC433C7;
	Mon,  4 Mar 2024 21:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587719;
	bh=4I0y6kZC4ZxuCS/ZNAN45LX1mgLi1LHY5z6ZHnITcrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M6KgSrEc/Ja0TQJqDDn2gRZQIEqVzavr0l0g7dA40KAP+KBuGiS5QhXT7CAdSAUP+
	 98cwnVi3O/WT3PpFX8yfiP88dapKa9bHdCnnmhZycuAD8u9GcsplL2Ri0srsBEMMKF
	 TUvW5kCfB46Fds0k0qeHADHhCeCbZGAtybVc/U5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukasz Majewski <lukma@denx.de>,
	Jiri Pirko <jiri@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 039/162] net: hsr: Use correct offset for HSR TLV values in supervisory HSR frames
Date: Mon,  4 Mar 2024 21:21:44 +0000
Message-ID: <20240304211553.096593174@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukasz Majewski <lukma@denx.de>

[ Upstream commit 51dd4ee0372228ffb0f7709fa7aa0678d4199d06 ]

Current HSR implementation uses following supervisory frame (even for
HSRv1 the HSR tag is not is not present):

00000000: 01 15 4e 00 01 2d XX YY ZZ 94 77 10 88 fb 00 01
00000010: 7e 1c 17 06 XX YY ZZ 94 77 10 1e 06 XX YY ZZ 94
00000020: 77 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00000030: 00 00 00 00 00 00 00 00 00 00 00 00

The current code adds extra two bytes (i.e. sizeof(struct hsr_sup_tlv))
when offset for skb_pull() is calculated.
This is wrong, as both 'struct hsrv1_ethhdr_sp' and 'hsrv0_ethhdr_sp'
already have 'struct hsr_sup_tag' defined in them, so there is no need
for adding extra two bytes.

This code was working correctly as with no RedBox support, the check for
HSR_TLV_EOT (0x00) was off by two bytes, which were corresponding to
zeroed padded bytes for minimal packet size.

Fixes: eafaa88b3eb7 ("net: hsr: Add support for redbox supervision frames")
Signed-off-by: Lukasz Majewski <lukma@denx.de>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://lore.kernel.org/r/20240228085644.3618044-1-lukma@denx.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_forward.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index 80cdc6f6b34c9..0323ab5023c69 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -83,7 +83,7 @@ static bool is_supervision_frame(struct hsr_priv *hsr, struct sk_buff *skb)
 		return false;
 
 	/* Get next tlv */
-	total_length += sizeof(struct hsr_sup_tlv) + hsr_sup_tag->tlv.HSR_TLV_length;
+	total_length += hsr_sup_tag->tlv.HSR_TLV_length;
 	if (!pskb_may_pull(skb, total_length))
 		return false;
 	skb_pull(skb, total_length);
-- 
2.43.0



