Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FCB13B3BE7;
	Mon, 23 Mar 2026 15:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279196; cv=none; b=dp0JeyLtJtQOfxBw7RMN4ePxC7AtWojqerHWERIo8cvPJasV9DNek/PlPbs0QXJAUanduVYe0WWpZtRzJwEb8FHbP8/z10WgwRmwqvDB2Qzp2aInjiKEvVC7dg+88Cs83dwMG+b9ybOlM7ZABYgK+nBbfkYO9RRWB5MmIjTXtBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279196; c=relaxed/simple;
	bh=Ui2lZ3iFeRpDuZNkC4pkn3VdJClzjbXDYhMmQNuVMLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g+BlycvhfIt1ElJfYEOhw/9T4zaqOGLKNTiIBNOzDvtozLGWV3488nqoDzH14iSfBZ3QApsZevH9VYIBC3r3ppNIlIjn5vd+OHRuW7UoCo1Bn7JlGj+5IOaEEHUx1vLd2R30xOTW6LqjldJ19beEZKC8zSzkItW9YHzQ61ViDMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GgVTDd94; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GgVTDd94"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2202C2BCB1;
	Mon, 23 Mar 2026 15:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279196;
	bh=Ui2lZ3iFeRpDuZNkC4pkn3VdJClzjbXDYhMmQNuVMLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GgVTDd949RirQoI+tH1EvUW28FSb12iWLHYf+jk2PiQdLSCjw+ubZDIFfv4DnZH83
	 UYdm0BIdSFXIOCaVqTXCxuYrK5SeKEgvpbA+9Z1dnWwm37cNu1ISndjWE8D2WJsgZy
	 TaqqgSsRgulknpXyhbojNYwWYDwbCldvmTTl5jvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Eggers <ceggers@arri.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 505/567] Bluetooth: SMP: make SM/PER/KDU/BI-04-C happy
Date: Mon, 23 Mar 2026 14:47:05 +0100
Message-ID: <20260323134546.514509098@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Christian Eggers <ceggers@arri.de>

[ Upstream commit 0e4d4dcc1a6e82cc6f9abf32193558efa7e1613d ]

The last test step ("Test with Invalid public key X and Y, all set to
0") expects to get an "DHKEY check failed" instead of "unspecified".

Fixes: 6d19628f539f ("Bluetooth: SMP: Fail if remote and local public keys are identical")
Signed-off-by: Christian Eggers <ceggers@arri.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/smp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index e7ee13fe83a74..62c8eab1b84a5 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -2744,7 +2744,7 @@ static int smp_cmd_public_key(struct l2cap_conn *conn, struct sk_buff *skb)
 	if (!test_bit(SMP_FLAG_DEBUG_KEY, &smp->flags) &&
 	    !crypto_memneq(key, smp->local_pk, 64)) {
 		bt_dev_err(hdev, "Remote and local public keys are identical");
-		return SMP_UNSPECIFIED;
+		return SMP_DHKEY_CHECK_FAILED;
 	}
 
 	memcpy(smp->remote_pk, key, 64);
-- 
2.51.0



