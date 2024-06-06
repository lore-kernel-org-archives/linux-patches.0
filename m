Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C73B19E7FF;
	Thu,  6 Jun 2024 14:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683537; cv=none; b=oWkKyOD4Hg4F3rhLJs3sxVVfz9LiCux6fqH7malWgGZOzAdcDu99vyhRVmNIdG8Wo8aTOgxg4oxkHdeX3FWQKDRz+43WDYUj/9H4mjGzQoKDKB7kZOgOmTlkevBieCVIB21lbhwqf4yjz3hPU5C/6kKI+f/GakTR1HDMnh56yVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683537; c=relaxed/simple;
	bh=akNfn3B+QJO9kVweUQVNH+m6vrOEzAwk+Jb5reAsrhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HeraOC+5j8Y1YY/zJneA9rPvx+sl/PZrRyxnCcTtiiVvuJr8dPJUHC/xXOWc46HWniqb+D9i2Rq680LkG2H+gxIrCxXhepJ3yUTV/Fws2W+ilXMSJRPH+4JUW0JiedErd7ku71fLF9gMn7RZ+J9J3+VIzlA40WjB0xe0J60pBBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DLUCtPPw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DLUCtPPw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B593C2BD10;
	Thu,  6 Jun 2024 14:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683537;
	bh=akNfn3B+QJO9kVweUQVNH+m6vrOEzAwk+Jb5reAsrhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DLUCtPPw86fDAPNWrjyk5UD/TbEea/4tsCe7+VXNEirU4B+2so2q9Zr9aj3PbI/0s
	 XXNKyg7TnOIBFI7VbHriRcL5PrLvvYdwZsDVS2ksUiLcvwxWSv/cV+XNbFlOiNUnH0
	 /SjS8vHZ+QLZX7FaHize0tfjKvodyLx/hrq81Z2I=
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
Subject: [PATCH 6.1 427/473] nfc: nci: Fix kcov check in nci_rx_work()
Date: Thu,  6 Jun 2024 16:05:56 +0200
Message-ID: <20240606131713.873249941@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6a1d1e1f9a7cc..e4933246cd3ad 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -1527,6 +1527,7 @@ static void nci_rx_work(struct work_struct *work)
 
 		if (!nci_valid_size(skb)) {
 			kfree_skb(skb);
+			kcov_remote_stop();
 			break;
 		}
 
-- 
2.43.0



