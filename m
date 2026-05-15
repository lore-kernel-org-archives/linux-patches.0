Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0E03F44C0;
	Fri, 15 May 2026 16:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861522; cv=none; b=LdBWoLJp6XzjVnuk9HM+cYBhAuT2mAQ74+lJNMDlvqZ44QyXBdPXw21gzhu1fWHNTui/515jRd134YPnptRS6F0FUOz7oZCZkdTDYhqfmXV+WDiJYKlJfCDV6ynjeCakcH7/A9djBBiorn7QQXyCOHOl0qgmKfSofY8Fm0j84Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861522; c=relaxed/simple;
	bh=yWRAkUarROLMoVgR5odD7sUxE3FnovuMLlvGmclMai8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DpTrIF8hsRwamx5pIbGPu2Fx2Y0zalpF2AnLBSk2TtPSyllim0Sddp5iXnOVHNywribnh9z3KhQs03LP4E+q72mNQdN6HUqvobdEiaZxqBohzlxCdgW8/HM+xKXXepD9DC9kiQKuRA2fp+mcTISd9EwwO6qza6bG8nMDISsVYCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=inXUhsZH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="inXUhsZH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B69A4C2BCB0;
	Fri, 15 May 2026 16:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861522;
	bh=yWRAkUarROLMoVgR5odD7sUxE3FnovuMLlvGmclMai8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=inXUhsZHy1D/d9rKJhrwc5ugjxagIZoI3kTD+xa1Wt1yKuZ/xmRdD2u18KtPERYx3
	 5HHYt/8AnR+RPsr1w03N0H8FKhrSeLCeJZn/NLi56ZYANZfKagwoPbOekoamTGC/4s
	 ZfiCp0gjjdJySxy1lGJVJdxj5bGeEb0ZoEIzg7P0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.6 361/474] batman-adv: bla: put backbone reference on failed claim hash insert
Date: Fri, 15 May 2026 17:47:50 +0200
Message-ID: <20260515154722.831050580@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit ba9d20ee9076dac32c371116bacbe72480eb356c upstream.

When batadv_bla_add_claim() fails to insert a new claim into the hash, it
leaked a reference to the backbone_gw for which the claim was intended.
Call batadv_backbone_gw_put() on the error path to release the reference
and avoid leaking the backbone_gw object.

Cc: stable@kernel.org
Fixes: 3db0decf1185 ("batman-adv: Fix non-atomic bla_claim::backbone_gw access")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/bridge_loop_avoidance.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -723,6 +723,7 @@ static void batadv_bla_add_claim(struct
 
 		if (unlikely(hash_added != 0)) {
 			/* only local changes happened. */
+			batadv_backbone_gw_put(backbone_gw);
 			kfree(claim);
 			return;
 		}


