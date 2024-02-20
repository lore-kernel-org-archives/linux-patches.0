Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F8A151CEF;
	Tue, 20 Feb 2024 21:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463047; cv=none; b=uxNHyIeytFJBYPQwKhYj3C6/K497RtG8WgjddV0qNK86lPbDyzKRW8IY7XepQCVcRg8uE60ZC6DvKIZOOj0XXDZJMg4tBzShQQu3hlf+NuwXc+ENxJJ0Cl6m7uip5uOprD4ZZlbIccqRw3+aYQPzDX4yggkgqbeJlQSQgKKO0dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463047; c=relaxed/simple;
	bh=H8ZyO2tMapicuImcMekJLIhCjsLo7mhBbfqLHCjgm6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pXWSLZVc4MzWM/YZ+uFb5hp4Lv/GmDgR8WMpaYCal+Dxn6MiM/52Zzm46IpOFg7vYCNHt+yi8gwvK91BvbbVA3nv0NVp4S+Vo/qJMwGkQc9kGXh0UubgxoN6k/Ijya3jB+lEkuFKUAlonYM+dlGoTCxDeo1xNxv2Z/euV3EtDUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EKD9O5jz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EKD9O5jz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC512C433F1;
	Tue, 20 Feb 2024 21:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463047;
	bh=H8ZyO2tMapicuImcMekJLIhCjsLo7mhBbfqLHCjgm6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EKD9O5jzb1OtcaBsJ/w4Ai84S+OvImHlOULe0PAt4sUW+7bp5SRX3d8KXskyAmOQO
	 jCxvc+1ppQLp9emz+S/YtTmEekbLxnpSb4lSupEzpwFucF6pLQwkZVtHONZQqUD/Nh
	 h4CxLIOg4lBBOh1I4v5CWgAOxE76rElZcAIUmWkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Zhou <hui.zhou@corigine.com>,
	Louis Peens <louis.peens@corigine.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 119/197] nfp: flower: fix hardware offload for the transfer layer port
Date: Tue, 20 Feb 2024 21:51:18 +0100
Message-ID: <20240220204844.636744354@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Zhou <hui.zhou@corigine.com>

commit 3a007b8009b5f8af021021b7a590a6da0dc4c6e0 upstream.

The nfp driver will merge the tp source port and tp destination port
into one dword which the offset must be zero to do hardware offload.
However, the mangle action for the tp source port and tp destination
port is separated for tc ct action. Modify the mangle action for the
FLOW_ACT_MANGLE_HDR_TYPE_TCP and FLOW_ACT_MANGLE_HDR_TYPE_UDP to
satisfy the nfp driver offload check for the tp port.

The mangle action provides a 4B value for source, and a 4B value for
the destination, but only 2B of each contains the useful information.
For offload the 2B of each is combined into a single 4B word. Since the
incoming mask for the source is '0xFFFF<mask>' the shift-left will
throw away the 0xFFFF part. When this gets combined together in the
offload it will clear the destination field. Fix this by setting the
lower bits back to 0xFFFF, effectively doing a rotate-left operation on
the mask.

Fixes: 5cee92c6f57a ("nfp: flower: support hw offload for ct nat action")
CC: stable@vger.kernel.org # 6.1+
Signed-off-by: Hui Zhou <hui.zhou@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Link: https://lore.kernel.org/r/20240124151909.31603-3-louis.peens@corigine.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/netronome/nfp/flower/conntrack.c |   24 ++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -1379,10 +1379,30 @@ static void nfp_nft_ct_translate_mangle_
 		mangle_action->mangle.mask = (__force u32)cpu_to_be32(mangle_action->mangle.mask);
 		return;
 
+	/* Both struct tcphdr and struct udphdr start with
+	 *	__be16 source;
+	 *	__be16 dest;
+	 * so we can use the same code for both.
+	 */
 	case FLOW_ACT_MANGLE_HDR_TYPE_TCP:
 	case FLOW_ACT_MANGLE_HDR_TYPE_UDP:
-		mangle_action->mangle.val = (__force u16)cpu_to_be16(mangle_action->mangle.val);
-		mangle_action->mangle.mask = (__force u16)cpu_to_be16(mangle_action->mangle.mask);
+		if (mangle_action->mangle.offset == offsetof(struct tcphdr, source)) {
+			mangle_action->mangle.val =
+				(__force u32)cpu_to_be32(mangle_action->mangle.val << 16);
+			/* The mask of mangle action is inverse mask,
+			 * so clear the dest tp port with 0xFFFF to
+			 * instead of rotate-left operation.
+			 */
+			mangle_action->mangle.mask =
+				(__force u32)cpu_to_be32(mangle_action->mangle.mask << 16 | 0xFFFF);
+		}
+		if (mangle_action->mangle.offset == offsetof(struct tcphdr, dest)) {
+			mangle_action->mangle.offset = 0;
+			mangle_action->mangle.val =
+				(__force u32)cpu_to_be32(mangle_action->mangle.val);
+			mangle_action->mangle.mask =
+				(__force u32)cpu_to_be32(mangle_action->mangle.mask);
+		}
 		return;
 
 	default:


