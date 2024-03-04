Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17737868F;
	Mon,  4 Mar 2024 21:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589368; cv=none; b=soDgvBS1Kz/vRkaz96G6Jz5jvG1gzQL3D1ozVFkkZP5+nhVdl6pZ5sd0McJIW4uMleLmsPx657/S1qd2D5fTA5m/kFXheA/YtWJRVADEZtwq8tCiK9RSssEAfCqbgtUvse2VGElGSTK3DnZ+OH+X9bbZdTAJuE0pjBcRnfZ/3BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589368; c=relaxed/simple;
	bh=tFdpaNtSy9wB1nE5Q3QW1Z6fPAGUGyyhYRDlh3DV6fM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PcFv772h3OO7mv546KcNO0jhnBaxp0/V1FPHT5TruxO5Gh7I3jzJ80gI9gS/TI5MIkf7xz4UPiZuFwrbQdz7Gz1eyIV8Y+N0lYlWJhIMkMkTXsjTtYNBwgVQ8Q7njHIRfPou1K2a+gdYjdckeV3G0slMLDxQz3Zs0bYYN1Yg+Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l9chVQ3i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l9chVQ3i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32592C433C7;
	Mon,  4 Mar 2024 21:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589368;
	bh=tFdpaNtSy9wB1nE5Q3QW1Z6fPAGUGyyhYRDlh3DV6fM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l9chVQ3iLs30X1DGFDyFhAWa/BYm7EbS5m5iN/iPjW1pJryVQArD8a1y1f4SsTf9J
	 Y96zxBVv2sbfA5ppkN73VXvLJ4kiA/lLVjccg/7+4aRXfWFGcADxvra0VlfTE7EW06
	 Y5K1kpkWCbzvMmIZI0jJhG9pFTGnlfnh+y9dAB90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Maxim Mikityanskiy <maximmi@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Gal Pressman <gal@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 83/84] Revert "tls: rx: move counting TlsDecryptErrors for sync"
Date: Mon,  4 Mar 2024 21:24:56 +0000
Message-ID: <20240304211545.182872475@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211542.332206551@linuxfoundation.org>
References: <20240304211542.332206551@linuxfoundation.org>
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

From: Gal Pressman <gal@nvidia.com>

commit a069a90554168ac4cc81af65f000557d2a8a0745 upstream.

This reverts commit 284b4d93daee56dff3e10029ddf2e03227f50dbf.
When using TLS device offload and coming from tls_device_reencrypt()
flow, -EBADMSG error in tls_do_decryption() should not be counted
towards the TLSTlsDecryptError counter.

Move the counter increase back to the decrypt_internal() call site in
decrypt_skb_update().
This also fixes an issue where:
	if (n_sgin < 1)
		return -EBADMSG;

Errors in decrypt_internal() were not counted after the cited patch.

Fixes: 284b4d93daee ("tls: rx: move counting TlsDecryptErrors for sync")
Cc: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls_sw.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -278,9 +278,6 @@ static int tls_do_decryption(struct sock
 	}
 	darg->async = false;
 
-	if (ret == -EBADMSG)
-		TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSDECRYPTERROR);
-
 	return ret;
 }
 
@@ -1585,8 +1582,11 @@ static int decrypt_skb_update(struct soc
 	}
 
 	err = decrypt_internal(sk, skb, dest, NULL, darg);
-	if (err < 0)
+	if (err < 0) {
+		if (err == -EBADMSG)
+			TLS_INC_STATS(sock_net(sk), LINUX_MIB_TLSDECRYPTERROR);
 		return err;
+	}
 	if (darg->async)
 		goto decrypt_next;
 


