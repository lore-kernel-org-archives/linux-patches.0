Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3199D3F44D9;
	Wed, 20 May 2026 17:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297934; cv=none; b=FIogsz49fK+DM+qLDVVcmJYrqnjymCTJl6fdWtKTZtyZBmDUSblJjGAkkwU0OYVTr3ugk1XymH3C7pqln/SNTcNlx/MmL/WwNb7Akr8FgPokVHZSI2x8YkXxS/3u4DVVR1RDZJH5ZfqX9q0lQbDM5xZdGoGZAI9PRcard97Zf6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297934; c=relaxed/simple;
	bh=IhHyWDNNoY3FhzkRp6JD5AvQW9sXJzdpvMVvB/v3atA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GoIWRT5YWMhVK5+9/2dFzqNx2qLgcp4wrItMDlQWTeu4/LcDu/CH+FQa7YOF2DPiqyXqbflURsnPCOp6Z6HSZE8VlXEzHbySKLU1I8l92KeOe/e8pOXs91BA5FRDlqALltIzvXBJea3u037p9vlMbJbUnEDm1Y47AOEfDLAtMEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FUJ6hCzC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FUJ6hCzC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F5DB1F000E9;
	Wed, 20 May 2026 17:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297933;
	bh=P2+DxHe+oq3sjPAUxGBad89hSqlTGqcwumWCX02V1k0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FUJ6hCzCLpAdUe+c55i5Gdz6+6+dh7yFA9AZHdhmg4xAq91pHv6NHEicWheY67Ryk
	 enmJ0Re3D+n1B4TPYQtOe8PmrKntM77ElUTSRNu0cIgYUUQiT3ZD//Tca0c48vcX5W
	 Y/R4fEVeX/2Uwm8Lx0noezeVhBym/E9ei8hzU7AI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Luczaj <mhal@rbox.co>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	David Wei <dw@davidwei.uk>,
	linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Stefan Metzmacher <metze@samba.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 178/957] Bluetooth: SCO: check for codecs->num_codecs == 1 before assigning to sco_pi(sk)->codec
Date: Wed, 20 May 2026 18:11:01 +0200
Message-ID: <20260520162138.413909118@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit 4e10a9ebbf081c16517cdd9366ac618bf38d7d0c ]

copy_struct_from_sockptr() fill 'buffer' in
sco_sock_setsockopt() with zeros, so there's no
real problem.

But it actually looks strange to do this,
without checking all of codecs->codecs[0]
really comes from userspace:

  sco_pi(sk)->codec = codecs->codecs[0];

As only optlen < sizeof(struct bt_codecs) is checked
and codecs->num_codecs is not checked against != 1,
but only <= 1, and the space for the additional struct bt_codec
is not checked.

Note I don't understand bluetooth and I didn't do any runtime
tests with this! I just found it when debugging a problem
in copy_struct_from_sockptr().

I just added this to check the size is as expected:

  BUILD_BUG_ON(struct_size(codecs, codecs, 0) != 1);
  BUILD_BUG_ON(struct_size(codecs, codecs, 1) != 8);

And made sure it still compiles using this:

  make CF=-D__CHECK_ENDIAN__ W=1ce C=1 net/bluetooth/sco.o

Fixes: 3e643e4efa1e ("Bluetooth: Improve setsockopt() handling of malformed user input")
Cc: Michal Luczaj <mhal@rbox.co>
Cc: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Cc: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: David Wei <dw@davidwei.uk>
Cc: linux-bluetooth@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/sco.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 1a38577135d44..9404fdb10ea63 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -1045,7 +1045,8 @@ static int sco_sock_setsockopt(struct socket *sock, int level, int optname,
 
 		codecs = (void *)buffer;
 
-		if (codecs->num_codecs > 1) {
+		if (codecs->num_codecs != 1 ||
+		    optlen < struct_size(codecs, codecs, codecs->num_codecs)) {
 			hci_dev_put(hdev);
 			err = -EINVAL;
 			break;
-- 
2.53.0



