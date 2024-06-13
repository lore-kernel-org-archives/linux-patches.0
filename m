Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E57143C51;
	Thu, 13 Jun 2024 11:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278961; cv=none; b=B0007SGIHxlCTF38te83KNUw9cXgmF30eYyYepv3Z65z3XmCKkFJZcVk+CYCGmpe+79nsRUr/VB/3BOaRD8GGCfaQqp9JQMvzgGBJ96kTMOAaDZvrIgMhUPj3HwjiKwiRcZ0OgojoSFMRFoltbR/Hvg4KbLMajDE7yUixo91AK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278961; c=relaxed/simple;
	bh=jTmo/txdprUxW+iwFDMeneCc98xNsgyRwUzOqC5yTb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eHNLvByebCiDoZq15M90YQC57a0/9ZwF+dQJc9yxK1MUZKvB/V5heHBzTH1WrMLkCBWTkZ9I8vtEAxYMFKQ9siMAn53N8qWWHtWKRY9HhOCwS9ErbnOfb82EK9i0mR1fRTIApijr83Ad8n+UdB21vyCOICC3GQbrxFtGHpcuUBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VgoZukD3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VgoZukD3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FDEDC2BBFC;
	Thu, 13 Jun 2024 11:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278961;
	bh=jTmo/txdprUxW+iwFDMeneCc98xNsgyRwUzOqC5yTb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VgoZukD3FI+z127WXsskCcbjTbljditvppVfhkDbzNPc2Wpjy5H5+8OvenJYgzt3c
	 I+LCrWsD4NQZKu9pc14jQnyBoEbO+XOEgoBM19s3PRjVnfe4tgDNyZB1hjNYvL5erV
	 9M0KK+jvNmvViKwsBiCX/3bjvUKyZCgjQwR6cUGM=
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
Subject: [PATCH 4.19 129/213] nfc: nci: Fix kcov check in nci_rx_work()
Date: Thu, 13 Jun 2024 13:32:57 +0200
Message-ID: <20240613113232.974181563@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 6e83159b7b436..0e6bca80265ae 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -1526,6 +1526,7 @@ static void nci_rx_work(struct work_struct *work)
 
 		if (!nci_valid_size(skb)) {
 			kfree_skb(skb);
+			kcov_remote_stop();
 			break;
 		}
 
-- 
2.43.0



