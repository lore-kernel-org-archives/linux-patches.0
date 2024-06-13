Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80FCF44C6F;
	Thu, 13 Jun 2024 12:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280112; cv=none; b=ezdaLKnJ6Utj9cg9OsVe8t9a6vKSWqLbDEyV0YZ8DJbijhQM4dztEBVZP88AAJ9HdGWp3H7Pu6/d88Av/IF3hZSmNnltzPoF9clFUbsjJNsQ48Cg8YCSWqJ+7aokJrtGWBXvas7IR9U8JjLz+36ACRBKogPWPMz537u5uIno9lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280112; c=relaxed/simple;
	bh=cw+ZSv+71iQYLZS3XgSfh11+bWAQEF6PishnUAX6zLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZki1ZLWE23akdl8fq4wyhD9eca5BFP8s07Z/dEhvY4iJeXLrwhVB8XxGNs14fHOgnkmWISjPt1dIWSnZ9I9Dvw9bH6pOdIcq81RFGerNTXAwsZsyYBak9QnVdtChPfKrx/f5g9VDcvxEelCr2ueOIR5GgvzdPa6UzYxCgF8+XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mL2EKktF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mL2EKktF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B16C2BBFC;
	Thu, 13 Jun 2024 12:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280112;
	bh=cw+ZSv+71iQYLZS3XgSfh11+bWAQEF6PishnUAX6zLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mL2EKktFAKQ8Ks1yjirbwdcjlGqUTGQGzqt5S7S3IV+1C/ORsMf9D87k9y3nPnyx5
	 /Dsdy5xKXEUlvJC66K6NgvaU7/DQJTge4FRTwAgtJOkEKYEBT1DMPugd/saa9wYgnL
	 As6ZGNHb3xIsBaf4RlC2xfT0GRdAnxhsknGwo5vU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+0438378d6f157baae1a2@syzkaller.appspotmail.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 146/202] nfc: nci: Fix kcov check in nci_rx_work()
Date: Thu, 13 Jun 2024 13:34:04 +0200
Message-ID: <20240613113233.393092995@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 19e35f24750ddf860c51e51c68cf07ea181b4881 ]

Commit 7e8cdc97148c ("nfc: Add KCOV annotations") added
kcov_remote_start_common()/kcov_remote_stop() pair into nci_rx_work(),
with an assumption that kcov_remote_stop() is called upon continue of
the for loop. But commit d24b03535e5e ("nfc: nci: Fix uninit-value in
nci_dev_up and nci_ntf_packet") forgot to call kcov_remote_stop() before
break of the for loop.

Reported-by: syzbot <syzbot+0438378d6f157baae1a2@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=0438378d6f157baae1a2
Fixes: d24b03535e5e ("nfc: nci: Fix uninit-value in nci_dev_up and nci_ntf_packet")
Suggested-by: Andrey Konovalov <andreyknvl@gmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/6d10f829-5a0c-405a-b39a-d7266f3a1a0b@I-love.SAKURA.ne.jp
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 6671e352497c ("nfc: nci: Fix handling of zero-length payload packets in nci_rx_work()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/nci/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 61b12281ec47c..ebf1b511d8e3b 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -1514,6 +1514,7 @@ static void nci_rx_work(struct work_struct *work)
 
 		if (!nci_valid_size(skb)) {
 			kfree_skb(skb);
+			kcov_remote_stop();
 			break;
 		}
 
-- 
2.43.0



