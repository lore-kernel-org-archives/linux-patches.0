Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F2841A8F;
	Sat, 30 May 2026 18:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166143; cv=none; b=aBL7QWSO/sBN/vL51ETd271PamMatk25e22Z7NpVQBO5gNqwUM9NW8fN5vjB4aT4IAOtXGcVsLAF3mHwRa7RRaZEbJhirG8DowRu4CqUP/Xaw+bjoYKzwp8E8YJmoM3TULW4A4rPkP5Q9f1dbTY/9yiNR8UHl7mupVFpM+I2eyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166143; c=relaxed/simple;
	bh=CvMZKgY7Dzu/aRguVd9Ngh0Q2uFdSVE8tfzK53V7ZVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QEWQMWn7DG6fOHDuvnO69OJI5wz4vtzWYQAfQYpVxGihNRJwa9hesIzeTAe/1jrUCLtRqGR9TskJBoY3EtU6HUAsTa7uMdQYHyABuVd4pqVK5wqaP+m4UkwoTL0DePI9AlYz/gpXCIZo3sh1nq1kM7ZLnCqxIqXp8ISU3nfWt9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZKoKPmo3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZKoKPmo3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 717181F00893;
	Sat, 30 May 2026 18:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166142;
	bh=ZODUYGThpkkjicTaRw5PUtPFdaBu36JSPZD3QkTCt+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZKoKPmo3doYdmYv4INewKLcN9yRDUYwZwX6eH64wUROgisP1KiMLig1v9obvTwNje
	 HDp4UVzx7i6b1yRM+8bGldLDHPlEYOzwuMHOtBi8ZWSlwCST9k7a22rCq+gNnPaxM2
	 3RBPUk2q/55O1IKIG7Sn2FF6xOKHtdVnS0OAk8MA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.10 287/589] Bluetooth: L2CAP: Fix null-ptr-deref in l2cap_sock_get_sndtimeo_cb()
Date: Sat, 30 May 2026 18:02:48 +0200
Message-ID: <20260530160232.488905052@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1703,6 +1703,9 @@ static long l2cap_sock_get_sndtimeo_cb(s
 {
 	struct sock *sk = chan->data;
 
+	if (!sk)
+		return 0;
+
 	return sk->sk_sndtimeo;
 }
 


