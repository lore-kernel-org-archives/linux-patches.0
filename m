Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC06161;
	Thu, 13 Jun 2024 12:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282513; cv=none; b=kt/4hyAE3kFhrjqsT42pljUW4pHTPePI+Kg7nveoJJSlEmTDDX4Im+hWoneJ3/Y1nIOZZ4RFxkwefFCH2q3CQSbC+Vel8ArXZ4IkTlYdp5jqXDy0O36iZOqHE2KWNzHHYm9JTycb7ULeCwluvIRXJoTILT7DgS9/ANGyyUPL/8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282513; c=relaxed/simple;
	bh=2tfE8KEHu5jh0QO6nHAglu/zdpZntsJUqD24X3wRW98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pbU+zwo/j5p6FS0oHwTE0+16I7uKUSjEQjJCQPtDq8h49jGqHRd2cp9KPIo6zjYyO6u+w1ZAzvpzH3D1kXm9aLNbo2ZL8j0TJs+bzmQxXzdG2PTA6MG9mekjwvEWj7ASMn5bZrrZ/vpf1ZzQmXFfPoAOFg7nXybAFa9rdBAwy18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bAtlERAf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bAtlERAf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95720C32786;
	Thu, 13 Jun 2024 12:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282513;
	bh=2tfE8KEHu5jh0QO6nHAglu/zdpZntsJUqD24X3wRW98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bAtlERAfAptoJaBetJTQPB/SFQT7FmoLdOvRLaQpLWL6sOROMlR4halGR16TAFhtz
	 dvCOK9/Op9ZXsq3VWOUFh2z5BARIbcJmYifwXNQSn5XA6/XpB7S3Am1xLRpYgV2kZf
	 IkMwbeE52/WtJskW6mlRcG58ll1wkVT7d1noHMTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryosuke Yasuoka <ryasuoka@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 302/402] nfc: nci: Fix handling of zero-length payload packets in nci_rx_work()
Date: Thu, 13 Jun 2024 13:34:19 +0200
Message-ID: <20240613113313.922398643@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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
index a32e49278a3f4..4d718c6921e07 100644
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



