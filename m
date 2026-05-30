Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87EE430E0DC;
	Sat, 30 May 2026 17:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163849; cv=none; b=RKhVI9/EtcNsfsU3e5zOcXINcBbnsV8J3SmnYEhrEGsl8YYgO6Rrz3SBLc1fbX3+uVUtYnMhpXOLkmCT/T+qkCi8WD8FFvosp20jJbRgsBNpSqAGmRmuVzD7hZcOTBpEhpxASNwA7hODpUxE52g1CPNWBxX4uPaENMY0t07o82I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163849; c=relaxed/simple;
	bh=Qc702lhIrGP6eMMEMIGm0WUWkMmap+kAeQqRa1X5FYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sK+SMOkrcMPvE50fnoacQ7IyotMZdDnzGH1943tq6YKzQTmowXCJGxBiane39NlhvdKrbybio+T85YfdRwGhsn0ir6bEn4dDMdb6JamepuzS5kLvdYYEm9S7SIwHmD+osS17YnuIpx0C9SlWgFzzJd6kFaXdH2+sT6hLSL8x9Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pv2J73iW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pv2J73iW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98AD91F00898;
	Sat, 30 May 2026 17:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163848;
	bh=KDik4Ehj3d3ExREEXoX55ribX+0Z59Z7UL0PV6zzITg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pv2J73iWscW1hpb+6ItzbNrocnXDDHoLpI5TmwLaRnJg3aa0bynWUQTr1RWyUDPfz
	 P4AP0Ph8ZIoIw/+qc2SS4i+HoECA00YOfaVEHPjO0j9s21eJrdoUgxlxE56Pp9sqRK
	 17UO/avqZ1xnynERo37Gw/ot3MiW5fIafIh0Mrck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.15 380/776] Bluetooth: L2CAP: Fix null-ptr-deref in l2cap_sock_get_sndtimeo_cb()
Date: Sat, 30 May 2026 18:01:34 +0200
Message-ID: <20260530160250.342756067@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siwei Zhang <oss@fourdim.xyz>

commit 78a88d43dab8d23aeef934ed8ce34d40e6b3d613 upstream.

Add the same NULL guard already present in
l2cap_sock_resume_cb() and l2cap_sock_ready_cb().

Fixes: 8d836d71e222 ("Bluetooth: Access sk_sndtimeo indirectly in l2cap_core.c")
Cc: stable@kernel.org
Signed-off-by: Siwei Zhang <oss@fourdim.xyz>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_sock.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1715,6 +1715,9 @@ static long l2cap_sock_get_sndtimeo_cb(s
 {
 	struct sock *sk = chan->data;
 
+	if (!sk)
+		return 0;
+
 	return sk->sk_sndtimeo;
 }
 


