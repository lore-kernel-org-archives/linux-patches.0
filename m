Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578F11E4B1;
	Tue, 14 May 2024 11:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687971; cv=none; b=kBYzGcDSJ/LM3aLPhLj2/iR8T6SmEcgKgpaqK0p9Rj+JYF2KsCY3/Oc818lgfrvY2GR1ailRTrStv+FljWeRBM4CaLptN9uMFTzaPItOjPxNVbocQHsPVD9joK7bylS1u2vWQwXvZQlkxnkwD+PgIKK8e7gt5pD1AbG8hneXHb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687971; c=relaxed/simple;
	bh=hrZ6tTG/oRwkCi7YPwVyqFVlc35DOtx+9vFJe921mfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qv3VI5ovxYgWG7r6q05VHojsB/b7rzLxM1BSsBxAEZ8U9MZ86xJRz0PlQLpfvLehOXEcm18J4Sfr0e6baxDu+j47eaJoMYCeFSvFGxh1Z0C0Xl5w6YaGCHiN8HQdveQp2Eyi6JF1QqQpC75iFN3po7S5v2YqnoQqIHr6HAMPe3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UJQdeINs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UJQdeINs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB2FC2BD10;
	Tue, 14 May 2024 11:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687970;
	bh=hrZ6tTG/oRwkCi7YPwVyqFVlc35DOtx+9vFJe921mfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UJQdeINsCaC3627d/3ULfY8wMD3HY8llhZCWW8ZFAc0rkCXudrzxAvA4ehJMaizp0
	 Qmr0998YYgUUDDnnFx7AUBpNW+FrWVBZjg+3lR1l0TnfXMfEVhSRQ3vPAn0+ObPLOd
	 cch8vaR2MmHvu3P3x396I5L2/YiPmmC3R6BZmUEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.15 168/168] Bluetooth: qca: fix firmware check error path
Date: Tue, 14 May 2024 12:21:06 +0200
Message-ID: <20240514101013.101113471@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit 40d442f969fb1e871da6fca73d3f8aef1f888558 upstream.

A recent commit fixed the code that parses the firmware files before
downloading them to the controller but introduced a memory leak in case
the sanity checks ever fail.

Make sure to free the firmware buffer before returning on errors.

Fixes: f905ae0be4b7 ("Bluetooth: qca: add missing firmware sanity checks")
Cc: stable@vger.kernel.org      # 4.19
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btqca.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -492,7 +492,7 @@ static int qca_download_firmware(struct
 
 	ret = qca_tlv_check_data(hdev, config, data, size, soc_type);
 	if (ret)
-		return ret;
+		goto out;
 
 	segment = data;
 	remain = size;


