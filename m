Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738D934217C;
	Tue, 11 Nov 2025 01:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825108; cv=none; b=cy+c7McMc6MYMNR/ajoCqDLJGvh5a+jfYEQEQW2IRsimOLFt+3KkiqGr435+boyKdImcfs7lRDo2fyaPb9jIwH6IDABZAuqWorEPtTPxe+aMHKn280R2FKF0h05yZRMkEZ2sw+vpVlWKPIQI4c9LJZN8UwZc4zqHc2LucGDNwJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825108; c=relaxed/simple;
	bh=BqOcQIDTnusxnmadM7e5wfnMnWxwptD8fyXhkJ16XME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l13t+8G7mXL94js9s7PRlmwYhVv244cgNEJVw4RL/Fafm73gjCGinKWtwtyNJuMUxPJMlAlbJJVhs+2U0VaiGHgC2KtlwAjzoW4Q3c+UXZrXfkXUl6ETWTbkOIhYd+wYd1I1H0uNfg+hw9K/GUPdW/MOz8nE0UtQCfG0wbSH6WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EnRp8GU7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EnRp8GU7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1322EC4CEFB;
	Tue, 11 Nov 2025 01:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825108;
	bh=BqOcQIDTnusxnmadM7e5wfnMnWxwptD8fyXhkJ16XME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EnRp8GU7I2P9n7rxRMRwfXO8qUqytqfjYSr2odjs3/dqd4TsgYKOwrFTlkr8ZUz+D
	 QRD/i9o1fvxFCaOWWvn6FRjznECDm2b+OmlOf1mAA4Z+UwqAqMDoL0vow7U7UGR98b
	 9AZrOFMRBaHxGNwqeviFRnr55HJJECjZTv3FSEJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 662/849] Bluetooth: ISO: Dont initiate CIS connections if there are no buffers
Date: Tue, 11 Nov 2025 09:43:52 +0900
Message-ID: <20251111004552.429200574@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit d79c7d01f1c8bcf9a48337c8960d618fbe31fc0c ]

If the controller has no buffers left return -ENOBUFF to indicate that
iso_cnt might be out of sync.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 6e2923b301505..3b2a4a9d79d61 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -460,6 +460,13 @@ static int iso_connect_cis(struct sock *sk)
 		goto unlock;
 	}
 
+	/* Check if there are available buffers for output/TX. */
+	if (iso_pi(sk)->qos.ucast.out.sdu && !hci_iso_count(hdev) &&
+	    (hdev->iso_pkts && !hdev->iso_cnt)) {
+		err = -ENOBUFS;
+		goto unlock;
+	}
+
 	/* Just bind if DEFER_SETUP has been set */
 	if (test_bit(BT_SK_DEFER_SETUP, &bt_sk(sk)->flags)) {
 		hcon = hci_bind_cis(hdev, &iso_pi(sk)->dst,
-- 
2.51.0



