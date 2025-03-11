Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7E91E9B06;
	Tue, 11 Mar 2025 15:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706727; cv=none; b=gW9Jgr3ZeEOSY4kyWg/Tp8BdKWaKbEuxZpUlL/JG7xsGuyspWrntckiqrMh5Kobvd7O/rWfssl+H00CMYQ7r8D3IlDVQLE6wU/MHohAD4dQIB0iRrOhYkmCmvW4e+jhLEjdXqDwGOArEHiE4o+lgrdvmHeKHy2p4BeBCMT6i704=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706727; c=relaxed/simple;
	bh=eZ9N7stQq0QF4Pu4E6V7qCbVuH//hn8MLbh7aaF3NaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WsRWwSL/bn6k03nw+23qMwtOIdMvbeopY1DZRODk8gnuBSr83OwgR98A388pPXKXavAMz45p5zko9XKrVi/4d4DERdY0d2IbBrAq8bZ2KO5D0ATKLjpUOJxQ4n64k8fg5TXMCfbcmNdhjjPrOiRxoj70bIfovQoV3OYv6T/N3Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zM1uga7O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zM1uga7O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21895C4CEE9;
	Tue, 11 Mar 2025 15:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706727;
	bh=eZ9N7stQq0QF4Pu4E6V7qCbVuH//hn8MLbh7aaF3NaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zM1uga7OweDjQOMX3vr3sda3RMuFVXz5kZGuOqCkRXRJbJEx9lP7pDAmBLTb22KCd
	 1UO5VgssC0TqqkM5XrbLD0BkI4x9aG0I8en/rzsk5qWBiie8jdcvehJsTxZvokaPrI
	 2sd8d0MTAwejAkcOGVFe41xi9Jx3tT3mXkVPe7nU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Yujun <linyujun809@huawei.com>,
	Brian Cain <bcain@quicinc.com>,
	Brian Cain <brian.cain@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 115/462] hexagon: Fix unbalanced spinlock in die()
Date: Tue, 11 Mar 2025 15:56:21 +0100
Message-ID: <20250311145802.906192970@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lin Yujun <linyujun809@huawei.com>

[ Upstream commit 03410e87563a122075c3721acc7d5510e41d8332 ]

die executes holding the spinlock of &die.lock and unlock
it after printing the oops message.
However in the code if the notify_die() returns NOTIFY_STOP
, die() exit with returning 1 but never unlocked the spinlock.

Fix this by adding spin_unlock_irq(&die.lock) before returning.

Fixes: cf9750bae262 ("Hexagon: Provide basic debugging and system trap support.")
Signed-off-by: Lin Yujun <linyujun809@huawei.com>
Link: https://lore.kernel.org/r/20230522025608.2515558-1-linyujun809@huawei.com
Signed-off-by: Brian Cain <bcain@quicinc.com>
Signed-off-by: Brian Cain <brian.cain@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/hexagon/kernel/traps.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/hexagon/kernel/traps.c b/arch/hexagon/kernel/traps.c
index b334e80717099..653328606ef31 100644
--- a/arch/hexagon/kernel/traps.c
+++ b/arch/hexagon/kernel/traps.c
@@ -199,8 +199,10 @@ int die(const char *str, struct pt_regs *regs, long err)
 	printk(KERN_EMERG "Oops: %s[#%d]:\n", str, ++die.counter);
 
 	if (notify_die(DIE_OOPS, str, regs, err, pt_cause(regs), SIGSEGV) ==
-	    NOTIFY_STOP)
+	    NOTIFY_STOP) {
+		spin_unlock_irq(&die.lock);
 		return 1;
+	}
 
 	print_modules();
 	show_regs(regs);
-- 
2.39.5



