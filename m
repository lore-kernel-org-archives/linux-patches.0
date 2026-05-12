Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C072D060B;
	Tue, 12 May 2026 18:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609236; cv=none; b=UJJCr9qO9WpAYXYvNVZQxee516UUwz9ARHAJyg4Lumsh4I7fnT7m+RXT8ba6XSvUGaDxozGnKhJXkiZDmeEZylMHC+XyQXZ6iIHjNjFr6laNz91bzMFyz9v4wIS7Iq+NFUad3Exxq7c3wxsfSIpxZCYEjClcKmyTiMY/QgGywxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609236; c=relaxed/simple;
	bh=D+1DMTlPgseoYfItwwWVdFHfwTxruBXxic8rtEP5RUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GAGSHcxzxuMSQxKId9Z5V1FMS2MmGJc7qn/UZluS/MQFspRA4jtA1STraT4QsOvk9495I0v1MM369mZYY3gyZUe2j14+g/F9RSfIy/EGqrg4MO/PBdeCat6piuKGxrkvNl5i2Z6n7cr3JP8pLE3k7NIOI3IH2/1nn95iv2BrbHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JrLRNbJh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JrLRNbJh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC4E3C2BCB0;
	Tue, 12 May 2026 18:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609236;
	bh=D+1DMTlPgseoYfItwwWVdFHfwTxruBXxic8rtEP5RUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JrLRNbJhxeZ/ij0KheXfL93QjqVY7eO/naCapc4SFsA9qkHwqZA5ZcYYHMO37FQIR
	 iUewEXL1uh6ueHS8xOqud7cAMj7VfPbyBOXxP72LL8tnBd0xehReNb97ce8AE1S8IS
	 9/irsr7KLDuy9X87m0c+LPo9a6uaXcdE4Qu5d+lI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.0 076/307] Bluetooth: L2CAP: Fix null-ptr-deref in l2cap_sock_get_sndtimeo_cb()
Date: Tue, 12 May 2026 19:37:51 +0200
Message-ID: <20260512173941.725158937@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1764,6 +1764,9 @@ static long l2cap_sock_get_sndtimeo_cb(s
 {
 	struct sock *sk = chan->data;
 
+	if (!sk)
+		return 0;
+
 	return READ_ONCE(sk->sk_sndtimeo);
 }
 


