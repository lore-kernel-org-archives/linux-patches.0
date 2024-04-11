Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323361465A2;
	Thu, 11 Apr 2024 10:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830617; cv=none; b=M5Z5gnYBj0ilcLmPOPQHkZz1PJh/JVMCxkjmfDuMKcn+c+UjhyoOlZp70QbJOVL84nUhMBxcEH1XejSKegrNmrOpzDPS5XhJx57QNx7/Fk5w3yZF9XQtqsDa/kzK06do3bthIaOkKOgQnRigSJDIli04f52q7q9roy4k9AKdeSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830617; c=relaxed/simple;
	bh=8sCP1b8Y3TB6pZ0dKmFjSsDhlBwu1yDUqwW32p5IVKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GLQeBdp+DJSWt25T9cGo63mzcUmBFLmBH0VRiAMyrW1Ch/foNV/iWZpkQNlrWtqSTGHGNcziUPKPCTx8aE3e3vfVMIea1he/xknozIdo+5iphlNVSwG8c0KKJpxpC3fKlqKKGAUKNvBPFcpTGYKrrQFthMqk10i5+L1taMTFpWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l3opTaWW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l3opTaWW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD6EAC433C7;
	Thu, 11 Apr 2024 10:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830617;
	bh=8sCP1b8Y3TB6pZ0dKmFjSsDhlBwu1yDUqwW32p5IVKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l3opTaWWwU4GdSFgm8RWngff+RS98GwkSWwwkA9YhYzRwJiooEsA6qupxDzxYvncx
	 Ae3TiQMJmOEFr8dNFVBN+S/Ri6jwx2knHAYPJFxZi5hqLALZWYB3RYT5SmTCWW1zpA
	 qgKH4dsqR2qiH9poOaxkXjiHn7uf1UMPGU3IDAZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 059/215] speakup: Fix 8bit characters from direct synth
Date: Thu, 11 Apr 2024 11:54:28 +0200
Message-ID: <20240411095426.669999039@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Thibault <samuel.thibault@ens-lyon.org>

[ Upstream commit b6c8dafc9d86eb77e502bb018ec4105e8d2fbf78 ]

When userland echoes 8bit characters to /dev/synth with e.g.

echo -e '\xe9' > /dev/synth

synth_write would get characters beyond 0x7f, and thus negative when
char is signed.  When given to synth_buffer_add which takes a u16, this
would sign-extend and produce a U+ffxy character rather than U+xy.
Users thus get garbled text instead of accents in their output.

Let's fix this by making sure that we read unsigned characters.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Fixes: 89fc2ae80bb1 ("speakup: extend synth buffer to 16bit unicode characters")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240204155736.2oh4ot7tiaa2wpbh@begin
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/speakup/synth.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/speakup/synth.c b/drivers/staging/speakup/synth.c
index 3568bfb89912c..b5944e7bdbf67 100644
--- a/drivers/staging/speakup/synth.c
+++ b/drivers/staging/speakup/synth.c
@@ -208,8 +208,10 @@ void spk_do_flush(void)
 	wake_up_process(speakup_task);
 }
 
-void synth_write(const char *buf, size_t count)
+void synth_write(const char *_buf, size_t count)
 {
+	const unsigned char *buf = (const unsigned char *) _buf;
+
 	while (count--)
 		synth_buffer_add(*buf++);
 	synth_start();
-- 
2.43.0



