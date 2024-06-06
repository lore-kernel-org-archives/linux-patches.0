Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63F919AD9B;
	Thu,  6 Jun 2024 14:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683049; cv=none; b=Y0ctH3GjwHgw3qV1LKbdXleHq7UukaBHYul9Ek3myK9flVl4L4Gl4yoqvFyckWv1Qjx1NEMdNsKFH8/Ol5ZRdpAh35Nk+OoRhuhY03Z8LDYJ4PbBcbvAxHBm11Ohff7MGa7fhhd5qSGH7dMgPUVmfMj9AmSnCxUdNfqbwt2yNJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683049; c=relaxed/simple;
	bh=eCu3PT9GjikZqpvgsMa76l9r31WPU+QLNXmfDEf9JXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H5dKntA/Ne46OWNdcGxEzPYBcgIUiHZpSrAQ/L1c/JVN61xdSwz/JC+SEI+Qroqyfv+QZFzvE7DE49FDx7E3OpFHvYeF0LHs0iZiJqq97gJlzhzl+eBMb+QgVEcNx9v8pZMZpktnUusq5N1mv8299uG0ldBkbc/A9I5NAbh7jIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P3hBdnqv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P3hBdnqv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 859CFC4AF0C;
	Thu,  6 Jun 2024 14:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683049;
	bh=eCu3PT9GjikZqpvgsMa76l9r31WPU+QLNXmfDEf9JXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P3hBdnqviHpCn1sHMxpRQZreWedT1Y2o9VolZHdbiORAyfrOt6XP0ubvMVsxCATic
	 J16ZsZzy8GHUWOkfMy8FlMZfhJQRUSMZPVJU1FZcuStPP0699Ep3oG1EISuQyRsFC+
	 b2Sa+RzR72uNQbgEfpRtQoZH20Ui6LRmgINJIEJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryosuke Yasuoka <ryasuoka@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 271/374] nfc: nci: Fix handling of zero-length payload packets in nci_rx_work()
Date: Thu,  6 Jun 2024 16:04:10 +0200
Message-ID: <20240606131700.980016923@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryosuke Yasuoka <ryasuoka@redhat.com>

[ Upstream commit 6671e352497ca4bb07a96c48e03907065ff77d8a ]

When nci_rx_work() receives a zero-length payload packet, it should not
discard the packet and exit the loop. Instead, it should continue
processing subsequent packets.

Fixes: d24b03535e5e ("nfc: nci: Fix uninit-value in nci_dev_up and nci_ntf_packet")
Signed-off-by: Ryosuke Yasuoka <ryasuoka@redhat.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20240521153444.535399-1-ryasuoka@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/nci/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 7a9897fbf4f41..f456a5911e7d1 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -1531,8 +1531,7 @@ static void nci_rx_work(struct work_struct *work)
 
 		if (!nci_valid_size(skb)) {
 			kfree_skb(skb);
-			kcov_remote_stop();
-			break;
+			continue;
 		}
 
 		/* Process frame */
-- 
2.43.0



