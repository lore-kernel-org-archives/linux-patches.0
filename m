Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1623E832A;
	Wed, 20 May 2026 18:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300270; cv=none; b=Vz39mn8egNl4LbylDY0xnD7ojv61hRlaRHT13j8JPb0hGcQz1RRxosSNq3osTv/myeCJ4MOm0HkJLp8mZHpvQlcVeuqM1Nbhb9Z3GYONUpAz78VYLa4/CDf2IbYA7aL5yhKCd+9sV7xCkow2RWpBQXb6T7OsISGb6cpUTPARAQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300270; c=relaxed/simple;
	bh=dP4ukKl3t5Q9bHt1hHVvcn/XbTfLle9LWQ4ZDKR+KFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iC7tIJpkiTrc7HDzYblpIKxClAfumy9I2Q/rNnutKY16VqO38E7N/DfxzcZxKW9azSgLNL7dndY1p5VNzCArBmILshfx/NBBOdiXZgQnIGZbRP0OjWWFq6MQRgPkxAbsHip705jaWklUHFB7uqh1UIFAGvYOanou8xXVqyHMR4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cCrs4Oru; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cCrs4Oru"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D585B1F00896;
	Wed, 20 May 2026 18:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300269;
	bh=gdHaQ/fvPhsfTfJAde7DuLpdRF41DI7gkjP9oTHPX/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cCrs4OrufWkUZmwJZOLLUvev5n3B/loQrFotrx4aa46oPYUgaOVNtwgN7rBJT2Chm
	 dkthvUgqNKB5jXLwlj1nRYp+pzj/v1Q2JJ9lKBTucgNJM0z7/0U9g3JTnVgEs3n0gP
	 AnSz///YOOt7rhMeQ9cBYD7foNupG5YPiYbXL774=
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
Subject: [PATCH 6.12 110/666] Bluetooth: SCO: check for codecs->num_codecs == 1 before assigning to sco_pi(sk)->codec
Date: Wed, 20 May 2026 18:15:21 +0200
Message-ID: <20260520162113.605994740@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ded0c52ccf0b9..d915db52db221 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -978,7 +978,8 @@ static int sco_sock_setsockopt(struct socket *sock, int level, int optname,
 
 		codecs = (void *)buffer;
 
-		if (codecs->num_codecs > 1) {
+		if (codecs->num_codecs != 1 ||
+		    optlen < struct_size(codecs, codecs, codecs->num_codecs)) {
 			hci_dev_put(hdev);
 			err = -EINVAL;
 			break;
-- 
2.53.0



